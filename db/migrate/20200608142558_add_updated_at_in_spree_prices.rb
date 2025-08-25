class AddUpdatedAtInSpreePrices < ActiveRecord::Migration
  def change
  	add_column :spree_prices, :created_at, :datetime, null: false unless column_exists?(:spree_prices, :created_at)
    add_column :spree_prices, :updated_at, :datetime, null: false unless column_exists?(:spree_prices, :updated_at)
  end
end
