class Pier < ActiveRecord::Base
  has_many :points
  has_many :routes, through: :points
end
