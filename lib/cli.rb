require 'rest-client'
require 'json'
require 'rainbow'
ActiveRecord::Base.logger = nil
# prompt = TTY::Prompt.new

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

    def premenu
    prompt = TTY::Prompt.new
    user_input = prompt.select("What do you want to do?", [
    "Login in to your profile",
    "Create a new profile",
    "Go rogue",
    "Quit"
    ])

    case user_input
    when "Login in to your profile"
    login
    return_to_menu
    when "Create a new profile"
    signup
    return_to_menu
    when "Go rogue"
    menu
    return_to_menu
    when "Quit"
    exit
    else
    puts Rainbow("Invalid option. Please select a number between 1 and 4.").white.bright
    end
end

    def login
    puts "here the user logs in"
    puts "should bring you to the menu"
    end

    # Menu page for the logged in user
    def menu
    prompt = TTY::Prompt.new
    user_input = prompt.select("What do you want to do?", [
          "Create your user profile",
          "Search for doctors by region",
          "Search for doctors by specialty",
          "Search for the doctors the user has visited",
          "Does something else",
          "Quit the application"
    ])

    case user_input

    when "Create your user profile"
      # Preferable to set the default to the Houston area
      show_all_doctors
      return_to_menu
    when "Search for doctors by region"
      show_all_doctors_by_location
      return_to_menu
    when "Search for doctors by specialty"
      show_all_doctors_by_location
      return_to_menu
    when "Search for the doctors the user has visited"
      show_all_doctors_by_speciality
      return_to_menu
    when "Does something else"
      puts "Not coded yet"
      return_to_menu
    when "Does something else"
      puts "Not coded yet"
    when "Quit the application"
      exit
    else
      puts Rainbow("Invalid option...").white.bright
    end

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
    puts Rainbow("\n\n ❤ ❤ ❤  Thanks for choosing uDoc, we hope he's a great fit ❤ ❤ ❤ \n\n").green
    nil
  end

  # Sends you back to the menu
  def return_to_menu
    puts Rainbow("\nWould you like to return to the menu? (y/n)").white.bright
    user_input = gets.chomp
    if user_input == "y"
    menu

  elsif user_input == "n"
    puts Rainbow("Would you like to quit the app? (y/n)").white.bright
    user_input = gets.chomp
    if user_input == "y"
      exit
    else
      menu
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
    return "--------------------------------------------------------"
  end

end
