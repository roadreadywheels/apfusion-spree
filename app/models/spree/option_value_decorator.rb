module Spree
  module OptionValueDecorator
    def create_at_apfusion
      SpreeApfusion::OptionValue.create(self)
    end

    def update_at_apfusion
      SpreeApfusion::OptionValue.update(self)
    end

    def destroy_at_apfusion
      SpreeApfusion::OptionValue.destroy(self)
    end
  end

  OptionValue.prepend(OptionValueDecorator)
end
