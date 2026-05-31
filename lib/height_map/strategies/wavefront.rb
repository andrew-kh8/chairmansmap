# typed: false

module HeightMap
  module Strategies
    # Wavefront propagation for the Eikonal equation |∇T| = F on a regular grid.
    # Unlike FMM (priority queue / narrow band), the wave expands FIFO from the source
    # and cells are re-enqueued when their arrival time improves.
    # Slope constraint matches PathFinder#build_graph: |dz| <= cell_size * max_h_delta.
    class Wavefront
      extend T::Sig

      def initialize(height_map, cell_size, max_h_delta, aslant_cell: nil)
        @y_coords = height_map.keys.sort
        @x_coords = T.must(height_map[@y_coords.first]).keys.sort
        @grid = @y_coords.map { |y| @x_coords.map { |x| height_map[y][x].to_f } }
        @cell_size = cell_size.to_f
        @max_h_delta = max_h_delta.to_f
        @h_delta = @cell_size * @max_h_delta
        @aslant_cell = (aslant_cell || Math.sqrt(2 * @cell_size**2)).to_f
        @nrows = @y_coords.size
        @ncols = @x_coords.size
      end

      def call(start, goal)
        res = {path: [], cost: 0}
        si, sj = coord_to_index(start)
        gi, gj = coord_to_index(goal)
        return res if si.nil? || gi.nil?
        return res unless passable?(si, sj)

        times = Array.new(@nrows) { Array.new(@ncols, Float::INFINITY) }
        times[si][sj] = 0

        queue = [[si, sj]]
        queued = Array.new(@nrows) { Array.new(@ncols, false) }
        queued[si][sj] = true

        until queue.empty?
          i, j = queue.shift
          queued[i][j] = false

          neighbors(i, j).each do |ni, nj|
            next unless edge_passable?(i, j, ni, nj)
            next unless passable?(ni, nj)

            t = candidate_time(ni, nj, times)
            next if t.nil? || t.infinite? || t >= times[ni][nj]

            times[ni][nj] = t
            next if queued[ni][nj]

            queue.push([ni, nj])
            queued[ni][nj] = true
          end
        end

        goal_time = times[gi][gj]
        return res if goal_time.infinite?

        res[:cost] = goal_time
        res[:path] = backtrack(si, sj, gi, gj, times)
        res
      end

      private

      def coord_to_index(point)
        y, x = point
        i = @y_coords.index(y)
        j = @x_coords.index(x)
        return nil if i.nil? || j.nil?

        [i, j]
      end

      def passable?(i, j)
        neighbors(i, j).any? { |ni, nj| edge_passable?(i, j, ni, nj) }
      end

      def edge_passable?(i, j, ni, nj)
        elevation_delta(i, j, ni, nj) <= @h_delta
      end

      def elevation_delta(i, j, ni, nj)
        (@grid[ni][nj] - @grid[i][j]).abs
      end

      def slope_ratio(i, j, ni, nj)
        elevation_delta(i, j, ni, nj) / edge_distance(i, j, ni, nj)
      end

      def slowness(i, j)
        return Float::INFINITY unless passable?(i, j)

        ratios = neighbors(i, j).filter_map do |ni, nj|
          next unless edge_passable?(i, j, ni, nj)

          slope_ratio(i, j, ni, nj)
        end

        return Float::INFINITY if ratios.empty?

        max_ratio = ratios.max
        @cell_size * (1 + max_ratio / @max_h_delta)
      end

      def neighbors(i, j)
        [[-1, 0], [1, 0], [0, -1], [0, 1], [-1, -1], [-1, 1], [1, -1], [1, 1]].filter_map do |di, dj|
          ni = i + di
          nj = j + dj
          next unless ni.between?(0, @nrows - 1) && nj.between?(0, @ncols - 1)

          [ni, nj]
        end
      end

      def edge_distance(i, j, ni, nj)
        (i - ni).abs + (j - nj).abs == 2 ? @aslant_cell : @cell_size
      end

      def candidate_time(i, j, times)
        candidates = []

        eikonal = solve_eikonal(i, j, times)
        candidates << eikonal if eikonal && !eikonal.infinite?

        neighbors(i, j).each do |ni, nj|
          next unless edge_passable?(ni, nj, i, j)

          neighbor_time = times[ni][nj]
          next if neighbor_time.infinite?

          f = slowness(i, j)
          next if f.infinite?

          dist = edge_distance(ni, nj, i, j)
          candidates << neighbor_time + f * dist / @cell_size
        end

        candidates.min
      end

      # Upwind finite-difference update for |∇T| = F using known neighbor times.
      def solve_eikonal(i, j, times)
        f = slowness(i, j)
        return nil if f.infinite?

        h = @cell_size
        tx = known_times(i, j, :x, times)
        ty = known_times(i, j, :y, times)

        return nil if tx.empty? && ty.empty?
        return ty.min + f * h if tx.empty?
        return tx.min + f * h if ty.empty?

        a = tx.min
        b = ty.min
        fh = f * h

        if (a - b).abs >= fh
          [a, b].min + fh
        else
          (a + b + Math.sqrt(2 * fh * fh - (a - b)**2)) / 2.0
        end
      end

      def known_times(i, j, axis, times)
        if axis == :x
          candidates = [[i, j - 1], [i, j + 1]]
        else
          candidates = [[i - 1, j], [i + 1, j]]
        end

        candidates.filter_map do |ni, nj|
          next unless ni.between?(0, @nrows - 1) && nj.between?(0, @ncols - 1)
          next unless edge_passable?(ni, nj, i, j)

          t = times[ni][nj]
          next if t.infinite?

          t
        end
      end

      def backtrack(si, sj, gi, gj, times)
        path = [[@y_coords[gi], @x_coords[gj]]]
        i = gi
        j = gj
        current = times[i][j]

        while i != si || j != sj
          best = nil
          best_time = current

          neighbors(i, j).each do |ni, nj|
            next unless edge_passable?(ni, nj, i, j)

            t = times[ni][nj]
            next if t.infinite? || t >= best_time

            if best.nil? || t < best[2]
              best = [ni, nj, t]
            end
          end

          break if best.nil?

          i, j, current = best
          path.unshift([@y_coords[i], @x_coords[j]])
        end

        path
      end
    end
  end
end
