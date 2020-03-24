Spree::Product.class_eval do
		# after_create :create_at_apfusion
		# after_update :update_at_apfusion
		# after_destroy :destroy_at_apfusion

		validates :apfusion_product_id,:uniqueness => true,:on => :update,if: 'apfusion_product_id.present?'	

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
					if product_property.apfusion_product_property_id.present?
						SpreeApfusion::ProductProperty.update(product_property)
					else
						SpreeApfusion::ProductProperty.create(product_property)
					end	
				end	
			end	
		end

		def self.update_one_product
			product = Spree::Product.find(1003)
			# product.stock_items.each do |stock_item|
			# 	if stock_item.apfusion_stock_item_id.present?
			# 		SpreeApfusion::StockItem.update(stock_item)
			# 	else
			# 	 	SpreeApfusion::StockItem.create(stock_item)
			# 	end	
			# end		
			SpreeApfusion::Product.create(product)		
			# product.stock_items.update_all(apfusion_stock_item_id: nil)
			# product.images.update_all(apfusion_image_id: nil)
				
			

			

		 # # 	product.product_properties.each do |product_property|
			# # 		SpreeApfusion::ProductProperty.update_product(product_property)
			# # end	
			# product.images.each do |image|
			# 	SpreeApfusion::Image.create(image)
			# end		
			# product.stock_items.each do |stock_item|
			# 	# if stock_item.apfusion_stock_item_id.present?
			# 	# 		SpreeApfusion::StockItem.update(stock_item)
			#  # 	else
			#  			SpreeApfusion::StockItem.cr(stock_item)
			#  	# end	
			# end		
		end

		def self.create_product_to_apfusion_having_duplicate_ids
			apfusion_product_ids = Spree::Product.group(:apfusion_product_id).having("count(apfusion_product_id) > 1").count.keys			
			apfusion_product_ids.each do |apf_product_id|
				ids = Spree::Product.where(apfusion_product_id: Spree::Product.group(:apfusion_product_id).having("count(apfusion_product_id) > 1").select(:apfusion_product_id)).where(apfusion_product_id: apf_product_id).collect(&:id)
				Spree::Product.where(id: ids.tap(&:pop)).each do |product|
		 			SpreeApfusion::Product.create(product)		
					product.stock_items.update_all(apfusion_stock_item_id: nil)
					product.images.update_all(apfusion_image_id: nil)
				end	

			end
		end


		def self.create_product_to_apfusion_having_duplicate_ids_ignore_first_element
			apfusion_product_ids = Spree::Product.group(:apfusion_product_id).having("count(apfusion_product_id) > 1").count.keys			
			apfusion_product_ids.each do |apf_product_id|
				ids = Spree::Product.where(apfusion_product_id: Spree::Product.group(:apfusion_product_id).having("count(apfusion_product_id) > 1").select(:apfusion_product_id)).where(apfusion_product_id: apf_product_id).collect(&:id)
				Spree::Product.where(id: ids.drop(1)).each do |product|
		 			SpreeApfusion::Product.create(product)		
					product.stock_items.update_all(apfusion_stock_item_id: nil)
					product.images.update_all(apfusion_image_id: nil)
				end	

			end
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
					if stock_item.apfusion_stock_item_id.present?
						SpreeApfusion::StockItem.update(stock_item)
					else
						SpreeApfusion::StockItem.create(stock_item)
					end	
				end
			end	
		end

end

		
