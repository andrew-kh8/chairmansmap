# typed: strict

module Geo
  class UnprojectGeom
    extend T::Sig

    sig {
      params(geom: T.any(
        RGeo::Geos::CAPIPointImpl,
        RGeo::Geos::CAPIPolygonImpl,
        RGeo::Geos::CAPIMultiPolygonImpl
      )).returns(T.any(
        RGeo::Geographic::ProjectedPointImpl,
        RGeo::Geographic::ProjectedPolygonImpl,
        RGeo::Geographic::ProjectedMultiPolygonImpl
      ))
    }
    def self.call(geom)
      factory = RGeo::Geographic.projected_factory(projection_srid: Plot::SRID)
      factory.unproject(geom)
    end
  end
end
