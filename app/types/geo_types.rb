# typed: strict

module GeoTypes
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

  PolygonCoordinates = T.type_alias { T::Array[T::Array[T::Array[Float]]] }
end
