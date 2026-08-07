module Spree
  module ShipmentDecorator
    def self.prepended(base)
      base.after_update :update_at_apfusion, if: Proc.new { |shipment| shipment.tracking.present? && shipment.apfusion_shipment_id.present? }
    end

    def update_at_apfusion
      SpreeApfusion::Shipment.update(self)
    end
  end

  Shipment.prepend(ShipmentDecorator)
end
