require_relative '../lib/tty-spinner'
require_relative '../examples/multi/custom_style.rb'
require_relative '../examples/multi/spinnerFunctions.rb'
require_relative '../examples/happy_ending.rb'
require_relative '../lib/tty-font'
require 'rest-client'
require 'json'
require 'rainbow'
require 'pastel'

ActiveRecord::Base.logger = nil
# prompt = TTY::Prompt.new
current_patient = nil
class CommandLine
 
  #displays welcome message



  def greet

    pastel = Pastel.new
    font = TTY::Font.new("3d")
    puts
    puts pastel.green(font.write('uDoc'))
    puts




#     puts Rainbow("

#         ooo.               
#        8  `8.              
# o    o 8   `8 .oPYo. .oPYo.
# 8    8 8    8 8    8 8    '
# 8    8 8   .P 8    8 8    .
# `Y00P' 8ooo'  `YooP' `YooP'
# ./\/\ :.....:.....:::.....:
# :.....:::::::::::::::::::::
# ::::::::::::::::::::::::::: 

#        ").green
     puts Rainbow(" ❤ ❤  The ultimate Doctor finding App ❤ ❤").white
     puts Rainbow("Find your doctor by location or specialty:  \n").green
  end

  def starting_menu
    prompt = TTY::Prompt.new

    current_patient = nil
    spinnerFunctionForMainScreen
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
        spinnerFunction3
        current_patient = Patient.create({
          user_name: username,
          password: password
        })
  
      end
    
      if (users_response == "Login in to your profile")
        spinnerFunctionForLogin
        current_patient = Patient.where({
          user_name: prompt.ask("What is your username?"),
          password: prompt.ask("What is your password?")
        })
        spinnerFunction4
      end

      if (users_response == "Go rogue")
        users_response_for_rogue = prompt.select("Rogue warrior mode: ", [
          "Search for Doctors",
          "Quit"
        ])
        case users_response_for_rogue
        when "Search for Doctors"


          search_response = prompt.select("What would you like to search by?", [
            "City Location",
            "Specialty"
          ])
          case search_response
            when "City Location"
              spinnerFunction5
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
            end
      




        when "Quit"
          happy_ending_exit
        end  





    #   when "Search for Doctors"
    #     search_response = prompt.select("What would you like to search by?", [
    #       "City Location",
    #       "Specialty"
    #     ])





        case search_response
          when "City Location"
            spinnerFunction5
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
            spinnerFunction5
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
              })
    
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
      end

      if (users_response == "Quit")
        quit
      end


    end
    
    while true
    

      puts
      puts "Login successful!  Enjoy uDoc :)"
      puts
    
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
            spinnerFunction4
            puts
            puts "First Name Successfully updated!"
            puts
          when "Last Name"
            last_name = prompt.ask("Please enter your last name: ")
            current_patient.update(last_name: last_name)
            spinnerFunction4
            puts
            puts "Last Name Successfully updated!" 
            puts
          when "City"
            city = prompt.ask("What city in the Greater Houston Metro Area are you in?")
            current_patient.update(city: city)
            current_patient_location.update(name: city)
            spinnerFunction4
            puts
            puts "City Successfully updated!" 
            puts
          when "Quit"
            quit
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
            spinnerFunction5
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
            spinnerFunction5
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
              })
    
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
    happy_ending_exit
  end

