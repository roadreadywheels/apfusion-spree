Spree::OptionValue.class_eval do
	after_create :create_at_apfusion
	after_update :update_at_apfusion
	after_destroy :destroy_at_apfusion
	def create_at_apfusion
		p 'SYNC APFUSION'
		p '.'*50
		p self.as_json
		p SpreeApfusion::OptionValue.create(self)
		# p SpreeApfusion::Image.create()
		p '.'*50
	end

	def update_at_apfusion
			p 'UPDate OptionValue'
			p '.'*50
			p self.as_json
			p SpreeApfusion::OptionValue.update(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
	end

	def destroy_at_apfusion
			p 'SYNC APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::OptionValue.destroy(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
	end

end