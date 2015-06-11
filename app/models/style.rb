class Style < ActiveRecord::Base
	include PgSearch

	belongs_to :modelyear
	has_many :consumer_ratings
	has_many :media

	multisearchable :against => [:edmunds_style_id, :name, :submodel, :trim, :modelyear_id]
	pg_search_scope :search, :against => [:submodel, :name, :trim],
									:associated_against => { :modelyear => [:name, :year], :consumer_ratings => [:averagerating]}


	validates :modelyear_id, presence: true
	validates :edmunds_style_id, presence: true, uniqueness: true
	validates :name, presence: true


end
