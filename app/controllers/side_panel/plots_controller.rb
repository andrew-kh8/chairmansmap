module SidePanel
  class PlotsController < ApplicationController
    def index
      @people = Person.all.order(:surname)
      render partial: "index"
    end
  end
end
