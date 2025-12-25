module Geometry
  class HuntersController < ApplicationController
    def index
      hunter_locations = HunterLocationGeometry.call
      features = Panko::ArraySerializer.new(nil, each_serializer: Geo::HunterLocationSerializer).serialize(hunter_locations)

      render json: Geo::GeojsonSerializer.new.serialize_to_json(features)
    end
  end
end
