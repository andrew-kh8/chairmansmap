# typed: strict

module Geo
  class GetCadasterQuarter
    extend T::Sig

    sig { params(cadaster_number: String).returns(Typed::Result[GeoTypes::PolygonCoordinates, String]) }
    def call(cadaster_number)
      res = Apis::Cadaster::Client.new.get_quarter(cadaster_number)

      if res.success?
        Typed::Success.new(res.payload.coordinates)
      else
        Typed::Failure.new(res.error.message)
      end
    end
  end
end
