# typed: strict
# frozen_string_literal: true

module Apis
  module Cadaster
    class Polygon < T::Struct
      extend T::Sig

      # there are more fields, but these are essential
      const :id, Integer
      const :geometry, Geometry
      const :cadaster_number, String
      const :inserted, Time
      const :updated, Time

      sig { returns(::GeoTypes::PolygonCoordinates) }
      def coordinates
        geometry.coordinates
      end
    end
  end
end
