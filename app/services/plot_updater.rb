class PlotUpdater
  include Dry::Monads[:result]

  class UpdateError < StandardError; end

  def call(plot_id, person_id, plot_data)
    plot = Plot.find(plot_id)

    current_date = Date.current

    ActiveRecord::Base.transaction do
      plot.owner.presence&.update!(active_to: current_date)

      plot.owners.create!(person_id: person_id, active_from: current_date) if person_id.present?

      plot.update!(plot_data) if plot_data.present?
    rescue => error
      raise UpdateError, "При обновлении данных произошла ошибка. #{error}"
    end

    Success(plot)
  rescue ActiveRecord::RecordNotFound => _error
    Failure("Не получилось найти участок")
  rescue UpdateError => error
    Failure(error.message)
  end
end
