# typed: strict

class AgromonitoringsController < ApplicationController
  include Pagy::Method

  sig { void }
  def create
    village = Village.find(params[:village_id])
    agro_pol = Agromonitoring::CreatePolygonVillage.call(village)

    if agro_pol.success?
      flash[:notice] = "Agromonitoring integration successfully integrated"
    else
      flash[:alert] = "Error while integrating with Agromonitoring"
    end

    redirect_to village_path(village)
  end

  sig { void }
  def destroy
    village = Village.find(params[:village_id])
    agro_pol = Agromonitoring::DestroyPolygonVillage.call(village)

    if agro_pol.success?
      flash[:notice] = "Agromonitoring integration successfully deleted"
    else
      flash[:alert] = "Error while delete integrating with Agromonitoring"
    end

    redirect_to village_path(village)
  end

  sig { void }
  def add_tiles
    village = Village.find(params[:village_id])

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
