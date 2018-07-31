module SpreeApfusion
  class Product

  	def self.create product
      @product = product
      @product_hash 
      SpreeApfusion::Product.generate_product_hash 
  		SpreeApfusion::OAuth.send(:post, '/api/v2/products.json', {product: @product_hash})
  	end


    def self.update product
      @product = product

      p "========UPDate call Values====="
      p @product.id
      SpreeApfusion::Product.generate_product_hash 
      SpreeApfusion::OAuth.send(:PUT, '/api/v2/products/'+@product.id.to_s+'.json', {product: @product_hash}) 
    end  

    def self.generate_product_hash 
      SpreeApfusion::Product.add_product_price
    end


    def self.add_product_price 
      p "++++++++++++++++#{@product}++++++++++++++++++"
      p "-----------------#{@product.price}-----"
      @product_hash = @product.attributes
      @product_hash["price"] = @product.price

    end

	end
end