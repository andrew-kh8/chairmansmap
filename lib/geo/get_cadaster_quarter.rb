# typed: strict

module Geo
  class GetCadasterQuarter
    extend T::Sig
    include Dry::Monads::Result::Mixin

    sig { params(cadaster_number: String).returns(Dry::Monads::Result[String, GeoTypes::PolygonCoordinates]) }
    def call(cadaster_number)
      res = Apis::Cadaster::Client.new.get_quarter(cadaster_number)

      if res.success?
        Success(res.success.coordinates)
      else
        Failure(res.failure)
      end
    end
  end
end
