module SpreeApfusion
  class Product

  	def self.create product
      @product = product
      @product_hash 
  		# p "===#{product}==productCALL==="
  		# p "========#{SpreeApfusion::Product.sanitize_params(product)}=============sanitizeparams=========="
      SpreeApfusion::Product.generate_product_hash 
  		SpreeApfusion::OAuth.send(:post, '/api/v2/products.json', {product: @product_hash})
  	end

  	# def self.sanitize_params product
  	# 	p "==========#{product}==sanitizeFunction===="
  	# 	product.except(:name,:price, :shipping_category)
  	# end

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


# SpreeApfusion::OAuth.send(:post, '/api/v1/products.json', {product: {name:'test product', price: 12,shipping_category: 'default'}})