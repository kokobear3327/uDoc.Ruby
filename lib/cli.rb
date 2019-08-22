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









#     def premenu
#     prompt = TTY::Prompt.new
#     user_input = prompt.select("What do you want to do?", [
#     "Login in to your profile",
#     "Create a new profile",
#     "Go rogue",
#     "Quit"
#     ])

#     case user_input
#     when "Login in to your profile"
#     login
#     puts "login Successful!"
#     menu
#     when "Create a new profile"
#     signup
#     puts "Username successfully created!"
#     menu
#     when "Go rogue"
#     premenu
#     when "Quit"
#     exit
#     else
#     puts Rainbow("Invalid option. Please select an option and hit enter.").white.bright
#     end
#     end

#     def login
#       prompt = TTY::Prompt.new
#       current_patient = Patient.where({
#         user_name: prompt.ask("What is your username?"),
#         password: prompt.ask("What is your password?")
#       })
#     end

#     # Menu page for the logged in user
#     def menu
#     prompt = TTY::Prompt.new
#     user_input = prompt.select("What do you want to do?", [
#           "Update your user profile",
#           "Search for doctors",
#           "Review Searches",
#           "Quit"
#     ])

#     case user_input

#     when "Update your user profile"
#       response = prompt.select("What would you like to update?", [
#         "First Name",
#         "Last Name",
#         "City",
#         "Quit"
#       ])
#       case response
#         when "First Name"
#           first_name = prompt.ask("Please enter your first name: ")
#           current_patient.update(first_name: first_name)
#         when "Last Name"
#           last_name = prompt.ask("Please enter your last name: ")
#           current_patient.update(last_name: last_name)
#         when "City"
#           city = prompt.ask("What city in the Greater Houston Metro Area are you in?")
#           current_patient.update(city: city)
#           current_patient_location.update(name: city)
#         when "Quit"
#           exit
#         else
#           "Please choose a valid option"
#         end
#     when "Search for doctors"
#       search_response = prompt.select("What would you like to search by?", [
#         "City Location",
#         "Specialty"
#       ])
#       case search_response
# 			when "City Location"
# 				doctor_locations = Doctor.distinct.pluck(:city).sort
# 				doctor_specialty = Doctor.distinct.pluck(:specialty).sort
# 				doctor_array = []
# 				city_location = prompt.select("Which city?", doctor_locations)
# 				Doctor.where(city: city_location).find_each do |doctor|
# 					doctor_array << doctor
# 				end
# 				puts "There are #{doctor_array.length} doctors in #{city_location}"
# 				refine_selection = prompt.select("Would you like to refine your search?", [
# 					"Yes",
# 					"No"
# 				])
# 				if refine_selection == "Yes"
# 					doc_spec = prompt.select("Which specialty?", doctor_specialty)
# 					doctor_array.each do |doctor|
# 						if doc_spec == doctor.specialty
							
# 						end
# 					end
# 				end


# 			when "Specialty"

# 			else
# 				"Please choose a valid option"

				
# 			end
#     when "Review Searches"
        
#     when "Quit"
#       exit
#     else
#       puts Rainbow("Invalid option...").white.bright
#     end

#     end

#     # Sign up dialogue
#     def signup 
#       prompt = TTY::Prompt.new
#       username = prompt.ask("Please enter a username:")
#       password = prompt.ask("Please enter a password:")
      
#       current_patient = Patient.create({
#         user_name: username,
#         password: password
#       })
  
#       current_patient_location = Location.create({
#         patient_id: current_patient.id
#       })
#     end

#     # def createuser(username, userage, useremail)
#     # puts "Username: #{username} was created successfully! \n"
#     # end


#     # def login
#     # puts "To login, enter your username"
#     # username = gets.chomp
#     # loginuser(username)
#     # # This ^ takes you to the menu portal
#     # end

#     # def loginuser(username)
#     #   menu
#     # end

#   def show_all_doctors
#     puts "shows_all_doctors has been called, preferably narrowing to the Houston Area"
#   end

#   def show_all_doctors_by_speciality
#     puts "show_all_doctors_by_speciality called"
#   end

#   def show_all_doctors_by_location
#     puts "show_all_doctors_by_location called"
#   end


#   #quits the app
#   def exit
#     puts Rainbow("\n\n ❤ ❤ ❤  Thanks for choosing uDoc, we hope he's a great fit ❤ ❤ ❤ \n\n").green
#     nil
#   end

#   # Sends you back to the menu
#   def return_to_menu
#     puts Rainbow("\nWould you like to return to the menu? (y/n)").white.bright
#     user_input = gets.chomp
#     if user_input == "y"
#     menu

