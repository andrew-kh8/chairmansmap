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

  sig { void }
  def add_tiles
    village = Village.find(params[:id])

    result = Agromonitoring::AddTilesToVillage.new(village).call(
      from: Date.parse(params[:from]),
      to: Date.parse(params[:to])
    )

    if result.invalid_tiles.present?
      flash[:alert] = "#{result.invalid_tiles.size} invalid tiles. #{result.error&.message}"
    end

    if result.new_tiles.any?
      flash[:notice] = "#{result.new_tiles.size} new tiles added."
    end

    render turbo_stream: [
      flash_turbo_stream,
      turbo_stream.replace("agromonitoring_tiles", partial: "villages/agromonitoring_tiles", locals: {village:})
    ]
  end
end
