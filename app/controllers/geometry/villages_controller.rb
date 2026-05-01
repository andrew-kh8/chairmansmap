# typed: strict

module Geometry
  class VillagesController < ApplicationController
    sig { void }
    def show
      village = Village.find(params[:id])
      unprojected_village_geom = Geo::UnprojectGeom.call(village.geom)

      feature = Geo::PlotSerializer.new.serialize(unprojected_village_geom)

      render json: Geo::GeojsonSerializer.new.serialize_to_json([feature])
    end

    sig { void }
    def height_map
      h_map = Geo::PolygonHeightMap.call
      render json: Geo::HeightMapSerializer.new.serialize(h_map)
    end
  end
end
