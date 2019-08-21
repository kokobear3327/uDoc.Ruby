class Location < ActiveRecord::Base
	belongs_to(:patients)
	belongs_to(:doctors)
end