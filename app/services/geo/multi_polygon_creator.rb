module Geo
  class MultiPolygonCreator
    include Dry::Monads[:result]

    MultiPolygonData = Struct.new(:multi_polygon, :area, :perimeter)

    def call(coords, srid: Plot::SRID)
      if coords.first != coords.last
        return Failure("The coordinates are not closed in a circle")
      end

      factory = RGeo::Geos.factory(srid: srid)
      ring = factory.linear_ring(coords.map { |x, y| factory.point(x, y) })
      polygon = factory.polygon(ring)
      multi_polygon = factory.multi_polygon([polygon])

      Success(MultiPolygonData.new(multi_polygon, multi_polygon.area, ring.length))
    end
  end
end
