# typed: strict

class MaintenancesController < ApplicationController
  extend T::Sig

  before_action :redirect_to_root, if: -> { ENV["MAINTENANCE_MODE"].nil? }

  sig { void }
  def show
    recover_date = T.must(ENV["MAINTENANCE_MODE"]).to_datetime
    render :show, layout: "empty", locals: {recover_date: recover_date}
  end

  private

  sig { void }
  def redirect_to_root
    redirect_to root_path
  end
end
