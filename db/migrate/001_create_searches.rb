class CreateSearches < ActiveRecord::Migration[5.2]
	def change
		create_table :searches do |table|
			table.belongs_to(:doctor)
			table.belongs_to(:patient)
			table.integer(:patient_id)
			table.integer(:doctor_id)
		end
	end
end