require_relative '../lib/tty-spinner'
require_relative '../examples/multi/custom_style.rb'
require 'rest-client'
require 'json'
require 'rainbow'

ActiveRecord::Base.logger = nil
# prompt = TTY::Prompt.new
current_patient = nil
class CommandLine
 
  #displays welcome message

  def greet
    puts Rainbow("

        ooo.               
       8  `8.              
o    o 8   `8 .oPYo. .oPYo.
8    8 8    8 8    8 8    '
8    8 8   .P 8    8 8    .
`Y00P' 8ooo'  `YooP' `YooP'
./\/\ :.....:.....:::.....:
:.....:::::::::::::::::::::
::::::::::::::::::::::::::: 

       ").green
    # puts Rainbow(" ❤ /\\❤  The uDoc App  ❤ /\\❤ \n Find your doctor by location or specialty:  \n").white.bright
     puts Rainbow(" ❤ ❤  The ultimate Doctor finding App ❤ ❤").white.bright 
     puts Rainbow("Find your doctor by location or specialty:  \n").green
  end

  def starting_menu
    prompt = TTY::Prompt.new

    current_patient = nil
    
    while current_patient == nil
      users_response = prompt.select("Please either: ", [
        "Login in to your profile",
        "Create a new profile",
        "Go rogue",
        "Quit"
      ])
      if (users_response == "Create a new profile")
        username = prompt.ask("Please enter a username:")
        spinnerFunction
        password = prompt.ask("Please enter a password:")
        
        current_patient = Patient.create({
          user_name: username,
          password: password
        })
    
        current_patient_location = Location.create({
          patient_id: current_patient.id
        })
      end
    
      if (users_response == "Login in to your profile")
        current_patient = Patient.where({
          user_name: prompt.ask("What is your username?"),
          password: prompt.ask("What is your password?")
        })
      end

      if (users_response == "Go rogue")
        puts "You must make a profile or login"
      end

      if (users_response == "Quit")
        quit
      end


    end
    
    while true
    
      puts "Hello! Please take a moment to update your profile if you are a new patient or
      your information has changed.  Otherwise, enjoy the uDoc App!"
    
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
            puts "First Name Successfully updated!"
          when "Last Name"
            last_name = prompt.ask("Please enter your last name: ")
            current_patient.update(last_name: last_name)
            puts "Last Name Successfully updated!"
          when "City"
            city = prompt.ask("What city in the Greater Houston Metro Area are you in?")
            current_patient.update(city: city)
            current_patient_location.update(name: city)
            puts "City Successfully updated!"
          when "Quit"
            
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

                #binding.pry

                doctor_id = prompt.select("Which Doctor?", refined_doctor_hash)
                Search.create({
                    doctor_id: doctor_id,
                    patient_id: current_patient[0].id
                })
            else
                doctor_id = prompt.select("Which Doctor?", doctor_hash)
                Search.create({
                    doctor_id: doctor_id,
                    patient_id: current_patient[0].id
                })
            end
          end

        when "Review Searches"
          puts "Yay You clicked it"


        when "Quit"
          quit
      end
    end
    
    
    
    


  end

end


  #quits the app
  def quit
    puts Rainbow("\n\n ❤ ❤ ❤  Thanks for choosing uDoc, we hope he's a great fit ❤ ❤ ❤ \n\n").green
    nil
    exit
  end





