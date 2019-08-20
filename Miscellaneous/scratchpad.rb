  #obtains user input from menu page
  def pre_menu_choice
    user_input = gets.chomp
    case user_input
    when "1"
      # login portal
      return_to_menu
    when "2"
      # create new user
      return_to_menu
    when "3"
      menu
      menu_choice
    when "4"
      puts Rainbow("Here are all the authors to choose from:\n").white.bright
      show_all_authors
      puts Rainbow("\nPlease provide an author name:").white.bright
      author = gets.chomp
      find_article_titles_by_author(author)
      show_full_list_of_articles(author)
      return_to_menu
    when "5"
      show_latest_article
      return_to_menu
    when "6"
      exit
    else
      puts Rainbow("Invalid option. Please select a number between 1 and 6.").white.bright
      # menu
      # menu_choice
    end
  end