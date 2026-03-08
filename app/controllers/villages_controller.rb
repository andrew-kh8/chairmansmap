# typed: strict

class VillagesController < ApplicationController
  include Pagy::Method

  sig { void }
  def index
    pagy, villages = pagy(:offset, Village.all, limit: 20)

    render :index, locals: {pagy:, villages:}
  end

  sig { void }
  def show
    village = Village.find(params[:id])

    render :show, locals: {village:}
  end
end
