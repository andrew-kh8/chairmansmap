# typed: false

class Api::PlotsFilterController < ApplicationController
  def index
    if search_params.present?
      render json: {plots: PlotSearch.call(search_params).map(&:number)}
    else
      render json: {}
    end
  end

  private

  def search_params
    params.permit(:owner_type, :sale_status).compact_blank
  end
end
