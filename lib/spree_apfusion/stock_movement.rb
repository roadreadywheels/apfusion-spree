module SpreeApfusion
  class StockMovement

    def self.create stock_movement
      @stock_movement = stock_movement
      @stock_movement_hash 
      @stock_movement.stock_item.stock_location_id
      SpreeApfusion::StockMovement.generate_stock_movement_hash 
      SpreeApfusion::OAuth.send(:post, '/api/v2/stock_locations/'+@stock_movement.stock_item.stock_location_id.to_s+'/stock_movements.json', {stock_movement: @stock_movement_hash})
    end

    def self.generate_stock_movement_hash 
      @stock_movement_hash = @stock_movement.attributes
      SpreeApfusion::StockMovement.add_variant_id
      SpreeApfusion::StockMovement.check_variant_is_master

    end

    def self.add_variant_id 
      @stock_movement_hash["variant_id"] = @stock_movement.stock_item.variant_id
    end

    def self.check_variant_is_master 
      if @stock_movement.stock_item.variant.is_master == true
        @stock_movement_hash["product_id"] = @stock_movement.stock_item.variant.product_id
      end  
    end

  end
end