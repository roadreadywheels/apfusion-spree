module Spree
  module StockItemDecorator
    def create_at_apfusion
      SpreeApfusion::StockItem.create(self)
    rescue
    end

    def update_at_apfusion
      SpreeApfusion::StockItem.update(self)
    rescue
    end

    def destroy_at_apfusion
      SpreeApfusion::StockItem.destroy(self)
    end
  end

  StockItem.prepend(StockItemDecorator)
end
