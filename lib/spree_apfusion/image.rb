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

    # def self.update image
    #   @image = image

    #   p "========UPDate call Values====="
    #   p @image.id
    #   SpreeApfusion::Image.generate_image_hash 
    #   SpreeApfusion::OAuth.send(:PUT, '/api/v2/images/'+@image.id.to_s+'.json', {image: @image_hash})
    # end


    # def self.destroy image
    #   @image = image
    #   p "========Delete call====="
    #   p @image.id
    #   SpreeApfusion::Image.generate_image_hash 
    #   SpreeApfusion::OAuth.send(:DELETE , '/api/v2/images/'+@image.id.to_s+'.json', {image: @image_hash})
    # end
    def self.add_image_attachment

      # p "add imge attachment called+++++++++++++++++++++++++++++++++++++"
      # p  attachment = ActionDispatch::Http::UploadedFile.new({:filename => 'pexels-photo.jpg',:content_type => 'image/jpeg',:tempfile => File.new(Rails.root+'app/assets/images'+'pexels-photo.jpg')})
      # p "========================================="

      p "add image URL CALLED======================"*2
      p "-------------------------"
      p path = @image.attachment.url[/[^?]+/]
      p "++++++++++++++++++++++++++++++++++"
      p url = "#{Rails.root}/public#{path}"
      @image_hash["url"] = url
      
    end

    def self.generate_image_hash 
      @image_hash = @image.attributes
      SpreeApfusion::Image.add_image_attachment
    end

  end
end