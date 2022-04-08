class AddApfusionProductPropertyIdToSpreeProductProperties < ActiveRecord::Migration
  def change
  	add_column :spree_product_properties, :apfusion_product_property_id, :integer
  end
end
