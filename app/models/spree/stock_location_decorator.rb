module Spree
  module StockLocationDecorator
    def self.prepended(base)
      def base.create_all_stock_locations
        Spree::StockLocation.where(apfusion_stock_location_id: nil).each do |stock_location|
          SpreeApfusion::StockLocation.create(stock_location)
        end
      end

      def base.update_all_stock_locations
        Spree::StockLocation.all.each do |stock_location|
          SpreeApfusion::StockLocation.update(stock_location)
        end
      end
    end

    def create_at_apfusion
      SpreeApfusion::StockLocation.create(self)
    rescue
    end

    def update_at_apfusion
      SpreeApfusion::StockLocation.update(self)
    rescue
    end

    def destroy_at_apfusion
      SpreeApfusion::StockLocation.destroy(self)
    end
  end

  StockLocation.prepend(StockLocationDecorator)
end
