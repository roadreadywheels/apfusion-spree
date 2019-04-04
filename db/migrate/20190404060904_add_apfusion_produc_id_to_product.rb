class AddApfusionProducIdToProduct < ActiveRecord::Migration
  def change
  	add_column :spree_products, :apfusion_product_id, :integer
  end
end
