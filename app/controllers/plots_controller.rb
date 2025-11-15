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
  end
end
