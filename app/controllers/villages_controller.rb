# typed: false

class VillagesController < ApplicationController
  def show
    village = Village.find(params[:id])

    render :show, locals: {village:}
  end
end
