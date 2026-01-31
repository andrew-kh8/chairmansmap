class PlotCoordsUpdater
  include Dry::Monads[:result]

  def self.call(plot)
    coords = Geo::GetPlotCoords.call(plot.cadastral_number)
    new_geom_data = Geo::MultiPolygonCreator.call(coords).value_or { |error| return Dry::Monads::Failure(error) }

    plot.update!(geom: new_geom_data.multi_polygon)

    Dry::Monads::Success(plot)
  rescue => error
    Dry::Monads::Failure(error)
  end
end
