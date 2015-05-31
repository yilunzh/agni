class CreateStyles < ActiveRecord::Migration
  def up
    create_table :styles do |t|
      t.integer :modelyear_id
      t.integer :edmunds_style_id
      t.string :name
      t.hstore :submodel
      t.string :trim

      t.timestamps null: false
    end
  end

  def down
    drop_table :styles
  end
end
