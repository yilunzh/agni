class ConsumerRating < ActiveRecord::Base
	belongs_to :style

	validates :averageRating, presence: true
	validates :reviewsCount, presence: true

end
