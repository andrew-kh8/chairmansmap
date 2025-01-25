class PlotFilterController < ApplicationController
  NO_MATTER = 'не важно'

  def index
    query = {}
    query.merge!({ owner_type: which_owner }) if which_owner
    query.merge!({ sale_status: which_sale_status }) if which_sale_status

    if which_owner || which_sale_status
      plots_numbers = PlotDatum.where(query).map { _1.plot.number }
      render json: { plots: plots_numbers }
    else
      render json: {}
    end
  end

  private

  def which_owner
    params.require(:owner_type) == NO_MATTER ? false : params.require(:owner_type)
  end

  def which_sale_status
    params.require(:sale_status) == NO_MATTER ? false : params.require(:sale_status)
  end
end
