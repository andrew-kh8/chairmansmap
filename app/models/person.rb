# typed: strict

class Person < ApplicationRecord
  include Discard::Model

  has_many :owners
  has_many :plots, through: :owners

  sig { returns(String) }
  def full_name
    [surname, first_name, middle_name].join(" ")
  end

  sig { returns(T.nilable(String)) }
  def member
    member_from&.strftime("%d.%m.%Y")
  end

  sig { returns(String) }
  def short_name
    "#{surname} #{first_name&.first}. #{middle_name&.first}."
  end
end
