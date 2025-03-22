# frozen_string_literal: true

class Plot < ApplicationRecord
  self.primary_key = :number

  has_one :plot_datum, dependent: :destroy
  has_many :owners, dependent: :restrict_with_error
  has_one :owner, -> { where(active_to: nil) }, dependent: :restrict_with_error, inverse_of: :plot
  has_many :persons, through: :owners
  has_one :person, through: :owner

  validates :gid, :area, :perimetr, :number, presence: true
  validates :number, numericality: true
  validates :geom, presence: true
end
