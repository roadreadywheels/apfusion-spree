Spree::Product.class_eval do
		# after_create :create_at_apfusion
		# after_update :update_at_apfusion
		# after_destroy :destroy_at_apfusion


		def create_at_apfusion
			SpreeApfusion::Product.create(self)
		end

		def update_at_apfusion
			SpreeApfusion::Product.update(self)
		end

		def destroy_at_apfusion
			SpreeApfusion::Product.destroy(self)
		end



		def self.create_all_products
			Spree::StockLocation.create_all_stock_locations	
			Spree::Property.create_all_property
			Spree::Product.all.each do |product|
				SpreeApfusion::Product.create(product)
				product.stock_items.each do |stock_item|
					SpreeApfusion::StockItem.create(stock_item)
				end
				product.product_properties.each do |product_property|

					SpreeApfusion::ProductProperty.create(product_property)
				end	
			end 
				Spree::Image.create_all_images	
		end

		def self.create_product_properties
			Spree::Property.create_all_property
			Spree::Product.all.each do |product|
				product.product_properties.each do |product_property|
					SpreeApfusion::ProductProperty.create(product_property)
				end	
			end	
		end

		def self.update_one_product
			# Spree::StockLocation.all.each do |stock_location|
			# 	SpreeApfusion::StockLocation.update(stock_location)
			# end 
			product = Spree::Product.find_by_name("Apfusion product 8")
			SpreeApfusion::Product.update(product)
				# product.stock_items.each do |stock_item|
				# 		SpreeApfusion::StockItem.update(stock_item)
				# end

		end


		def self.update_product
			Spree::Product.all.each do |product|	
				SpreeApfusion::Product.update(product)
				product.stock_items.each do |stock_item|
					SpreeApfusion::StockItem.update(stock_item)
				end
			end	
		end

end

		