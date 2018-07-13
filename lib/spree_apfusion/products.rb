module SpreeApfusion
  class Product

  	def create product
  		SpreeApfusion::OAuth.send('/api/products', {product: product})
  	end

	end
end