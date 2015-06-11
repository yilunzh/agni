require 'json'
require 'rest_client'

class Make < ActiveRecord::Base
	include PgSearch
	multisearchable :against => [:name, :edmunds_make_id]

	has_many :modelyears
	
	validates :edmunds_make_id, presence: true, uniqueness: true
	validates :niceName, presence: true


end	