module Geometry
  class PlotsController < ApplicationController
    def index
      plots = PlotGeometry.call
      features = Panko::ArraySerializer.new(nil, each_serializer: Geo::PlotsSerializer).serialize(plots)

      render json: Geo::GeojsonSerializer.new.serialize_to_json(features)
    end

    def show
      plot = Plot.find(params[:id])
      unprojected_plot_geom = Geo::UnprojectPlot.call(plot)

      feature = Geo::PlotSerializer.new.serialize(unprojected_plot_geom)

      render json: Geo::GeojsonSerializer.new.serialize_to_json([feature])
    end
  end
end
