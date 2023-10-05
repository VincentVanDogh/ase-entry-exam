BEGIN;

DELETE FROM aka;
DELETE FROM basiertAuf;
DELETE FROM hasst;
DELETE FROM liebt;
DELETE FROM interessiert;
DELETE FROM nutzt;
DELETE FROM ueber;
DELETE FROM wirbt;
DELETE FROM Zielgruppe;
DELETE FROM Zeitung;
DELETE FROM Social;
DELETE FROM MarketingKanal;
DELETE FROM Abteilung;
DELETE FROM Sonderedition;
DELETE FROM Auflage;
DELETE FROM Edition;
DELETE FROM Verlag;
DELETE FROM schrieb;
DELETE FROM Autorin;
DELETE FROM Lyrik;
DELETE FROM Roman;
DELETE FROM Sachbuch;
DELETE FROM Schriftstueck;

SELECT setval('seq_schriftstueck', 1, false);
SELECT setval('seq_autorin', 10000, false);

COMMIT;

INSERT INTO Schriftstueck(Titel, Seiten) VALUES
            --Sachbuch--
('Mathematik fuer Spieler', 172),                           --1
('Formale Modellierung fuer Juenglinge', 160),              --2
('Denkweisen von Bruedern', 432),                           --3
('Process der Programmierung', 175),                        --4
('Technische Grundlagen der Tuerme', 287),                  --5
             --Roman--
('Trainspotting', 344),                                     --6
('Der Spieler', 192),                                       --7
('Der Juengling', 484),                                     --8
('Die Brueder Karamasow', 840),                             --9
('Der Process', 208),                                       --10
('Die Verwandlung', 128),                                   --11
('Der Herr der Ringe - Die Gefaehrten', 608),               --12
('Der Herr der Ringe - Die zwei Tuerme', 510),              --13
('Der Herr der Ringe - Die Rueckkehr des Koenigs', 444),    --14
             --Lyrik--
('schtzngrmm', 1),                                          --15
('Grodek', 1),                                              --16
('Frosch-Haiku', 1),                                        --17
      --Extra fuer Trigger1--
('Das Silmarillion', 588),                                  --18
('Der Elephant verschwindet', 187),                         --19
('Old Boy', 416);                                           --20

INSERT INTO Sachbuch VALUES (1), (2), (3), (4), (5);

INSERT INTO Roman VALUES 
(6, 'Drama'), 
(7, 'Krimi'),
(8, 'Krimi'),
(9, 'Krimi'),
(10, 'Philosophie'),
(11, 'Drama'),
(12, 'Drama'), 
(13, 'Drama'), 
(14, 'Drama');

INSERT INTO Lyrik VALUES (15), (16), (17);

INSERT INTO ueber VALUES (1, 7), (2, 8), (3, 9), (4, 10), (5, 13);

INSERT INTO Autorin(Name, GebDat) VALUES
('Philipp Lahm', '1983-11-11'),
('Sunzi', '0544-01-01'),
('Edward Snowden', '1983-06-21'),
('Hans von Lehndorff', '1910-04-13'),
('Irvine Welsh', '1958-09-27'),
('Fjodor Michailowitsch Dostojewski', '1821-11-11'),
('Franz Kafka', '1883-07-03'),
('J.R.R. Tolkien', '1892-01-03'),
('Ernst Jandl', '1925-08-01'),
('Georg Trakl', '1887-02-03'),
('Matsuo Munefusa', '1644-01-01');

INSERT INTO schrieb VALUES
(10000, 1, '2003-11-11'),       --Lahm: Mathematik fuer Spieler
(10007, 2, '0564-01-01'),       --Sunzi: Formale Modellierung fuer Juenglinge
(10014, 3, '2003-06-21'),       --Snowden: Denkweisen von Bruedern
(10021, 4, '1930-04-13'),       --Lehndorff: Process der Programmierung
(10021, 5, '1940-04-13'),       --Lehndorff: Technische Grundlagen der Tuerme
(10028, 6, '1978-09-27'),       --Welsh: Trainspotting
(10035, 7, '1841-11-11'),       --Dostojewski: Der Spieler
(10035, 8, '1851-11-11'),       --Dostojewski: Der Juengling
(10035, 9, '1861-11-11'),       --Dostojewski: Brueder Karamasow
(10042, 10, '1903-07-03'),      --Kafka: Der Process
(10042, 11, '1913-07-03'),      --Kafka: Die Verwandlung
(10049, 12, '1912-01-03'),      --Tolkien: Herr der Ringe 1
(10049, 13, '1922-01-03'),      --Tolkien: Herr der Ringe 2
(10049, 14, '1932-01-03'),      --Tolkien: Herr der Ringe 3
(10056, 15, '1945-08-01'),      --Jandl: schtzngrmm
(10063, 16, '1907-02-03'),      --Trakl: Grodek
(10070, 17, '1664-01-01');      --Munefusa: Frosch-Haiku

