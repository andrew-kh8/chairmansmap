class PlotUpdater
  include Dry::Monads[:result]

  def call(plot_id, person_id, plot_data)
    begin
      plot = Plot.find(plot_id)
    rescue ActiveRecord::RecordNotFound => error
      return Failure("Не получилось найти участок")
    end

    current_date = Date.current

    ActiveRecord::Base.transaction do
      if plot.owner.present?
        plot.owner.update!(active_to: current_date)
      end

      if person_id.present?
        plot.owners.create!(person_id: person_id, active_from: current_date)
      end

      if plot_data.present?
        plot.plot_datum.update!(plot_data)
      end
    rescue => error
      return Failure("При обновлении данных произошла ошибка. #{error}")
    end

    Success(plot)
  end
end
