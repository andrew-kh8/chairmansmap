# typed: strict

module Agromonitoring
  class CreatePolygonVillage
    extend T::Sig

    sig { params(village: Village).returns(Typed::Result[Apis::Agromonitoring::Polygon, NilClass]) }
    def self.call(village)
      # agromonitoring doesn't support multiple geoms
      polygon_geom = village.geom.first
      unprojected_geom = Geo::UnprojectGeom.call(polygon_geom)
      geo_json = Agromonitoring::GeojsonSerializer.new.serialize(unprojected_geom)

      agro_polygon = Apis::Agromonitoring::Client.new.create_polygon(name: village.name, geo_json:)

      village.update!(agromonitoring_id: agro_polygon.id)

      Typed::Success.new(agro_polygon)
    rescue Apis::Agromonitoring::Client::AgromonitoringError => error
      Rails.logger.error("Failed to create Agromonitoring polygon. Error: #{error.name} #{error.message}")
      Typed::Failure.blank
    end
  end
end
