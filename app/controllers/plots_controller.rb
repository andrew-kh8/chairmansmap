class PlotsController < ApplicationController
  def index
    @plots = Plot.includes(:plot_datum, :person).all
  end

  def show
    @plot = Plot.includes(:plot_datum, :person).find(params[:id])
  end
end
