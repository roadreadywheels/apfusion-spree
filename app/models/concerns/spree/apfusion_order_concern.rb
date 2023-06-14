module Spree
  module ApfusionOrderConcern
    extend ActiveSupport::Concern

    APFUSION_PAYMENT_METHOD_NAME = 'Create at Apfusion'.freeze
    APFUSION_PAYMENT_METHOD = {
          'type'=>'Spree::PaymentMethod::Check',
          'display_on'=>'both',
          'auto_capture'=>'',
          'active'=>'true',
          'name'=> APFUSION_PAYMENT_METHOD_NAME,
          'description'=>'Payment for Apfusion app'}.freeze

    def self.get_apfusion_response options
      return SpreeApfusion::Order.get_orders if options.blank?

      SpreeApfusion::Order.get_specific_orders(options)
    end

    def self.create_apfusion_orders response, order_collection = []
      response.each do |order|
        apf_order = Spree::Order.find_by_apfusion_order_id(order['id']) || self.create_apfusion_order(order)
        order_collection.push(apf_order) if apf_order.present?
      end
      return order_collection
    end

    def self.create_apfusion_order order
      begin
        @order = Spree::Order.new
        orders_attributes = {
          'email' => order['user_email'],
          'special_instructions' => (order['special_instructions'] || "APF: #{order['number']}"),
          'apfusion_order_id' => order['id'],
          'apfusion_completed_at' => order['completed_at'],
          'user_id' => order['rrw_user_id']
        }
        @order.update(orders_attributes)
        @order.set_methods(order)
        return @order
      rescue Exception => e
        self.send_exception(e, order)
        e.message
      end
    end

    def set_methods order
      apfusion_update_addresses(order)
      apfusion_set_line_item_shipments(order)
      apfusion_create_payment
      adjustments.destroy_all
      reload_totals
    end

    def reload_totals
      update_totals
      persist_totals
      self.next
      self.next
    end

    def apfusion_update_addresses order
      set_address_state(order)
      self.temporary_address = true
      orders_attributes = {
        'bill_address_attributes' => apfusion_set_address(order['bill_address']),
        'ship_address_attributes' => apfusion_set_address(order['ship_address'])
      }
      update(orders_attributes)
      self.next
      line_items.destroy_all
      shipments.destroy_all
    end

    def set_address_state order
      order['line_items'].delete_if { |k| k.empty? }
      order['line_items'].each do |line_item|
        set_line_item(line_item: line_item, quantity: line_item['quantity'])
      end
      self.next
    end

    def apfusion_set_line_item_shipments order
      order['line_items'].delete_if { |k| k.empty? }
      order['shipments'].delete_if { |k| k.empty? }
      self.apfusion_create_line_item_shipments(order['shipments'], order['line_items'])
    end

    def apfusion_create_line_item_shipments shipments, line_items
      shipments.each do |shipment|
        shipment_record = self.apfusion_create_shipments(shipment)

        shipment['manifest'].each do |manifest|
          line_items.each do |line_item|
            if line_item['variant_id'] == manifest['variant_id']
              set_line_item(line_item: line_item, shipment_condition: { shipment: shipment_record }, quantity: manifest['quantity'])
            end
          end
        end
      end
    end

    def set_line_item line_item:, shipment_condition: {}, quantity:
      variant = line_item['variant']['is_master'] ?
                Spree::Product.find_by_apfusion_product_id(line_item['source_id']).master :
                Spree::Variant.find_by_apfusion_variant_id(line_item['source_id'])
      self.contents.add(variant, quantity, shipment_condition, (line_item['price'] || 0))
    end

    def apfusion_create_shipments shipment
      shipping_method_name = shipment['shiping_method_name']['linked_from']
      shipping_method = Spree::ShippingMethod.find_by_name(shipping_method_name)
      stock_location = Spree::StockLocation.find_by_name(shipment['stock_location_name'])
      shipment_record = self.shipments.create(stock_location_id: stock_location.id, apfusion_shipment_id: shipment['number'])
      shipment_record.shipping_rates.create(shipping_method: shipping_method, selected: true, cost: shipment["cost"])
      return shipment_record
    end

    def apfusion_delete_fields address
      ['id', 'email', 'customer_number', 'full_name', 'state_text', 'country', 'state'].map{ |field| 
        address.delete(field)
      }
      return address
    end

    def apfusion_set_address address
      country = Spree::Country.find_by_name(address['country']['name']) rescue ''
      address['country_id'] = country.present? ? country.id : address['country_id']
      address['state_id'] = country.present? ? country.states.find_by_name(address['state']['name']).id : address['state_id']
      address['phone'] = '888-790-5899' if !address['phone'].present?
      apfusion_delete_fields(address)
      return address
    end

    def apfusion_get_address address, allow_override = true
      return apfusion_set_address(address) if allow_override

      Spree::Address.create(apfusion_set_address(address)).id
    end

    def apfusion_create_payment
      reload_totals
      payments.create(amount: total, payment_method_id: apfusion_payment_method.id)
    end

    def apfusion_payment_method
      check_payment_method = Spree::PaymentMethod.find_by_name(APFUSION_PAYMENT_METHOD_NAME)
      if check_payment_method.present?
        check_payment_method
      else
        Spree::PaymentMethod.create(APFUSION_PAYMENT_METHOD)
      end
    end

    def self.apfusion_exception_data order, error
      return [{key: 'APFusion Order', value: order['number']},
      {key: 'Email', value: order['email']},
      {key: 'State', value: order['state']},
      {key: 'Total', value: order['total']},
      {key: 'Payment State', value: order['payment_state']},
      {key: 'Shipment State', value: order['shipment_state']},
      {key: 'Special Instructions', value: order['special_instructions']},
      {key: 'Error Logs', value: "#{error.backtrace.to_s[0..500]} ..."}]
    end

    def self.send_exception error, order
      @order.destroy
      err_data = {
        message: error.message,
        function_where_issue_occurred: 'APFusion Sync Order issue',
        cc_email: nil,
        other: self.apfusion_exception_data(order, error),
        type: 'apfusion_orders_sync'
      }
      Spree::UserMailer.error_email(err_data).deliver!
    end
  end
end
