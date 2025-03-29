class SidePanel::HuntersController < ApplicationController
  def index
    hunter_locations = HunterLocation.all
    render partial: 'index', locals: { hunter_locations: hunter_locations }
  end

  def new
    render partial: 'new'
  end
end
