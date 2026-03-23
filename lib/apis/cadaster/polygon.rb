# typed: strict
# frozen_string_literal: true

module Apis
  module Cadaster
    class Polygon < T::Struct
      extend T::Sig

      # there are more fields, but these are essential
      const :id, Integer
      const :geometry, Geometry
      const :cadaster_number, String
      const :ownership_type, T.nilable(String)
      const :inserted, Time
      const :updated, Time

      sig { returns(T.any(::GeoTypes::PolygonCoordinates, ::GeoTypes::MultiPolygonCoordinates)) }
      def coordinates
        geometry.coordinates
      end

      sig { returns(T.nilable(String)) }
      def owner_type
        return nil if ownership_type.blank?

        if Plot.owner_types.key?(ownership_type)
          Plot.owner_types[ownership_type]
        else
          {
            "Частная" => "personal",
            "Государственная" => "state"
          }[ownership_type]
        end
      end
    end
  end
end
