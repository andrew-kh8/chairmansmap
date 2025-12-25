class HunterLocationGeometry
  HunterLocationGeojson = Struct.new(:date, :geojson_geom)

  def self.call
    hunter_locations = HunterLocation.select(:date, "ST_AsGeoJSON(ST_Transform(location, 4326)) as geojson_geom")

    hunter_locations.map { |hl| HunterLocationGeojson.new(date: hl.date, geojson_geom: JSON.parse(hl.geojson_geom)) }
  end
end
