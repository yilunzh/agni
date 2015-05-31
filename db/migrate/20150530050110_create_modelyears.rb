class CreateModelyears < ActiveRecord::Migration
  def up
    create_table :modelyears do |t|
      t.string :name
      t.string :niceName
      t.integer :year
      t.integer :make_id

      t.timestamps null: false
    end
  end

  def down
  	drop_table :modelyears
  end
end
