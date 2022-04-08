class AddApfusionStockLocationIdToStockLocation < ActiveRecord::Migration
  def change
  	add_column :spree_stock_locations, :apfusion_stock_location_id, :integer
  end
end
