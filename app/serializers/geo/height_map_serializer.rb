# typed: false

module Geo
  class HeightMapSerializer < Panko::Serializer
    attributes :height_map, :path, :cost

    def height_map
      {
        x: object.x_coords,
        y: object.y_coords,
        z: object.z_coords
      }
    end

    def path
      {
        x: object.px_coords,
        y: object.py_coords,
        z: object.pz_coords
      }
    end
  end
end
