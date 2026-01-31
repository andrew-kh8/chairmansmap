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

    def by_owner_type(owner_type)
      owner_type.blank? ? self : where(owner_type:)
    end

    def by_sale_status(sale_status)
      sale_status.blank? ? self : where(sale_status:)
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
      .by_owner_type(filters[:owner_type])
      .by_sale_status(filters[:sale_status])
      .by_sort
  end

  def self.people_select_options
    participants = {PARTICIPANTS => people_options}

    GENERAL_OPTIONS.merge(participants)
  end

  def self.sale_statuses
    Plot.sale_statuses.keys.unshift(nil)
  end

  def self.owner_types
    Plot.owner_types.keys.unshift(nil)
  end

  class << self
    private

    def people_options
      Person
        .select(:id, :surname, :first_name, :middle_name)
        .map { |person| [person.short_name, person.id] }
        .sort_by(&:first)
    end
  end
end
