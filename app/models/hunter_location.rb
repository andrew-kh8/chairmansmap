# typed: false

class HunterLocation < ApplicationRecord
  SRID = 3857

  validates :location, :date, presence: true
end
