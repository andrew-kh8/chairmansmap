# frozen_string_literal: true

class PlotUpdater
  include Dry::Monads[:result]

  def call(plot_id, person_id, plot_data)
    begin
      plot = Plot.find(plot_id)
    rescue ActiveRecord::RecordNotFound => e
      return Failure('Не получилось найти участок')
    end

    current_date = Date.current

    ActiveRecord::Base.transaction do
      plot.owner.update!(active_to: current_date) if plot.owner.present?

      plot.owners.create!(person_id: person_id, active_from: current_date) if person_id.present?

      plot.plot_datum.update!(plot_data) if plot_data.present?
    rescue StandardError => e
      return Failure("При обновлении данных произошла ошибка. #{e}")
    end

    Success(plot)
  end
end
