Spree::Product.class_eval do
		after_create :create_at_apfusion
		after_update :update_at_apfusion

		def create_at_apfusion
			p 'SYNC APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::Product.create(self)
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

	end