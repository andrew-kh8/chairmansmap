# typed: strict
# frozen_string_literal: true

module Apis
  module Cadaster
    class PolygonList < T::Struct
      extend T::Sig

      const :polygons, T::Array[Polygon]
      const :page, Integer
      const :count, Integer
      const :total_count, Integer

      sig { returns(T::Boolean) }
      def empty?
        polygons.empty?
      end

      sig { returns(T::Boolean) }
      def has_next_page?
        (page + 1) * count < total_count
      end

      sig { returns(Integer) }
      def total_pages
        (total_count / count.to_f).ceil
      end
    end
  end
end
