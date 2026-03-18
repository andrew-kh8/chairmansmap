# typed: strict

class PlotUpdater
  extend T::Sig

  class UpdateError < StandardError; end

  sig do
    params(plot_id: String, person_id: T.nilable(Integer), plot_data: T.nilable(T::Hash[Symbol, T.untyped]))
      .returns(Typed::Result[Plot, String])
  end
  def self.call(plot_id, person_id, plot_data)
    plot = Plot.find(plot_id)

    current_date = Date.current

    ActiveRecord::Base.transaction do
      if person_id.present?
        plot.owner.presence&.update!(active_to: current_date)
        plot.owners.create!(person_id: person_id, active_from: current_date)
      end

      plot.update!(plot_data) if plot_data.present?
    rescue => error
      raise UpdateError, "При обновлении данных произошла ошибка. #{error}"
    end

    Typed::Success.new(plot)
  rescue ActiveRecord::RecordNotFound => _error
    Typed::Failure.new("Не получилось найти участок")
  rescue UpdateError => error
    Typed::Failure.new(error.message)
  end
end
