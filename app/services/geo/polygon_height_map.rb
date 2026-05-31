# typed: strict

require "csv"

module Geo
  class PolygonHeightMap
    extend T::Sig

    class HeightMap < T::Struct
      extend T::Sig

      const :x_coords, T::Array[T.any(Integer, Float, String)]
      const :y_coords, T::Array[T.any(Integer, Float, String)]
      const :z_coords, T::Array[T::Array[T.any(Integer, Float, String)]]
      const :px_coords, T::Array[T.any(Integer, Float, String)]
      const :py_coords, T::Array[T.any(Integer, Float, String)]
      const :pz_coords, T::Array[T.any(Integer, Float, String)]

      const :cost, Numeric
    end

    sig { returns(HeightMap) }
    def self.call
      cs = T.cast(CSV.read("outputr.csv", headers: true), CSV::Table) # hack for sorbet

      x_coords = cs.by_col["X"].uniq.map(&:to_f) # .map { |a| (a - a.floor) * 1000 }
      y_coords = cs.by_col["Y"].uniq.map(&:to_f) # .map { |a| (a - a.floor) * 1000 }
      z_coords = cs.by_col["Z"].map { |q| q.to_f.floor(4) }.each_slice(x_coords.size).map(&:itself)

      xyz = ::HeightMap::PathFinder::XYZParams.new(x: x_coords.map(&:to_f), y: y_coords.map(&:to_f), z: z_coords.map { |q| q.map(&:to_f) })
      res = ::HeightMap::PathFinder.new(xyz, 30, 0.1).call(from:, to:)

      HeightMap.new(x_coords:, y_coords:, z_coords:, px_coords: res.x, py_coords: res.y, pz_coords: res.z, cost: res.cost)
    end
  end
end
