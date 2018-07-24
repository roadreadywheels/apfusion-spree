Spree::Product.class_eval do
		after_create :sync_apfusion

		def sync_apfusion
			p 'SYNC APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::Product.create(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
		end
	end