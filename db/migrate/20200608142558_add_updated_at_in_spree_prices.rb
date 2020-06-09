class AddUpdatedAtInSpreePrices < ActiveRecord::Migration
  def change
  	add_column :spree_prices, :created_at, :datetime, null: false
    add_column :spree_prices, :updated_at, :datetime, null: false
  end
end
