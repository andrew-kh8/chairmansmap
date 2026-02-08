# typed: false

class PlotCoordsUpdater
  def self.call(plot)
    coords = Geo::GetPlotCoords.call(plot.cadastral_number)
    new_geom_data = Geo::MultiPolygonCreator.call(coords).value_or { |error| return DM::Failure(error) }

    plot.update!(geom: new_geom_data.multi_polygon, area: new_geom_data.area, perimeter: new_geom_data.perimeter)

    DM::Success(plot)
  rescue => error
    DM::Failure(error)
  end
end
