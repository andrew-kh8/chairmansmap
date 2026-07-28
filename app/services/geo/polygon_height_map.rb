# typed: strict

module Geo
  class PolygonHeightMap
    extend T::Sig

    class HeightMap < T::Struct
      extend T::Sig

      const :x, T::Array[String]
      const :y, T::Array[String]
      const :z, T::Array[String]

      sig { returns(T::Array[T::Array[String]]) }
      def z_matrix
        z.each_slice(x.size).to_a
      end
    end

    sig { params(village: Village).returns(T.nilable(HeightMap)) }
    def self.call(village)
      return nil if !village.height_map?

      csv = T.cast(CSV.parse(village.height_map.read, headers: true), CSV::Table)

      HeightMap.new(
        x: csv["X"].uniq,
        y: csv["Y"].uniq,
        z: csv["Z"]
      )
    end
  end
end
