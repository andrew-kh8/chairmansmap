# typed: false

module Agromonitoring
  class GeojsonSerializer < Panko::Serializer
    attributes :type, :geometry, :properties

    def type
      GeoConst::FEATURE
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
