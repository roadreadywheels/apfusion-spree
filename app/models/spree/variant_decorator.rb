module Spree
  module VariantDecorator
    def create_at_apfusion
      SpreeApfusion::Variant.create(self)
    end

    def update_at_apfusion
      SpreeApfusion::Variant.update(self)
    end

    def destroy_at_apfusion
      SpreeApfusion::Variant.destroy(self)
    end
  end

  Variant.prepend(VariantDecorator)
end
