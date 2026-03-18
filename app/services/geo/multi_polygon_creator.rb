# typed: strict

module Geo
  class MultiPolygonCreator
    extend T::Sig

    class MultiPolygonData < T::Struct
      const :multi_polygon, RGeo::Geos::CAPIMultiPolygonImpl
      const :area, Float
      const :perimeter, Float
    end

    sig do
      params(coords: T::Array[T::Array[T::Array[Float]]], srid: Integer)
        .returns(Typed::Result[MultiPolygonData, String])
    end
    def self.call(coords, srid: GeoConst::DEFAULT_DB_SRID)
      if coords.any? { |polygon_coords| polygon_coords.first != polygon_coords.last }
        return Typed::Failure.new("The coordinates are not closed in a circle")
      end

      perimeter = 0.0
      factory = RGeo::Geos.factory(srid: srid)

      polygons = coords.map do |polygon_coords|
        ring = factory.linear_ring(polygon_coords.map { |x_coord, y_coord| factory.point(x_coord, y_coord) })
        perimeter += ring.length
        factory.polygon(ring)
      end

      multi_polygon = factory.multi_polygon(polygons)

      Typed::Success.new(MultiPolygonData.new(multi_polygon:, area: multi_polygon.area, perimeter: perimeter))
    end
  end
end
