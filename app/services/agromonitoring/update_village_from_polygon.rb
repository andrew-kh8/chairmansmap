# typed: strict

module Agromonitoring
  class UpdateVillageFromPolygon
    extend T::Sig

    class Result < T::Struct
      extend T::Sig

      const :village, Village
      const :error, T.nilable(StandardError)

      sig { returns(T::Boolean) }
      def success?
        error.nil?
      end
    end

    sig { params(polygon_id: String, village: Village).returns(Result) }
    def self.call(polygon_id, village)
      polygon = Apis::Agromonitoring::Client.new.polygon(polygon_id)
      raw_coords = polygon.coords
      agro_geom = Geo::MultiPolygonCreator.call(raw_coords, srid: GeoConst::AGROMONITORING_SRID).on_error do
        raise StandardError.new("Failed to create multi polygon")
      end.payload
      geom = Geo::TransformGeomSrid.call(agro_geom.multi_polygon)

      village.update!(agromonitoring_id: polygon.id, geom:)

      Result.new(village: village)
    rescue Apis::Agromonitoring::Client::AgromonitoringError, ActiveRecord::RecordInvalid => error
      Rails.logger.error("Failed to update Village '#{village.name}' from polygon. Error: #{error.message}")
      Result.new(village: village, error: error)
    end
  end
end
