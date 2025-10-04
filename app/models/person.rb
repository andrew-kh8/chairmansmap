class Person < ApplicationRecord
  include Discard::Model

  has_many :owners
  has_many :plots, through: :owners

  def full_name
    [surname, first_name, middle_name].join(" ")
  end

  def member
    member_from.strftime("%d.%m.%Y")
  end
end
