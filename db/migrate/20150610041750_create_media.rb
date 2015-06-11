class CreateMedia < ActiveRecord::Migration
  def up
    create_table :media do |t|
      t.string :title
      t.string :category
      t.string :tags, array: true
      t.string :provider
      t.json :sources, array: true
      t.string :color
      t.string :submodels, array: true
      t.string :shot_type_abbr
      t.integer :style_id

      t.timestamps null: false
    end
  end

  def down
    drop_table :media
  end
end
