# typed: false

module Agromonitoring
  class DestroyPolygonVillage
    extend T::Sig

    sig { params(village: Village).returns(T.any(DM::Success, DM::Failure)) }
    def self.call(village)
      agro_polygon = Apis::Agromonitoring::Client.new.delete_polygon(village.agromonitoring_id)

      village.update!(agromonitoring_id: nil)

      DM::Success(agro_polygon)
    rescue Apis::Agromonitoring::Client::AgromonitoringError => error
      Rails.logger.error("Failed to destroy Agromonitoring polygon. Error: #{error.name} #{error.message}")
      DM::Failure(village)
    end
  end
end
