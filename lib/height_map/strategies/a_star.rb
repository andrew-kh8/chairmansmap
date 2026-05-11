# typed: false

module HeightMap
  module Strategies
    class AStar
      extend T::Sig

      def initialize(graph)
        @graph = graph
      end

      # sig { params(start: [Float, Float], goal: [Float, Float]).void }
      def call(start, goal)
        res = {path: [], cost: 0}
        path = {}
        f_queue_score = {start => 0}
        g_score = {start => 0}

        while f_queue_score.present?
          point, _point_score = f_queue_score.min_by(&:last)
          f_queue_score.delete(point)

          if point == goal

            path_back = point

            res[:cost] += g_score[goal]
            res[:path].unshift(goal)

            while path[path_back]
              res[:path].unshift(path[path_back])
              path_back = path[path_back]
            end

            break
          end

          tos = @graph[point]
          tos&.each do |neighbor, v|
            neighbor_score = g_score[point] + v

            if neighbor_score < (g_score[neighbor] || Float::INFINITY)
              g_score[neighbor] = g_score[point] + v
              f_queue_score[neighbor] = g_score[neighbor] + heuristic(neighbor, goal)
              path[neighbor] = point
            end
          end
        end

        res
      end

      private

      def heuristic(a, b)
        Math.sqrt((a.first - b.first)**2 + (a.last - b.last)**2)
      end
    end
  end
end
