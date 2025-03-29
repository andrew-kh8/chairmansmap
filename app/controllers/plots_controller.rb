class PlotsController < ApplicationController
  def index
    @people = Person.all.order(:surname)
  end
end
