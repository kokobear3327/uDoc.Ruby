require_relative 'config/environment.rb'
doc_names = Hash.new
Doctor.order(first_name: :asc).each do |doctor|
	doc_names[doctor.first_name] = doctor.id
end

doc_names.each do |doc|
	puts doc[0]
end