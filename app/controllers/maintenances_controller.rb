class MaintenancesController < ApplicationController
  before_action :check_work_mode
  def show
    recover_date = ENV["MAINTENANCE_MODE"].to_datetime
    render :show, layout: "empty", locals: {recover_date: recover_date}
  end

  private

  def check_work_mode
    redirect_to root_path if ENV["MAINTENANCE_MODE"].nil?
  end
end
