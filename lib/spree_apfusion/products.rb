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

    def self.destroy product
      @product = product

      p "========UPDate call Values====="
      p @product.id
      SpreeApfusion::Product.generate_product_hash 
      SpreeApfusion::OAuth.send(:DELETE, '/api/v2/products/'+@product.id.to_s+'.json', {product: @product_hash}) 
    end  

    def self.generate_product_hash 
      @product_hash = @product.attributes
      SpreeApfusion::Product.add_product_price
      SpreeApfusion::Product.add_option_type_id


    end


    def self.add_product_price 
      @product_hash["price"] = @product.price

    end

    def self.add_option_type_id
      p"======OptionType CALLED=="
      @product_hash["option_type_ids"] = @product.option_types.collect(&:id)

      p @product.option_types.collect(&:id)

      
    end

	end
end