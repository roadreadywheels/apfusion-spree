module SpreeApfusion
  class StockItem

    def self.create stock_item
      @stock_item = stock_item
      if @stock_item.stock_location.apfusion_stock_location_id.nil?
        p "#{@stock_item.stock_location.name} is missing APF stock location ID. Could not get created/synced to APF."
        return
      end
      @stock_item_hash 
      SpreeApfusion::StockItem.generate_stock_item_hash 
      response = SpreeApfusion::OAuth.send(:post, '/api/v2/stock_locations/'+@stock_item.stock_location.apfusion_stock_location_id.to_s+'/stock_items.json', {stock_item: @stock_item_hash})
      if response[:success] == true && response[:response].present? 
        if response[:response].is_a?(Hash) && response[:response]["id"].present?                
           @stock_item.update_attributes(apfusion_stock_item_id: response[:response]["id"])
        elsif response[:response].is_a?(Hash) && response[:response]["errors"].present?
          @stock_item.update_column('apfusion_response', response[:response]["errors"])
        elsif response[:response].is_a?(Array)
          @stock_item.update_attributes(apfusion_stock_item_id: response[:response][0]["id"])
        end
      end
    end

    def self.update stock_item
      @stock_item = stock_item
      @stock_item.id
      SpreeApfusion::StockItem.generate_stock_item_hash 

      response = SpreeApfusion::OAuth.send(:PUT, '/api/v2/stock_locations/'+@stock_item.stock_location.apfusion_stock_location_id.to_s+'/stock_items/'+@stock_item.apfusion_stock_item_id.to_s+'.json', {stock_item: @stock_item_hash,filter_type: "id"})

      if response.is_a?(String)
        @stock_item.update_column('apfusion_response', response)
      elsif response[:success] == true
        if response[:response].present? && response[:response]["errors"].present?
          @stock_item.update_column('apfusion_response', response[:response]["errors"].to_s)
        else
          @stock_item.product.update_attributes(last_sync_to_apf_at: Time.current)
          @stock_item.update_column('apfusion_response', nil)
        end
      else
        @stock_item.update_column('apfusion_response', response.to_s)
      end

      response
    end


    def self.destroy stock_item
      @stock_item = stock_item
      @stock_item.id
      SpreeApfusion::StockItem.generate_stock_item_hash 
      SpreeApfusion::OAuth.send(:DELETE ,'/api/v2/stock_locations/'+@stock_item.stock_location.apfusion_stock_location_id.to_s+'/stock_items/'+@stock_item.apfusion_stock_item_id.to_s+'.json', {stock_item: @stock_item_hash})
    end


    def self.generate_stock_item_hash 
      @stock_item_hash = @stock_item.attributes
      @stock_item_hash["stock_location_id"] = @stock_item.stock_location.apfusion_stock_location_id
      @stock_item_hash["variant_id"] = @stock_item.variant.apfusion_variant_id
      @stock_item_hash["force"] = true
      @stock_item_hash["sku"] = @stock_item.variant.sku
      product = @stock_item.variant.product
      if product.block_whole_sale.eql?(1)
        @stock_item_hash["block_whole_sale"] = true
      end
      if product.discontinued?
        @stock_item_hash["count_on_hand"] = 0
      end
    end

    # def self.check_variant_is_master 
    #   if @stock_item.variant.is_master == true
    #     @stock_item_hash["variant_id"] = @stock_item.variant.product.apfusion_product_id
    #   else
    #     @stock_item_hash["variant_id"] = @stock_item.variant.apfusion_variant_id
    #   end  

    # end


  end
end