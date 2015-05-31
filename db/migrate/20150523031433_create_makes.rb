class CreateMakes < ActiveRecord::Migration
  def up
    create_table :makes do |t|
      t.string :name
      t.string :niceName
      t.integer :edmunds_make_id

      t.timestamps
    end
  end

  def down
  	drop_table :makes
  end
end
