--4
CREATE TABLE tableB AS SELECT popp.* FROM popp JOIN rivers ON ST_DWithin(popp.geom, rivers.geom, 1000)
WHERE popp.f_codedesc= 'Building'

SELECT * FROM tableB

--5

SELECT * FROM airports
CREATE TABLE airportsNew AS SELECT airports.name, airports.geom, airports.elev FROM airports
SELECT * FROM airportsNew

--najbardziej na wschod
SELECT * FROM airportsNew WHERE
ST_X(airportsNew.geom) = (SELECT MAX(ST_X(airportsNew.geom)) FROM airportsNew) 
--najbardziej na zachod
SELECT * FROM airportsNew WHERE
ST_X(airportsNew.geom) = (SELECT MIN(ST_X(airportsNew.geom)) FROM airportsNew) 
--punkt srodkowy
SELECT ST_AsText(ST_LineInterpolatePoint(ST_MakeLine(
        (SELECT geom FROM airportsNew WHERE ST_X(geom) = (SELECT MIN(ST_X(geom)) FROM airportsNew)),
        (SELECT geom FROM airportsNew WHERE ST_X(geom) = (SELECT MAX(ST_X(geom)) FROM airportsNew))), 0.5)) AS srodek;
--dodanie nowego lotniska
INSERT INTO airportsNew (name, geom, elev)
VALUES ('airportB', (SELECT ST_AsText(ST_LineInterpolatePoint(ST_MakeLine(
        (SELECT geom FROM airportsNew WHERE ST_X(geom) = (SELECT MIN(ST_X(geom)) FROM airportsNew)),
        (SELECT geom FROM airportsNew WHERE ST_X(geom) = (SELECT MAX(ST_X(geom)) FROM airportsNew))), 0.5))), 150);
		
--6
SELECT ST_Area(ST_Buffer(ST_MakeLine(
  (SELECT ST_Centroid(geom) FROM lakes WHERE names = 'Iliamna Lake'),
  (SELECT geom FROM airportsNew WHERE name = 'AMBLER')), 1000, 'endcap=flat')) AS area;



--7
SELECT * FROM swamp
SELECT * FROM trees
SELECT * FROM tundra
--tundra
SELECT SUM(
  ST_Area(ST_Intersection(las.geom, tun.geom))) AS Suma_tundra
FROM
  trees AS las,
  tundra AS tun
WHERE
  ST_Intersects(las.geom, tun.geom);
--bagno
SELECT SUM(
  ST_Area(ST_Intersection(las.geom, bag.geom))) AS Suma_bagno
FROM
  trees AS las,
  swamp AS bag
WHERE
  ST_Intersects(las.geom, bag.geom);