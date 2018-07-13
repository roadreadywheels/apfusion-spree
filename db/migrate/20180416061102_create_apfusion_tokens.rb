class CreateApfusionTokens < ActiveRecord::Migration
  def change
    create_table :apfusion_tokens do |t|
    	t.string :token
    	t.string :scope
      t.timestamps null: false
    end
  end
end
