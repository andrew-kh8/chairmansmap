# typed: strict

module Geo
  class GetPlotCoords
    extend T::Sig

    sig { params(cadaster_number: String).returns(Typed::Result[GeoTypes::PolygonCoordinates, String]) }
    def self.call(cadaster_number)
      res = Apis::Cadaster::Client.new.get_plot(cadaster_number)

      if res.success?
        Typed::Success.new(res.payload.coordinates)
      else
        Typed::Failure.new("Response body is empty")
      end
    end
  end
end
