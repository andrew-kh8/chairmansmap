# frozen_string_literal: true

class PlotSearch
  PARTICIPANTS = "Участники"
  GENERAL_OPTIONS = {"Наличие собственника" => [["Любой", ANY = "any"], ["Без собственника", NONE = "none"]]}

  module Scopes
    def by_person(people)
      return self if people.blank?

      case people.first
      when ANY
        where.associated(:person)
      when NONE
        where.missing(:person)
      else
        joins(:person).where(person: {id: people})
      end
    end

    def by_area(min, max)
      return self if min.blank? && max.blank?

      where(area: min..max)
    end

    def by_sort
      order(:number)
    end
  end

  def self.call(filters)
    Plot
      .extending(Scopes)
      .by_person(filters[:people])
      .by_area(filters[:area_min], filters[:area_max])
      .by_sort
  end

  def self.people_select_options
    participants = {PARTICIPANTS => people_options}

    GENERAL_OPTIONS.merge(participants)
  end

  private_class_method

  def self.people_options
    Person
      .select(:id, :surname, :first_name, :middle_name)
      .map { |person| [person.short_name, person.id] }
      .sort_by(&:first)
  end
end
