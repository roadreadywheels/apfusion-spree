module SpreeApfusion
  class Shipment

  
    def self.update shipment
      begin
        @shipment = shipment
        p @shipment.id
        p @shipment.number
        p @shipment.apfusion_shipment_id
        SpreeApfusion::Shipment.generate_shipment_hash 
        SpreeApfusion::OAuth.send(:PUT, '/api/v2/shipments/'+@shipment.apfusion_shipment_id.to_s+'.json', {shipment: @shipment_hash})
      rescue Exception => e
        
      end
      
    end
  

    def self.generate_shipment_hash 
      @shipment_hash = @shipment.attributes
      @shipment_hash["stock_location_id"] = @shipment.stock_location.apfusion_stock_location_id
      @shipment_hash["number"] = @shipment.apfusion_shipment_id
      @shipment_hash["order_id"] = @shipment.order.apfusion_order_id  
    end

  end
end