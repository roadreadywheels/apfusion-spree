Spree::Order.class_eval do
		


	def self.sync_orders
		p "sync ordre clladed"*5
		response = SpreeApfusion::Order.get_orders
		p "="*20
		p response[:response]
		response[:response].each do |order|
		 	p "1111"*20
		 	p order
		 	p "_______"*20
		 	p order["line_items"]
		 	@order = Spree::Order.new
		 	order["bill_address_attributes"].delete('id')
		 	order["ship_address_attributes"].delete('id')
		 	bill_address = order["bill_address_attributes"]
		 	ship_address = order["ship_address_attributes"]
		 	orders_attributes = {'bill_address_attributes'=>bill_address,'ship_address_attributes'=>ship_address}
		 	@order.update_attributes(orders_attributes)
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
					# @order.contents.add(variant,quantity)
					p "begin called "*4
				 p @shipment = @order.shipments.new(stock_location_id:  Spree::StockLocation.find_by_name("noidacompany").id)

				 if @shipment.save
				 	p "fkdjjksfk"
				 else
				 	@shipment.errors.full_messages.join(',')
				 end	
					 @order.contents.add(variant, quantity, shipment: @shipment)
				rescue ActiveRecord::ReproductscordInvalid => e
					error = e.record.errors.full_messages.join(', ')
				end
			end	
			p "======="*20
			p orders_attributes
			p "++++++"*20
			p @order.total
			

			p "NEXt STEP ====="*6
			p @order.next
			payment_method = Spree::PaymentMethod.where(name: "Check").last
			@order.payments.create(amount: @order.total, payment_method_id: payment_method.id)
			@order.next
			
				
		end

	end

end