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
			Spree::Product.all.each do |product|
				p "============Each called="
				p product
				SpreeApfusion::Product.create(product)
			end 
		end


	end