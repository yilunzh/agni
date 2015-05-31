class CreateConsumerRatings < ActiveRecord::Migration
  def up
    create_table :consumer_ratings do |t|
      t.float :averageRating
      t.json :links, array: true
      t.json :reviews, array: true
      t.integer :reviewsCount
      t.integer :style_id

      t.timestamps null: false
    end
  end

  def down
  	drop_table :consumer_ratings
  end
end
