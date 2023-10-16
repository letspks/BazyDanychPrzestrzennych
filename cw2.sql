CREATE EXTENSION postgis;
DROP TABLE punkty
CREATE TABLE budynki (id INT, geom GEOMETRY, nazwa VARCHAR(20));

INSERT INTO punkty VALUES (1, ST_GeomFromText('POINT(6 9.5)'),'K');
INSERT INTO punkty VALUES (2, ST_GeomFromText('POINT(6.5 6)'),'J');
INSERT INTO punkty VALUES (3, ST_GeomFromText('POINT(9.5 6)'),'I');
INSERT INTO punkty VALUES (4, ST_GeomFromText('POINT(1 3.5)'),'G');
INSERT INTO punkty VALUES (5, ST_GeomFromText('POINT(5.5 1.5)'),'H');

INSERT INTO drogi VALUES (1, ST_MakeLine(ST_GeomFromText('POINT(7.5 10.5)'),ST_GeomFromText('POINT(7.5 0)')),'Y');
INSERT INTO drogi VALUES (2, ST_MakeLine(ST_GeomFromText('POINT(0 4.5)'),ST_GeomFromText('POINT(12 4.5)')),'X');

INSERT INTO budynki VALUES (1, ST_MakePolygon(ST_GeomFromText('LINESTRING(8 4,10.5 4,10.5 1.5,8 1.5,8 4)')),'A');
INSERT INTO budynki VALUES (2, ST_MakePolygon(ST_GeomFromText('LINESTRING(4 7,6 7,6 5,4 5,4 7)')),'B');
INSERT INTO budynki VALUES (3, ST_MakePolygon(ST_GeomFromText('LINESTRING(3 8,5 8, 5 6, 3 6, 3 8)')),'C');
INSERT INTO budynki VALUES (4, ST_MakePolygon(ST_GeomFromText('LINESTRING(9 9, 10 9, 10 8,9 8, 9 9)')),'D');
INSERT INTO budynki VALUES (5, ST_MakePolygon(ST_GeomFromText('LINESTRING(1 2, 2 2, 2 1, 1 1, 1 2)')),'E');

SELECT * FROM drogi
--a
SELECT ST_Length(geom) FROM drogi
--b
SELECT ST_AsText(geom),ST_Area(geom),ST_Perimeter(geom) FROM budynki WHERE nazwa = 'A';
--c
SELECT budynki.nazwa, ST_Area(budynki.geom) AS Powierzchnia FROM budynki ORDER BY budynki.nazwa;
--d
SELECT budynki.nazwa, ST_Perimeter(budynki.geom) FROM budynki ORDER BY ST_Area(budynki.geom) desc limit 2;
--e
SELECT ST_Distance(b.geom, punkty.geom) FROM budynki AS b, punkty AS punkty WHERE b.nazwa = 'C' AND punkty.nazwa = 'G';

--f
SELECT ST_Area(ST_Difference((SELECT budynki.geom FROM budynki WHERE budynki.nazwa='C'), ST_buffer((SELECT budynki.geom FROM budynki WHERE budynki.nazwa='B'),0.5))) AS Powierzchnia;

--g
SELECT budynki.nazwa FROM budynki, drogi WHERE ST_Y(ST_Centroid(budynki.geom)) > ST_Y(ST_Centroid(drogi.geom)) and drogi.nazwa='X';

--h
SELECT ST_Area(ST_Symdifference((SELECT budynki.geom from budynki where budynki.nazwa='C'),ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))',0))) AS Powierzchnia;