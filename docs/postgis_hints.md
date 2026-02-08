# PostGis hints and error solutions

## Cannot find SRID (4326) in spatial_ref_sys

1. check if there is a srid
`SELECT * FROM spatial_ref_sys WHERE srid = 4326;`

2. if result is empty run
```
DROP EXTENSION IF EXISTS postgis CASCADE;
CREATE EXTENSION postgis;
```
3. then check it again
4. if now all right, but after tests doesn't - check database_cleaner configuration (truncation clears all tables)

## Transform (unproject) coordinates

### with postgis
coords in db are stored in 3857, to transform them to 4326 run this
```ruby
  sql <<~SQL
    SELECT
        ST_AsGeoJSON(ST_Transform(geom, 4326)) as geojson_geom,
        id,
        cadastral_number
    FROM plots
    WHERE id = ?;
  SQL

result = ActiveRecord::Base.connection.execute(
  ActiveRecord::Base.sanitize_sql_array([sql, plot.id])
).first["geojson_geom"]

JSON.parse(result)
```

### with RGeo PROJ
[github doc](https://github.com/rgeo/rgeo-proj4)
```ruby
plot = Plot.find(params[:plot_id])
factory = RGeo::Geographic.projected_factory(projection_srid: 3857)
unprojected = factory.unproject(plot.geom)
RGeo::GeoJSON.encode(unprojected)
```


## Get Center of object(s)

check postgis docs
* [ST_Centroid](https://postgis.net/docs/ST_Centroid.html)
* [ST_PointOnSurface](https://postgis.net/docs/ST_PointOnSurface.html)
* [ST_GeometricMedian](https://postgis.net/docs/ST_GeometricMedian.html)

```sql
SELECT ST_AsText(ST_Transform(ST_Centroid(ST_Collect(geom)), 4326)) FROM plots;

SELECT ST_X(res), ST_Y(res) from (
  select ST_AsText(ST_Transform(ST_Centroid(ST_Collect(geom)), 4326)) as res FROM plots
);
```
