# typed: strict

module Geo
  class UnprojectPlot
    extend T::Sig

    sig { params(plot: Plot).returns(RGeo::Geographic::ProjectedMultiPolygonImpl) }
    def self.call(plot)
      factory = RGeo::Geographic.projected_factory(projection_srid: Plot::SRID)
      factory.unproject(plot.geom)
    end
  end
end
