class AddApfusionOptionValueIdToOptionValue < ActiveRecord::Migration
  def change
  	add_column :spree_option_values, :apfusion_option_value_id, :integer
  end
end
