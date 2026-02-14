# typed: strict

class Api::PlotsFilterController < ApplicationController
  extend T::Sig

  sig { void }
  def index
    if search_params.present?
      render json: {plots: PlotSearch.new.call(search_params).map(&:number)}
    else
      render json: {}
    end
  end

  private

  sig { returns(T::Hash[Symbol, T.untyped]) }
  def search_params
    params.permit(:owner_type, :sale_status).compact_blank.to_h
  end
end
