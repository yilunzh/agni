class UpdateConsumerRating < ActiveRecord::Migration
  def up
  	rename_column :consumer_ratings, :averageRating, :averagerating
  	rename_column :consumer_ratings, :reviewsCount, :reviewscount
  end

  def down
  	rename_column :consumer_ratings, :averagerating, :averageRating
  	rename_column :consumer_ratings, :reviewscount, :reviewsCount
  end
end
