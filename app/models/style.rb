class Style < ActiveRecord::Base
	belongs_to :modelyear
	has_many :consumer_reviews

	validates :modelyear_id, presence: true
	validates :edmunds_style_id, presence: true, uniqueness: true
	validates :name, presence: true
end
