module Geo
  class GetPlotCoords
    include Dry::Monads[:result]

    def self.call(cadaster_number)
      Apis::Geoplys::Client.plot_coords(cadaster_number)
    end
  end
end
