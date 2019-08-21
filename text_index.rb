require_relative 'config/environment.rb'
prompt = TTY::Prompt.new

current_patient = nil

while current_patient == nil
	users_response = prompt.select("Please either: ", [
		"Sign Up",
		"Login",
	])
	if (users_response == "Sign Up")
		username = prompt.ask("Please enter a username:")
		password = prompt.ask("Please enter a password:")
		
		current_patient = Patient.create({
			user_name: username,
			password: password
		})
	end

	if (users_response == "Login")
		current_patient = Patient.where({
			user_name: prompt.ask("What is your username?"),
			password: prompt.ask("What is your password?")
		})
	end
end

while true

	puts "Hello! Please take a moment to update your profile if you are a new patient or
	your information has changed."

	users_response = prompt.select("What do you want to do ?", [
		"Update Profile",
		"Search for Doctors",
		"Review Searches",
		"Quit"
	])
	case users_response
	when "Update Profile"
		response = prompt.select("What would you like to update?", [
			"First Name",
			"Last Name",
			"City",
			"Quit"
		])
		case response
			when "First Name"
				first_name = prompt.ask("Please enter your first name: ")
				current_patient.update(first_name: first_name)
			when "Last Name"
				last_name = prompt.ask("Please enter your last name: ")
				current_patient.update(last_name: last_name)
			when "City"
				city = prompt.ask("What city in the Greater Houston Metro Area are you in?
					Please enter the city in all caps with no spaces. Ex. SUGARLAND instead of Sugar Land")
				current_patient.update(city: city)
			when "Quit"
				break
			else
				"Please choose a valid option"
			end
	when "Search for Doctors"
		search_response = prompt.select("What would you like to search by?", [
			"City Location",
			"Specialty"
		])
		case search_response
			when "City Location"
				doc_location = {}
				Doctor.order(first_name: :asc).each do | doctor |
					doc_location[doctor.city] = doctor.id
				end
				city_location = prompt.select("What city do you want to search?", doc_location)
				case city_location
					when "HOUSTON"
						doc_names = {}
						Doctor.find_by(city: "HOUSTON").each do |doctor|
							doc_names[doctor.first_name]
						end
						select_doctor = prompt.select("Which doctor do you want?", doc_names)
					end
			# when "Specialty"
			# 	doc_specialty = {}
			# 	Doctor.order(first_name: :asc).each do | doctor |
			# 		doc_specialty[doctor.specialty] = doctor.id
			# 	end
			# 	doctor_id = prompt.select("What Specialty do you want to search?", doc_specialty)
			# 	Location.create({
			# 		doctor_id: doctor_id,
			# 		patient_id: current_patient.id
			# 	})
			# end
		end
	end
end



