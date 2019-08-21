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
	if (users_response == "Update Profile")
		response = prompt.select("What would you like to update/do?", [
			"First Name",
			"Last Name",
			"City",
			"Quit"
		])
		if (response == "First Name")
			first_name = prompt.ask("What is your first name?")
			current_patient.update(first_name: first_name)
		end

		if (response == "Last Name")
			last_name = prompt.ask("What is your last name?")
			current_patient.update(last_name: last_name)
		end

		if (response == "City")
			city = prompt.ask("What city in the Greater Houston Metro area are you in?")
			current_patient.update(city: city)
		end

	if (response == "Search for Doctors")
		doc_response = prompt.select("What would you like to search by?", [
			"City Location",
			"Specialty"
		])
		if (doc_response == "City Location")
			doc_specialty = {}
			Doctor.order(first_name: :asc).each do |doctor|
				doc_specialty[doctor.first_name] = doctor.id
			end
			doctor_id = prompt.ask("What specialty do you want to search by?", doc_specialty)
			Location.create({
				patient_id: current_patient.id,
				doctor_id: doctor_id
			})
			end
	
	end
	if (users_response == "Quit")
		break
	end
end



