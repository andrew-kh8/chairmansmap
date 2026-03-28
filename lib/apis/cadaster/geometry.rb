# typed: strict
# frozen_string_literal: true

module Apis
  module Cadaster
    class Geometry < T::Struct
      extend T::Sig

      class Crs < T::Struct
        extend T::Sig

        const :type, String, default: "name"
        const :properties, T::Hash[Symbol, String]
        const :name, String, default: "EPSG:3857"

        sig { returns(T.nilable(String)) }
        def srid
          name.split(":").last
        end
      end

      const :type, String, default: "Polygon"
      const :coordinates, GeoTypes::PolygonCoordinates
      const :crs, Crs

      sig { returns(T.nilable(String)) }
      def srid
        crs.srid
      end
    end
  end
end
