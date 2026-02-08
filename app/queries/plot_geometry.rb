# typed: false
# frozen_string_literal: true

class PlotGeometry
  PlotGeojson = Struct.new(:id, :number, :geojson_geom)

  def self.call(plot_ids = nil)
    plots = Plot.select(:id, :number, "ST_AsGeoJSON(ST_Transform(geom, 4326)) as geojson_geom")

    if plot_ids.present?
      plots = plots.where(id: plot_ids)
    end

    plots.map { |plot| PlotGeojson.new(id: plot.id, number: plot.number, geojson_geom: JSON.parse(plot.geojson_geom)) }
  end
end
