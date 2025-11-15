class PlotsController < ApplicationController
  include Pagy::Method

  def index
    plots = Plot.includes(:plot_datum, :person).order(:gid)
    @pagy, @plots = pagy(:offset, plots, limit: 24)
  end

  def show
    @plot = Plot.includes(:plot_datum, :person).find(params[:id])
    render :show, locals: {plot: @plot, person: @plot.person}
  end
end
