module SidePanel
  class HuntersController < ApplicationController
    def index
      hunter_locations = HunterLocationSearch.call(search_params)
      locals = {
        hunter_locations: hunter_locations,
        dog_options: HunterLocationSearch::DOG_OPTIONS,
        license_options: HunterLocationSearch::LICENSE_OPTIONS
      }
      render partial: "index", locals:
    end

    def new
      render partial: "new"
    end

    def create
      CreateHunterLocation.call(hunter_params)

      hunter_locations = HunterLocation.all
      locals = {
        hunter_locations: hunter_locations,
        dog_options: HunterLocationSearch::DOG_OPTIONS,
        license_options: HunterLocationSearch::LICENSE_OPTIONS
      }
      render partial: "index", locals:
    end

    private

    def hunter_params
      params.require(:hunter_location).permit(:date, :license, :dog, :description, :location)
    end

    def search_params
      hunter_location = params.fetch(:hunter_location) { {} }

      {
        from: hunter_location[:from],
        to: hunter_location[:to],
        dog: hunter_location[:dog],
        license: hunter_location[:license]
      }.compact_blank
    end
  end
end
