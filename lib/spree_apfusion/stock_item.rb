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
      @stock_item = stock_item

      p "========UPDate call Values====="
      p @stock_item.id
      SpreeApfusion::StockItem.generate_stock_item_hash 
      SpreeApfusion::OAuth.send(:PUT, '/api/v2/stock_locations/'+@stock_item.stock_location_id.to_s+'/stock_items/'+@stock_item.id.to_s+'.json', {stock_item: @stock_item_hash})
    end


    def self.destroy stock_item
      @stock_item = stock_item
      p "========Delete call====="
      p @stock_item.id
      SpreeApfusion::StockItem.generate_stock_item_hash 
      SpreeApfusion::OAuth.send(:DELETE , '/api/v2/products/'+@stock_item.product_id.to_s+'/stock_items/'+@stock_item.id.to_s+'.json', {stock_item: @stock_item_hash})
    end


    def self.generate_stock_item_hash 
      @stock_item_hash = @stock_item.attributes
    end

  end
end