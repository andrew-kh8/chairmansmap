# typed: false

module Geometry
  class VillagesController < ApplicationController
    def show
      village = Village.find(params[:id])
      unprojected_village_geom = Geo::UnprojectGeom.call(village.geom)

      feature = Geo::PlotSerializer.new.serialize(unprojected_village_geom)

      render json: Geo::GeojsonSerializer.new.serialize_to_json([feature])
    end
  end
end
