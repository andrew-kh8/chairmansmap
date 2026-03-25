# typed: strict

class Plot < ApplicationRecord
  SRID = 3857

  enum :sale_status, {"не продается" => "nothing", "продается" => "for_sale"}
  enum :owner_type, {"личная собственность" => "personal", "государственная собственность" => "state"}

  has_many :owners, dependent: :destroy
  has_one :owner, -> { where(active_to: nil) }
  has_many :persons, through: :owners
  has_one :person, through: :owner
  belongs_to :village

  validates :geom, :area, :perimeter, :number, presence: true
  validates :number, numericality: true
  validates :cadastral_number, presence: true, uniqueness: true, format: {with: CadastralConst::NUMBER_REGEX}

  sig { returns(T::Array[String]) }
  def photos
    []
  end
end
