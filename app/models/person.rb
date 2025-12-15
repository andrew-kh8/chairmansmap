class Person < ApplicationRecord
  include Discard::Model

  has_many :owners
  has_many :plots, through: :owners

  # deprecated with PeopleSearch
  scope :by_full_name, ->(search_string = nil) do
    if search_string.nil?
      all
    else
      where("concat_ws(' ', surname, first_name, middle_name) ILIKE ?", "%#{search_string}%")
    end
  end

  def full_name
    [surname, first_name, middle_name].join(" ")
  end

  def member
    member_from.strftime("%d.%m.%Y")
  end

  def short_name
    "#{surname} #{first_name.first}. #{middle_name.first}"
  end
end
