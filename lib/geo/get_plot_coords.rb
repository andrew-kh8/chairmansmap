# typed: strict

module Geo
  class GetPlotCoords
    extend T::Sig
    extend Dry::Monads::Result::Mixin

    sig { params(cadaster_number: String).returns(Dry::Monads::Result[String, GeoTypes::PolygonCoordinates]) }
    def self.call(cadaster_number)
      res = Apis::Cadaster::Client.new.get_plot(cadaster_number)

      if res.success?
        Success(res.success.coordinates)
      else
        Failure("Response body is empty")
      end
    end
  end
end
