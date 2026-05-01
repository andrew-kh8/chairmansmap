# typed: strict

require "csv"

module Geo
  class PolygonHeightMap
    extend T::Sig

    class HeightMap < T::Struct
      const :x_coords, T::Array[T.any(Integer, Float, String)]
      const :y_coords, T::Array[T.any(Integer, Float, String)]
      const :z_coords, T::Array[T::Array[T.any(Integer, Float, String)]]
    end

    sig { returns(HeightMap) }
    def self.call
      cs = T.cast(CSV.read("outputr.csv", headers: true), CSV::Table) # hack for sorbet

      x_coords = cs.by_col["X"].uniq
      y_coords = cs.by_col["Y"].uniq
      z_coords = cs.by_col["Z"].each_slice(x_coords.size).map(&:itself)

      HeightMap.new(x_coords:, y_coords:, z_coords:)
    end
  end
end
