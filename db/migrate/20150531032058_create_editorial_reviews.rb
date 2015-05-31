class CreateEditorialReviews < ActiveRecord::Migration
  def up
    create_table :editorial_reviews do |t|
      t.string :tags, array: true
      t.string :description
      t.string :introduction
      t.json :link
      t.string :edmundsSays
      t.string :pros, array: true
      t.string :cons, array: true
      t.string :whatsNew
      t.string :body
      t.string :powertrain
      t.string :safety
      t.string :interior
      t.string :driving
      t.integer :modelyear_id

      t.timestamps null: false
    end
  end

  def down
    drop_table :editorial_reviews
  end
end
