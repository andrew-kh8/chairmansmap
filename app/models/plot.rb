class Plot < ApplicationRecord
  SRID = 3857

  enum :sale_status, {"не продается" => "nothing", "продается" => "for_sale"}
  enum :owner_type, {"личная собственность" => "personal", "государственная собственность" => "state"}

  has_many :owners, dependent: :destroy
  has_one :owner, -> { where(active_to: nil) }
  has_many :persons, through: :owners
  has_one :person, through: :owner

  validates :geom, :area, :perimeter, :number, presence: true
  validates :number, numericality: true
  validates :cadastral_number, uniqueness: true, format: {with: /\A\d{1,2}:\d{1,2}:\d{1,7}:\d{1,9}\z/}

  def photos
    []
  end
end
