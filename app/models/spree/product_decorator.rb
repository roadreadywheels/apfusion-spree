Spree::Product.class_eval do
		after_create :create_at_apfusion
		after_update :update_at_apfusion
		after_destroy :destroy_at_apfusion
		def create_at_apfusion
			p 'SYNC APFUSION'
			p '.'*50
			p "+++++++++AFTER product create++++++++++"
			p self.as_json
			SpreeApfusion::Product.create(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
		end

		def update_at_apfusion
			p 'SYNC APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::Product.update(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
		end

		def destroy_at_apfusion
			p 'SYNC APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::Product.destroy(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
		end



		def self.create_all_products
			p "=======ALL OptionType CALLED================="
			p a = Spree::Product.all
			p "++++++++++++++++++++++++++++++==="
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

		def self.update_product
			Spree::Product.all.each do |product|
				SpreeApfusion::Product.update(product)
			end	
		end

	end

	