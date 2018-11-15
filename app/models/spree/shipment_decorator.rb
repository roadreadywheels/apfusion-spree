Spree::Shipment.class_eval do
	 after_update :update_at_apfusion

	def update_at_apfusion
		p 'SYNC APFUSION variant  cReate movement calleds'
		p '.'*50
		p self.as_json
		 	SpreeApfusion::Shipment.update(self)
		p '.'*50
	end

	

end