class Point < ActiveRecord::Base
  belongs_to :pier
  belongs_to :route
end
