# typed: false

module Geometry
  class VillagesController < ApplicationController
    def show
      village = Village.find(params[:id])
      unprojected_village_geom = Geo::UnprojectGeom.call(village.geom)

      feature = Geo::PlotSerializer.new.serialize(unprojected_village_geom)

      render json: Geo::GeojsonSerializer.new.serialize_to_json([feature])
    end

    def height_map
      h_map = Geo::PolygonHeightMap.call
      render json: {x: h_map.x_coords, y: h_map.y_coords, z: h_map.z_coords}
    end
  end
end
