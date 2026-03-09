# typed: strict

class ApplicationController < ActionController::Base
  extend T::Sig

  before_action :check_maintenance_mode

  # rescue_from NoMethodError, with: :not_implemented
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  sig { void }
  def not_implemented
    render json: {
      message: "the method not implemented"
    }, status: :not_implemented
  end

  sig { void }
  def unprocessable_entity
    render json: {
      message: "something went wrong"
    }, status: :unprocessable_content
  end

  sig { void }
  def not_found
    render json: {
      message: "record not found"
    }, status: :not_found
  end

  sig { void }
  def check_maintenance_mode
    if ENV.fetch("MAINTENANCE_MODE") { false } && request.path != maintenance_path
      redirect_to maintenance_path
    end
  end

  sig { returns(ActiveSupport::SafeBuffer) }
  def flash_turbo_stream
    turbo_stream.replace(:flashes, partial: "application/flashes")
  end
end
