Spree::OptionValue.class_eval do
	after_create :create_option_values
	after_update :update_option_values
	after_destroy :destroy_option_values
	def create_option_values
		p 'SYNC APFUSION'
		p '.'*50
		p self.as_json
		p SpreeApfusion::OptionValue.create(self)
		# p SpreeApfusion::Image.create()
		p '.'*50
	end

	def update_option_values
			p 'UPDate OptionValue'
			p '.'*50
			p self.as_json
			p SpreeApfusion::OptionValue.update(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
	end

	def destroy_option_values
			p 'SYNC APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::OptionValue.destroy(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
	end

end