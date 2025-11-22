class PlotCreator
  include Dry::Monads[:result]

  attr_reader :plot, :plot_data, :owner, :params

  PlotParams = Struct.new(:number, :description, :sale_status, :owner_type, :cadastral_number, :person_id)

  def initialize(plot_params)
    @params = PlotParams.new(**plot_params)

    @plot = build_plot
    @plot_data = build_plot_data
    @owner = build_owner
  end

  def call
    if plot.valid? && plot_data.valid? && owner.valid?

      ActiveRecord::Base.transaction do
        plot.save!
        plot_data.save!
        owner.save!
      rescue
        raise Dry::Monads::Failure(plot.errors.full_messages + plot_data.errors.full_messages)
      end

      Dry::Monads::Success(plot)
    else

      Dry::Monads::Failure(plot.errors.full_messages + plot_data.errors.full_messages)
    end
  end

  private

  def build_plot
    coords = Apis::Geoplys::GetCoords.new.call(params.cadastral_number).value_or { return Plot.new }
    multi_polygon_data = Geo::MultiPolygonCreator.new.call(coords).value_or { return Plot.new }

    Plot.new(
      gid: rand(1..500),
      area: multi_polygon_data.area,
      perimeter: multi_polygon_data.perimeter,
      number: params.number,
      geom: multi_polygon_data.multi_polygon
    )
  end

  def build_plot_data
    PlotDatum.new(
      plot: plot,
      description: params.description,
      sale_status: params.sale_status,
      owner_type: params.owner_type,
      cadastral_number: params.cadastral_number
    )
  end

  def build_owner
    Owner.new(
      plot: plot,
      person_id: params.person_id,
      active_from: Date.current
    )
  end
end
