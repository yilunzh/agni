class SearchController < ApplicationController
	def search
		@results= []
		@bodytypes = [["Sedan", "sedan"], ["Coupe", "coupe"], ["Hatchback", "hatchback"], ["Crossover", "crossover"],
									["SUV", "suv"], ["Minivan", "minivan"], ["Wagon", "wagon"]]

		if params['/search'].nil?
			@styles = []
		else
			clean_search_params
			@styles = Style.joins(:modelyear).where("submodel -> 'body' ilike '%#{params['/search'][:bodytype]}%'  
																							 and modelyears.year >= #{params['/search'][:minyear].to_i}
																							 and modelyears.year <= #{params['/search'][:maxyear].to_i}")
										 .joins(:consumer_ratings)
										 .order("consumer_ratings.averagerating DESC, consumer_ratings.reviewscount DESC").limit(4)
			unless @styles.empty? 
				@styles.each do |style|
					result = {}
					modelyear = style.modelyear
					make = modelyear.make
					media = style.media.where("media.shot_type_abbr = 'FQ' and media.category = 'EXTERIOR'").first
					binding.pry
					photo = ""
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

					result = { make: make, modelyear: modelyear, style: style, rating: rating, reviews_count: reviews_count, photo: photo}
					@results << result
				end
			end
		end
	end

	private

	def clean_search_params
		params["/search"][:minyear] = 1990 if params['/search'][:minyear].empty?
		params["/search"][:maxyear] = Time.now.year if params['/search'][:maxyear].empty?
	end
end
