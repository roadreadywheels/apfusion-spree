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
			Spree::Product.where(apfusion_product_id: nil).each do |product|
				SpreeApfusion::Product.create(product)
				product.stock_items.where(apfusion_stock_item_id: nil).each do |stock_item|
					SpreeApfusion::StockItem.create(stock_item)
				end
				product.product_properties.where(apfusion_product_property_id: nil).each do |product_property|
					
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
			# Spree::OptionType.last.option_values.each do |option_value|
			# 	SpreeApfusion::OptionValue.create(option_value)
			# end	
			Spree::Product.last.variants.each do |variant|
				SpreeApfusion::Variant.update(variant)	
			end	
			# 	product.images.each do |image|
			# 		SpreeApfusion::Image.update(image)
			#   end

		end


		def self.update_product
			Spree::StockLocation.create_all_stock_locations
			Spree::Product.all.each do |product|	
				if product.apfusion_product_id.present?
					SpreeApfusion::Product.update(product)
				else
					SpreeApfusion::Product.create(product)
				end	
				product.stock_items.each do |stock_item|
					SpreeApfusion::StockItem.update(stock_item)
				end
			end	
		end

end

		