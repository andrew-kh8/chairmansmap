# typed: strict

class Village < ApplicationRecord
  has_many :agromonitoring_tiles, dependent: :destroy

  validates :name, presence: true
  validates :cadastral_number, uniqueness: true, format: {with: CadastralConst::QUARTER_REGEX}, allow_nil: true
  validates :agromonitoring_id, uniqueness: true, allow_nil: true
  validate :geom_srid

  sig { returns(T::Boolean) }
  def agromonitoring_integration?
    agromonitoring_id.present?
  end

  private

  sig { void }
  def geom_srid
    if geom.present? && geom.srid != GeoConst::DEFAULT_DB_SRID
      errors.add(:geom, "SRID must be #{GeoConst::DEFAULT_DB_SRID}")
    end
  end
end
