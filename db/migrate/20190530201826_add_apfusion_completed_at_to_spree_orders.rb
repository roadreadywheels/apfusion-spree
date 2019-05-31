class AddApfusionCompletedAtToSpreeOrders < ActiveRecord::Migration
  def change
  	add_column :spree_orders, :apfusion_completed_at, :datetime
  end
end
