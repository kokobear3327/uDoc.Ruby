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
prompt = TTY::Prompt.new
current_patient = nil
class CommandLine


  def greet

    pastel = Pastel.new
    font = TTY::Font.new("3d")
    puts
    puts pastel.green(font.write('uDoc'))
    puts

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
        }).first
        spinnerFunction4
      end

      if (users_response == "Go rogue")
        spinnerFunction4
        users_response_for_rogue = prompt.select("Rogue warrior mode: ", [
          "Search for Doctors",
          "Quit"
        ])
        case users_response_for_rogue
        when "Search for Doctors"
          search_response = prompt.select("What would you like to search by?", [
              "State",
              "Specialty"
          ])
          case search_response
              when "State"
                  doctor_states = Doctor.distinct.pluck(:state).sort
                  doctor_cities = []
                  doctor_specialties = []
                  doc_hash = {}
                  
                  state_selection = prompt.select("Which State?", doctor_states)
                  Doctor.where(state: state_selection).find_each do |doctor|
                      doc_hash[doctor.as_json.values] = doctor.id
                  end
                  puts "There are #{doc_hash.length} doctors practicing in #{state_selection}"
                  ref_search = prompt.select("Would you like to refine your search?", [
                      "Yes",
                      "No"  
                  ])
                  if ref_search == "Yes"
                      ref_doc_hash = {}
                      ref_selection = prompt.select("How would you like to refine?", [
                          "City",
                          "Specialty"
                      ])
                      case ref_selection
                          when "City"
                              Doctor.where(state: state_selection).find_each do |doctor|
                                  doctor_cities << doctor.city
                              end
                              sorted_cities = doctor_cities.sort
                              city_selection = prompt.select("Which City?", sorted_cities.uniq)
                              Doctor.where(state: state_selection, city: city_selection).find_each do |doctor|
                                  ref_doc_hash[doctor.as_json.values] = doctor.id
                              end
                              puts "There are #{ref_doc_hash.length} doctors in #{city_selection}"
                              sup_ref_search = prompt.select("Would you like to refine the search by specialty?", [
                                  "Yes",
                                  "No"
                              ])
                              if sup_ref_search == "Yes"
                                  sup_ref_doc_hash = {}
                                  Doctor.where(state: state_selection, city: city_selection).find_each do |doctor|
                                      doctor_specialties << doctor.specialty
                                  end
                                  sorted_specialties = doctor_specialties.sort
                                  
                                  specialty_selection = prompt.select("Which Specialty?", sorted_specialties.uniq)
                                  Doctor.where(state: state_selection, city: city_selection, specialty: specialty_selection).find_each do |doctor|
                                      sup_ref_doc_hash[doctor.as_json.values] = doctor.id
                                  end
                                  puts "There are #{sup_ref_doc_hash.length} who practice #{specialty_selection} in #{city_selection}"
                                  doctor_id = prompt.select("Which Doctor?", sup_ref_doc_hash)
                                  
                              else
                                  doctor_id = prompt.select("Which Doctor?", ref_doc_hash)
                                  
                              end
                          when "Specialty"
                              Doctor.where(state: state_selection).find_each do |doctor|
                                  doctor_specialties << doctor.specialty
                              end
                              sorted_specialties = doctor_specialties.sort
                              specialty_selection = prompt.select("Which Specialty?", sorted_specialties.uniq)
                              Doctor.where(state: state_selection, specialty: specialty_selection).find_each do |doctor|
                                  ref_doc_hash[doctor.as_json.values] = doctor.id
                              end
                              prompt.say("There are #{ref_doc_hash.length} doctors practicing #{specialty_selection} in #{state_selection}")
                              sup_ref_search = prompt.select("Would you like to refine the search by city?",[
                                  "Yes",
                                  "No"
                              ])
                              if sup_ref_search == "Yes"
                                  refined_by_city_hash = {}
                                  Doctor.where(state: state_selection, specialty: specialty_selection).find_each do |doctor|
                                      doctor_cities << doctor.city
                                  end
                                  sorted_cities = doctor_cities.sort
                                  city_selection = prompt.select("Which City?", sorted_cities.uniq)
                                  Doctor.where(state: state_selection, specialty: specialty_selection, city: city_selection).find_each do |doctor|
                                      refined_by_city_hash[doctor.as_json.values] = doctor.id
                                  end
                                  prompt.say("There are #{refined_by_city_hash.length} practicing #{specialty_selection} in #{city_selection}")
                                  doctor_id = prompt.select("Which Doctor", refined_by_city_hash)
                                  
                              else
                                  doctor_id = prompt.select("Which Doctor?", ref_doc_hash)
                                 
                              end
                  else
                      doctor_id = prompt.select("Which Doctor?", doctor_hash)
                      
                  end
              end
              when "Specialty"
                  doctor_specialties = Doctor.distinct.pluck(:specialty).sort
                  doctor_hash = {}
                  doctor_specialty = prompt.select("Which Specialty?", doctor_specialties)
                  Doctor.where(specialty: doctor_specialty).find_each do |doctor|
                      doctor_hash[doctor.as_json.values] = doctor.id
                  end
                  puts "There are #{doctor_hash.length} doctors who practice #{doctor_specialty}"
                  refined_search = prompt.select("Would you like to refine your search?", [
                      "Yes",
                      "No"  
                  ])
                  if refined_search == "Yes"
                      refined_doctor_hash = {}
                      spec_doctor_state = []
                      spec_doctor_city = []
                      
                      Doctor.where(specialty: doctor_specialty).find_each do |doctor|
                          spec_doctor_state << doctor.state
                      end
                      spec_sorted_states = spec_doctor_state.sort
                      doc_state_select = prompt.select("Which State?", spec_sorted_states.uniq)
                      Doctor.where(specialty: doctor_specialty, state: doc_state_select).find_each do |doctor|
                          spec_doctor_city << doctor.city
                      end
                      spec_sorted_cities = spec_doctor_city.sort
                      doc_city_select = prompt.select("Which City?", spec_sorted_cities.uniq)
                      Doctor.where(specialty: doctor_specialty, state: doc_state_select, city: doc_city_select).find_each do |doctor|
                          refined_doctor_hash[doctor.as_json.values] = doctor.id
                      end
                      doctor_id = prompt.select("Which Doctor?", refined_doctor_hash)
                      
                  else
                      doctor_id = prompt.select("Which Doctor?", doctor_hash)
                     
                  end 
              else
                  "Please select a valid option"
              end
      




        when "Quit"
          happy_ending_exit
        end  








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
              "State",
              "Specialty"
          ])
          case search_response
              when "State"
                  doctor_states = Doctor.distinct.pluck(:state).sort
                  doctor_cities = []
                  doctor_specialties = []
                  doc_hash = {}
                  
                  state_selection = prompt.select("Which State?", doctor_states)
                  Doctor.where(state: state_selection).find_each do |doctor|
                      doc_hash[doctor.as_json.values] = doctor.id
                  end
                  puts "There are #{doc_hash.length} doctors practicing in #{state_selection}"
                  ref_search = prompt.select("Would you like to refine your search?", [
                      "Yes",
                      "No"  
                  ])
                  if ref_search == "Yes"
                      ref_doc_hash = {}
                      ref_selection = prompt.select("How would you like to refine?", [
                          "City",
                          "Specialty"
                      ])
                      case ref_selection
                          when "City"
                              Doctor.where(state: state_selection).find_each do |doctor|
                                  doctor_cities << doctor.city
                              end
                              sorted_cities = doctor_cities.sort
                              city_selection = prompt.select("Which City?", sorted_cities.uniq)
                              Doctor.where(state: state_selection, city: city_selection).find_each do |doctor|
                                  ref_doc_hash[doctor.as_json.values] = doctor.id
                              end
                              puts "There are #{ref_doc_hash.length} doctors in #{city_selection}"
                              sup_ref_search = prompt.select("Would you like to refine the search by specialty?", [
                                  "Yes",
                                  "No"
                              ])
                              if sup_ref_search == "Yes"
                                  sup_ref_doc_hash = {}
                                  Doctor.where(state: state_selection, city: city_selection).find_each do |doctor|
                                      doctor_specialties << doctor.specialty
                                  end
                                  sorted_specialties = doctor_specialties.sort
                                  
                                  specialty_selection = prompt.select("Which Specialty?", sorted_specialties.uniq)
                                  Doctor.where(state: state_selection, city: city_selection, specialty: specialty_selection).find_each do |doctor|
                                      sup_ref_doc_hash[doctor.as_json.values] = doctor.id
                                  end
                                  puts "There are #{sup_ref_doc_hash.length} who practice #{specialty_selection} in #{city_selection}"
                                  doctor_id = prompt.select("Which Doctor?", sup_ref_doc_hash)
                                  Search.create({
                                    doctor_id: doctor_id,
                                    patient_id: current_patient.id
                                })
                              else
                                  doctor_id = prompt.select("Which Doctor?", ref_doc_hash)
                                  Search.create({
                                    doctor_id: doctor_id,
                                    patient_id: current_patient.id
                                })
                              end
                          when "Specialty"
                              Doctor.where(state: state_selection).find_each do |doctor|
                                  doctor_specialties << doctor.specialty
                              end
                              sorted_specialties = doctor_specialties.sort
                              specialty_selection = prompt.select("Which Specialty?", sorted_specialties.uniq)
                              Doctor.where(state: state_selection, specialty: specialty_selection).find_each do |doctor|
                                  ref_doc_hash[doctor.as_json.values] = doctor.id
                              end
                              prompt.say("There are #{ref_doc_hash.length} doctors practicing #{specialty_selection} in #{state_selection}")
                              sup_ref_search = prompt.select("Would you like to refine the search by city?",[
                                  "Yes",
                                  "No"
                              ])
                              if sup_ref_search == "Yes"
                                  refined_by_city_hash = {}
                                  Doctor.where(state: state_selection, specialty: specialty_selection).find_each do |doctor|
                                      doctor_cities << doctor.city
                                  end
                                  sorted_cities = doctor_cities.sort
                                  city_selection = prompt.select("Which City?", sorted_cities.uniq)
                                  Doctor.where(state: state_selection, specialty: specialty_selection, city: city_selection).find_each do |doctor|
                                      refined_by_city_hash[doctor.as_json.values] = doctor.id
                                  end
                                  prompt.say("There are #{refined_by_city_hash.length} practicing #{specialty_selection} in #{city_selection}")
                                  doctor_id = prompt.select("Which Doctor", refined_by_city_hash)
                                  Search.create({
                                      doctor_id: doctor_id,
                                      patient_id: current_patient.id
                                  })
                              else
                                  doctor_id = prompt.select("Which Doctor?", ref_doc_hash)
                                  Search.create({
                                      doctor_id: doctor_id,
                                      patient_id: current_patient.id
                                  })
                              end
                  else
                      doctor_id = prompt.select("Which Doctor?", doctor_hash)
                      Search.create({
                          doctor_id: doctor_id,
                          patient_id: current_patient.id
                      })
                  end
              end
              when "Specialty"
                  doctor_specialties = Doctor.distinct.pluck(:specialty).sort
                  doctor_hash = {}
                  doctor_specialty = prompt.select("Which Specialty?", doctor_specialties)
                  Doctor.where(specialty: doctor_specialty).find_each do |doctor|
                      doctor_hash[doctor.as_json.values] = doctor.id
                  end
                  puts "There are #{doctor_hash.length} doctors who practice #{doctor_specialty}"
                  refined_search = prompt.select("Would you like to refine your search?", [
                      "Yes",
                      "No"  
                  ])
                  if refined_search == "Yes"
                      refined_doctor_hash = {}
                      spec_doctor_state = []
                      spec_doctor_city = []
                      
                      Doctor.where(specialty: doctor_specialty).find_each do |doctor|
                          spec_doctor_state << doctor.state
                      end
                      spec_sorted_states = spec_doctor_state.sort
                      doc_state_select = prompt.select("Which State?", spec_sorted_states.uniq)
                      Doctor.where(specialty: doctor_specialty, state: doc_state_select).find_each do |doctor|
                          spec_doctor_city << doctor.city
                      end
                      spec_sorted_cities = spec_doctor_city.sort
                      doc_city_select = prompt.select("Which City?", spec_sorted_cities.uniq)
                      Doctor.where(specialty: doctor_specialty, state: doc_state_select, city: doc_city_select).find_each do |doctor|
                          refined_doctor_hash[doctor.as_json.values] = doctor.id
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
                  "Please select a valid option"
              end

            when "Review Searches"
              doc_review_hash = {}
              prompt.say("Your Doctors")
        
              current_patient.searches.reload
              current_patient.searches.map do |search|
                  prompt.say(search.doctor.as_json.values)
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

