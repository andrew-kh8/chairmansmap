class SidePanel::HuntersController < ApplicationController
  def index
    hunter_locations = HunterLocation.all
    render partial: 'index', locals: { hunter_locations: hunter_locations }
  end

  def new
    render partial: 'new'
  end

  def create
    HunterLocation.create!(hunter_params)

    hunter_locations = HunterLocation.all
    render partial: 'index', locals: { hunter_locations: hunter_locations }
  end

  private

  def hunter_params
    # error with projection (leaflet has EPSG:3857)
    location = RGeo::Cartesian.factory.point(*params[:hunter_location][:location].split.map(&:to_f))
    params.require(:hunter_location).permit(:date, :license, :dog, :description).merge({ location: location })
  end
end
