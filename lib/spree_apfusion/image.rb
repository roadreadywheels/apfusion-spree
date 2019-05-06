module SpreeApfusion
  class Image

    def self.create image
      @image = image
      @image.viewable.product.id
      @image_hash 
      SpreeApfusion::Image.generate_image_hash 
      SpreeApfusion::OAuth.send(:post, '/api/v2/products/'+@image.viewable.product.id.to_s+'/images.json', {image: @image_hash})
    end

    def self.update image
      @image = image
      @image.id
      SpreeApfusion::Image.generate_image_hash 
      response = SpreeApfusion::OAuth.send(:PUT, '/api/v2/products/'+@image.viewable.product.id.to_s+'/images/'+@image.id.to_s+'.json', {image: @image_hash})[:response]
      @image.update_attributes(apfusion_image_id: response["id"]) 
    end


    def self.destroy image
      @image = image
      @image.id
      SpreeApfusion::Image.generate_image_hash 
      SpreeApfusion::OAuth.send(:DELETE ,'/api/v2/products/'+@image.viewable.product.id.to_s+'/images/'+@image.id.to_s+'.json', {image: @image_hash})
    end
    


    def self.add_image_attachment
      url_type = @image.attachment.url
      if url_type.include?('amazonaws.com')
        url = url_type
        @image_hash["url"] = url
      else
        path = @image.attachment.url[/[^?]+/]
        url = "#{Rails.root}/public#{path}"
        @image_hash["url"] = url
      end  
      
    end

    def self.check_variant_is_master 
      is_master = @image.viewable.is_master 
      if is_master == true
        @image_hash["is_master"] = is_master
      end  
    end


    def self.add_variant_id
      @image_hash["variant_id"] = @image.viewable.id
      
    end


    def self.generate_image_hash 
      @image_hash = @image.attributes
      SpreeApfusion::Image.add_image_attachment
      SpreeApfusion::Image.check_variant_is_master
      SpreeApfusion::Image.add_variant_id
    end

  end
end