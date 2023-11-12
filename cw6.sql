CREATE TABLE obiekty(id int primary key, name varchar(20), geom geometry);

INSERT INTO obiekty(id,name,geom) VALUES (1,'obiekt1',St_GeomFromEWKT('SRID=0;MULTICURVE(LINESTRING(0 1, 1 1),
CIRCULARSTRING(1 1,2 0, 3 1), CIRCULARSTRING(3 1, 4 2, 5 1),LINESTRING(5 1, 6 1))'));

INSERT INTO obiekty(id,name,geom) VALUES (2,'obiekt2',St_GeomFromEWKT('SRID=0;CURVEPOLYGON(COMPOUNDCURVE(LINESTRING(10 6, 14 6),
CIRCULARSTRING(14 6, 16 4, 14 2), CIRCULARSTRING(14 2,12 0, 10 2),LINESTRING(10 2, 10 6)),CIRCULARSTRING(11 2, 13 2, 11 2))'));
			  			  
INSERT INTO obiekty(id,name,geom) VALUES (3,'obiekt3',St_GeomFromEWKT('SRID=0;POLYGON((10 17, 12 13, 7 15, 10 17))'));

INSERT INTO obiekty(id,name,geom) VALUES (4,'obiekt4',St_GeomFromEWKT('SRID=0;MULTILINESTRING((20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5))'));
			  			  
INSERT INTO obiekty(id, name, geom) VALUES (5,'obiekt5', ST_GeomFromEWKT('SRID=0; MULTIPOINT((30 30 59),(38 32 234))'));

INSERT INTO obiekty(id, name, geom) VALUES (6,'obiekt6', ST_GeomFromEWKT('SRID=0; GEOMETRYCOLLECTION(LINESTRING(1 1, 3 2),POINT(4 2))'));

--zad 1
SELECT ST_Area(ST_Buffer(ST_ShortestLine(o3.geom, o4.geom),5)) as AREA FROM obiekty as o3, obiekty as o4 WHERE
o3.name='obiekt3' and o4.name= 'obiekt4';

--zad2
SELECT ST_GeometryType(obiekt.geom) FROM obiekty as obiekt WHERE obiekt.name='obiekt4';

SELECT ST_IsClosed((ST_Dump(geom)).geom) AS czyzamkniety FROM obiekty as obiekt WHERE obiekt.name='obiekt4';
--nie jest zamkniety
 UPDATE obiekty 
 SET geom = ST_MakePolygon(ST_LineMerge(ST_CollectionHomogenize(ST_Collect(geom, 'LINESTRING(20.5 19.5, 20 20)'))))
WHERE name = 'obiekt4';
--
SELECT ST_IsClosed((ST_Dump(geom)).geom) AS czyzamkniety FROM obiekty as obiekt WHERE obiekt.name='obiekt4';
--juz jest zamkniety

--zad3
INSERT INTO obiekty(id,name,geom)VALUES
(7,'obiekt7',ST_Collect((SELECT geom FROM obiekty WHERE name='obiekt3'),(SELECT geom FROM obiekty WHERE name='obiekt4')));

--zad4
SELECT Sum(St_Area(ST_Buffer(obiekty.geom, 5))) AS CALKOWITE_POLE FROM obiekty WHERE ST_HasArc(obiekty.geom)=false;
