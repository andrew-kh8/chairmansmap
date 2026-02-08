# typed: false

class PlotsController < ApplicationController
  include Pagy::Method

  def index
    plots = PlotSearch.call(search_params)

    @pagy, @plots = pagy(:offset, plots, limit: 20)
  end

  def show
    plot = Plot.includes(:person).find(params[:id])
    render :show, locals: {plot: plot, person: plot.person}
  end

  def new
    plot = Plot.new
    people = Person.kept.map { |person| [person.short_name, person.id] }

    render :new, locals: {plot: plot, people: people}
  end

  def create
    plot_result = PlotCreator.call(permitted_params)

    if plot_result.success?
      redirect_to plot_path(plot_result.success)
    else
      redirect_to new_plot_path, alert: plot_result.failure
    end
  end

  def destroy
    plot_id = params[:id]
    plot = Plot.find(plot_id)

    if plot.destroy!
      redirect_to plots_path, notice: "Участок #{plot_id} удален"
    else
      redirect_to plot_path(plot), alert: "Не получилось удалить участок #{plot_id}"
    end
  end

  private

  def permitted_params
    params.require(:plot).permit(:cadastral_number, :number, :person_id, :owner_type, :sale_status, :description) # :photos
  end

  def search_params
    params
      .permit(:area_min, :area_max, people: [])
      .tap do |plot_params|
        plot_params[:area_min] = plot_params[:area_min].blank? ? nil : plot_params[:area_min].to_f * 100
        plot_params[:area_max] = plot_params[:area_max].blank? ? nil : plot_params[:area_max].to_f * 100
      end
      .compact_blank
  end
end
