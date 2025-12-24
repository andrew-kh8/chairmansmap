module Geometry
  class PlotsController < ApplicationController
    def index
      sql = <<~SQL
        SELECT
        ST_AsGeoJSON(ST_Transform(geom, 4326)) as geojson_geom,
        id,
        number
        FROM plots;
      SQL

      result = ActiveRecord::Base.connection.execute(sql)

      features = result.map do |plot_d|
        {
          type: "Feature",
          geometry: JSON.parse(plot_d["geojson_geom"]),
          properties: {
            id: plot_d["id"],
            number: plot_d["number"]
          }
        }
      end

      geojson = {
        type: "FeatureCollection",
        features: features
      }

      render json: geojson
    end
  end
end
