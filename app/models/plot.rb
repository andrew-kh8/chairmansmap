class Plot < ApplicationRecord
  SRID = 3857

  self.primary_key = :number

  has_one :plot_datum, dependent: :destroy
  has_many :owners
  has_one :owner, -> { where(active_to: nil) }
  has_many :persons, through: :owners
  has_one :person, through: :owner

  validates :gid, :area, :perimeter, :number, presence: true
  validates :number, numericality: true
end
