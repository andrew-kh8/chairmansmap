module SidePanel
  class PlotsController < ApplicationController
    def index
      @people = Person.all.order(:surname)
      render partial: "index"
    end

    def show
      plot = Plot.preload(:person).find(params[:id])

      if turbo_frame_request?
        render partial: "side_panel/plots/data", locals: {plot:}
      else
        redirect_to root_path
      end
    end

    def edit
      people = Person.all.order(:surname)
      plot = Plot.find(params[:id])

      render partial: "side_panel/plots/update_form", locals: {people:, plot:}
    end

    def update
      plot = PlotUpdater.new.call(params.require(:id), owner_params[:person_id].to_i, plot_params)

      if plot.success?
        render partial: "side_panel/plots/data", locals: {plot: plot.success}, notice: "good"
      else
        render partial: "side_panel/plots/data", locals: {plot: plot.failure}, alert: "bad"
      end
    end

    private

    def owner_params
      params.require(:owner).permit(:person_id)
    end

    def plot_params
      params.require(:plot).permit(:sale_status, :owner_type, :description)
    end
  end
end
