class AddAsfusionPropertyIdToProperty < ActiveRecord::Migration
  def change
  	add_column :spree_properties, :apfusion_property_id, :integer
  end
end
