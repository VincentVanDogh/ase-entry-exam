--- Query 1 --- Anzahl der dicken Buecher (> 200 Seiten) pro Autorin
CREATE OR REPLACE VIEW NumberOfLargeBooks AS
       SELECT COUNT(*), autorin.name
       FROM autorin, schrieb, schriftstueck
       WHERE autorin.aid = schrieb.autorin AND 
             schriftstueck.sid = schrieb.schriftstueck AND 
             seiten > 200
       GROUP BY autorin.name;

SELECT * FROM NumberOfLargeBooks;

--- Query 2 --- Transitivitaet von Alliasen
CREATE OR REPLACE VIEW AllAliases AS
WITH RECURSIVE tmp(alias, aliasVon) AS (
       SELECT alias, aliasVon FROM aka
   UNION ALL
       SELECT tmp.alias, aka.aliasVon FROM aka JOIN tmp ON
       aka.alias = tmp.aliasVon
) SELECT * FROM tmp ORDER BY tmp.aliasVon, tmp.alias;

SELECT * FROM AllAliases;

--- Query 3 --- Wenn Roman X auf Y basiert und Y auf Z (mit selben Genres), dann basiert X ueber 2 Schritte auf Z
CREATE OR REPLACE VIEW NovelDistance AS
WITH RECURSIVE tmp(neu, alt, genre, c) AS (
       SELECT neu, alt, genre, 1 
       FROM basiertauf JOIN roman ON 
       sid = neu
   UNION ALL
       SELECT tmp.neu, basiertauf.alt, roman.genre, tmp.c + 1 
       FROM basiertauf, roman, tmp
       WHERE sid = basiertauf.neu AND basiertauf.neu = tmp.alt
) SELECT * FROM tmp WHERE c >= 2 ORDER BY tmp.neu, tmp.alt;

SELECT * FROM NovelDistance;

--Tipp: Falls "ERROR:  cannot change name of view column "sid" to "alt"" auftaucht, DROP VIEW NovelDistance tippen