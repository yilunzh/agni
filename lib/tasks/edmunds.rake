namespace :data do
	desc "get makes"
	task :makes => :environment do
		response = RestClient.get "http://api.edmunds.com/api/vehicle/v2/makes?fmt=json&api_key=#{ENV["edmunds_key"]}"
		response = JSON.parse response
		objects = []
		response["makes"].each do |make|
			objects << Make.new(edmunds_make_id: make["id"], name: make["name"], niceName: make["niceName"])
		end
		Make.import objects, :validate => true
	end

	desc "get model and year"
	task :modelyears => :environment do
		makes = Make.all
		makes.each do |make|
			puts "#{make.niceName}"
			response = RestClient.get "https://api.edmunds.com/api/vehicle/v2/#{make.niceName}/models?fmt=json&api_key=#{ENV["edmunds_key"]}"
			response = JSON.parse response
			objects = []
			response["models"].each do |model|
				model["years"].each do |year|
					objects << Modelyear.new(name: model["name"], niceName: model["niceName"], year: year["year"], make_id: make.id)
				end
			end
			Modelyear.import objects, :validate => true
		end
	end

	desc "get styles"
	task :styles => :environment do
		makes = Make.all
		errors = []
		makes.each do |make|
			make.modelyears.each do |modelyear|
				puts "#{make.niceName} #{modelyear.niceName} #{modelyear.year}"
				begin
					response = RestClient.get "https://api.edmunds.com/api/vehicle/v2/#{make.niceName}/#{modelyear.niceName}/#{modelyear.year}/styles?fmt=json&api_key=#{ENV["edmunds_key"]}"
					response = JSON.parse response
				rescue => e
					Rails.logger.error {"#{e.message} #{e.backtrace.join("\n")}"}
					nil
				end
				errors << {make: make.niceName, model: modelyear.niceName, year: modelyear.year, error: e}
				objects = []
				response["styles"].each do |style|
					objects << Style.new(edmunds_style_id: style["id"], name: style["name"], submodel: style["submodel"], trim: style["trim"], modelyear_id: modelyear.id)
				end
				Style.import objects, :validate => true
			end	
		end
	end

	task :consumer_ratings_test => :environment do
		makes = Make.where(niceName: ["ferrari", "lamborghini", "porsche"])
		makes.each do |make|
			make.modelyears.each do |modelyear|
				objects = []
				modelyear.styles.each do |style|
					errors = []
					puts "#{make.niceName} #{modelyear.niceName} #{modelyear.year} #{style.name}"
					begin
						response = RestClient.get "https://api.edmunds.com/api/vehiclereviews/v2/styles/#{style.edmunds_style_id}?fmt=json&api_key=#{ENV["edmunds_key"]}"
						response = JSON.parse response
					rescue => e
						Rails.logger.error { "#{e.message} #{e.backtrace.join("\n")}" }
						nil
					end
					if response != nil
						objects << ConsumerRating.new(averageRating: response["averageRating"], links: response["links"], reviews: response["reviews"], reviewsCount: response["reviewsCount"])
					end
				end
				ConsumerRating.import objects, :validate => true
			end
		end
	end

	task :editorial_review_test => :environment do
		makes = Make.where(niceName: ["ferrari", "lamborghini", "porsche"])
		makes.each do |make|
			objects = []
			make.modelyears.each do |modelyear|
				puts "#{make.niceName} #{modelyear.niceName} #{modelyear.year}"
				begin
					response = RestClient.get "https://api.edmunds.com/api/editorial/v2/#{make.niceName}/#{modelyear.niceName}/#{modelyear.year}?api_key=#{ENV["edmunds_key"]}&fmt=json"
					response = JSON.parse response
				rescue => e
					Rails.logger.error { "#{e.message} #{e.backtrace.join("\n")}" }
					nil
				end
				if response != nil
					objects << EditorialReview.new(tags: response["tags"], description: response["description"], 
																				 introduction: response["introduction"], link: response["link"],
																				 edmundsSays: response["edmundsSays"], pros: response["pros"],
																				 cons: response["cons"], whatsNew: response["whatsNew"],
																				 body: response["body"], powertrain: response["powertrain"],
																				 safety: response["safety"], interior: response["interior"],
																				 driving: response["driving"], modelyear_id: modelyear.id)
				end
			end	
			EditorialReview.import objects, :validate => true
		end
	end

end