module SpreeApfusion
  class Image

    def self.create image
      @image = image
      @image.viewable.product.id
      @image_hash 
      SpreeApfusion::Image.generate_image_hash 
      begin
        response = SpreeApfusion::OAuth.send(:post, '/api/v2/products/'+@image.viewable.product.apfusion_product_id.to_s+'/images.json', {image: @image_hash,filter_type: "id"})
        if response[:success] == true && response[:response].present? && response[:response]["id"].present? 
          @image.update_column :apfusion_image_id, response[:response]["id"]
        end 
        
      rescue Exception => e
        p e.message
      end
    end

    def self.update image
      @image = image
      @image.id
      SpreeApfusion::Image.generate_image_hash 
      SpreeApfusion::OAuth.send(:PUT, '/api/v2/products/'+@image.viewable.product.apfusion_product_id.to_s+'/images/'+@image.apfusion_image_id.to_s+'.json', {image: @image_hash,filter_type: "id"})[:response]
    end


    def self.destroy image
      @image = image
      @image.id
      SpreeApfusion::Image.generate_image_hash 
      SpreeApfusion::OAuth.send(:DELETE ,'/api/v2/products/'+@image.viewable.product.apfusion_product_id.to_s+'/images/'+@image.id.to_s+'.json', {image: @image_hash})
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

   


    def self.add_variant_id
      @image_hash["viewable_id"] = @image.viewable.apfusion_variant_id
      
    end


    def self.generate_image_hash 
      @image_hash = @image.attributes
      SpreeApfusion::Image.add_image_attachment 
      SpreeApfusion::Image.add_variant_id
    end

  end
end