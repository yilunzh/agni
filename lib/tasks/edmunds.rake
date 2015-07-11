namespace :data do
	desc "get makes"
	task :makes => :environment do
		begin
			response = RestClient.get "http://api.edmunds.com/api/vehicle/v2/makes?fmt=json&api_key=#{ENV["edmunds_key"]}"
			response = JSON.parse response
		rescue => e
			Rails.logger.error("#{e.message} #{e.backtrace.join("\n")}")
			puts e.inspect
		end	
		objects = []
		if response != nil
			response["makes"].each do |make|
				make["name"] = "edited name"
				objects << Make.new(edmunds_make_id: make["id"], name: make["name"], niceName: make["niceName"])
				binding.pry
				break
			end
			Make.import objects, :on_duplicate_key_update => [:name], :validate => true
		end
	end

	desc "get model and year"
	task :modelyears => :environment do
		makes = Make.all
		makes.each do |make|
			puts "#{make.niceName}"
			begin
				response = RestClient.get "https://api.edmunds.com/api/vehicle/v2/#{make.niceName}/models?fmt=json&api_key=#{ENV["edmunds_key"]}"
				response = JSON.parse response
			rescue => e
				Rails.logger.error("#{e.message} #{e.backtrace.join("\n")}")
				puts e.inspect
			end
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
		makes = Make.where(niceName: ["honda", "toyota", "nissan", "mazda", "audi", "bmw", "mercedes-benz", "volkswagen", "ford", "chevrolet"])
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
						objects << ConsumerRating.new(averagerating: response["averageRating"], 
																					links: response["links"], reviews: response["reviews"], 
																					reviewscount: response["reviewsCount"], style_id: style.id)
					end
				end
				ConsumerRating.import objects, :validate => true
			end
		end
	end

	task :consumer_ratings => :environment do
		makes = Make.all
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
						objects << ConsumerRating.new(averagerating: response["averageRating"], 
																					links: response["links"], reviews: response["reviews"], 
																					reviewscount: response["reviewsCount"], style_id: style.id)
					end
				end
				ConsumerRating.import objects, :validate => true
			end
		end
	end

	task :editorial_review_test => :environment do
		makes = Make.where(niceName: ["honda", "toyota", "nissan", "mazda", "audi", "bmw", "mercedes-benz", "volkswagen", "ford", "chevrolet"])
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

	task :editorial_review => :environment do
		makes = Make.all
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

	task :media => :environment do
		ratings = ConsumerRating.all
		ratings.each do |rating|
			style = rating.style
			puts "#{style.name}"
			objects = []
			begin
				response = RestClient.get "https://api.edmunds.com/api/media/v2/styles/#{style.edmunds_style_id}/photos?view=full&api_key=#{ENV["edmunds_key"]}&fmt=json"
				response = JSON.parse response
			rescue => e
				Rails.logger.error { "#{e.message} #{e.backtrace.join("\n")}" }
			end
			if response != nil
				photos = response["photos"]
				photos.each do |photo|
					medium = Medium.new(title: photo["title"], category: photo["category"], tags: photo["tags"],
														provider: photo["provider"], sources: photo["sources"], color: photo["color"],
														submodels: photo["submodels"], shot_type_abbr: photo["shotTypeAbbreviation"], 
														style_id: style.id)
					objects << medium
				end
			end 
			Medium.import objects, :validate => true
		end
	end

	task :prices => :environment do
		ratings = ConsumerRating.all
		objects = []
		ratings.each do |rating|
			style = rating.style
			puts "#{style.name}"
			begin
				response = RestClient.get "https://api.edmunds.com/v1/api/tmv/tmvservice/calculateusedtmv?styleid=#{style.edmunds_style_id}&condition=clean&mileage=50000&zip=85257&fmt=json&api_key=#{ENV["edmunds_key"]}"
				response = JSON.parse response
			rescue => e
				Rails.logger.error { "#{e.message} #{e.backtrace.join("\n")}" }
			end

			if response != nil
				national_prices = response["tmv"]["nationalBasePrice"]
				national_prices.each do |k, v|
					if not v.nil?
						price = Price.new(base_msrp: national_prices["base_msrp"], base_invoice: national_prices["baseInvoice"],
															delivery_charges: national_prices["deliveryCharges"], tmv: national_prices["tmv"],
															used_tmv_retail: national_prices["usedTmvRetail"], used_private_party: national_prices["usedPrivateParty"],
															used_trade_in: national_prices["usedTradeIn"], estimate_tmv: national_prices["estimateTmv"],
															tmv_recommended_rating: national_prices["tmvRecommendedRating"], style_id: style.id)

						objects << price
						break
					end	
				end
			end 
			if objects.count > 50
				Price.import objects, :validate => true
				objects = []
			end
		end
	end

end