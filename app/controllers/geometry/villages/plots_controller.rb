# typed: false

module Geometry::Villages
  class PlotsController < ApplicationController
    def index
      plots = PlotGeometry.call(village_id: params[:village_id])
      features = Panko::ArraySerializer.new(nil, each_serializer: Geo::PlotsSerializer).serialize(plots)

      render json: Geo::GeojsonSerializer.new.serialize_to_json(features)
    end
  end
end
