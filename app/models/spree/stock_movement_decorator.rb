Spree::StockMovement.class_eval do
	  after_create :create_at_apfusion

	def create_at_apfusion
		p 'SYNC APFUSION variant  cReate movement calleds'
		p '.'*50
		p self.as_json
		
		 	SpreeApfusion::StockMovement.create(self)
			
		# p SpreeApfusion::Image.create()
		p '.'*50
	end

	

end