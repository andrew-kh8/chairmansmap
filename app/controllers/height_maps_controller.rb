# typed: strict

class HeightMapsController < ApplicationController
  include Pagy::Method

  sig { void }
  def create
    AddHeightToVillageJob.perform_async(params[:village_id])

    flash[:notice] = "Height map is integrating. It may take a few minutes to complete. Please refresh the page after some time."

    redirect_to village_path(params[:village_id])
  end

  sig { void }
  def destroy
    village = Village.find(params[:village_id])

    if OpenTopo::DestroyHeightFromVillage.new(village).call
      flash[:notice] = "Height map integration successfully deleted"
    else
      flash[:alert] = "Error while deleting height map integration"
    end

    redirect_to village_path(village)
  end
end
