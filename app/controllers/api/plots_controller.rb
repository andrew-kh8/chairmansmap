class Api::PlotsController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }

  resource_description do
    short 'Plot'

    error 404, 'plot not found'

    deprecated false
    description <<-DESC
      In fact, plot contains two models - plot and plot_datum
      Plot has geo data like geom with coordinates, plot's number, gid, area and perimeter
      Plot data has another data like sale status, owner type, kadastr number and description
    DESC
  end

  api! "show plot's data"
  param :id, String, 'ID of plot'
  def show
    render json: PlotSerializer.new.serialize_to_json(Plot.find(params[:id]))
  end

  api! "update plot's data"
  param :id, String, 'ID of plot'
  param :owner, Hash do
    param :person_id, String, 'ID of new owner'
  end
  param :plot_data, Hash do
    param :sale_status, String, "plot's sale status"
    param :owner_type, String, "plot's owner type"
    param :description, String, "plot's description"
  end
  def update
    plot = PlotUpdater.new.call(params.require(:id), owner_params[:person_id].to_i, plot_data_params)

    if plot.success?
      render json: PlotSerializer.new.serialize_to_json(plot.success), status: :ok
    else
      render json: { message: plot.failure }, status: :bad_request
    end
  end

  private

  def owner_params
    params.require(:owner).permit(:person_id)
  end

  def plot_data_params
    params.require(:plot_data).permit(:sale_status, :owner_type, :description)
  end
end
