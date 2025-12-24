module Geometry
  class HuntersController < ApplicationController
    def index
      sql = <<~SQL
        SELECT
        ST_AsGeoJSON(ST_Transform(location, 4326)) as geojson_geom,
        date
        FROM hunter_locations;
      SQL

      result = ActiveRecord::Base.connection.execute(sql)
      features = result.map { |hunter_geom| Geo::HunterLocationSerializer.new.serialize(hunter_geom) }

      geojson = {
        type: "FeatureCollection",
        features: features
      }

      render json: geojson
    end
  end
end
