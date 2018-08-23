Spree::OptionType.class_eval do
		after_create :create_at_apfusion
		after_update :update_at_apfusion
		after_destroy :destroy_at_apfusion
		def create_at_apfusion
			p 'SYNC APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::OptionType.create(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
		end

			
		# def self.create_all_option_type
		# 	p "=======ALL OptionType CALLED================="
		# 	p a = Spree::OptionType.all
		# 	p "++++++++++++++++++++++++++++++==="
		# 	Spree::OptionType.all.each do |option_type|
		# 		p "============Each called="
		# 		p option_type
		# 		SpreeApfusion::OptionType.create(option_type)
		# 	end 
		# end


		def update_at_apfusion
			p 'UPDate APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::OptionType.update(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
		end

		def destroy_at_apfusion
			p 'SYNC APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::OptionType.destroy(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
		end

	end