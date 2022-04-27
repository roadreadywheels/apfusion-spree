module SpreeApfusion
  class Order
    def self.get_orders options = {}
      order = Spree::Order.last_apfusion_order_id
      return get_order_hash({ q: { completed_at: order.apfusion_completed_at } })
    end

    def self.get_specific_orders options = {}
      return get_order_hash(options)
    end

    def self.get_order_hash options = {}
      begin
        page = options[:page] || 1
        per_page = options[:per_page] || 10
        query = options[:q] || options
        orders = []
        loop do
          orders_response = SpreeApfusion::OAuth.send(:GET, '/api/v2/orders', { page: page, per_page: per_page, q: query })[:response]
          orders_response['orders'].each do |order|
            order_details = SpreeApfusion::OAuth.send(:GET, "/api/v2/orders/#{order['number']}", {})[:response]
            orders.push(order_details)
          end
          page = page + 1
          sleep 5 # to prevent api limits being hit.
          break if orders_response['count'] < per_page
        end
        return orders
      rescue Exception => e
        { success: false, error: e.message }
      end
    end
  end
end
