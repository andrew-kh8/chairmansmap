# typed: false

class PlotCreator
  extend T::Sig

  class PlotParams < T::Struct
    const :number, T.nilable(Integer)
    const :description, T.nilable(String)
    const :sale_status, T.nilable(String)
    const :owner_type, T.nilable(String)
    const :cadastral_number, T.nilable(String)
    const :person_id, T.nilable(Integer)
  end

  class << self
    extend T::Sig

    sig { params(plot_params: T::Hash[Symbol, T.untyped]).returns(T.untyped) }
    def call(plot_params)
      params = PlotParams.new(
        number: plot_params[:number]&.to_i,
        description: plot_params[:description],
        sale_status: plot_params[:sale_status],
        owner_type: plot_params[:owner_type],
        cadastral_number: plot_params[:cadastral_number],
        person_id: plot_params[:person_id]&.to_i
      )
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

    sig { params(params: PlotParams).returns(T.untyped) }
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

    sig { params(plot: Plot, person: Person).returns(Owner) }
    def build_owner(plot, person)
      Owner.new(
        plot: plot,
        person: person,
        active_from: Date.current
      )
    end
  end
end
