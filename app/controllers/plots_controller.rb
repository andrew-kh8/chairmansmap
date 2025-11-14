class PlotsController < ApplicationController
  def index
    @plots = Plot.includes(:plot_datum, :person).order(:gid)
  end

  def show
    @plot = Plot.includes(:plot_datum, :person).find(params[:id])
    render :show, locals: {plot: @plot, person: @plot.person}
  end
end
