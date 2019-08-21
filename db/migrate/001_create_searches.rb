class CreateSearches < ActiveRecord::Migration[4.2]
	def change
		create_table :searches do |table|
			table.integer(:patient_id)
			table.integer(:doctor_id)
		end
	end
end