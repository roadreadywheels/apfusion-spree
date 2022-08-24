module SpreeApfusion
  class Product

  	def self.create product
      product_hash = SpreeApfusion::Product.generate_product_hash(product)
  		response = SpreeApfusion::OAuth.send(:post, '/api/v2/products.json', {product: product_hash})
      if response[:success] == true && response[:response].present? && response[:response]["id"].present?                
        product.update_attributes(apfusion_product_id: response[:response]["id"])
        product.master.update_attributes(apfusion_variant_id: response[:response]["master"]["id"])
      end   
  	end

    def self.update product
      return if product.blank?

      product_hash = SpreeApfusion::Product.generate_product_hash(product)
      response = SpreeApfusion::OAuth.send(:PUT, '/api/v2/products/'+product.apfusion_product_id.to_s+'.json', {product: product_hash,filter_type: "id"}) 
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
      @product_hash["price"] =  if product.apfusion_amount.to_i > 0
                                  product.apfusion_amount
                                elsif product.resale_amount.to_i > 0
                                  calculate_price(product.resale_amount)
                                else
                                  calculate_price(product.price)
                                end
      @product_hash["resale_amount"] = product.resale_amount
      @product_hash["bsap_amount"] = product.bsap_amount + (product.bsap_amount * 0.09)
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

    private

    def self.calculate_price price
      price + (price * 0.08)
    end

	end
end