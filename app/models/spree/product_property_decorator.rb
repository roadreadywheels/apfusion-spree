module Spree
  module ProductPropertyDecorator
    def self.prepended(base)

      def base.update_all_product_properties
        Spree::Product.all.each do |product|
          product.product_properties.each do |product_property|
            SpreeApfusion::ProductProperty.update(product_property)
          end
        end
      end
    end

    def create_at_apfusion
      SpreeApfusion::ProductProperty.create(self)
    end

    def update_at_apfusion
      SpreeApfusion::ProductProperty.update(self)
    end

    def destroy_at_apfusion
      SpreeApfusion::ProductProperty.destroy(self)
    end
  end

  ProductProperty.prepend(ProductPropertyDecorator)
end
