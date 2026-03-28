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
  def new
    render :new, locals: {village: Village.new}
  end

  sig { void }
  def check_cadastral_number
    data = Geo::GetCadasterQuarter.call(params[:cadastral_number])

    if data.success?
      render json: {message: "ok"}, status: 200
    else
      render json: {message: data.error}, status: 404
    end
  end

  sig { void }
  def create
    village = VillageCreator.call(village_params, populate_plots: params.require(:village)[:populate_plots] == "1")

    if village.success?
      redirect_to village_path(village.payload), notice: "Деревня успешно создана."
    else
      flash[:alert] = "Ошибка при создании деревни: #{village.error}"
      redirect_to new_village_path
    end
  end

  private

  sig { returns(T::Hash[Symbol, T.untyped]) }
  def village_params
    params.require(:village).permit(:name, :cadastral_number).to_h
  end
end
