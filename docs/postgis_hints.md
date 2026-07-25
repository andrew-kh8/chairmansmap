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

### with RGeo Feature

```ruby
factory_3857 = RGeo::Geos.factory(srid: 3857)
geo_3857 = factory_3857.point(100, 500) # any type of geometry

factory_for_db = RGeo::Geos.factory(srid: GeoConst::DEFAULT_DB_SRID)
RGeo::Feature.cast(geo_3857, factory: factory_for_db, project: true)
```

## Get Center of object(s)

check postgis docs

- [ST_Centroid](https://postgis.net/docs/ST_Centroid.html)
- [ST_PointOnSurface](https://postgis.net/docs/ST_PointOnSurface.html)
- [ST_GeometricMedian](https://postgis.net/docs/ST_GeometricMedian.html)

```sql
SELECT ST_AsText(ST_Transform(ST_Centroid(ST_Collect(geom)), 4326)) FROM plots;

SELECT ST_X(res), ST_Y(res) from (
  select ST_AsText(ST_Transform(ST_Centroid(ST_Collect(geom)), 4326)) as res FROM plots
);
```

## GDAL geotif to csv

```bash
apt-get install gdal-bin
gdalinfo -v
gdal_translate -of XYZ -co COLUMN_SEPARATOR=, -co ADD_HEADER_LINE=YES input_geotif.tif output.csv
```

## RGeo bbox (bounding box)

```ruby
geom.class == RGeo::Geos::CAPIMultiPolygonImpl
e = geom.envelope # #<RGeo::Geos::CAPIPolygonImpl:0xaed8 "POLYGON ((11.0 11.0, 22.0 11.0, 22.0 44.0, 11.0 44.0, 11.0 11.0))">
e.coordinates # [[11.0, 11.0], [22.0, 11.0], ...]
```


## FFI GDAL

```ruby
require "ffi-gdal"
require "csv"

AFFINE_TRANSFORM_PARAMS_SIZE = 6 # аффинное преобразование на плоскости описывается 6 параметрами
BAND_NUMBER = 1 # GeoTIFF содержит один слой с высотой
gdal = FFI::GDAL::GDAL

FFI::GDAL::GDAL.GDALAllRegister

# "input.tif" должен существовать на диске, TempFile не подходит
dataset = gdal.GDALOpen("input.tif", gdal::Access[:GA_ReadOnly]) # GA_ReadOnly == 0
raise "cannot open" if dataset.null?

width  = gdal.GDALGetRasterXSize(dataset)
height = gdal.GDALGetRasterYSize(dataset)

band = gdal.GDALGetRasterBand(dataset, 1)

# Читаем GeoTransform
geo_transform = FFI::MemoryPointer.new(:double, AFFINE_TRANSFORM_PARAMS_SIZE)
gdal.GDALGetGeoTransform(dataset, geo_transform)
gt = geo_transform.read_array_of_double(AFFINE_TRANSFORM_PARAMS_SIZE)

origin_x    = gt[0]
pixel_width = gt[1]
rot_x       = gt[2]
origin_y    = gt[3]
rot_y       = gt[4]
pixel_height = gt[5]   # обычно отрицательный

CSV.open("output.csv", "w") do |csv|
  csv << ["x", "y", "z"]

  height.times do |py|
    buf = FFI::MemoryPointer.new(:float, width)

    gdal.GDALRasterIO(
      band,                           # указатель на растровый слой
      gdal::RWFlag[:GF_Read],         # флаг чтения/записи = 0
      0,                              # смещение по X (столбец начала)
      py,                             # смещение по Y (строка начала)
      width,                          # ширина области для чтения = все колонки
      1,                              # высота области для чтения = 1 строка
      buf,                            # буфер для данных
      width,                          # ширина буфера
      1,                              # высота буфера
      gdal::DataType[:GDT_Float32],   # тип данных в буфере = 6 = Float32
      0,                              # расстояние между пикселями (в байтах)
      0                               # расстояние между строками (в байтах)
    )

    row = buf.read_array_of_float(width)

    row.each_with_index do |z, px|
      # Географические координаты
      x_geo = origin_x + px * pixel_width + py * rot_x
      y_geo = origin_y + px * rot_y       + py * pixel_height

      csv << [x_geo, y_geo, z]
    end
  end
end

gdal.GDALClose(dataset)
```
