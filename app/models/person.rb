# frozen_string_literal: true

class Person < ApplicationRecord
  include Discard::Model

  has_many :owners, dependent: :restrict_with_error
  has_many :plots, through: :owners

  def full_name
    [surname, first_name, middle_name].join(' ')
  end

  def member
    member_from.strftime('%d.%m.%Y')
  end
end
