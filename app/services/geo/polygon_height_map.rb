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
      polygon = "idaho" # idaho - oregon
      cs = T.cast(CSV.read("#{polygon}.csv", headers: true), CSV::Table) # hack for sorbet

      x_coords = cs.by_col["X"].uniq.map(&:to_f) # .map { |a| (a - a.floor) * 1000 }
      y_coords = cs.by_col["Y"].uniq.map(&:to_f) # .map { |a| (a - a.floor) * 1000 }
      z_coords = cs.by_col["Z"].map { |q| q.to_f.floor(4) }.each_slice(x_coords.size).map(&:itself)

      xyz = ::HeightMap::PathFinder::XYZParams.new(x: x_coords, y: y_coords, z: z_coords)
      #           y       x
      case polygon
      when "monrovia_10m"
        from = [3781702, 407930] # monrovia 1m
        to = [3781610, 407217]
        cell_size = 10
        h_delta = 0.2
      when "oregon"
        from = [45.96245, -117.9537] # oregon 10m
        to = [45.96245, -117.9652]
        cell_size = 10
        h_delta = 0.1
      when "idaho"
        from = [44.3414, -111.2032]
        to = [44.3599, -111.2287]
        cell_size = 10
        h_delta = 0.05 # 0.04 - fmm, a. 0.05 - vawefront
      else
        Rails.logger.info "no from-to coords"
      end

      res = ::HeightMap::PathFinder.new(xyz, cell_size, h_delta).call(from:, to:, alg: :wavefront) # fmm wavefront a

      HeightMap.new(x_coords:, y_coords:, z_coords:, px_coords: res.x, py_coords: res.y, pz_coords: res.z, cost: res.cost)
    end
  end
end
