module SidePanel
  class HuntersController < ApplicationController
    def index
      hunter_locations = HunterLocation.all
      render partial: "index", locals: {hunter_locations: hunter_locations}
    end

    def new
      render partial: "new"
    end

    def create
      CreateHunterLocation.new.call(hunter_params)

      hunter_locations = HunterLocation.all
      render partial: "index", locals: {hunter_locations: hunter_locations}
    end

    private

    def hunter_params
      params.require(:hunter_location).permit(:date, :license, :dog, :description, :location)
    end
  end
end
