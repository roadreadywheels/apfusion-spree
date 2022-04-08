class AddShipmentIdFromApfusion < ActiveRecord::Migration
  def change
  	add_column :spree_shipments, :apfusion_shipment_id, :string
  end
end
