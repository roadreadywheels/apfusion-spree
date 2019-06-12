module SpreeApfusion
  class ProductProperty

    def self.create product_properties
      @product_properties = product_properties
      @product_properties
      SpreeApfusion::ProductProperty.generate_product_properties_hash 
      response = SpreeApfusion::OAuth.send(:post, '/api/v2/products/'+@product_properties.product.apfusion_product_id.to_s+'/product_properties.json', {product_property: @product_properties_hash})[:response] 
      @product_properties.update_attributes(apfusion_product_property_id: response["id"]) 
    end

    def self.update product_properties
      @product_properties = product_properties
      @product_properties.id
      SpreeApfusion::ProductProperty.generate_product_properties_hash 
      SpreeApfusion::OAuth.send(:PUT, '/api/v2/products/'+@product_properties.product.apfusion_product_id.to_s+'/product_properties/'+@product_properties.apfusion_product_property_id.to_s+'.json', {product_property: @product_properties_hash})
    end

    def self.destroy product_properties
      @product_properties = product_properties
      @product_properties.id
      SpreeApfusion::ProductProperty.generate_product_properties_hash
      SpreeApfusion::OAuth.send(:DELETE , '/api/v2/products/'+@product_properties.product.apfusion_product_id.to_s+'/product_properties/'+@product_properties.apfusion_product_property_id.to_s+'.json', {product_property: @product_properties_hash})
    end


    def self.generate_product_properties_hash 
      @product_properties_hash = @product_properties.attributes
      @product_properties_hash["product_id"] = @product_properties.product.apfusion_product_id
      @product_properties_hash["property_id"] = @product_properties.property.apfusion_property_id
    end


  end
end