class CreateDoctors < ActiveRecord::Migration[5.2]
    def change
        create_table (:doctors) do |table|
            table.string :first_name
            table.string :last_name
            table.string :specialty
            table.string :city
        end
    end
end