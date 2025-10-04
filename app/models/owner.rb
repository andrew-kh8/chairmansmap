class Owner < ApplicationRecord
  belongs_to :plot
  belongs_to :person
  has_one :plot_datum, through: :plot

  validates :plot_id, uniqueness: {scope: :active_to}, unless: :active_to?
end
