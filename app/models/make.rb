require 'json'
require 'rest_client'

class Make < ActiveRecord::Base

	has_many :modelyears
	
	validates :edmunds_make_id, presence: true, uniqueness: true
	validates :niceName, presence: true


end	