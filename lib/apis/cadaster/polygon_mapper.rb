# typed: strict
# frozen_string_literal: true

module Apis
  module Cadaster
    class PolygonMapper < T::Struct
      extend T::Sig

      sig { params(polygons_data: T::Array[T::Hash[Symbol, T.untyped]]).returns(T::Array[Polygon]) }
      def self.build_polygons(polygons_data)
        polygons_data.map { |polygon| build_polygon(polygon) }
      end

      sig { params(polygon_data: T::Hash[Symbol, T.untyped]).returns(Polygon) }
      def self.build_polygon(polygon_data)
        polygon_data[:cadaster_number] = polygon_data[:properties][:options][:cad_num] # or [:properties][:descr] / [:properties][:externalKey]
        polygon_data.merge!(polygon_data[:properties][:systemInfo])

        TypeCoerce[Polygon].new.from(polygon_data)
      end
    end
  end
end
