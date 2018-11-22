module SpreeApfusion
  class Order

    def self.get_orders
      p "get ore"
      if ApfusionOrder.last.present?
      	@order = ApfusionOrder.last.order_id
      end	
      SpreeApfusion::OAuth.send(:GET, '/api/v2/orders', {order_id: @order})
    end

  end
end