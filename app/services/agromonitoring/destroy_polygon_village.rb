# typed: false

module Agromonitoring
  class DestroyPolygonVillage
    extend T::Sig
    extend Dry::Monads::Result::Mixin

    sig { params(village: Village).returns(Dry::Monads::Result[Apis::Agromonitoring::Polygon, Village]) }
    def self.call(village)
      agro_polygon = Apis::Agromonitoring::Client.new.delete_polygon(village.agromonitoring_id)

      village.update!(agromonitoring_id: nil)

      Success(agro_polygon)
    rescue Apis::Agromonitoring::Client::AgromonitoringError => error
      Rails.logger.error("Failed to destroy Agromonitoring polygon. Error: #{error.name} #{error.message}")
      Failure(village)
    end
  end
end