BEGIN;

INSERT INTO Verlag VALUES 
('Karlchen Knack Verlag', 150.20, 'AA001', 'Ouagadougou'),
('Megabyte Knack Verlag', 1000000.00, 'Bz012', 'Muenchen'),
('Oma Knack Verlag', 2000.50, 'u1023', 'Graz'),
('Opa Knack Verlag', 75000.99, 'pL192', 'Springfield'),
('Schlabber Knack Verlag', 300.00, 'jh493', 'Seoul');

INSERT INTO Edition VALUES
(1, 1, 2011, 'Karlchen Knack Verlag', 2),
(2, 1, 1400, 'Karlchen Knack Verlag', 3),
(3, 1, 2019, 'Megabyte Knack Verlag', 4),
(4, 1, 1965, 'Oma Knack Verlag', 5),
(5, 1, 1983, 'Schlabber Knack Verlag', 6);

INSERT INTO Auflage VALUES 
(1, 1, 2, 'Donald Duck Druckerei'),
(2, 1, 3, 'Druck bei Hagrid'),
(3, 1, 4, 'Baumgartlinger Druck'),
(4, 1, 5, 'Wiedner Druck'),
(5, 1, 6, 'Amadeus Druck');

INSERT INTO Sonderedition VALUES
(1, 1, 'Grundbrechend'),
(3, 1, 'Wunderschoen'),
(4, 1, 'Atemberaubend');

INSERT INTO Abteilung VALUES
('Karlchen Knack Verlag', 'AA001', 'Ouagadougou'),
('Megabyte Knack Verlag', 'Bz012', 'Muenchen'),
('Oma Knack Verlag', 'u1023', 'Graz'),
('Opa Knack Verlag', 'pL192', 'Springfield'),
('Schlabber Knack Verlag', 'jh493', 'Seoul');

COMMIT;

INSERT INTO MarketingKanal VALUES 
('Zeus', 0),
('Leibniz', 0),
('Goethe', 0),
('Gauss', 0),
('Poisson', 0);

INSERT INTO Social VALUES
('Zeus', 'Facebook'),
('Leibniz', 'Twitter'),
('Goethe', 'Facebook'),
('Gauss', 'Twitter'),
('Poisson', 'Aurora');

INSERT INTO Zeitung VALUES
('Zeus', 1, 1),
('Zeus', 2, 5),
('Zeus', 3, 7),
('Leibniz', 7, 1),
('Goethe', 8, 1);

INSERT INTO Zielgruppe VALUES
('Cool kids', 'young'),
('Single parents', 'middle-aged'),
('War veterans', 'old'),
('Gamers', 'young'),
('Unemployed', 'middle-aged');

INSERT INTO wirbt VALUES
('Karlchen Knack Verlag', 'Zeus', 'Cool kids', '2015-03-15'),
('Karlchen Knack Verlag', 'Leibniz', 'Single parents', '2016-04-20'),
('Oma Knack Verlag', 'Goethe', 'War veterans', '2014-10-01'),
('Schlabber Knack Verlag', 'Zeus', 'Gamers', '2018-09-23'),
('Schlabber Knack Verlag', 'Poisson', 'Unemployed', '2017-11-05');

INSERT INTO nutzt VALUES
('Cool kids', 'Zeus'),
('Single parents', 'Leibniz'),
('Single parents', 'Goethe'),
('Gamers', 'Gauss'),
('Gamers', 'Poisson');

INSERT INTO interessiert VALUES
('Cool kids', 1),
('Single parents', 3),
('War veterans', 4),
('Gamers', 5),
('Unemployed', 8);

INSERT INTO liebt VALUES
--('Cool kids', 10000),
('Single parents', 10035),
--('War veterans', 10021),
('Gamers', 10042),
('Unemployed', 10042);

INSERT INTO hasst VALUES
('Cool kids', 10014),
('Single parents', 10028),
('War veterans', 10063),
('Gamers', 10056),
('Unemployed', 10049);

INSERT INTO aka VALUES
(10000, 10007),
(10007, 10014),
(10014, 10021),
(10021, 10028),
(10028, 10035);

INSERT INTO basiertAuf VALUES
(9, 8),
(8, 7),
(11, 10),
(14, 13),
(13, 12);