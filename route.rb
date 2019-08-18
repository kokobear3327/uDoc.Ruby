class Route < ActiveRecord::Base
  has_many :points 
  has_many :piers, through: :points
end
