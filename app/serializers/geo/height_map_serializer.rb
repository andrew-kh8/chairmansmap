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
        type: "Feature",
        geometry: {
          type: "LineString",
          coordinates: object.px_coords.zip(object.py_coords)
        }
      }
    end
  end
end
