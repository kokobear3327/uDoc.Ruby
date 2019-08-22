require_relative '../config/environment'
prompt = TTY::Prompt.new

cli = CommandLine.new
a = Artii::Base.new :font => 'slant'
prompt.say(a.asciify('Welcome to:'))
cli.greet
cli.starting_menu


