module Geo
  class GeojsonSerializer < Panko::Serializer
    FEATURE_COLLECTION = "FeatureCollection"

    attributes :type, :features

    def type
      FEATURE_COLLECTION
    end

    def features
      object
    end
  end
end
