class AddApfusionStockItemIdToStockItem < ActiveRecord::Migration
  def change
  	add_column :spree_stock_items, :apfusion_stock_item_id, :integer
  end
end
