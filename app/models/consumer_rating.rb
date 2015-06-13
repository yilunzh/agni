class ConsumerRating < ActiveRecord::Base
	include PgSearch
	multisearchable :against => [:reviews, :averagerating, :reviewscount]

	belongs_to :style

	validates :averagerating, presence: true
	validates :reviewsCount, presence: true

end
