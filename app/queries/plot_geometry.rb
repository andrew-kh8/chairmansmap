# typed: strict
# frozen_string_literal: true

class PlotGeometry
  extend T::Sig

  class PlotGeojson < T::Struct
    MultiPolygonType = T.type_alias { T::Array[T::Array[T::Array[T::Array[Float]]]] }

    const :id, String
    const :number, Integer
    const :geojson_geom, T::Hash[String, T.any(String, MultiPolygonType)]
  end

  sig { params(plot_ids: T.untyped).returns(T::Array[PlotGeojson]) }
  def self.call(plot_ids = nil)
    plots = Plot.select(:id, :number, "ST_AsGeoJSON(ST_Transform(geom, 4326)) as geojson_geom")

    if plot_ids.present?
      plots = plots.where(id: plot_ids)
    end

    plots.map { |plot| PlotGeojson.new(id: plot.id, number: plot.number, geojson_geom: JSON.parse(plot["geojson_geom"])) }
  end
end
