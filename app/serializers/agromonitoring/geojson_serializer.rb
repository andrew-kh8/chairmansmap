# typed: false

module Agromonitoring
  class GeojsonSerializer < Panko::Serializer
    FEATURE = "Feature"

    attributes :type, :geometry, :properties

    def type
      FEATURE
    end

    def geometry
      RGeo::GeoJSON.encode(object)
    end

    def properties
      {
        srid: object.srid # "properties" member required by api
      }
    end
  end
end
