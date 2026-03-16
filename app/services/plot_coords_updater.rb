# typed: strict

class PlotCoordsUpdater
  extend T::Sig
  extend Dry::Monads::Result::Mixin

  sig { params(plot: Plot).returns(Dry::Monads::Result[Plot, String]) }
  def self.call(plot)
    cadastral_number = plot.cadastral_number
    return Failure("no cad num") if cadastral_number.nil?

    coords = Geo::GetPlotCoords.call(cadastral_number).value_or { |error| return Failure(error) }

    new_geom_data = Geo::MultiPolygonCreator.call(coords).value_or { |error| return Failure(error) }

    plot.update!(geom: new_geom_data.multi_polygon, area: new_geom_data.area, perimeter: new_geom_data.perimeter)

    Success(plot)
  rescue => error
    Failure(error)
  end
end
