# typed: strict

module Geo
  class GetCadasterQuarter
    extend T::Sig

    sig { params(cadaster_number: String).returns(GeoTypes::PolygonCoordinates) }
    def self.call(cadaster_number)
      Apis::Cadaster::Client.new.get_quarter(cadaster_number).coordinates
    end
  end
end
