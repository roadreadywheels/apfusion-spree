module SpreeApfusion
  class Property

    def self.create property
      @property = property
      SpreeApfusion::Property.generate_property_hash 
      response = SpreeApfusion::OAuth.send(:post, '/api/v2/properties.json', {property: @property_hash})[:response]
      @property.update_attributes(apfusion_property_id: response["id"])
    end

    def self.update property
      @property = property
      @property.id
      SpreeApfusion::Property.generate_property_hash 
      SpreeApfusion::OAuth.send(:PUT, '/api/v2/properties/'+@property.apfusion_property_id.to_s+'.json', {property: @property_hash})
    end

    def self.destroy property
      @property = property
      @property.id
      SpreeApfusion::Property.generate_property_hash
      SpreeApfusion::OAuth.send(:DELETE , '/api/v2/properties/'+@property.apfusion_property_id.to_s+'.json', {property: @property_hash})
    end
      
  

    def self.generate_property_hash 
      @property_hash = @property.attributes
    end

  end
end