class Patient < ActiveRecord::Base
	belongs_to(:location)
	has_many(:doctors, {through: :location})
	def create_patient_profile

		# proof of concept that adding things to the database works

		puts "Please enter your first name: "
		first_name = gets.chomp
		puts "Please enter your last name: "
		last_name = gets.chomp
		puts "Please enter your date of birth: "
		dob = gets.chomp
		puts "Please enter your insurance network: "
		insurance = gets.chomp

		patient = Patient.create(first_name: first_name, last_name: last_name, date_of_birth: dob, insurance_network: insurance)
	end

end