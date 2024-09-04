module SpreeApfusion
  class Product

    def self.fetch ids
      SpreeApfusion::OAuth.send(:get, "/api/v2/products.json", { ids: ids, per_page: 100 })
    end

    def self.create product
      product_hash = SpreeApfusion::Product.generate_product_hash(product)
      response = SpreeApfusion::OAuth.send(:post, '/api/v2/products.json', {product: product_hash})
      if response[:success] == true && response[:response].present? && response[:response]["id"].present?                
        product.update_attributes(apfusion_product_id: response[:response]["id"], last_sync_to_apf_at: Time.current)
        product.master.update_attributes(apfusion_variant_id: response[:response]["master"]["id"])
      elsif response[:success] == true && response[:response].present? && response[:response]["errors"].present?                
        product.update_column('apfusion_response', response[:response]["errors"].to_s)
      else
        product.update_column('apfusion_response', response.to_s)
      end   
    end

    def self.update product
      return if product.blank?

      product_hash = SpreeApfusion::Product.generate_product_hash(product)
      response = SpreeApfusion::OAuth.send(:PUT, '/api/v2/products/'+product.apfusion_product_id.to_s+'.json', {product: product_hash,filter_type: "id"})
      if response[:success] == true
        product.update_attributes(last_sync_to_apf_at: Time.current)
      else
        product.update_column('apfusion_response', response.to_s)
      end
      response
    end  

    def self.destroy product
      return if product.blank?

      product_hash = SpreeApfusion::Product.generate_product_hash(product)
      SpreeApfusion::OAuth.send(:DELETE, '/api/v2/products/'+product.id.to_s+'.json', {product: product_hash}) 
    end  

    def self.generate_product_hash product = nil
      return {} if product.blank?

      @product_hash = product.attributes
      SpreeApfusion::Product.add_product_price(product)
      SpreeApfusion::Product.add_option_type_id(product)
      SpreeApfusion::Product.add_sku(product)
      SpreeApfusion::Product.add_taxons(product)
      @product_hash
    end

    def self.add_product_price product
      @product_hash["price"] =  product.apf_price
      @product_hash["resale_amount"] = product.resale_amount
      @product_hash["bsap_amount"] = product.apf_bsap_price

      oe_number = product.oe_number.to_s
      @product_hash["oem_number"] = oe_number.gsub("|", ",") if oe_number != 'N/A'

      @product_hash
    end

    def self.add_option_type_id product
      @product_hash["option_type_ids"] = product.option_types.collect(&:apfusion_option_type_id)
    end

    def self.add_sku product
      @product_hash["sku"] = product.try(:sku)
    end

    def self.add_taxons product
       @product_hash["taxon_ids"] = "5"
    end    

    def self.compared_rrw_items_with_apfs
      @unmatched_row = []

      Spree::Product.where.not(apfusion_product_id: nil).find_in_batches(batch_size: 100) do |group|
        apfusion_product_ids = group.pluck(:apfusion_product_id).join(',')

        response = SpreeApfusion::Product.fetch(apfusion_product_ids)

        if response[:success] == true && response[:response]['products'].present?
          response[:response]["products"].each do |product|
            rrw_element = Spree::Product.find_by_apfusion_product_id(product['id'])
            next if rrw_element.nil?

            if product['name'] != rrw_element.name
              @unmatched_row << [product['name'], product['master']['sku'], product['meta_description'], product['total_on_hand'], 'NAME', rrw_element.name, rrw_element.is_block_whole_sale?]
            elsif product['master']['sku'] != rrw_element.sku
              @unmatched_row << [product['name'], product['master']['sku'], product['meta_description'], product['total_on_hand'], 'SKU', rrw_element.sku, rrw_element.is_block_whole_sale?]
            elsif product['meta_description'] != rrw_element.meta_description
              @unmatched_row << [product['name'], product['master']['sku'], product['meta_description'], product['total_on_hand'], 'META_DESCRIPTION', rrw_element.meta_description, rrw_element.is_block_whole_sale?]
            elsif product['total_on_hand'] != rrw_element.total_on_hand
              @unmatched_row << [product['name'], product['master']['sku'], product['meta_description'], product['total_on_hand'], 'STOCKS', rrw_element.total_on_hand, rrw_element.is_block_whole_sale?]
            end
          end
        end
      end

      @unmatched_row
    end
  end
end