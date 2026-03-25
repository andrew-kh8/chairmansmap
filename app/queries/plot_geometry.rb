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

  sig { params(village_id: T.nilable(String), plot_ids: T.untyped).returns(T::Array[PlotGeojson]) }
  def self.call(village_id: nil, plot_ids: nil)
    geojson_sql = Plot.sanitize_sql_array(["ST_AsGeoJSON(ST_Transform(geom, :srid)) as geojson_geom", srid: GeoConst::LEAFLET_SRID])
    plots = Plot.select(:id, :number, geojson_sql)

    if village_id.present?
      plots = plots.where(village_id: village_id)
    end

    if plot_ids.present?
      plots = plots.where(id: plot_ids)
    end

    plots.map { |plot| PlotGeojson.new(id: plot.id, number: plot.number, geojson_geom: JSON.parse(plot["geojson_geom"])) }
  end
end
