require_relative 'config/environment.rb'
prompt = TTY::Prompt.new

current_patient = nil

while current_patient == nil
	users_response = prompt.select("Please either: ", [
		"Sign Up",
		"Login",
	])

	case users_response
	when "Sign Up"
		username = prompt.ask("Please enter a username:")
		password = prompt.ask("Please enter a password:")
		
		current_patient = Patient.create({
			user_name: username,
			password: password
		})
	when"Login"
		current_patient = Patient.where({
			user_name: prompt.ask("What is your username?"),
			password: prompt.ask("What is your password?")
		}).first
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
			"Quit"])
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
				doctor_hash = {}
				

				city_location = prompt.select("Which city?", doctor_locations)
				Doctor.where(city: city_location).find_each do |doctor|
					doctor_hash[doctor.last_name] = doctor.id
				end
				puts "There are #{doctor_hash.length} in #{city_location}"
				refined_search = prompt.select("Would you like to refine your search?", [
					"Yes",
					"No"	
				])
				if refined_search == "Yes"
					refined_doctor_hash = {}
					doc_spec = prompt.select("Which Specialty?", doctor_specialty)
					Doctor.where({ city: city_location, specialty: doc_spec}).find_each do |doctor|
						refined_doctor_hash[doctor.last_name] = doctor.id
					end
					doctor_id = prompt.select("Which Doctor?", refined_doctor_hash)
					Search.create({
						doctor_id: doctor_id,
						patient_id: current_patient.id
					})
				else
					doctor_id = prompt.select("Which Doctor?", doctor_hash)
					Search.create({
						doctor_id: doctor_id,
						patient_id: current_patient.id
					})
				end
			when "Specialty"
				doctor_specialties = Doctor.distinct.pluck(:specialty).sort
				doctor_locations = Doctor.distinct.pluck(:city).sort
				doctor_hash = {}

				doctor_specialty = prompt.select("Which Specialty?", doctor_specialties)
				Doctor.where(specialty: doctor_specialty).find_each do |doctor|
					doctor_hash[doctor.last_name] = doctor.id
				end
				puts "There are #{doctor_hash.length} doctors who practice #{doctor_specialty}"
				refined_search = prompt.select("Would you like to refine your search?", [
					"Yes",
					"No"	
				])

				if refined_search == "Yes"
					refined_doctor_hash = {}
					doc_city = prompt.select("Which City?", doctor_locations)
					Doctor.where({ specialty: doctor_specialty, city: doc_city}).find_each do |doctor|
						refined_doctor_hash[doctor.last_name] = doctor.id
					end

					doctor_id = prompt.select("Which Doctor?", refined_doctor_hash)
					Search.create({
						doctor_id: doctor_id,
						patient_id: current_patient.id
					})s 

				else
					doctor_id = prompt.select("Which Doctor?", doctor_hash)
					Search.create({
						doctor_id: doctor_id,
						patient_id: current_patient.id
					})
				end
			else
				"Please choose a valid option"
			end

	when "Review Searches"
		prompt.say("Your Doctors")
		current_patient.searches.reload
		current_patient.searches.each do |search|
		prompt.say(search.doctor.inspect)
		end
	
	end
end
