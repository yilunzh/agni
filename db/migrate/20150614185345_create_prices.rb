class CreatePrices < ActiveRecord::Migration
  def up
    create_table :prices do |t|
      t.integer :base_msrp
      t.integer :base_invoice
      t.integer :delivery_charges
      t.integer :tmv
      t.integer :used_tmv_retail
      t.integer :used_private_party
      t.integer :used_trade_in
      t.integer :estimate_tmv
      t.string :tmv_recommended_rating
      t.integer :style_id

      t.timestamps null: false
    end
  end

  def down
    drop_table :prices
  end
end
