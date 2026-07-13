# typed: strict

require "csv"

module Geo
  class PolygonHeightMap
    extend T::Sig

    class HeightMap < T::Struct
      extend T::Sig
    end

    sig { returns(HeightMap) }
    def self.call
      HeightMap.new
    end
  end
end
