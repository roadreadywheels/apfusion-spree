Spree::Order.class_eval do
  include Spree::ApfusionOrderConcern
  scope :last_apfusion_order_id, -> { where.not(apfusion_order_id: nil).order(:created_at).last }

  def self.sync_orders options = {}
    response = Spree::ApfusionOrderConcern.get_apfusion_response(options)
    Spree::ApfusionOrderConcern.create_apfusion_orders(response) if response.is_a?(Array)
  end

	def deliver_order_confirmation_email
		p "deliver order confirmation called"*20
		unless self.apfusion_order_id.present?
	  	Spree::OrderMailer.confirm_email(id).deliver_later
	  	update_column(:confirmation_delivered, true)
	  end
	end
end
