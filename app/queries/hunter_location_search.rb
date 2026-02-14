# typed: strict
# frozen_string_literal: true

class HunterLocationSearch
  extend T::Sig

  DOG_OPTIONS = T.let({"есть" => true, "нет" => false}, T::Hash[String, T::Boolean])
  LICENSE_OPTIONS = T.let({"есть" => true, "нет" => false}, T::Hash[String, T::Boolean])

  sig { params(relation: ActiveRecord::Relation).void }
  def initialize(relation = HunterLocation.all)
    @relation = relation
  end

  sig { params(filters: T.untyped).returns(ActiveRecord::Relation) }
  def call(filters = {})
    by_date(filters[:from], filters[:to])
    by_dog(filters[:dog])
    by_license(filters[:license])

    @relation
  end

  private

  sig { params(license: T.untyped).void }
  def by_license(license)
    return if license.nil?

    @relation = @relation.where(license:)
  end

  sig { params(date_from: T.untyped, date_to: T.untyped).void }
  def by_date(date_from, date_to)
    return if date_from.blank? && date_to.blank?

    @relation = @relation.where(date: date_from..date_to)
  end

  sig { params(dog: T.untyped).void }
  def by_dog(dog)
    return if dog.nil?

    @relation = @relation.where(dog:)
  end
end
