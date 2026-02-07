class PlotCreator
  PlotParams = Struct.new(:number, :description, :sale_status, :owner_type, :cadastral_number, :person_id)

  class << self
    def call(plot_params)
      params = PlotParams.new(**plot_params)
      person = Person.find(params.person_id)

      plot = build_plot(params).value_or { |error| return DM::Failure(error) }

      ActiveRecord::Base.transaction do
        plot.save!
        build_owner(plot, person).save!
      end

      DM::Success(plot)
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => error
      DM::Failure(error.message)
    rescue ActiveRecord::RecordNotFound => _error
      DM::Failure("Person not found")
    end

    private

    def build_plot(params)
      coords = Geo::GetPlotCoords.call(params.cadastral_number).value_or { return DM::Failure("Failed to get coordinates") }
      multi_polygon_data = Geo::MultiPolygonCreator.call(coords).value_or { return DM::Failure("Failed to build polygon") }

      DM::Success(
        Plot.new(
          area: multi_polygon_data.area,
          perimeter: multi_polygon_data.perimeter,
          number: params.number,
          geom: multi_polygon_data.multi_polygon,
          description: params.description,
          sale_status: params.sale_status,
          owner_type: params.owner_type,
          cadastral_number: params.cadastral_number
        )
      )
    end

    def build_owner(plot, person)
      Owner.new(
        plot: plot,
        person: person,
        active_from: Date.current
      )
    end
  end
end
