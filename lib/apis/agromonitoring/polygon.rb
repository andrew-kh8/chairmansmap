# typed: strict
# frozen_string_literal: true

module Apis
  module Agromonitoring
    class Polygon < T::Struct
      extend T::Sig

      const :id, String
      const :name, String
      const :geo_json, T::Hash[Symbol, T.untyped]
      const :center, T::Array[T.any(Float, BigDecimal)]
      const :area, Float # hectares
      const :user_id, String
      const :created_at, Integer # Time

      sig { returns(T::Array[T::Array[T::Array[T.any(Float, BigDecimal)]]]) }
      def coords
        geo_json[:geometry][:coordinates]
      end
    end
  end
end
