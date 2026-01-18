class PlotCoordsUpdater
  include Dry::Monads[:result]

  def self.call(plot)
    coords = Apis::Geoplys::GetCoords.call(plot.cadastral_number)
    new_geom_data = Geo::MultiPolygonCreator.call(coords).value_or { |error| return Failure(error) }

    plot.update!(geom: new_geom_data.multi_polygon)

    Success(plot)
  rescue => error
    Failure(error)
  end
end
