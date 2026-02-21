# typed: false

class Village < ApplicationRecord
  validates :name, presence: true
  validates :cadastral_number, uniqueness: true, format: {with: CadastralConst::QUARTER_REGEX}, allow_nil: true
end
