# typed: strict
# frozen_string_literal: true

module Apis
  module Cadaster
    class PolygonMapper < T::Struct
      extend T::Sig

      sig { params(polygons_data: T::Array[T::Hash[Symbol, T.untyped]], meta: T::Hash[Symbol, T.untyped]).returns(PolygonList) }
      def self.build_polygons(polygons_data, meta)
        polygons = polygons_data.filter_map { |polygon| build_polygon(polygon) }
        PolygonList.new(polygons:, page: meta[:page], count: meta[:count], total_count: meta[:totalCount])
      end

      sig { params(polygon_data: T::Hash[Symbol, T.untyped]).returns(T.nilable(Polygon)) }
      def self.build_polygon(polygon_data)
        return nil if !polygon_data[:properties][:category].in?([36381, 36368])
        return nil if polygon_data[:geometry][:type] == "Point"

        polygon_data[:cadaster_number] = polygon_data[:properties][:options][:cad_num] # or [:properties][:descr] / [:properties][:externalKey]
        polygon_data[:ownership_type] = polygon_data[:properties][:options][:ownership_type]
        polygon_data.merge!(polygon_data[:properties][:systemInfo])

        TypeCoerce[Polygon].new.from(polygon_data)
      end
    end
  end
end
