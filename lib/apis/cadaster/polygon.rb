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

      sig { returns(GeoTypes::PolygonCoordinates) }
      def coordinates
        geometry.coordinates
      end

      sig { returns(T.nilable(String)) }
      def owner_type
        type = ownership_type
        return nil if type.blank?

        if Plot.owner_types.key?(type)
          Plot.owner_types[type]
        else
          {
            "Частная" => "personal",
            "Государственная" => "state"
          }[type]
        end
      end
    end
  end
end
