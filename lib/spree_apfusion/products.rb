module SpreeApfusion
  class Product

  	def self.create product
  		SpreeApfusion::OAuth.send(:post, '/api/v1/products.json', {product: SpreeApfusion::Product.sanitize_params(product)})
  	end

  	def self.sanitize_params product
  		product.slice(:name)
  	end

	end
end
