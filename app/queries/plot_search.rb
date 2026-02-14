# typed: strict
# frozen_string_literal: true

class PlotSearch
  extend T::Sig

  PARTICIPANTS = "Участники"
  GENERAL_OPTIONS = T.let(
    {"Наличие собственника" => [["Любой", ANY = "any"], ["Без собственника", NONE = "none"]]},
    T::Hash[String, T::Array[T::Array[String]]]
  )

  sig { params(relation: ActiveRecord::Relation).void }
  def initialize(relation = Plot.all)
    @relation = relation
  end

  sig { params(filters: T::Hash[Symbol, T.untyped]).returns(ActiveRecord::Relation) }
  def call(filters = {})
    by_person(filters[:people])
    by_area(filters[:area_min], filters[:area_max])
    by_owner_type(filters[:owner_type])
    by_sale_status(filters[:sale_status])
    by_sort

    @relation
  end

  private

  sig { params(people_ids: T.nilable(T::Array[Integer])).void }
  def by_person(people_ids)
    return if people_ids.blank?

    @relation = case people_ids.first
    when PlotSearch::ANY
      @relation.where.associated(:person)
    when PlotSearch::NONE
      @relation.where.missing(:person)
    else
      @relation.joins(:person).where(person: {id: people_ids})
    end
  end

  sig { params(min: T.nilable(T.any(Integer, Float)), max: T.nilable(T.any(Integer, Float))).void }
  def by_area(min, max)
    return if min.blank? && max.blank?

    @relation = @relation.where(area: min..max)
  end

  sig { params(owner_type: T.nilable(String)).void }
  def by_owner_type(owner_type)
    return if owner_type.blank?

    @relation = @relation.where(owner_type:)
  end

  sig { params(sale_status: T.nilable(String)).void }
  def by_sale_status(sale_status)
    return if sale_status.blank?

    @relation = @relation.where(sale_status:)
  end

  sig { void }
  def by_sort
    @relation = @relation.order(:number)
  end

  class << self
    extend T::Sig

    sig { returns(T::Hash[String, T::Array[String]]) }
    def people_select_options
      participants = {PARTICIPANTS => people_options}

      GENERAL_OPTIONS.merge(participants)
    end

    sig { returns(T::Array[T.nilable(T.any(String, Symbol))]) }
    def sale_statuses
      [nil] + Plot.sale_statuses.keys
    end

    sig { returns(T::Array[T.nilable(T.any(String, Symbol))]) }
    def owner_types
      [nil] + Plot.owner_types.keys
    end

    private

    sig { returns(T::Array[[String, Integer]]) }
    def people_options
      Person
        .select(:id, :surname, :first_name, :middle_name)
        .map { |person| [person.short_name, person.id] }
        .sort_by(&:first)
    end
  end
end
