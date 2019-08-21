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

		current_patient_location = Location.create({
			patient_id: current_patient.id
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
		case response
			when "First Name"
				first_name = prompt.ask("Please enter your first name: ")
				current_patient.update(first_name: first_name)
			when "Last Name"
				last_name = prompt.ask("Please enter your last name: ")
				current_patient.update(last_name: last_name)
			when "City"
				city = prompt.ask("What city in the Greater Houston Metro Area are you in?")
				current_patient.update(city: city)
				current_patient_location.update(name: city)
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
				doctor_locations = Doctor.distinct.pluck(:city).sort
				doctor_specialty = Doctor.distinct.pluck(:specialty).sort
				doctor_array = []
				city_location = prompt.select("Which city?", doctor_locations)
				Doctor.where(city: city_location).find_each do |doctor|
					doctor_array << doctor
				end
				puts "There are #{doctor_array.length} doctors in #{city_location}"
				refine_selection = prompt.select("Would you like to refine your search?", [
					"Yes",
					"No"
				])
				if refine_selection == "Yes"
					doc_spec = prompt.select("Which specialty?", doctor_specialty)
					doctor_array.each do |doctor|
						if doc_spec == doctor.specialty
							
						end
					end
				end


			when "Specialty"

			else
				"Please choose a valid option"

				
			end
				
			
				
	
		
	end
end



