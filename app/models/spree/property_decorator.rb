module Spree
  module PropertyDecorator
    def self.prepended(base)

      def base.update_all_property
        Spree::Property.all.each do |property|
          SpreeApfusion::Property.update(property)
        end
      end
    end

    def create_at_apfusion
      SpreeApfusion::Property.create(self)
    end

    def update_at_apfusion
      SpreeApfusion::Property.update(self)
    end

    def destroy_at_apfusion
      SpreeApfusion::Property.destroy(self)
    end
  end

  Property.prepend(PropertyDecorator)
end
