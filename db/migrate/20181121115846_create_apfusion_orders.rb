class CreateApfusionOrders < ActiveRecord::Migration
  def change
    create_table :apfusion_orders do |t|
      t.integer :order_id

      t.timestamps null: false
    end
  end
end
