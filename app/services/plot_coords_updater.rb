class PlotCoordsUpdater
  include Dry::Monads[:result]

  def call(cadaster_number, coords)
    new_geom_data = Geo::MultiPolygonCreator.new.call(coords).value_or { |error| return Failure(error) }

    plot = Plot.joins(:plot_datum).find_by(plot_datum: {cadastral_number: cadaster_number})

    plot.update!(geom: new_geom_data.multi_polygon)

    Success(plot)
  end
end
