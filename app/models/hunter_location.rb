class HunterLocation < ApplicationRecord
  SRID = 3857

  validates :location, :date, presence: true

  def self.build_point_from_srid(lng, lat, srid = 4326)
    point_srid = "SRID=#{srid};POINT(#{lng} #{lat})"
    sql_query = "SELECT ST_AsText(ST_Transform(ST_GeomFromText(?), ?)) AS location"

    connection.execute(sanitize_sql([sql_query, point_srid, SRID]))
  end
end
