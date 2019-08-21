class Patient < ActiveRecord::Base
	belongs_to(:location)
	has_many(:doctors, {through: :location})
end