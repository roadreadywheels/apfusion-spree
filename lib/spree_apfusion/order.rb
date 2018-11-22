module SpreeApfusion
  class Order

    def self.get_orders
      p "get ore"
      @order = Spree::Order.where.not(apfusion_order_id: nil).order(:created_at).last
      if @order.present?
      	@order_id = @order.apfusion_order_id
      end	
      SpreeApfusion::OAuth.send(:GET, '/api/v2/orders', {order_id: @order_id})
    end

  end
end