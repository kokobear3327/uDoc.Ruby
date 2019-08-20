class Doctor < ActiveRecord::Base
    belongs_to(:location)
    has_many(:patients, {through: :location})
end