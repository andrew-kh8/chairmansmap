# typed: false

module Geo
  class HeightMapSerializer < Panko::Serializer
    attributes :height_map

    def height_map
      {
        x: object.x_coords,
        y: object.y_coords,
        z: object.z_coords
      }
    end
  end
end
