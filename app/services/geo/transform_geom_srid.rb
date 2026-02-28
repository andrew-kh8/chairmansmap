# typed: strict

module Geo
  class TransformGeomSrid
    extend T::Sig

    sig { params(geom: RgeoTypes::GeosCAPI, to_srid: Integer).returns(RgeoTypes::GeosCAPI) }
    def self.call(geom, to_srid = GeoConst::DEFAULT_DB_SRID)
      factory = RGeo::Geos.factory(srid: to_srid)
      RGeo::Feature.cast(geom, factory: factory, project: true)
    end
  end
end
