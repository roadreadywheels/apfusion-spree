module SpreeApfusion
  class Order

    def self.get_orders(options = {})
      @order = Spree::Order.where.not(apfusion_order_id: nil).order(:created_at).last
      @order_id = @order.apfusion_order_id if @order.present?
      @orders = []
      page = options[:page] || 1
      per_page = options[:per_page] || 10
      query = options[:q] || {}
      query[:completed_at_gt] = @order.apfusion_completed_at
      loop do
        orders = SpreeApfusion::OAuth.send(:GET, '/api/v2/orders', {page: page, per_page: per_page, q: query})[:response]
        orders["orders"].each do |order|
          order_details = SpreeApfusion::OAuth.send(:GET, "/api/v2/orders/#{order["number"]}", {})[:response]
        @orders.push(order_details)  
        end
        page = page + 1
        sleep 5 #to prevent api limits being hit.
        break if orders["count"] < per_page
      end
      return @orders
    end
  end 
end