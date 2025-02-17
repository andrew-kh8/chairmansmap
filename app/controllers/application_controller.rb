class ApplicationController < ActionController::Base
  rescue_from NoMethodError, with: :not_implemented
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_implemented
    render json: {
      message: 'the method not implemented'
    }, status: :not_implemented
  end

  def unprocessable_entity
    render json: {
      message: 'something went wrong'
    }, status: :unprocessable_entity
  end

  def not_found
    render json: {
      message: 'record not found'
    }, status: :not_found
  end
end
