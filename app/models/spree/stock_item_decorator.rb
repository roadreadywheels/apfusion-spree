Spree::StockItem.class_eval do
		after_create :create_at_apfusion
	  # after_update :update_at_apfusion
		after_destroy :destroy_at_apfusion
	def create_at_apfusion
		p 'SYNC APFUSION after create 	stock item create called '
		p '.'*50
		p self.as_json
		 	SpreeApfusion::StockItem.create(self)
		# p SpreeApfusion::Image.create()
		p '.'*50
	end

	def update_at_apfusion
			p 'UPDate StockItem sotck item  update clald'
			p '.'*50
			p self.as_json

			SpreeApfusion::StockItem.update(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
	end


	def destroy_at_apfusion
			p 'SYNC APFUSION'
			p '.'*50
			p self.as_json
			p SpreeApfusion::StockItem.destroy(self)
			# p SpreeApfusion::Image.create()
			p '.'*50
	end

end