# typed: strict

module RgeoTypes
  GeosCAPI = T.type_alias {
    T.any(
      RGeo::Geos::CAPIPointImpl,
      RGeo::Geos::CAPIPolygonImpl,
      RGeo::Geos::CAPIMultiPolygonImpl
    )
  }
  GeoProjected = T.type_alias {
    T.any(
      RGeo::Geographic::ProjectedPointImpl,
      RGeo::Geographic::ProjectedPolygonImpl,
      RGeo::Geographic::ProjectedMultiPolygonImpl
    )
  }
end
