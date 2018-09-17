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

    def self.generate_stock_movement_hash 
      @stock_movement_hash = @stock_movement.attributes
      SpreeApfusion::StockMovement.add_variant_id

    end

    def self.add_variant_id 
      @stock_movement_hash["variant_id"] = @stock_movement.stock_item.variant_id
    end

  end
end