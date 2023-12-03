--SELECT * FROM rasters.uk_lake_district;

-- CREATE TABLE tmp AS
-- SELECT lo_from_bytea(0,
-- ST_AsGDALRaster(ST_Union(st_clip), 'GTiff', ARRAY['COMPRESS=DEFLATE',
-- 'PREDICTOR=2', 'PZLEVEL=9'])
-- ) AS loid
-- FROM rasters.uk_lake_district;

--export tifu z uk_lake_district
--SELECT lo_export(loid, 'C:\Users\Public\Documents\uk_lake.tiff')
--FROM tmp;

--ladowanie danych z sentinela
--"Program Files\PostgreSQL\15\bin\raster2pgsql.exe" -s 32630 -N -32767 -t 254x254 -I -C -M -d "C:\Users\Piotrek\Desktop\IMG_DATA\T30UVF_20231110T112311_B04.jp2 public.sentinel2_band4_2 | "Program Files\PostgreSQL\15\bin\psql.exe" -d raster -h localhost -U postgres -p 5432


create table redd as SELECT ST_Union(ST_SetBandNodataValue(rast, NULL), 'MAX') rast
                      FROM (SELECT rast FROM public.sentinel2_band4_1
                        UNION ALL
                         SELECT rast FROM public.sentinel2_band4_2) foo;

create table nirr as SELECT ST_Union(ST_SetBandNodataValue(rast, NULL), 'MAX') rast
                      FROM (SELECT rast FROM public.sentinel2_band8_1
                        UNION ALL
                         SELECT rast FROM public.sentinel2_band8_2) foo;

WITH r1 AS (
(SELECT ST_Union(ST_Clip(a.rast, ST_Transform(b.geom, 32630), true)) as rast
            FROM public.redd AS a, rasters.nationalparks AS b
            WHERE ST_Intersects(a.rast, ST_Transform(b.geom, 32630)) AND b.gid=1))
,
r2 AS (
(SELECT ST_Union(ST_Clip(a.rast, ST_Transform(b.geom, 32630), true)) as rast
    FROM public.nirr AS a, rasters.nationalparks AS b
    WHERE ST_Intersects(a.rast, ST_Transform(b.geom, 32630)) AND b.gid=1))

SELECT ST_MapAlgebra(r1.rast, r2.rast, '([rast1.val]-[rast2.val])/([rast1.val]+[rast2.val])::float', '32BF') AS rast
INTO uk_lake_district_ndwi FROM r1, r2;

CREATE TABLE tmp_outNDWI AS
SELECT lo_from_bytea(0, ST_AsGDALRaster(ST_Union(rast), 'GTiff',  ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])) AS loid
FROM uk_lake_district_ndwi;

-- Zapisywanie pliku na dysku 

SELECT lo_export(loid, 'C:\Users\Public\Documents\NDWI.tiff') FROM tmp_outNDWI;