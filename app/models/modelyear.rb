class Modelyear < ActiveRecord::Base

	belongs_to :make
	has_many :styles
	has_many :editorial_reviews

	validates :niceName, presence: true, uniqueness: { scope: :year }
	validates :year, presence: true
	validates :make_id, presence: true
end
