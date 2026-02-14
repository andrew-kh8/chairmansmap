# typed: true
# frozen_string_literal: true

class HunterLocationGeometry
  extend T::Sig

  class HunterLocationGeojson < T::Struct
    const :date, ActiveSupport::TimeWithZone
    const :geojson_geom, T::Hash[String, T.any(String, T::Array[Float])]
  end

  sig { returns(T::Array[HunterLocationGeojson]) }
  def self.call
    HunterLocation
      .select(:date, "ST_AsGeoJSON(ST_Transform(location, 4326)) as geojson_geom")
      .map { |hl| HunterLocationGeojson.new(date: hl.date, geojson_geom: JSON.parse(hl["geojson_geom"])) }
  end
end
