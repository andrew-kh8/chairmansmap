# typed: strict

module Geo
  class UnprojectGeom
    extend T::Sig

    sig { params(geom: RgeoTypes::GeosCAPI).returns(RgeoTypes::GeoProjected) }
    def self.call(geom)
      factory = RGeo::Geographic.projected_factory(projection_srid: GeoConst::DEFAULT_DB_SRID)
      factory.unproject(geom)
    end
  end
end
