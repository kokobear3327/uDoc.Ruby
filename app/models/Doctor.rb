class Doctor < ActiveRecord::Base
    has_many(:searches)
    has_many(:patients, {through: :searches})
end