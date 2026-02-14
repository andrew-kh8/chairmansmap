# typed: strict
# frozen_string_literal: true

class PeopleSearch
  extend T::Sig

  sig { params(relation: ActiveRecord::Relation).void }
  def initialize(relation: Person.all)
    @relation = relation
  end

  sig { params(filters: T::Hash[Symbol, T.untyped]).returns(ActiveRecord::Relation) }
  def call(filters = {})
    by_full_name(filters[:full_name])
    by_plot_presence(filters[:plot_presence])
    by_active(filters[:active])
    by_sort(filters[:sort])

    @relation
  end

  private

  sig { params(full_name: T.untyped).void }
  def by_full_name(full_name)
    return if full_name.blank?

    @relation = @relation.where("concat_ws(' ', surname, first_name, middle_name) ILIKE ?", "%#{full_name}%")
  end

  sig { params(plot_presence: T.untyped).void }
  def by_plot_presence(plot_presence)
    return if plot_presence.nil?

    @relation = if plot_presence
      @relation.where.associated(:plots)
    else
      @relation.where.missing(:plots)
    end
  end

  sig { params(active: T.untyped).void }
  def by_active(active)
    return if active.nil?

    @relation = if active
      @relation.where(discarded_at: nil)
    else
      @relation.where.not(discarded_at: nil)
    end
  end

  sig { params(sort_type: T.untyped).void }
  def by_sort(sort_type)
    @relation = case sort_type
    when "name_desc"
      @relation.order(surname: :desc, first_name: :desc, middle_name: :desc)
    when "member"
      @relation.order(:member_from)
    when "member_desc"
      @relation.order(member_from: :desc)
    else # default, by name asc
      @relation.order(:surname, :first_name, :middle_name)
    end
  end
end
