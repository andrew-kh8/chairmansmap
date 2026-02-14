# typed: strict

module Geo
  class MultiPolygonCreator
    extend T::Sig

    class MultiPolygonData < T::Struct
      const :multi_polygon, RGeo::Geos::CAPIMultiPolygonImpl
      const :area, Float
      const :perimeter, Float
    end

    sig { params(coords: T::Array[T::Array[Float]], srid: Integer).returns(T.untyped) }
    def self.call(coords, srid: Plot::SRID)
      if coords.first != coords.last
        return DM::Failure("The coordinates are not closed in a circle")
      end

      factory = RGeo::Geos.factory(srid: srid)
      ring = factory.linear_ring(coords.map { |x_coord, y_coord| factory.point(x_coord, y_coord) })
      polygon = factory.polygon(ring)
      multi_polygon = factory.multi_polygon([polygon])

      DM::Success(MultiPolygonData.new(multi_polygon:, area: multi_polygon.area, perimeter: ring.length))
    end
  end
end
