module Spree
  module ShipmentDecorator
    def self.prepended(base)
      base.after_update :update_at_apfusion, if: Proc.new { |shipment| shipment.tracking.present? }
    end

    def update_at_apfusion
      SpreeApfusion::Shipment.update(self)
    end
  end

  Shipment.prepend(ShipmentDecorator)
end
