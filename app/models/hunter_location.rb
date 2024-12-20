class HunterLocation < ApplicationRecord
  SRID = 28406
  
  validates :location, :date, presence: true
end
