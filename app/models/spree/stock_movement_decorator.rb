module Spree
  module StockMovementDecorator
    def create_at_apfusion
      SpreeApfusion::StockMovement.create(self)
    end
  end

  StockMovement.prepend(StockMovementDecorator)
end
