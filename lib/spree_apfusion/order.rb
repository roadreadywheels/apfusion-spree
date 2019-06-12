module SpreeApfusion
  class Order

    def self.get_orders
      @order = Spree::Order.where.not(apfusion_order_id: nil).order(:created_at).last
      if @order.present?
      	@order_id = @order.apfusion_order_id
      end	
      @orders_hash = []
      page = 1
      loop do
      	orders = SpreeApfusion::OAuth.send(:GET, '/api/v2/orders', {page: page, q: {completed_at_gt: @order.apfusion_completed_at}})[:response]
      	orders["orders"].each do |order|
	      	order_details = SpreeApfusion::OAuth.send(:GET, "/api/v2/orders/#{order["number"]}", {})[:response]
      	@orders_hash.push(order_details)	
	  		end
	  		page = page + 1
	  		sleep 5 #to prevent api limits being hit.
	  		break if orders["count"] < 25
      end
      return @orders_hash
    end

  end 
end