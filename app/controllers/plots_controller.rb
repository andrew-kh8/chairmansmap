class PlotsController < ApplicationController
  include Pagy::Method

  def index
    plots = Plot.includes(:plot_datum, :person).order(:gid)

    participants = {"Участники" => plots.map { [_1.person.short_name, _1.id] }.sort_by { |n, i| n }}
    general = {"Наличие собственника" => [["Любой", "any"], ["Без собственника", "none"]]}
    @people_data = general.merge(participants)

    @pagy, @plots = pagy(:offset, plots, limit: 20)
  end

  def show
    plot = Plot.includes(:plot_datum, :person).find(params[:id])
    render :show, locals: {plot: plot, person: plot.person}
  end

  def new
    plot = Plot.new
    people = Person.kept.map { [_1.short_name, _1.id] }

    render :new, locals: {plot: plot, people: people}
  end

  def create
    plot_result = PlotCreator.new(permitted_params).call

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
end
