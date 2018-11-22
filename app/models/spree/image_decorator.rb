Spree::Image.class_eval do
		after_commit ->(obj) {obj.create_at_apfusion}, on: :create
		after_commit ->(obj) {obj.update_at_apfusion}, on: :update
		after_destroy :destroy_at_apfusion

		def create_at_apfusion
			p 'SYNC APFUSION image create_at_apfusion'
			p '.'*50
			p self.as_json
			p SpreeApfusion::Image.create(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
		end

		def update_at_apfusion
			p 'UPDate APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::Image.update(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
		end

		def destroy_at_apfusion
			p 'SYNC APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::Image.destroy(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
		end

		def self.create_all_images
			Spree::Image.all.each do |image|
				SpreeApfusion::Image.create(image)
			end		

		end

	end