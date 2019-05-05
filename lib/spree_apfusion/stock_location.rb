module SpreeApfusion
  class StockLocation

    def self.create stock_location
      @stock_location = stock_location
      SpreeApfusion::StockLocation.generate_stock_location_hash 
      response = SpreeApfusion::OAuth.send(:post, '/api/v2/stock_locations.json', {stock_location: @stock_location_hash})[:response]  
      @stock_location.update_attributes(apfusion_stock_location_id: response["id"])
    end

    def self.update stock_location
      @stock_location = stock_location
      @stock_location.id
      SpreeApfusion::StockLocation.generate_stock_location_hash 
      SpreeApfusion::OAuth.send(:PUT, '/api/v2/stock_locations/'+@stock_location.apfusion_stock_location_id.to_s+'.json', {stock_location: @stock_location_hash})[:response]
    end

    def self.destroy stock_location
      @stock_location = stock_location
      @stock_location.id
      SpreeApfusion::StockLocation.generate_stock_location_hash
      SpreeApfusion::OAuth.send(:DELETE , '/api/v2/stock_locations/'+@stock_location.apfusion_stock_location_id.to_s+'.json', {stock_location: @stock_location_hash})
    end
      
  

    def self.generate_stock_location_hash 
      @stock_location_hash = @stock_location.attributes
    end



  end
end