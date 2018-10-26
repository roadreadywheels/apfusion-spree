module SpreeApfusion
  class Property

    def self.create property
      @property = property
      SpreeApfusion::Property.generate_property_hash 
      SpreeApfusion::OAuth.send(:post, '/api/v2/properties.json', {property: @property_hash})
    end

    def self.update property
      @property = property

      p "========UPDate call====="
      p @property.id
      SpreeApfusion::Property.generate_property_hash 
      SpreeApfusion::OAuth.send(:PUT, '/api/v2/properties/'+@property.id.to_s+'.json', {property: @property_hash})
    end

    def self.destroy property
      @property = property
      p "========Delete call====="
      p @property.id
      SpreeApfusion::Property.generate_property_hash
      SpreeApfusion::OAuth.send(:DELETE , '/api/v2/properties/'+@property.id.to_s+'.json', {property: @property_hash})
    end
      
  

    def self.generate_property_hash 
      @property_hash = @property.attributes
    end

  end
end