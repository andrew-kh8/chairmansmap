# typed: strict

module HeightMap
  class PathFinder
    extend T::Sig

    CoordType = T.type_alias { T.any(String, Integer, Float) }

    class XYZParams < T::Struct
      const :x, T::Array[Float]
      const :y, T::Array[Float]
      const :z, T::Array[T::Array[Float]]
    end

    class PathResult < T::Struct
      const :x, T::Array[Float]
      const :y, T::Array[Float]
      const :z, T::Array[Float]
    end

    sig { returns(XYZParams) }
    attr_reader :xyz_params

    # sig { params(xyz_params: XYZParams).void }
    def initialize(xyz_params, cell_size, max_h_delta)
      @xyz_params = xyz_params
      @cell_size = cell_size # m
      @max_h_delta = max_h_delta # %
      @height_map = T.let(build_height_map, T::Hash[[Float, Float], T::Hash[[Float, Float], Float]])
    end

    sig { params(from: [CoordType, CoordType], to: [CoordType, CoordType], alg: Symbol).returns(PathResult) }
    def call(from:, to:, alg: :bfs)
      graph = build_graph
      res = HeightMap::Strategies::AStar.new(graph).call(from, to)

      path = res[:path]
      z = []
      path.each do |y, x|
        z << @height_map[y][x]
      end

      PathResult.new(x: path.map(&:last), y: path.map(&:first), z:)
    end

    private

    sig { params(coord_type: Symbol, coord: Float).returns(Float) }
    def nearest_coord(coord_type, coord)
      available_coords = (coord_type == :x) ? xyz_params.x : xyz_params.y

      return coord if available_coords.include?(coord)
      return available_coords.max if coord > available_coords.max
      return available_coords.min if coord > available_coords.min

      T.must(available_coords.min_by { |x| (coord - x).abs })
    end

    def build_graph
      yvals = @height_map.keys
      cost = {}
      h_delta = @cell_size * @max_h_delta

      @height_map.each do |yk, yv|
        prev_y_ind = yvals.index(yk) - 1
        prev_y = (prev_y_ind >= 0) ? yvals[prev_y_ind] : nil
        next_y = yvals[yvals.index(yk) + 1]
        prev_yv = @height_map[prev_y] || {}
        next_yv = @height_map[next_y] || {}

        yv.each do |xk, xv|
          prev_x_ind = yv.keys.index(xk) - 1
          prev_x = (prev_x_ind >= 0) ? yv.keys[prev_x_ind] : nil
          next_x = yv.keys[yv.keys.index(xk) + 1]
          cost[[yk, xk]] = {}

          left_v = prev_x ? (xv - (yv[prev_x] || xv)) : nil
          if left_v.present? && left_v.abs <= h_delta
            cost[[yk, xk]][[yk, prev_x]] = left_v + @cell_size
          end

          right_v = next_x ? (xv - (yv[next_x] || xv)) : nil
          if right_v.present? && right_v.abs <= h_delta
            cost[[yk, xk]][[yk, next_x]] = right_v + @cell_size
          end

          down_v = next_y ? (xv - next_yv.fetch(xk, xv)) : nil
          if down_v.present? && down_v.abs <= h_delta
            cost[[yk, xk]][[next_y, xk]] = down_v + @cell_size
          end

          up_v = prev_y ? (xv - prev_yv.fetch(xk, xv)) : nil
          if up_v.present? && up_v.abs <= h_delta
            cost[[yk, xk]][[prev_y, xk]] = up_v + @cell_size
          end

          up_right_v = (next_x && prev_y) ? (xv - prev_yv.fetch(next_x, xv)) : nil
          if up_right_v.present? && up_right_v.abs <= h_delta
            cost[[yk, xk]][[prev_y, next_x]] = up_right_v + aslant_cell
          end

          down_right_v = (next_x && next_y) ? (xv - next_yv.fetch(next_x, xv)) : nil
          if down_right_v.present? && down_right_v.abs <= h_delta
            cost[[yk, xk]][[next_y, next_x]] = down_right_v + aslant_cell
          end

          up_left_v = (prev_x && prev_y) ? (xv - prev_yv.fetch(prev_x, xv)) : nil
          if up_left_v.present? && up_left_v.abs <= h_delta
            cost[[yk, xk]][[prev_y, prev_x]] = up_left_v + aslant_cell
          end

          down_left_v = (prev_x && next_y) ? (xv - next_yv.fetch(prev_x, xv)) : nil
          if down_left_v.present? && down_left_v.abs <= h_delta
            cost[[yk, xk]][[next_y, prev_x]] = down_left_v + aslant_cell
          end

          cost[[yk, xk]].compact
        end
      end

      cost.compact_blank
    end

    def build_height_map
      x = xyz_params.x
      y = xyz_params.y
      z = xyz_params.z

      hmap = {}
      (0...y.size).each do |i|
        hmap[y[i]] = (0...x.size).to_h { |j| [x[j], z[i][j]] }
      end

      hmap
    end

    def aslant_cell
      Math.sqrt(2 * (@cell_size**2)).floor(1)
    end
  end
end
