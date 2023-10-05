DROP TRIGGER trCorrectDate ON schrieb;
DROP TRIGGER trUpdateBudget ON MarketingKanal;
DROP TRIGGER trAutorinAdd ON liebt;

DROP FUNCTION fCorrectDate();
DROP FUNCTION fUpdateBudget();
DROP FUNCTION fAutorinAdd();
DROP FUNCTION fCreateAutorin(INTEGER, VARCHAR, DATE);

DROP VIEW NumberOfLargeBooks;
DROP VIEW AllAliases;
DROP VIEW NovelDistance;

ALTER TABLE Verlag DROP CONSTRAINT fk_Hauptabteilung;
ALTER TABLE Edition DROP CONSTRAINT fk_Erstauflage;

DROP TABLE aka;
DROP TABLE basiertAuf;
DROP TABLE hasst;
DROP TABLE liebt;
DROP TABLE interessiert;
DROP TABLE nutzt;
DROP TABLE ueber;
DROP TABLE wirbt;
DROP TABLE Zielgruppe;
DROP TABLE Zeitung;
DROP TABLE Social;
DROP TABLE MarketingKanal;
DROP TABLE Abteilung;
DROP TABLE Sonderedition;
DROP TABLE Auflage;
DROP TABLE Edition;
DROP TABLE Verlag;
DROP TABLE schrieb;
DROP TABLE Autorin;
DROP TABLE Lyrik;
DROP TABLE Roman;
DROP TABLE Sachbuch;
DROP TABLE Schriftstueck;

DROP TYPE ZIELGRUPPEALTER;

DROP SEQUENCE seq_autorin;
DROP SEQUENCE seq_schriftstueck;