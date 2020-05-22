CREATE OR REPLACE TRIGGER check_sourcedest
BEFORE INSERT
    ON SourceDest
    FOR EACH ROW
BEGIN
    IF (:new.source = :new.destination) THEN
        RAISE_APPLICATION_ERROR(-20000, 'Destination and source airports cannot be the same!');
    END IF;
END;