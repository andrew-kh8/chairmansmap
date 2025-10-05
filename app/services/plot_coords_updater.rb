class PlotCoordsUpdater
  include Dry::Monads[:result]

  def call(cadaster_number, coords)
    if coords.first != coords.last
      return Failure("Error with #{cadaster_number} the coordinates are not closed in a circle")
    end

    new_geom = create_multi_polygon(coords)

    plot = Plot.joins(:plot_datum).find_by(plot_datum: {cadastral_number: cadaster_number})

    plot.update!(geom: new_geom)

    Success(plot)
  end

  private

  def create_multi_polygon(coords)
    factory = RGeo::Cartesian.factory(srid: Plot::SRID)
    ring = factory.linear_ring(coords.map { |x, y| factory.point(x, y) })
    polygon = factory.polygon(ring)
    factory.multi_polygon([polygon])
  end
end
