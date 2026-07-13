# typed: strict

module HeightMap
  module Strategies
    class BFS
      extend T::Sig
      extend T::Helpers

      interface!

      class PathResult < T::Struct
        const :path, T::Array[[Float, Float]]
        const :cost, Float
      end

      sig { abstract.params.returns(T::Array[[Float, Float]]) }
      def call
      end
    end
  end
end
