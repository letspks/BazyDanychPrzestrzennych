---1

CREATE TABLE NoweBudynki AS
SELECT t9.gid, t9.polygon_id, t9.name, t9.type, t9.geom, t9.height 
FROM t2019_kar_buildings AS t9 LEFT JOIN t2018_kar_buildings AS t8
ON t8.polygon_id = t9.polygon_id
WHERE t8.height <> t9.height 
OR t8.type <> t9.type 
OR ST_Equals(t8.geom, t9.geom) = false
OR t8.gid is NULL;

SELECT * FROM NoweBudynki;
--2
CREATE TABLE NowePOI AS
SELECT p9.type, COUNT(*) AS count
FROM t2019_kar_poi_table AS p9
WHERE EXISTS (
    SELECT 1
    FROM NoweBudynki AS b
    WHERE ST_DWithin(b.geom, p9.geom, 500)
)
GROUP BY p9.type;

SELECT * FROM NowePOI;

--3


CREATE TABLE zm_ulice AS
SELECT gid, link_id, st_name, ref_in_id, nref_in_id, func_class, speed_Cat, fr_speed_l,
	   to_speed_l, dir_travel, ST_Transform(ST_SetSRID(geom, 4326), 3068) AS geom FROM T2019_KAR_STREETS;
	   
select*from zm_ulice;


--4
CREATE TABLE input_points (p_id INT PRIMARY KEY,geom GEOMETRY(POINT, 4326));
INSERT INTO input_points (p_id, geom) VALUES
	(1, ST_GeomFromText('POINT(8.36093 49.03174)', 4326)),
	(2, ST_GeomFromText('POINT(8.39876 49.00644)', 4326));
select*from input_points;


--5

ALTER TABLE input_points
ALTER COLUMN geom TYPE GEOMETRY(Point, 3068) USING ST_SetSRID(geom, 3068);

UPDATE input_points SET geom = ST_Transform(geom, 3068);

SELECT p_id, ST_AsText(geom) AS geom_czyt FROM input_points;


--6

CREATE TABLE Crossings AS SELECT sn.* FROM t2019_kar_street_node AS sn
JOIN (
    SELECT ST_MakeLine(ST_SetSRID(geom, 4326) ORDER BY p_id) AS line
    FROM input_points
) AS line_geom
ON ST_DWithin(ST_Transform(ST_SetSRID(sn.geom, 4326), 4326), line_geom.line, 200);

SELECT * FROM Crossings;


--7
SELECT COUNT(DISTINCT(poi.geom)) FROM T2019_KAR_LAND_USE_A AS lu, T2019_KAR_POI_TABLE AS poi
WHERE
poi.type = 'Sporting Goods Store'
AND ST_DWithin(lu.geom, poi.geom, 300)
AND lu.type = 'Park (City/County)';


--8

CREATE TABLE T2019_KAR_BRIDGES AS
(SELECT DISTINCT(ST_Intersection(rail.geom, water.geom)) FROM t2019_kar_railways AS rail,
t2019_kar_water_lines AS water);

SELECT * FROM T2019_KAR_BRIDGES;
