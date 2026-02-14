# typed: false

module Geo
  class PlotsSerializer < Panko::Serializer
    FEATURE = "Feature"

    attributes :type, :geometry, :properties

    def type
      FEATURE
    end

    def geometry
      object.geojson_geom
    end

    def properties
      {
        id: object.id,
        number: object.number
      }
    end
  end
end
