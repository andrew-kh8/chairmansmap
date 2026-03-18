# typed: false

module Agromonitoring
  class DestroyPolygonVillage
    extend T::Sig

    sig { params(village: Village).returns(Typed::Result[Apis::Agromonitoring::Polygon, NilClass]) }
    def self.call(village)
      agro_polygon = Apis::Agromonitoring::Client.new.delete_polygon(village.agromonitoring_id)

      village.update!(agromonitoring_id: nil)

      Typed::Success.new(agro_polygon)
    rescue Apis::Agromonitoring::Client::AgromonitoringError => error
      Rails.logger.error("Failed to destroy Agromonitoring polygon. Error: #{error.name} #{error.message}")
      Typed::Failure.new.blank
    end
  end
end