#   elsif user_input == "n"
#     puts Rainbow("Would you like to quit the app? (y/n)").white.bright
#     user_input = gets.chomp
#     if user_input == "y"
#       exit
#     else
#       menu
#     end
#   end
#   end
  
#   # /\   /\    /\
#   #REPLACEMENT loads the response hash
#   def search_doctors_api
#     # Need to put the DoctorsAPI here.
#     response_string = RestClient.get"https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=45aee5b7c7584064ac1b1de6297f5137"
#     response_hash = JSON.parse(response_string.body)
#   end

#   #OLD loads the response hash
#   def search_techcrunch
#     # Need to put the DoctorsAPI here.
#     response_string = RestClient.get"https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=45aee5b7c7584064ac1b1de6297f5137"
#     response_hash = JSON.parse(response_string.body)
#   end
#   #      \/ 

#   #creates an array of all articles - authors and title
#   def all_article_titles_with_authors
#     @all = {}
#     search_techcrunch["articles"].each do |hash|
#       author = hash["author"]
#       title = hash["title"]
#       @all[title] = author
#     end
#     return @all
#   end

#   #formats the array of all articles - authors and titles
#   def show_all_article_titles_with_authors
#     @all = all_article_titles_with_authors
#     @all.each do |title, author|
#       puts "#{author} - #{title}"
#     end
#     return @all
#   end

#   #prompts user with the choice to read the full article
#   def show_full_list_of_articles(author)
#     puts Rainbow("Would you like to read the article(s)?(y/n)").white.bright
#     user_input = gets.chomp
#     case user_input
#     when "y"
#       author_articles = all_article_titles_with_authors.select do |title, name|
#         name.split(' ')[0] == author
#       end
#       hay = all_article_titles_with_content
#       array = []
#       author_articles.each do |title, name|
#         if hay.keys.include?(title)
#           array << hay[title]
#         end
#       end
#       array.each_with_index do |article, index| puts "\n#{dashes}\n#{index+1}. #{article}\n#{dashes}\n"
#       end
#     when "n"
#       puts Rainbow("Sorry to hear that, we'll take you back to the menu now!").white.bright
#       menu
#     end
#   end

#   #shows a formatted array of all articles - title and content
#   def show_all_article_titles_with_content
#     @all = {}
#     search_techcrunch["articles"].each do |hash|
#       title = hash["title"]
#       content = hash["content"]
#       @all[content] = title
#     end
#     @all.each do |content, title| puts "#{dashes}\n#{title}\n#{dashes}\n#{content}\n\n"
#     end
#     return nil
#   end

#   #supporting method used in show full list of articles
#   def all_article_titles_with_content
#     @all = {}
#     search_techcrunch["articles"].each do |hash|
#       title = hash["title"]
#       content = hash["content"]
#       @all[title] = content
#     end
#     @all
#   end

#   #shows an array of all authors in alphabetical order
  
#   def show_all_authors
#     @all = []
#     search_techcrunch["articles"].each do |article|
#       @all << article["author"]
#     end
#     unique_array = @all.uniq!.sort
#     puts "#{dashes}\n"
#     unique_array.each_with_index do |author, index| puts "#{index+1}. #{author}"
#     end
#     return nil
#   end


#   #finds all articles under the given author name (partial - first or last)
#   def find_article_titles_by_author(author)
#     @titles = []
#     search_techcrunch["articles"].each do |article|
#        if article["author"].include?(author)
#          @titles << article["title"]
#        end
#     end
#     @titles.each_with_index do |title, index| puts "#{index+1}. #{title}"
#     end
#     return nil
#   end


#   #shows the latest article
#   def show_latest_article
#     author = search_techcrunch["articles"][0]["author"]
#     title = search_techcrunch["articles"][0]["title"]
#     content = search_techcrunch["articles"][0]["content"]
#     publish_time = search_techcrunch["articles"][0]["publishedAt"]
#     url = search_techcrunch["articles"][0]["url"]
#     puts "#{dashes}\n#{title}\n\n#{content}\n\n#{author} - #{publish_time}\n#{dashes}"
#     puts Rainbow("\nWould you like to read the full article? (y/n)").white.bright
#     user_input = gets.chomp
#       if user_input == "y"
#         system("open #{url}")
#       else
#         puts Rainbow("\nNot your cuppa tea!?").white.bright
#         menu
#       end
#   end

#   #adds a line as a page breaker
#   def dashes
#     return "--------------------------------------------------------"
#   end

# end
