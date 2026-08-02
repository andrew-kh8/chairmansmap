# typed: strict

module Geo
  class CardinalDirectionsCoords
    extend T::Sig

    class CardinalDirections < T::Struct
      const :north, Float
      const :south, Float
      const :east, Float
      const :west, Float
    end

    sig { params(geom: T.any(GeoTypes::GeoProjected, GeoTypes::GeosCAPI)).returns(CardinalDirections) }
    def self.call(geom)
      coordinates = extract_coordinates(geom)

      west, east = coordinates.map(&:first).minmax
      south, north = coordinates.map(&:last).minmax

      CardinalDirections.new(north: T.must(north), south: T.must(south), east: T.must(east), west: T.must(west))
    end

    class << self
      extend T::Sig

      private

      sig { params(geom: T.any(GeoTypes::GeoProjected, GeoTypes::GeosCAPI)).returns(T::Array[T::Array[Float]]) }
      def extract_coordinates(geom)
        geom.coordinates.flatten.each_slice(2).map { |long, lat| [long, lat] }
      end
    end
  end
end
