class AddApfusionVariantIdToVariant < ActiveRecord::Migration
  def change
  	add_column :spree_variants, :apfusion_variant_id, :integer
  end
end
