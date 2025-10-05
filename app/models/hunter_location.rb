class HunterLocation < ApplicationRecord
  SRID = 3857
  
  validates :location, :date, presence: true

  def self.build_point_from_srid(lng, lat, srid=4326)
    point_srid = "SRID=#{srid};POINT(#{lng} #{lat})"

    connection
      .execute("SELECT ST_AsText(ST_Transform(ST_GeomFromText('#{point_srid}'), #{SRID})) AS location")
      .first['location']
  end
end
