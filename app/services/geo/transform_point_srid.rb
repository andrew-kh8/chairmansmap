# typed: strict

module Geo
  class TransformPointSrid
    extend T::Sig

    SRID = 3857
    TRANSFORMED_ATTR = "transformed_point"

    sig { params(lng: Float, lat: Float, from_srid: Integer).returns(T.untyped) }
    def self.call(lng, lat, from_srid = 4326)
      point_srid = "SRID=#{from_srid};POINT(#{lng} #{lat})"
      sql_query = "SELECT ST_AsText(ST_Transform(ST_GeomFromEWKT(?), ?)) AS #{TRANSFORMED_ATTR}"
      sanitized_query = ActiveRecord::Base.sanitize_sql([sql_query, point_srid, SRID])

      ActiveRecord::Base.connection.execute(sanitized_query).first[TRANSFORMED_ATTR]
    end
  end
end
