# typed: false

module Geo
  class HeightMapSerializer < Panko::Serializer
    attributes :height_map

    private

    def height_map
      {
        x: object.x,
        y: object.y,
        z: object.z_matrix
      }
    end
  end
end
