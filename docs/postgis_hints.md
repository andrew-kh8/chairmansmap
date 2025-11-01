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
4. error might reproduce again :)
