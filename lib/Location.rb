class Location < ActiveRecord::Base
	has_many(:patients)
	has_many(:doctors)

	def add_location
		puts "Please input where you live: "
		user_location = gets.chomp

		location = Location.create(name: user_location)
	end
end