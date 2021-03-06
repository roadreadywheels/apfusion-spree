module SpreeApfusion
  class StockItem

    def self.create stock_item
      @stock_item = stock_item
      @stock_item_hash 

      p "======StockItem Create CALLED============="*2
      p @stock_item.stock_location_id
      SpreeApfusion::StockItem.generate_stock_item_hash 
      SpreeApfusion::OAuth.send(:post, '/api/v2/stock_locations/'+@stock_item.stock_location_id.to_s+'/stock_items.json', {stock_item: @stock_item_hash})
    end

    def self.update stock_item

        p"===============unless condition called============================"*2
        @stock_item = stock_item

        p "========UPDate call stock item called====="
        p @stock_item.id
        SpreeApfusion::StockItem.generate_stock_item_hash 
        SpreeApfusion::OAuth.send(:PUT, '/api/v2/stock_locations/'+@stock_item.stock_location_id.to_s+'/stock_items/'+@stock_item.id.to_s+'.json', {stock_item: @stock_item_hash})
  

    end


    def self.destroy stock_item
      @stock_item = stock_item
      p "========Delete call stock_items====="
      p @stock_item.id
      SpreeApfusion::StockItem.generate_stock_item_hash 
      SpreeApfusion::OAuth.send(:DELETE ,'/api/v2/stock_locations/'+@stock_item.stock_location_id.to_s+'/stock_items/'+@stock_item.id.to_s+'.json', {stock_item: @stock_item_hash})
    end


    def self.generate_stock_item_hash 
      @stock_item_hash = @stock_item.attributes
      SpreeApfusion::StockItem.check_variant_is_master
      
     
    end

    def self.check_variant_is_master 
      if @stock_item.variant.is_master == true
        @stock_item_hash["product_id"] = @stock_item.variant.product_id
      end  
    end


  end
end