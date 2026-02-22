# typed: strict

class Village < ApplicationRecord
  validates :name, presence: true
  validates :cadastral_number, uniqueness: true, format: {with: CadastralConst::QUARTER_REGEX}, allow_nil: true
  validates :agromonitoring_id, uniqueness: true, allow_nil: true

  sig { returns(T::Boolean) }
  def agromonitoring_integration?
    agromonitoring_id.present?
  end
end
