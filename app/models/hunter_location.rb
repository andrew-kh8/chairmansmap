# frozen_string_literal: true

class HunterLocation < ApplicationRecord
  SRID = 28_406

  validates :location, :date, presence: true
end
