class Api::PlotsController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }

  def show
    render json: PlotSerializer.new.serialize_to_json(Plot.find(params[:id]))
  end

  def update
    plot = PlotUpdater.new.call(params.require(:id), owner_params[:person_id].to_i, plot_data_params)

    if plot.success?
      render json: PlotSerializer.new.serialize_to_json(plot.success), status: :ok
    else
      render json: {message: plot.failure}, status: :bad_request
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
