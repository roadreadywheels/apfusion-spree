module SpreeApfusion
  class Image

    def self.create image
      p "========Create image called=========="
      p @image = image
      p @image.viewable.product.id
      @image_hash 
      SpreeApfusion::Image.generate_image_hash 
      SpreeApfusion::OAuth.send(:post, '/api/v2/products/'+@image.viewable.product.id.to_s+'/images.json', {image: @image_hash})
    end

    def self.update image
      @image = image

      p "========UPDate call Values====="
      p @image.id
      SpreeApfusion::Image.generate_image_hash 
      SpreeApfusion::OAuth.send(:PUT, '/api/v2/products/'+@image.viewable.product.id.to_s+'/images/'+@image.id.to_s+'.json', {image: @image_hash})
    end


    def self.destroy image
      @image = image
      p "========Delete call====="
      p @image.id
      SpreeApfusion::Image.generate_image_hash 
      SpreeApfusion::OAuth.send(:DELETE ,'/api/v2/products/'+@image.viewable.product.id.to_s+'/images/'+@image.id.to_s+'.json', {image: @image_hash})
    end
    


    def self.add_image_attachment
      url_type = @image.attachment.url
      p "add image URL CALLED======================"*2
      if url_type.include?('amazonaws.com')
        p "if called =================="*2
        url = url_type
        @image_hash["url"] = url
      else
        p "ELSE CALLED URL ============"*2
        p "-------------------------"
        p path = @image.attachment.url[/[^?]+/]
        p "++++++++++++++++++++++++++++++++++"
        p url = "#{Rails.root}/public#{path}"
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