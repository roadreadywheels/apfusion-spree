Spree::StockMovement.class_eval do
	  # after_create :create_at_apfusion

	def create_at_apfusion
		SpreeApfusion::StockMovement.create(self)
	end

	

end