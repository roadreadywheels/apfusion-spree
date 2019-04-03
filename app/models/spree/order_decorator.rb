Spree::Order.class_eval do
	def self.sync_orders

		response = SpreeApfusion::Order.get_orders
		response.each do |order|
			p "response called"*8

		 		begin
		 			p "begin called"
		 			
		 			@order = Spree::Order.new
				 	order["bill_address"].delete('id')
				 	order["ship_address"].delete('id')
				 	order["bill_address"].delete('email')
				 	order["ship_address"].delete('email')
				 	order["bill_address"].delete('customer_number')
				 	order["ship_address"].delete('customer_number')
				 	order["bill_address"].delete('full_name')
				  order["ship_address"].delete('full_name')
				  order["bill_address"].delete('state_text')
				  order["ship_address"].delete('state_text')
				  bill_state_id = Spree::State.find_by_name(order["bill_address"]["state"]["name"]).id
				  bill_country_id = Spree::Country.find_by_name(order["bill_address"]["country"]["name"]).id
				  order["bill_address"]["state_id"] = bill_state_id
				  order["bill_address"]["country_id"] = bill_country_id
				  ship_state_id = Spree::State.find_by_name(order["ship_address"]["state"]["name"]).id
				  ship_country_id = Spree::Country.find_by_name(order["ship_address"]["country"]["name"]).id
				  order["ship_address"]["state_id"] = ship_state_id
				  order["ship_address"]["country_id"] = ship_country_id
				  order["bill_address"].delete('state')
				  order["ship_address"].delete('state')
				  order["bill_address"].delete('country')
				  order["ship_address"].delete('country')
				 	p bill_address = order["bill_address"]
				 	p ship_address = order["ship_address"]

				 	orders_attributes = {'bill_address_attributes'=>bill_address,'ship_address_attributes'=>ship_address,'email'=>order['email'],'apfusion_order_id'=>order['id']}


					order["line_items"].each do |line_item|
						if line_item["variant"]["is_master"] == true
							variant = Spree::Product.find(line_item["source_id"]).master
						else			
							variant = Spree::Variant.find(line_item["source_id"])
						end
						begin
						  quantity = line_item["quantity"]
							@order.contents.add(variant, quantity, {}, line_item["price"])
						rescue ActiveRecord::ReproductscordInvalid => e
							error = e.record.errors.full_messages.join(', ')
						end	
					end



					orders_attributes
				 	@order.update_attributes(orders_attributes)
					@order.next
					@order.next
					@order.shipments.destroy_all
					@order.line_items.destroy_all
					order["shipments"].each do |shipment|
						shipping_method_name = shipment["shiping_method_name"]["linked_from"]
						@shipping_method =  Spree::ShippingMethod.find_by_name(shipping_method_name)
	          stock_location = Spree::StockLocation.find_by_name(shipment["stock_location_name"])
	          @shipment = @order.shipments.create(stock_location_id: stock_location.id, apfusion_shipment_id: shipment["number"])
	          @shipment.shipping_rates.create(shipping_method: @shipping_method, selected: true, cost: shipment["cost"])
						shipment["manifest"].each do |menifest|
							price = 0
							quantity = menifest["quantity"]
							variant = nil
							order["line_items"].each do |line_item|
								if line_item["variant_id"] == menifest["variant_id"]
									price = line_item["price"]
									if line_item["variant"]["is_master"] == true
										variant = Spree::Product.find(line_item["source_id"]).master
									else			
										variant = Spree::Variant.find(line_item["source_id"])
									end
									@order.contents.add(variant, quantity, {shipment: @shipment}, price)
								
								end 

							end
							
	          	
	          end
	          
					end
					@order.update_totals
			    @order.persist_totals
					
					# # @order.next
					# # order["shipments"].each do |shipment|
					# # 	p shipment["number"]
					# # 	p 

					# # 	# p shipping_method_name.present?
					# # 	if shipping_method_name.present?
					# # 		p @shipping_method =  Spree::ShippingMethod.find_by_name(shipping_method_name)
					# # 		@order.shipments.each do |order_shipment| 
					# # 			p order_shipment
					# # 			p shipment["number"]
					# # 			order_shipment.update_attributes(apfusion_shipment_id: shipment["number"] )
					# # 			# p order_shipment.shipping_rates
					# # 		  order_shipment.shipping_rates.create(shipping_method: @shipping_method, selected: false, cost: 0)
					# # 			# order_shipment.shipping_rates.update_all(selected: false)
					# # 			# order_shipment.shipping_rates.find_by_shipping_method_id(@shipping_method).update_attributes(selected: true)
					# # 		end	
					# # 		@order.update_totals
			  # #       @order.persist_totals
			      
			  # #     	# p "else callde"*20
			  # #     	# @order.shipments.last.update_attributes(apfusion_shipment_id: line_item["shipping"]["number"] )
				 # #    end  
					# # end	
					# # @order.next

					check_payment_method = Spree::PaymentMethod.where(name: "Create at Apfusion").last
					if check_payment_method.present?
						payment_method = 	check_payment_method
					else
						payment_method =  Spree::PaymentMethod.create({"type"=>"Spree::PaymentMethod::Check", "display_on"=>"both", "auto_capture"=>"", "active"=>"true", "name"=>"Create at Apfusion", "description"=>"Payment for Apfusion app"})
					end
					@order.payments.create(amount: @order.total, payment_method_id: payment_method.id)
					@order.next
					@order.next
					@order.next
					@order.next
					

		 		rescue Exception => e
		 			p e.message
		 		end
		 	
		end 	
	end




	def deliver_order_confirmation_email
		p "deliver order confirmation called"*20
		unless self.apfusion_order_id.present?
	  	Spree::OrderMailer.confirm_email(id).deliver_later
	  	update_column(:confirmation_delivered, true)
	  end	
	end

end



