create or replace TYPE airport_row IS OBJECT (
        FlightId    NUMBER(38, 0),
        source      VARCHAR2(128 BYTE),
        destination VARCHAR2(128 BYTE)
);
/
create or replace TYPE airport_table IS TABLE OF airport_row;
/
-- Функція, що повертає таблиці з інформацією
-- про будь-які рейси аеропорту за певний рік
CREATE OR REPLACE FUNCTION select_YearAiportInfo (
        aiport_city   VARCHAR2,
        airport_year  INTEGER
    ) RETURN airport_table
PIPELINED
IS
BEGIN
    for iter IN (
        SELECT
        FlightId,
        source,
        destination
        FROM Flight
        WHERE (source = aiport_city OR destination = aiport_city)
        AND EXTRACT(YEAR FROM dispatch) = airport_year
        AND EXTRACT(YEAR FROM arrival) = airport_year
    )
    LOOP
        PIPE ROW(iter);
    END LOOP;
END;
