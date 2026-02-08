# typed: false

module Geo
  class HunterLocationSerializer < Panko::Serializer
    FEATURE = "Feature"
    DATE_FORMAT = "%d.%m.%Y %H:%M"

    attributes :type, :geometry, :properties

    def type
      FEATURE
    end

    def geometry
      object.geojson_geom
    end

    def properties
      {
        date: object.date.strftime(DATE_FORMAT)
      }
    end
  end
end
