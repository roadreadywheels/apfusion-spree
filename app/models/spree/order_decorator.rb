Spree::Order.class_eval do
		


	def self.sync_orders
		p "sync ordre clladed"*5
		response = SpreeApfusion::Order.get_orders
		p "="*20
		response[:response].each do |order|
		 	p "1111"*20
		 	@order = Spree::Order.new
		 	order["bill_address_attributes"].delete('id')
		 	order["ship_address_attributes"].delete('id')
		 	bill_address = order["bill_address_attributes"]
		 	ship_address = order["ship_address_attributes"]
		 	orders_attributes = {'bill_address_attributes'=>bill_address,'ship_address_attributes'=>ship_address}
			order["line_items"].each do |line_item|
				p "line_item"*10
				p line_item["product_id"]	
				if line_item["product_id"].present?
					variant = Spree::Product.find(line_item["product_id"]).master
				else
					variant = Spree::Variant.find(line_item["source_id"]).master
				end	
				begin
				 quantity = line_item["quantity"]
					@order =  @order.contents.add(variant,quantity)
				rescue ActiveRecord::ReproductscordInvalid => e
					error = e.record.errors.full_messages.join(', ')
				end
			end	
			p "======="*20
			p orders_attributes
			p "++++++"*20
			# p @order
			@order.update_attributes(orders_attributes)
			@order.save
				
		end

	end

end