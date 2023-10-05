CREATE SEQUENCE seq_schriftstueck;
CREATE SEQUENCE seq_autorin INCREMENT BY 7 MINVALUE 10000 NO CYCLE;
CREATE TYPE ZIELGRUPPEALTER AS ENUM ('young', 'middle-aged', 'old');

CREATE TABLE Schriftstueck (
    SID INTEGER PRIMARY KEY DEFAULT nextval('seq_schriftstueck'),
    Titel VARCHAR(255) NOT NULL,
    Seiten INTEGER NOT NULL
);

CREATE TABLE Sachbuch (
    SID INTEGER PRIMARY KEY REFERENCES Schriftstueck (SID)
);

CREATE TABLE Roman (
    SID INTEGER PRIMARY KEY REFERENCES Schriftstueck (SID),
    Genre VARCHAR(255) NOT NULL
);

CREATE TABLE Lyrik (
    SID INTEGER PRIMARY KEY REFERENCES Schriftstueck (SID)
);

CREATE TABLE ueber (
    Sachbuch INTEGER REFERENCES Sachbuch (SID),
    Roman INTEGER REFERENCES Roman (SID),
    PRIMARY KEY (Sachbuch, Roman)
);

CREATE TABLE Autorin (
    AID INTEGER PRIMARY KEY DEFAULT nextval('seq_autorin'),
    Name VARCHAR(255) NOT NULL,
    GebDat DATE NOT NULL
);

CREATE TABLE schrieb (
    Autorin INTEGER REFERENCES Autorin (AID),
    Schriftstueck INTEGER REFERENCES Schriftstueck (SID),
    StartDatum DATE NOT NULL,
    PRIMARY KEY (Autorin, Schriftstueck)
);

CREATE TABLE Verlag (
    Name VARCHAR(255) PRIMARY KEY,
    Budget NUMERIC(9, 2) NOT NULL CHECK (Budget >= 10.00 AND Budget <= 1000000.00),
    Hauptbereich VARCHAR(5) CHECK (Hauptbereich ~ '^[A-Z+a-z+0-9]{2}[0-9]{3}$'),
    Hauptstadt VARCHAR(255)
);

CREATE TABLE Edition (
    Schriftstueck INTEGER REFERENCES Schriftstueck (SID),
    EDNR INTEGER,
    Jahr INTEGER NOT NULL CHECK (Jahr >= 1400),
    Verlagsname VARCHAR(255) NOT NULL REFERENCES Verlag (Name),
    EditionANR INTEGER NOT NULL,
    PRIMARY KEY (Schriftstueck, EDNR)
);

CREATE TABLE Auflage (
    Schriftstueck INTEGER,
    EDNR INTEGER,
    ANR INTEGER,
    Druckerei VARCHAR(255) NOT NULL,
    FOREIGN KEY (Schriftstueck, EDNR) REFERENCES Edition (Schriftstueck, EDNR),
    PRIMARY KEY (Schriftstueck, EDNR, ANR)
);

CREATE TABLE Sonderedition (
    Schriftstueck INTEGER NOT NULL,
    EDNR INTEGER NOT NULL,
    Anlass VARCHAR(255),
    FOREIGN KEY (Schriftstueck, EDNR) REFERENCES Edition (Schriftstueck, EDNR),
    PRIMARY KEY (Schriftstueck, EDNR)
);

CREATE TABLE Abteilung (
    Verlagsname VARCHAR(255) REFERENCES Verlag (Name),
    Bereich VARCHAR(5) CHECK(Bereich ~ '^[A-Z+a-z+0-9]{2}[0-9]{3}$'),
    Stadt VARCHAR(255),
    PRIMARY KEY (Verlagsname, Bereich, Stadt)
);

CREATE TABLE MarketingKanal (
    KName VARCHAR(255) PRIMARY KEY,
    Kosten NUMERIC
);

CREATE TABLE Social (
    Kanal VARCHAR(255) PRIMARY KEY REFERENCES MarketingKanal (KName),
    Platform VARCHAR(255) NOT NULL
);

CREATE TABLE Zeitung (
    Kanal VARCHAR(255) REFERENCES MarketingKanal (KName),
    Schriftstueck INTEGER REFERENCES Schriftstueck (SID),
    Auflage INTEGER NOT NULL,
    PRIMARY KEY (Kanal, Schriftstueck)
);

CREATE TABLE Zielgruppe (
    Bez VARCHAR(255) PRIMARY KEY,
    AGruppe ZIELGRUPPEALTER
);

CREATE TABLE wirbt (
    Verlagsname VARCHAR(255) REFERENCES Verlag (Name),
    Kanal VARCHAR(255) REFERENCES MarketingKanal (KName),
    Zielgruppe VARCHAR(255) REFERENCES Zielgruppe (Bez),
    Datum DATE,
    PRIMARY KEY (Verlagsname, Kanal, Zielgruppe),
    UNIQUE (Verlagsname, Datum)
);

CREATE TABLE nutzt (
    Zielgruppe VARCHAR(255) REFERENCES Zielgruppe (Bez),
    SocialKanal VARCHAR(255) REFERENCES Social (Kanal),
    PRIMARY KEY (Zielgruppe, SocialKanal)
);

CREATE TABLE interessiert ( 
    Zielgruppe VARCHAR(255) REFERENCES Zielgruppe (Bez),
    Schriftstueck INTEGER REFERENCES Schriftstueck (SID),
    PRIMARY KEY (Zielgruppe, Schriftstueck)
);

CREATE TABLE liebt (
    Zielgruppe VARCHAR(255) REFERENCES Zielgruppe (Bez),
    Autorin INTEGER REFERENCES Autorin (AID),
    PRIMARY KEY (Zielgruppe, Autorin)
);

CREATE TABLE hasst (
    Zielgruppe VARCHAR(255) REFERENCES Zielgruppe (Bez),
    Autorin INTEGER REFERENCES Autorin (AID),
    PRIMARY KEY (Zielgruppe, Autorin)
);

CREATE TABLE aka (
    alias INTEGER REFERENCES Autorin (AID),
    aliasVon INTEGER REFERENCES Autorin (AID),
    PRIMARY KEY (alias, aliasVon)
);

CREATE TABLE basiertAuf (
    neu INTEGER REFERENCES Roman (SID),
    alt INTEGER REFERENCES Roman (SID),
    PRIMARY KEY (neu, alt)
);

--(a) Jeder Verlag hat eine Hauptabteilung
ALTER TABLE Verlag ADD CONSTRAINT fk_Hauptabteilung 
FOREIGN KEY (Name, Hauptbereich, Hauptstadt) REFERENCES Abteilung (Verlagsname, Bereich, Stadt) 
DEFERRABLE INITIALLY DEFERRED;

--(a) Jede Edition hat eine Erstauflage
ALTER TABLE Edition ADD CONSTRAINT fk_Erstauflage 
FOREIGN KEY (Schriftstueck, EDNR, EditionANR) REFERENCES Auflage (Schriftstueck, EDNR, ANR) 
DEFERRABLE INITIALLY DEFERRED;