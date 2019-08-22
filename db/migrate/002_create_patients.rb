class CreatePatients < ActiveRecord::Migration[4.2]
	def change
		create_table :patients do |table|
			table.string :user_name
			table.string :password
			table.string :first_name
			table.string :last_name
			table.string :city
			table.string :state
		end
	end
end