class AddApfusionOptionTypeIdToOptionType < ActiveRecord::Migration
  def change
  	add_column :spree_option_types, :apfusion_option_type_id, :integer
  end
end
