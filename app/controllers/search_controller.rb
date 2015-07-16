class SearchController < ApplicationController
	def search
		@results= []
		@bodytypes = ["sedan", "coupe", "suv"]
		@search = {}
		# @bodytypes = [["Sedan", "sedan"], ["Coupe", "coupe"], ["Hatchback", "hatchback"], ["Crossover", "crossover"],
		# 							["SUV", "suv"], ["Minivan", "minivan"], ["Wagon", "wagon"]]

		if params['/search'].nil?
			@styles = []
		else
			clean_search_params
			@search = { description: params['/search'][:description],
									bodytype: params['/search'][:bodytype], 
									minyear: params["/search"][:minyear], 
									maxyear: params["/search"][:maxyear],
									maxprice: params["/search"][:maxprice] }
			
			@styles = Style.where("submodel -> 'body' ilike '%#{params['/search'][:bodytype]}%'")
										 .joins(:modelyear).where("modelyears.year >= #{params['/search'][:minyear].to_i}
																							 and modelyears.year <= #{params['/search'][:maxyear].to_i}")
										 .joins(:prices).where("prices.used_tmv_retail <= #{params['/search'][:maxprice].to_i}")
										 .joins(:consumer_ratings).where("consumer_ratings.reviewscount >= 10")
										 .order("consumer_ratings.averagerating DESC, consumer_ratings.reviewscount DESC").limit(12)
			
			unless @styles.empty? 
				@styles.each do |style|
					result = {}
					modelyear = style.modelyear
					make = modelyear.make
					if not @results.any? { |result| result[:modelyear].niceName == modelyear.niceName and result[:modelyear].year == modelyear.year }
						media = style.media.where("media.shot_type_abbr = 'FQ' and media.category = 'EXTERIOR'").first
						photo = ""
						price = ActionController::Base.helpers.number_to_currency(style.prices.first.used_tmv_retail, precision: 0)
						if media
							media["sources"].each do |source|
								if source["size"]["width"] == 300
									photo = "http://media.ed.edmunds-media.com" + source["link"]["href"]
								end
							end
						end
						if not style.consumer_ratings.empty?
							rating = style.consumer_ratings[0]["averagerating"]
							reviews_count = style.consumer_ratings[0]["reviewscount"]
						end

						result = { make: make, modelyear: modelyear, style: style, price: price, 
											 rating: rating, reviews_count: reviews_count, photo: photo }
						@results << result
					end
				end
			end
		end
	end

	private

	def clean_search_params
		params["/search"][:minyear] = 1990 if params['/search'][:minyear].empty?
		params["/search"][:maxyear] = Time.now.year if params['/search'][:maxyear].empty?
		params["/search"][:maxprice] = 100000 if params['/search'][:maxprice].empty?
	end
end
