--- Trigger 1 --- Autorin.GebDat < schrieb.StartDatum
CREATE OR REPLACE FUNCTION fCorrectDate() RETURNS TRIGGER AS $$
BEGIN
    IF(NEW.StartDatum <
       (SELECT GebDat 
        FROM Autorin
        WHERE AID = NEW.Autorin))
    THEN RAISE EXCEPTION 'Achtung! Der/Die AutorIn konnte das Werk nicht vor seiner/ihrer Geburt schreiben!';
    END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trCorrectDate BEFORE INSERT
    ON schrieb FOR EACH ROW EXECUTE PROCEDURE fCorrectDate();

--- Trigger 2 --- Budget ändert sich mit den Kosten, d.h. Budget = Budget - Kosten
CREATE OR REPLACE FUNCTION fUpdateBudget() RETURNS TRIGGER AS $$
DECLARE 
    emp RECORD;
BEGIN
    --Die Kosten stiegen und somit sinkt der Betrag des Budgets
    IF NEW.Kosten > OLD.Kosten THEN
        UPDATE Verlag
        SET Budget = Budget - ((SELECT SUM(Kosten)
                               FROM MarketingKanal
                               WHERE NEW.KName = KName) - (SELECT OLD.Kosten
                                                           FROM MarketingKanal
                                                           WHERE NEW.KName = KName))
        WHERE Name IN (SELECT Verlagsname
                       FROM wirbt, MarketingKanal 
                       WHERE Name = Verlagsname AND Kanal = KName AND NEW.KName = KName);

    --Die Kosten sind gesunken und somit erhoeht sich der Betrag des Budgets
    ELSIF NEW.Kosten < OLD.Kosten THEN 
        UPDATE Verlag
        SET Budget = Budget + ((SELECT OLD.Kosten
                               FROM MarketingKanal
                               WHERE NEW.KName = KName) - (SELECT SUM(Kosten)
                                                           FROM MarketingKanal
                                                           WHERE NEW.KName = KName))
        WHERE Name IN (SELECT Verlagsname
                       FROM wirbt, MarketingKanal 
                       WHERE Name = Verlagsname AND Kanal = KName AND NEW.KName = KName);
    
    --Die Kosten wurden auf den selben Wert wie zuvor gesetzt
    ELSE
        RAISE WARNING 'Kosten blieben gleich!';
    END IF;

    --Benachrichtigung ueber die Budgets, die aktualisiert wurden
    FOR emp IN (SELECT DISTINCT name, budget 
                FROM verlag, wirbt, MarketingKanal
                WHERE name = Verlagsname AND Kanal = KName AND KName = NEW.KName 
                ORDER BY name) LOOP
            RAISE NOTICE 'Neues Budget von %: %', emp.name, emp.budget;
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trUpdateBudget AFTER UPDATE 
    ON MarketingKanal FOR EACH ROW EXECUTE PROCEDURE fUpdateBudget();

--- Trigger 3 --- Falls eine Zielgruppe eine Autorin liebt, dann liebt sie auch ihre Aliasse
CREATE OR REPLACE FUNCTION fAutorinAdd() RETURNS TRIGGER AS $$
    DECLARE rec RECORD;
BEGIN
    FOR rec IN (SELECT aliasVon
                FROM aka
                WHERE NEW.Autorin = alias)
    LOOP

    --Wenn die neue Zielgruppe Z in der Relation nicht vorkommt
    IF NOT EXISTS(SELECT *
                  FROM liebt
                  WHERE Autorin = rec.aliasVon AND Zielgruppe = NEW.Zielgruppe)
    THEN
        INSERT INTO liebt VALUES(NEW.Zielgruppe, rec.aliasVon);
        END IF;
    END LOOP;

    RETURN NULL;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trAutorinAdd AFTER INSERT ON liebt
       FOR EACH ROW EXECUTE PROCEDURE fAutorinAdd();

--- Trigger 4 --- Eine neue Autorin automatisch anlegen
CREATE OR REPLACE FUNCTION fCreateAutorin(p_schriftstueck INTEGER,
                                         p_name VARCHAR(255),
                                         p_GebDat DATE) RETURNS void AS $$
DECLARE
    v_alias VARCHAR(255);
    v_vorname VARCHAR(255);
    v_nachname VARCHAR(255);
    v_autorin_aid INTEGER;
    v_alias_aid INTEGER;
    v_book VARCHAR(255);
    v_sid INTEGER;
    v_zaehler INTEGER := 0;
    rec RECORD;
BEGIN

    IF p_schriftstueck < 3 THEN
        RAISE WARNING 'Mindestens 3 Schriftstuecke von einem/einer AutorIn';
    END IF;

    INSERT INTO AutorIn(Name, GebDat) VALUES (p_name, p_GebDat);

    SELECT regexp_replace(p_name,'\s\S+','') INTO v_vorname FROM autorin WHERE p_name = name;       --Vorname
    SELECT regexp_replace(p_name,'.+[\s]','') INTO v_nachname FROM AutorIn WHERE p_name = name;     --Nachname
    v_alias := CONCAT(substr(v_vorname, 1, 1), '.', substr(v_nachname, 1, 1), '.');                 --Initiale

    INSERT INTO AutorIn(Name, GebDat) VALUES (v_alias, p_GebDat);

    
    --Vergessen Sie nicht die Alias Autorin mit der echten Autorin ueber die aka Beziehung in Verbindung zu setzen.

    SELECT AID INTO v_autorin_aid FROM Autorin WHERE Name = p_name;
    SELECT AID INTO v_alias_aid FROM AutorIn WHERE Name = v_alias;
    INSERT INTO aka VALUES (v_alias_aid, v_autorin_aid);

    FOR counter IN 1..p_schriftstueck LOOP

        IF(MOD(v_zaehler, 3) = 0) THEN                          --Roman
            v_book := CONCAT('Novel of ', v_alias);
            INSERT INTO Schriftstueck(Titel, Seiten) VALUES
                (v_book, floor(random() * 100)::int);
            
            SELECT SID INTO v_sid FROM Schriftstueck WHERE SID >= ALL(SELECT SID FROM Schriftstueck);
            INSERT INTO Roman VALUES (v_sid, 'Drama');

            INSERT INTO schrieb VALUES (v_alias_aid, v_sid, NOW());

        ELSIF(MOD(v_zaehler, 3) = 1) THEN                       --Lyrik
            v_book := CONCAT('Poetry of ', v_alias);
            INSERT INTO Schriftstueck(Titel, Seiten) VALUES
                (v_book, floor(random() * 100)::int);

            SELECT SID INTO v_sid FROM Schriftstueck WHERE SID >= ALL(SELECT SID FROM Schriftstueck);
            INSERT INTO Lyrik VALUES (v_sid);

            INSERT INTO schrieb VALUES (v_alias_aid, v_sid, NOW());

        ELSE                                                    --Sachbuch
            v_book := CONCAT('Non-fiction of ', v_alias);
            INSERT INTO Schriftstueck(Titel, Seiten) VALUES
                (v_book, floor(random() * 100)::int);
            
            SELECT SID INTO v_sid FROM Schriftstueck WHERE SID >= ALL(SELECT SID FROM Schriftstueck);
            INSERT INTO Sachbuch VALUES (v_sid);

            INSERT INTO schrieb VALUES (v_alias_aid, v_sid, NOW());

        END IF;

        v_zaehler := v_zaehler + 1;
    END LOOP;
END;
$$ LANGUAGE plpgsql;