module Spree
  module ZoneDecorator
    def create_at_apfusion
      SpreeApfusion::Zone.create(self)
    end

    def update_at_apfusion
      SpreeApfusion::Zone.update(self)
    end

    def destroy_at_apfusion
      SpreeApfusion::Zone.destroy(self)
    end
  end

  Zone.prepend(ZoneDecorator)
end
