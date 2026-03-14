# typed: strict

class PlotCoordsUpdater
  extend T::Sig

  sig { params(plot: Plot).returns(T.any(DM::Success, DM::Failure)) }
  def self.call(plot)
    cadastral_number = plot.cadastral_number
    return DM::Failure("no cad num") if cadastral_number.nil?

    coords = Geo::GetPlotCoords.call(cadastral_number)
    return DM::Failure("no coords") if coords.empty?

    new_geom_data = Geo::MultiPolygonCreator.call(coords).value_or { |error| return DM::Failure(error) }

    plot.update!(geom: new_geom_data.multi_polygon, area: new_geom_data.area, perimeter: new_geom_data.perimeter)

    DM::Success(plot)
  rescue => error
    DM::Failure(error)
  end
end
