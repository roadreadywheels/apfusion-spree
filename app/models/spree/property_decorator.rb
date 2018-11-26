Spree::Property.class_eval do
		after_create :create_at_apfusion
		after_update :update_at_apfusion
		after_destroy :destroy_at_apfusion
		def create_at_apfusion
			p 'SYNC APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::Property.create(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
		end

			
		def self.create_all_property
			p "=======ALL Property CALLED================="
			p a = Spree::Property.all
			p "++++++++++++++++++++++++++++++==="
			Spree::Property.all.each do |property|
				p "============Each called="
				p property
				SpreeApfusion::Property.create(property)
			end 
		end


		def update_at_apfusion
			p 'UPDate APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::Property.update(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
		end

		def destroy_at_apfusion
			p 'SYNC APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::Property.destroy(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
		end

	end