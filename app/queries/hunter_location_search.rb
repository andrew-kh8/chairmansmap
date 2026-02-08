# typed: false
# frozen_string_literal: true

class HunterLocationSearch
  DOG_OPTIONS = {"есть" => true, "нет" => false}
  LICENSE_OPTIONS = {"есть" => true, "нет" => false}

  module Scopes
    def by_date(date_from, date_to)
      return self if date_from.blank? && date_to.blank?

      where(date: date_from..date_to)
    end

    def by_dog(dog)
      return self if dog.nil?

      where(dog:)
    end

    def by_license(license)
      return self if license.nil?

      where(license:)
    end
  end

  def self.call(filters = {})
    HunterLocation
      .extending(Scopes)
      .by_date(filters[:from], filters[:to])
      .by_dog(filters[:dog])
      .by_license(filters[:license])
  end
end
