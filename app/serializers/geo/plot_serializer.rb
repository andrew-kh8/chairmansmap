module Geo
  class PlotSerializer < Panko::Serializer
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
        centroid: object.centroid.coordinates.reverse
      }
    end
  end
end
