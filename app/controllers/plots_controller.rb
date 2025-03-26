class PlotsController < ApplicationController
  def index
    @people = Person.all.order(:surname)
  end

  def hunters
    hunter_locations = HunterLocation.all
    render partial: 'hunters', locals: { hunter_locations: hunter_locations }
  end

  def plots
    @people = Person.all.order(:surname)
    render partial: 'plots'
  end
end
