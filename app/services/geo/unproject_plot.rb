# typed: false

module Geo
  class UnprojectPlot
    def self.call(plot)
      factory = RGeo::Geographic.projected_factory(projection_srid: Plot::SRID)
      factory.unproject(plot.geom)
    end
  end
end
