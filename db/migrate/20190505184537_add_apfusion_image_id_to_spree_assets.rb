class AddApfusionImageIdToSpreeAssets < ActiveRecord::Migration
  def change
  	add_column :spree_assets, :apfusion_image_id, :integer
  end
end
