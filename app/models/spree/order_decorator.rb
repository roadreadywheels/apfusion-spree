module Spree
  module OrderDecorator
    def self.prepended(base)
    	base.include Spree::ApfusionOrderConcern
    	base.scope :last_apfusion_order_id, -> { where.not(apfusion_order_id: nil).order(:created_at).last }

		  def base.sync_orders(options = {})
		    response = Spree::ApfusionOrderConcern.get_apfusion_response(options)

		    Spree::ApfusionOrderConcern.create_apfusion_orders(response) if response.is_a?(Array)
		  end
    end

    def deliver_order_confirmation_email
			unless self.apfusion_order_id.present?
		  	Spree::OrderMailer.confirm_email(id).deliver_later
		  	update_column(:confirmation_delivered, true)
		  end
		end
  end

  Order.prepend(OrderDecorator)
end
