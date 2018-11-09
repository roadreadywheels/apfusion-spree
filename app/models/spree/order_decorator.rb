Spree::Order.class_eval do

	def self.sync_orders
		p "sync ordre clladed"*5
		response = SpreeApfusion::Order.get_orders
		p "="*20
		p response[:response]
		response[:response].each do |order|
			begin
			 	p "1111"*20
			 	p order['id']
			 	p "_______"*20
			 	p order["line_items"]
			 	order_ids = Spree::Order.all.collect(&:apfusion_order_id)
			 	unless order_ids.include?(order['id'])
				 	@order = Spree::Order.new
				 	p order["bill_address_attributes"].delete('id')
				 	order["ship_address_attributes"].delete('id')
				 	bill_address = order["bill_address_attributes"]
				 	ship_address = order["ship_address_attributes"]
				 	orders_attributes = {'bill_address_attributes'=>bill_address,'ship_address_attributes'=>ship_address,'email'=>order['email'],'apfusion_order_id'=>order['id']}

					order["line_items"].each do |line_item|
						p "line_item"*10
						if line_item["product_id"].present?
							variant = Spree::Product.find(line_item["product_id"]).master
						else
							variant = Spree::Variant.find(line_item["source_id"]).master
						end
						begin
						 quantity = line_item["quantity"]
							@order.contents.add(variant,quantity)
						 # @shipment = @order.shipments.new(stock_location_id:  Spree::StockLocation.find_by_name("noidacompany").id)
							# @order.contents.add(variant, quantity, shipment: @shipment)
						rescue ActiveRecord::ReproductscordInvalid => e
							error = e.record.errors.full_messages.join(', ')
						end
					end
					orders_attributes
					@order.update_attributes(orders_attributes)
					@order.next
					@order.next
					check_payment_method = Spree::PaymentMethod.where(name: "Create at Apfusion").last
					if check_payment_method.present?
						payment_method = 	check_payment_method
					else
						payment_method =  Spree::PaymentMethod.create({"type"=>"Spree::PaymentMethod::Check", "display_on"=>"both", "auto_capture"=>"", "active"=>"true", "name"=>"Create at Apfusion", "description"=>"Payment for Apfusion app"})
					end
					@order.payments.create(amount: @order.total, payment_method_id: payment_method.id)
					@order.next
					@order.next
				end
			rescue
				p 'Error in order'
				p order
			end
		end

	end

end