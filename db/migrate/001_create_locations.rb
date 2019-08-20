class CreateLocations < ActiveRecord::Migration[4.2]
	def change
		create_table :locations do |table|
			table.string :name
			table.integer(:patient_id)
			table.integer(:doctor_id)
		end
	end
end