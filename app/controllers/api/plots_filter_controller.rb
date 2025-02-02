class Api::PlotsFilterController < ApplicationController
  NO_MATTER = 'не важно'

  api! "get plot's ids by filters"
  param :owner_type, String, "owner's type"
  param :sale_status, String, 'sale status'
  def index
    query = create_query

    if query.present?
      plots_numbers = PlotDatum.eager_load(:plot).where(query).map { _1.plot.number }
      render json: { plots: plots_numbers }, status: :ok
    else
      render json: {}, status: :ok
    end
  end

  private

  # param object
  def which_owner
    params.require(:owner_type) == NO_MATTER ? false : params.require(:owner_type)
  end

  def which_sale_status
    params.require(:sale_status) == NO_MATTER ? false : params.require(:sale_status)
  end

  def create_query
    query = {}
    query.merge!({ owner_type: which_owner }) if which_owner
    query.merge!({ sale_status: which_sale_status }) if which_sale_status

    query
  end
end
