# typed: false

module Geo
  class GetPlotCoords
    def self.call(cadaster_number)
      Apis::Cadaster::Client.plot_coords(cadaster_number)
    end
  end
end
