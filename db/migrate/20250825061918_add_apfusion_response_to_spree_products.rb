class AddApfusionResponseToSpreeProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :spree_products, :apfusion_response, :text unless column_exists?(:spree_products, :apfusion_response)
    add_column :spree_stock_items, :apfusion_response, :text unless column_exists?(:spree_stock_items, :apfusion_response)
  end
end
