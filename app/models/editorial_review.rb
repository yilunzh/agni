class EditorialReview < ActiveRecord::Base
	belongs_to :modelyear

	validates :description, presence: true 
end
