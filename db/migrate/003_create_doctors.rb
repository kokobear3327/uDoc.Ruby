class CreateDoctors < ActiveRecord::Migration[5.2]
    def change
        create_table (:doctors) do |table|
            table.string :first_name
            table.string :last_name
            table.string :specialty
            table.string :practice_name
            table.integer :practice_phone_number
            table.string :street_address
            table.string :street_address_2
            table.string :city
            table.string :state
        end
    end
end