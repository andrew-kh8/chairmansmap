# typed: strict

class PlotCoordsUpdater
  extend T::Sig

  sig { params(plot: Plot).returns(Typed::Result[Plot, String]) }
  def self.call(plot)
    cadastral_number = plot.cadastral_number
    return Typed::Failure.new("Cadastral number is empty") if cadastral_number.nil?

    new_geom_data = Geo::GetPlotCoords.call(cadastral_number).and_then do |coords|
      Geo::MultiPolygonCreator.call(coords)
    end.on_error { |error| return Typed::Failure.new(error) }.payload

    plot.update!(geom: new_geom_data.multi_polygon, area: new_geom_data.area, perimeter: new_geom_data.perimeter)

    Typed::Success.new(plot)
  rescue => error
    Typed::Failure.new("Error while update plot #{error.message}")
  end
end
