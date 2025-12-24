module Geo
  class HunterLocationSerializer < Panko::Serializer
    FEATURE = "Feature"

    attributes :type, :geometry, :properties

    def type
      FEATURE
    end

    def geometry
      # FIX: wtf? pg returns json, so without parse it will be json.to_json
      JSON.parse(object["geojson_geom"])
    end

    def properties
      {
        date: object["date"].strftime("%d.%m.%Y %H:%M")
      }
    end
  end
end
