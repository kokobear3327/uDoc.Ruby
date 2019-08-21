class Patient < ActiveRecord::Base
	has_many(:searches)
	has_many(:doctors, {through: :searches})
end