require 'rest-client'
require 'json'
require 'rainbow'


class CommandLine

  #displays welcome message

  def greet
    puts Rainbow("

                                                                                                        
        ooo.               
       8  `8.              
o    o 8   `8 .oPYo. .oPYo.
8    8 8    8 8    8 8    '
8    8 8   .P 8    8 8    .
`YooP' 8ooo'  `YooP' `YooP'
./\/\ :.....:.....:::.....:
:.....:::::::::::::::::::::
::::::::::::::::::::::::::: 
    
       ").blue
    # puts Rainbow(" ❤ /\\❤  The uDoc App  ❤ /\\❤ \n Find your doctor by location or specialty:  \n").white.bright
     puts Rainbow(" ❤ ❤ ❤  The uDoc App  ❤ ❤ ❤ \n Find your doctor by location or specialty:  \n").white.bright
  end

    def premenu
    puts "#{dashes}\n
    Choose from the following options using the numbers 1 to 4 as your input:\n
    - 1 - Login in to your profile
    - 2 - Create a new profile
    - 3 - Go rogue
    - 4 - Quit
    "
    end


    #obtains user input from menu page
  def pre_menu_choice
    user_input = gets.chomp
    case user_input
    when "1"
      login
      return_to_menu
    when "2"
      signup
      return_to_menu
    when "3"
      menu
      menu_choice
    when "4"
      exit
      # puts Rainbow("Here are all the authors to choose from:\n").white.bright
      # show_all_authors
      # puts Rainbow("\nPlease provide an author name:").white.bright
      # author = gets.chomp
      # find_article_titles_by_author(author)
      # show_full_list_of_articles(author)
      # return_to_menu
    # when "5"
    #   show_latest_article
    #   return_to_menu
    # when "6"
    #   exit
    else
      puts Rainbow("Invalid option. Please select a number between 1 and 4.").white.bright
      # menu
      # menu_choice
    end
  end

  def login
    puts "here the user logs in"
    puts "should bring you to the menu"
  end


    # Menu page for the logged in user
    def menu
    puts "#{dashes}\n
    Choose from the following options using the numbers (1-6) as your input:\n
          

    - 1 - Search for doctor by name \n
    - 2 - Search for doctors by location \n
    - 3 - Search for doctors by speciality \n
    - 4 - ____________________________________ \n
    - 5 - Create a new user profile \n
    - 6 - Quit the application
    "
    end

    # Sign up dialogue
    def signup 
    puts "❤ ❤ ❤ ❤ ❤ ❤ ❤ ❤ ❤ ❤ ❤ ❤ \n"
    puts "Enter your username"
    username = gets.chomp
    puts "Enter your age"
    userage = gets.chomp
    puts "Enter your email"
    useremail = gets.chomp
    createuser(username, userage, useremail)
    puts "❤ ❤ ❤ ❤ ❤ ❤ ❤ ❤ ❤ ❤ ❤ ❤  \n"
    menu
    menu_choice
    # quit
    # You should have the option to either exit the application or return to menu.
    end

    def createuser(username, userage, useremail)
    puts "Username: #{username} was created successfully! \n"
    end


    def login
    puts "To login, enter your username"
    username = gets.chomp
    loginuser(username)
    # This ^ takes you to the menu portal
    end

    def loginuser(username)
      menu
      menu_choice
    end

  #obtains user input from menu page
  def menu_choice
    user_input = gets.chomp
    case user_input
    when "1"
      # Preferable to set the default to the Houston area
      show_all_doctors
      return_to_menu
    when "2"
      show_all_doctors_by_location
      return_to_menu
    when "3"
      show_all_doctors_by_speciality
      return_to_menu
    when "4"
      puts "Not coded yet"
      # puts Rainbow("Here are all the authors to choose from:\n").white.bright
      # show_all_authors
      # puts Rainbow("\nPlease provide an author name:").white.bright
      # author = gets.chomp
      # find_article_titles_by_author(author)
      # show_full_list_of_articles(author)
      return_to_menu
    when "5"
      signup
      return_to_menu
    when "6"
      exit
    else
      puts Rainbow("Invalid option. Please select a number between 1 and 6.").white.bright
      # menu
      # menu_choice
    end
  end

  def show_all_doctors
    puts "shows_all_doctors has been called, preferably narrowing to the Houston Area"
  end

  def show_all_doctors_by_speciality
    puts "show_all_doctors_by_speciality called"
  end

  def show_all_doctors_by_location
    puts "show_all_doctors_by_location called"
  end


  #quits the app
  def exit
    puts Rainbow("\n\n ❤ ❤ ❤ ❤ ❤ ❤ Thanks for choosing uDoc, we hope he's a great fit ❤ ❤ ❤ ❤ ❤ ❤ \n\n").blue.bright
    nil
  end

  # Sends you back to the menu
  def return_to_menu
    puts Rainbow("\nWould you like to return to the menu? (y/n)").white.bright
    user_input = gets.chomp
    if user_input == "y"
    menu
    menu_choice
  elsif user_input == "n"
    puts Rainbow("Would you like to quit the app? (y/n)").white.bright
    user_input = gets.chomp
    if user_input == "y"
      exit
    else
      menu
      menu_choice
    end
  end
  end
  
  # /\   /\    /\
  #REPLACEMENT loads the response hash
  def search_doctors_api
    # Need to put the DoctorsAPI here.
    response_string = RestClient.get"https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=45aee5b7c7584064ac1b1de6297f5137"
    response_hash = JSON.parse(response_string.body)
  end

  #OLD loads the response hash
  def search_techcrunch
    # Need to put the DoctorsAPI here.
    response_string = RestClient.get"https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=45aee5b7c7584064ac1b1de6297f5137"
    response_hash = JSON.parse(response_string.body)
  end
  #      \/ 

  #creates an array of all articles - authors and title
  def all_article_titles_with_authors
    @all = {}
    search_techcrunch["articles"].each do |hash|
      author = hash["author"]
      title = hash["title"]
      @all[title] = author
    end
    return @all
  end

  #formats the array of all articles - authors and titles
  def show_all_article_titles_with_authors
    @all = all_article_titles_with_authors
    @all.each do |title, author|
      puts "#{author} - #{title}"
    end
    return @all
  end

  #prompts user with the choice to read the full article
  def show_full_list_of_articles(author)
    puts Rainbow("Would you like to read the article(s)?(y/n)").white.bright
    user_input = gets.chomp
    case user_input
    when "y"
      author_articles = all_article_titles_with_authors.select do |title, name|
        name.split(' ')[0] == author
      end
      hay = all_article_titles_with_content
      array = []
      author_articles.each do |title, name|
        if hay.keys.include?(title)
          array << hay[title]
        end
      end
      array.each_with_index do |article, index| puts "\n#{dashes}\n#{index+1}. #{article}\n#{dashes}\n"
      end
    when "n"
      puts Rainbow("Sorry to hear that, we'll take you back to the menu now!").white.bright
      menu
      menu_choice
    end
  end

  #shows a formatted array of all articles - title and content
  def show_all_article_titles_with_content
    @all = {}
    search_techcrunch["articles"].each do |hash|
      title = hash["title"]
      content = hash["content"]
      @all[content] = title
    end
    @all.each do |content, title| puts "#{dashes}\n#{title}\n#{dashes}\n#{content}\n\n"
    end
    return nil
  end

  #supporting method used in show full list of articles
  def all_article_titles_with_content
    @all = {}
    search_techcrunch["articles"].each do |hash|
      title = hash["title"]
      content = hash["content"]
      @all[title] = content
    end
    @all
  end

  #shows an array of all authors in alphabetical order
  
  def show_all_authors
    @all = []
    search_techcrunch["articles"].each do |article|
      @all << article["author"]
    end
    unique_array = @all.uniq!.sort
    puts "#{dashes}\n"
    unique_array.each_with_index do |author, index| puts "#{index+1}. #{author}"
    end
    return nil
  end

    # Call function to show all of the doctors a user has visited
    # def show_doctors_patient_visited
    #   Patient.all.select | patient | 

    # end

  #finds all articles under the given author name (partial - first or last)
  def find_article_titles_by_author(author)
    @titles = []
    search_techcrunch["articles"].each do |article|
       if article["author"].include?(author)
         @titles << article["title"]
       end
    end
    @titles.each_with_index do |title, index| puts "#{index+1}. #{title}"
    end
    return nil
  end


  #shows the latest article
  def show_latest_article
    author = search_techcrunch["articles"][0]["author"]
    title = search_techcrunch["articles"][0]["title"]
    content = search_techcrunch["articles"][0]["content"]
    publish_time = search_techcrunch["articles"][0]["publishedAt"]
    url = search_techcrunch["articles"][0]["url"]
    puts "#{dashes}\n#{title}\n\n#{content}\n\n#{author} - #{publish_time}\n#{dashes}"
    puts Rainbow("\nWould you like to read the full article? (y/n)").white.bright
    user_input = gets.chomp
      if user_input == "y"
        system("open #{url}")
      else
        puts Rainbow("\nNot your cuppa tea!?").white.bright
        menu
      end
  end

  #adds a line as a page breaker
  def dashes
    return "------------------------------------------------------------------"
  end

end
