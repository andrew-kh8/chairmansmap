class Api::PlotsController < ApplicationController
  protect_from_forgery unless: -> { request.format.json? }

  def check_cadastral_number
    cadastral_number = params[:cadastral_number]
    data = Apis::Geoplys::GetCoords.call(cadastral_number)

    if data.success?
      render json: {message: "ok"}, status: 200
    else
      render json: {message: data.failure}, status: 404
    end
  end
end
