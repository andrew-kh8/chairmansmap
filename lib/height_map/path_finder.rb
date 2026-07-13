# typed: false

module HeightMap
  class PathFinder
    extend T::Sig

    CoordType = T.type_alias { T.any(String, Integer, Float) }

    class XYZParams < T::Struct
      const :x, T::Array[CoordType]
      const :y, T::Array[CoordType]
      const :z, T::Array[T::Array[CoordType]]
    end

    class PathResult < T::Struct
      const :x, T::Array[CoordType]
      const :y, T::Array[CoordType]
      const :z, T::Array[CoordType]
      const :cost, Numeric
    end

    sig { returns(XYZParams) }
    attr_reader :xyz_params

    sig { returns(Float) }
    attr_reader :aslant_cell

    # sig { params(xyz_params: XYZParams).void }
    def initialize(xyz_params, cell_size, max_h_delta)
      @xyz_params = xyz_params
      @cell_size = cell_size # m
      @max_h_delta = max_h_delta # %
      @aslant_cell = Math.sqrt(2 * (@cell_size**2)).floor(1)
      @height_map = T.let(build_height_map, T::Hash[[Float, Float], T::Hash[[Float, Float], Float]])
    end

    sig { params(from: [CoordType, CoordType], to: [CoordType, CoordType], alg: Symbol).returns(PathResult) }
    def call(from:, to:, alg: :a)
      from_real = [nearest_coord(:y, from.first), nearest_coord(:x, from.last)]
      to_real = [nearest_coord(:y, to.first), nearest_coord(:x, to.last)]
      res = if grid_algorithm?(alg)
        grid_strategy_for(alg).new(@height_map, @cell_size, @max_h_delta, aslant_cell: @aslant_cell).call(from_real, to_real)
      else
        strategy_for(alg).new(build_graph).call(from_real, to_real)
      end

      path = res[:path]
      z = []
      path.each do |y, x|
        z << @height_map[y][x]
      end

      PathResult.new(x: path.map(&:last), y: path.map(&:first), z:, cost: res[:cost])
    end

    # private

    sig { params(alg: Symbol).returns(T::Boolean) }
    def grid_algorithm?(alg)
      case alg
      when :fast_marching, :fmm, :wavefront then true
      else false
      end
    end

    sig { params(alg: Symbol).returns(T.untyped) }
    def grid_strategy_for(alg)
      case alg
      when :wavefront
        HeightMap::Strategies::Wavefront
      else
        HeightMap::Strategies::FastMarching
      end
    end

    sig { params(alg: Symbol).returns(T.untyped) }
    def strategy_for(alg)
      HeightMap::Strategies::AStar
    end

    sig { params(coord_type: Symbol, coord: CoordType).returns(CoordType) }
    def nearest_coord(coord_type, coord)
      available_coords = (coord_type == :x) ? xyz_params.x : xyz_params.y

      return coord if available_coords.include?(coord)
      return available_coords.max if coord > available_coords.max
      return available_coords.min if coord < available_coords.min

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
    # cost.compact_blank == {
    #   [44.50264, 33.57708] => { # from
    #     #   to                  cost
    #     [44.50264, 33.57742] => -2.0,
    #     [44.50393, 33.57708] => -12.0,
    #     [44.50393, 33.57742] => -17.0
    #   },
    #   [44.50264, 33.57742] => {[44.50264, 33.57786] => -2.0, [44.50393, 33.57742] => -15.0, [44.50393, 33.57786] => -21.0},
    #   [44.50264, 33.57786] => {[44.50264, 33.57816] => -3.0, [44.50393, 33.57786] => -19.0, [44.50393, 33.57816] => -23.0},
    #   [44.50264, 33.57816] => {[44.50264, 33.57855] => -4.0, [44.50393, 33.57816] => -20.0, [44.50393, 33.57855] => -23.0},
    #   [44.50264, 33.57855] => {[44.50393, 33.57855] => -19.0},
    #   [44.50393, 33.57708] => {[44.50393, 33.57742] => -5.0, [44.50521, 33.57708] => -23.0, [44.50521, 33.57742] => -19.0},
    #   [44.50393, 33.57742] => {[44.50393, 33.57786] => -6.0, [44.50521, 33.57742] => -14.0, [44.50521, 33.57786] => -11.0},
    #   [44.50393, 33.57786] => {[44.50393, 33.57816] => -4.0, [44.50521, 33.57786] => -5.0, [44.50521, 33.57816] => -10.0},
    #   [44.50393, 33.57816] => {[44.50393, 33.57855] => -3.0, [44.50521, 33.57816] => -6.0, [44.50521, 33.57855] => -5.0},
    #   [44.50393, 33.57855] => {[44.50521, 33.57855] => -2.0},
    #   [44.50521, 33.57708] => {[44.50521, 33.57742] => 4.0, [44.50663, 33.57708] => 7.0, [44.50663, 33.57742] => 10.0},
    #   [44.50521, 33.57742] => {[44.50521, 33.57786] => 3.0, [44.50663, 33.57742] => 6.0, [44.50663, 33.57786] => 12.0},
    #   [44.50521, 33.57786] => {[44.50521, 33.57816] => -5.0, [44.50663, 33.57786] => 9.0, [44.50663, 33.57816] => 16.0},
    #   [44.50521, 33.57816] => {[44.50521, 33.57855] => 1.0, [44.50663, 33.57816] => 21.0, [44.50663, 33.57855] => 22.0},
    #   [44.50521, 33.57855] => {[44.50663, 33.57855] => 21.0},
    #   [44.50663, 33.57708] => {[44.50663, 33.57742] => 3.0, [44.50694, 33.57708] => 19.0, [44.50694, 33.57742] => 19.0},
    #   [44.50663, 33.57742] => {[44.50663, 33.57786] => 6.0, [44.50694, 33.57742] => 16.0, [44.50694, 33.57786] => 14.0},
    #   [44.50663, 33.57786] => {[44.50663, 33.57816] => 7.0, [44.50694, 33.57786] => 8.0, [44.50694, 33.57816] => 6.0},
    #   [44.50663, 33.57816] => {[44.50663, 33.57855] => 1.0, [44.50694, 33.57816] => -1.0, [44.50694, 33.57855] => -1.0},
    #   [44.50663, 33.57855] => {[44.50694, 33.57855] => -2.0},
    #   [44.50694, 33.57708] => {[44.50694, 33.57742] => 0.0},
    #   [44.50694, 33.57742] => {[44.50694, 33.57786] => -2.0},
    #   [44.50694, 33.57786] => {[44.50694, 33.57816] => -2.0},
    #   [44.50694, 33.57816] => {[44.50694, 33.57855] => 0.0},
    #   [44.50694, 33.57855] => {}
    # }

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

    # hmap == {
    #   44.50264 => {33.57708 => 145.0, 33.57742 => 147.0, 33.57786 => 149.0, 33.57816 => 152.0, 33.57855 => 156.0},
    #   44.50393 => {33.57708 => 157.0, 33.57742 => 162.0, 33.57786 => 168.0, 33.57816 => 172.0, 33.57855 => 175.0},
    #   44.50521 => {33.57708 => 180.0, 33.57742 => 176.0, 33.57786 => 173.0, 33.57816 => 178.0, 33.57855 => 177.0},
    #   44.50663 => {33.57708 => 173.0, 33.57742 => 170.0, 33.57786 => 164.0, 33.57816 => 157.0, 33.57855 => 156.0},
    #   44.50694 => {33.57708 => 154.0, 33.57742 => 154.0, 33.57786 => 156.0, 33.57816 => 158.0, 33.57855 => 158.0}
    # }

    # def aslant_cell
    #   Math.sqrt(2 * (@cell_size**2)).floor(1)
    # end
  end
