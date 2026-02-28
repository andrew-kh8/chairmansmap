# typed: strict

module Agromonitoring
  class CreatePolygonVillage
    extend T::Sig

    sig { params(village: Village).returns(T.any(DM::Success, DM::Failure)) }
    def self.call(village)
      polygon_geom = village.geom.first # TODO: handle multiple geoms
      unprojected_geom = Geo::UnprojectGeom.call(polygon_geom)
      geo_json = Agromonitoring::GeojsonSerializer.new.serialize(unprojected_geom)

      agro_polygon = Apis::Agromonitoring::Client.new.create_polygon(name: village.name, geo_json:)

      village.update!(agromonitoring_id: agro_polygon.id)

      DM::Success(agro_polygon)
    rescue Apis::Agromonitoring::Client::AgromonitoringError => error
      Rails.logger.error("Failed to create Agromonitoring polygon. Error: #{error.name} #{error.message}")
      DM::Failure(village)
    end
  end
end
