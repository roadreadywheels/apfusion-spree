Spree::OptionType.class_eval do
		after_create :sync_apfusion
		after_update :update_option_type
		def sync_apfusion
			p 'SYNC APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::OptionType.create(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
		end

		def update_option_type
			p 'UPDate APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::OptionType.update(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
		end
	end