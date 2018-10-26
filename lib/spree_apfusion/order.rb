module SpreeApfusion
  class Order

    def self.get_orders
      p "get ore"
      
      SpreeApfusion::OAuth.send(:GET, '/api/v2/orders', {order: @order})
    end

  end
end