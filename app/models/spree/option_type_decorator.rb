module Spree
  module OptionTypeDecorator
    def create_at_apfusion
      SpreeApfusion::OptionType.create(self)
    end

    def update_at_apfusion
      SpreeApfusion::OptionType.update(self)
    end

    def destroy_at_apfusion
      SpreeApfusion::OptionType.destroy(self)
    end
  end

  OptionType.prepend(OptionTypeDecorator)
end