end

# x = cs.by_col["X"].uniq.map(&:to_f)
# y = cs.by_col["Y"].uniq.map(&:to_f)
# z = cs.by_col["Z"].map(&:to_f).each_slice(x.size)
# h = {}

# zz = [
#   # x1     x2     x3     x4     x5
#   [145.0, 147.0, 149.0, 152.0, 156.0], # y1
#   [157.0, 162.0, 168.0, 172.0, 175.0], # y2
#   [180.0, 176.0, 173.0, 178.0, 177.0], # y3
#   [173.0, 170.0, 164.0, 157.0, 156.0], # y4
#   [154.0, 154.0, 156.0, 158.0, 158.0]  # y5
# ]

# v1 ---------------------------------------------------------

# (0...y.size).each do |i|
#   h[x[i]] = z[i]
# end

# h = {
#   33.57708 => [145.0, 147.0, 149.0, 152.0, 156.0],
#   33.57742 => [157.0, 162.0, 168.0, 172.0, 175.0],
#   33.57786 => [180.0, 176.0, 173.0, 178.0, 177.0],
#   33.57816 => [173.0, 170.0, 164.0, 157.0, 156.0],
#   33.57855 => [154.0, 154.0, 156.0, 158.0, 158.0]
# }

# v2 ---------------------------------------------------------

# (0...y.size).each do |i|
#   h[y[i]] = (0...x.size).to_h { |j| [x[j], z[i][j]] }
# end
