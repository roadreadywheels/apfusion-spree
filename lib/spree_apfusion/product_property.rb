module SpreeApfusion
  class ProductProperty

    def self.create product_properties
      @product_properties = product_properties
      @product_properties
      SpreeApfusion::ProductProperty.generate_product_properties_hash 
      SpreeApfusion::OAuth.send(:post, '/api/v2/products/'+@product_properties.product_id.to_s+'/product_properties.json', {product_property: @product_properties_hash})
    end

    def self.update product_properties
      @product_properties = product_properties
      @product_properties.id
      SpreeApfusion::ProductProperty.generate_product_properties_hash 
      response = SpreeApfusion::OAuth.send(:PUT, '/api/v2/products/'+@product_properties.product_id.to_s+'/product_properties/'+@product_properties.id.to_s+'.json', {product_property: @product_properties_hash})[:response] 
      @product_properties.update_attributes(apfusion_product_property_id: response["id"]) 
    end

    def self.destroy product_properties
      @product_properties = product_properties
      @product_properties.id
      SpreeApfusion::ProductProperty.generate_product_properties_hash
      SpreeApfusion::OAuth.send(:DELETE , '/api/v2/products/'+@product_properties.product_id.to_s+'/product_properties/'+@product_properties.id.to_s+'.json', {product_property: @product_properties_hash})
    end


    def self.generate_product_properties_hash 
      @product_properties_hash = @product_properties.attributes
    end


  end
end