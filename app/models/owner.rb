# typed: false

class Owner < ApplicationRecord
  belongs_to :plot
  belongs_to :person

  validates :plot_id, uniqueness: {scope: :active_to}, unless: :active_to?
end
