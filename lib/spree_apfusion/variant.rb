module SpreeApfusion
  class Variant

    def self.create variant
      @variant = variant
      @variant_hash 
      SpreeApfusion::Variant.generate_variant_hash 
      response = SpreeApfusion::OAuth.send(:post, '/api/v2/products/'+@variant.product.apfusion_product_id.to_s+'/variants.json', {variant: @variant_hash})
      if response[:success] == true                 
        @variant.update_attributes(apfusion_variant_id: response[:response]["id"])
      end
    end

    def self.update variant
      @variant = variant
      SpreeApfusion::Variant.generate_variant_hash 
      SpreeApfusion::OAuth.send(:PUT, '/api/v2/products/'+@variant.product.apfusion_product_id.to_s+'/variants/'+@variant.apfusion_variant_id.to_s+'.json', {variant: @variant_hash})
    end


    def self.destroy variant
      @variant = variant
      @variant.id
      SpreeApfusion::Variant.generate_variant_hash 
      SpreeApfusion::OAuth.send(:DELETE , '/api/v2/products/'+@variant.product.apfusion_product_id.to_s+'/variants/'+@variant.apfusion_variant_id.to_s+'.json', {variant: @variant_hash})
    end

    def self.add_option_value_ids
      @variant_hash["option_value_ids"] = @variant.option_values.collect(&:apfusion_option_value_id)
    end

    def self.add_product_price
       @variant_hash["price"] = @variant.price
       @variant_hash["product_id"] = @variant.product.apfusion_product_id
    end

    def self.generate_variant_hash 
      @variant_hash = @variant.attributes
      SpreeApfusion::Variant.add_option_value_ids
      SpreeApfusion::Variant.add_product_price
    end

  end
end