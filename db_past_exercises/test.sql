                                            ---Aufgabe 1---

/*Realisieren Sie die fortlaufende Nummerierung des Attributs SID der Relation Schriftstueck
mit Hilfe einer Sequence. Die Sequence soll bei 1 beginnen und in Einerschritten erhöht werden.*/
INSERT INTO Schriftstueck(Titel, Seiten) VALUES
('Fahrenheit 451', 192);                            --SID = 21 

/*Realisieren Sie die fortlaufende Nummerierung des Primärschlüssel-Attributs AID in der Tabelle 
Autorin mit Hilfe einer Sequence. Die Sequence soll bei 10.000 beginnen und in Siebenerschritten erhöht werden.*/
INSERT INTO Autorin(Name, GebDat) VALUES
('George Orwell', '1903-06-25');                    --AID = 10077

/*Das Budget jedes Verlages muss zwischen 10 und 1.000.000 liegen (inklusive 10 und 1.000.000).*/
INSERT INTO Verlag VALUES
('Spongebob Verlag', 7.00, 'ab000', 'Amsterdam');   --Budget <= 10.00 und somit abgelehnt.

                                            ---Aufgabe 3---

--- Query 1 --- Anzahl der dicken Buecher (> 200 Seiten) pro Autorin
SELECT * FROM Schriftstueck;
SELECT * FROM NumberOfLargeBooks;

--- Query 2 --- Transitivitaet von Alliasen
SELECT * FROM aka;
SELECT * FROM AllAliases;

--- Query 3 --- Wenn Roman X auf Y basiert und Y auf Z (mit selben Genres), dann basiert X ueber 2 Schritte auf Z
SELECT * FROM basiertAuf;
SELECT * FROM NovelDistance;

                                            ---Aufgabe 4---

--- Trigger 1 --- Autorin.GebDat < schrieb.StartDatum
INSERT INTO schrieb VALUES 
(10000, 18, '1800-10-11');  

INSERT INTO schrieb VALUES 
(10000, 18, '2000-10-11');  

--- Trigger 2 --- Budget ändert sich mit den Kosten, d.h. Budget = Budget - Kosten

SELECT name, Budget, KName, Kosten
FROM Verlag, wirbt, MarketingKanal
WHERE name = verlagsname AND kanal = kname
ORDER BY name;

UPDATE MarketingKanal SET Kosten = 1000 WHERE Kname = 'Goethe';
UPDATE MarketingKanal SET Kosten = 1500 WHERE Kname = 'Goethe';
UPDATE MarketingKanal SET Kosten = 0 WHERE Kname = 'Goethe';

UPDATE MarketingKanal SET Kosten = 25 WHERE Kname = 'Zeus';
UPDATE MarketingKanal SET Kosten = 25 WHERE Kname = 'Leibniz';

--- Trigger 3 --- Falls eine Zielgruppe eine Autorin liebt, dann liebt sie auch ihre Aliasse

SELECT zielgruppe, autorin, name
FROM zielgruppe, liebt, autorin
WHERE zielgruppe = bez AND autorin = aid
ORDER BY zielgruppe, autorin;

INSERT INTO liebt VALUES
('Cool kids', 10000),
('War veterans', 10021);

--- Trigger 4 --- Eine AutorIn erstellen
SELECT fCreateAutorin(6, 'Joanne Rowling', '1965-07-31');