module SpreeApfusion
  class StockMovement

    def self.create stock_movement
      @stock_movement = stock_movement
      @stock_movement_hash 

      p "======VARIANT CREATE CALL======"
      p @stock_movement.stock_item.stock_location_id
      SpreeApfusion::StockMovement.generate_stock_movement_hash 
      SpreeApfusion::OAuth.send(:post, '/api/v2/stock_locations/'+@stock_movement.stock_item.stock_location_id.to_s+'/stock_movements.json', {stock_movement: @stock_movement_hash})
    end

    def self.update stock_movement
      @stock_movement = stock_movement

      p "========UPDate call Values====="
      p @stock_movement.id
      SpreeApfusion::StockMovement.generate_stock_movement_hash 
      SpreeApfusion::OAuth.send(:PUT, '/api/v2/products/'+@stock_movement.product_id.to_s+'/stock_movements/'+@stock_movement.id.to_s+'.json', {stock_movement: @stock_movement_hash})
    end


    def self.destroy stock_movement
      @stock_movement = stock_movement
      p "========Delete call====="
      p @stock_movement.id
      SpreeApfusion::StockMovement.generate_stock_movement_hash 
      SpreeApfusion::OAuth.send(:DELETE , '/api/v2/products/'+@stock_movement.product_id.to_s+'/stock_movements/'+@stock_movement.id.to_s+'.json', {stock_movement: @stock_movement_hash})
    end


    def self.generate_stock_movement_hash 
      @stock_movement_hash = @stock_movement.attributes
    end

  end
end