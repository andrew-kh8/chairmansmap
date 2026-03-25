# typed: strict

class CreatePlotsForVillageJob < ApplicationJob
  extend T::Sig

  queue_as :default
  sidekiq_options retry: 3

  sig { params(village_id: String).void }
  def perform(village_id)
    village = Village.find(village_id)
    cad_client = Apis::Cadaster::Client.new
    village_cadastral_number = village.cadastral_number
    return if village_cadastral_number.nil?

    first_page = cad_client.get_plots(village_cadastral_number)
    return if first_page.failure?

    create_plots(first_page.payload.polygons, village_id)

    (1..first_page.payload.total_pages).each do |page_number|
      page = cad_client.get_plots(village_cadastral_number, page: page_number)
      next if page.failure?

      create_plots(page.payload.polygons, village_id)
      sleep(rand(1.0..3.0)) # anti-throttle
    end
  end

  private

  sig { params(polygon_list: T::Array[Apis::Cadaster::Polygon], village_id: String).void }
  def create_plots(polygon_list, village_id)
    polygon_list.each do |polygon|
      multi_polygon_data = Geo::MultiPolygonCreator.call(polygon.coordinates)
        .on_error { |_error| next }
        .payload

      plot = Plot.new(
        area: multi_polygon_data.area,
        perimeter: multi_polygon_data.perimeter,
        number: polygon.cadaster_number.split(":").last.to_i + 200,
        geom: multi_polygon_data.multi_polygon,
        # description: params.description,
        # sale_status: params.sale_status,
        owner_type: polygon.owner_type,
        cadastral_number: polygon.cadaster_number,
        village_id: village_id
      )

      if !plot.save
        Rails.logger.error("Failed to save plot #{polygon.cadaster_number}: #{plot.errors.full_messages.join(", ")}")
      end
    end
  end
end
