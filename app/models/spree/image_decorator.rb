module Spree
  module ImageDecorator
    def self.prepended(base)
      base.after_commit ->(obj) {obj.create_at_apfusion}, on: :create

      def base.create_all_images
        Spree::Image.where(apfusion_image_id: nil).each do |image|
          SpreeApfusion::Image.create(image)
        end
      end

      def base.update_all_images
        Spree::Image.all.each do |image|
          SpreeApfusion::Image.update(image)
        end
      end

      def base.update_all_images
        Spree::Image.all.each do |image|
          SpreeApfusion::Image.update(image)
        end
      end
    end

    def create_at_apfusion
      SpreeApfusion::Image.create(self)
    end

    def update_at_apfusion
      SpreeApfusion::Image.update(self)
    end

    def destroy_at_apfusion
      SpreeApfusion::Image.destroy(self)
    end
  end

  # Image.prepend(ImageDecorator)
end
