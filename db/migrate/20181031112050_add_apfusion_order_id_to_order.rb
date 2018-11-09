class AddApfusionOrderIdToOrder < ActiveRecord::Migration
  def change
  	add_column :spree_orders, :apfusion_order_id, :integer
  end
end
