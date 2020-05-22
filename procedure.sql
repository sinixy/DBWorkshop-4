create or replace PROCEDURE update_arrival(
    flight              NUMBER,
    arrival_date        Timestamp,
    destination_airport VARCHAR
) AS
    flight_status       NUMBER;
    destination_status  NUMBER;
    old_arrival_date    Timestamp;
    dispatch_date       Timestamp;
    missing_data        EXCEPTION;

BEGIN
    SELECT COUNT(*)
    INTO flight_status
    FROM Flight
    WHERE FlightId = flight;

    SELECT COUNT(*)
    INTO destination_status
    FROM Flight
    WHERE destination = destination_airport;
    
    IF (flight_status = 1) AND (destination_status = 1) THEN
        SELECT dispatch, arrival
        INTO dispatch_date, old_arrival_date
        FROM Flight
        WHERE FlightId = flight;
    
        execute immediate 'alter table flight disable constraint FLIGHT_PERIOD_FK';
        execute immediate 'alter table period disable constraint PERIOD_ARRIVAL_FK';
        UPDATE Arrival
        SET arrival = arrival_date
        WHERE arrival = old_arrival_date;
        
        UPDATE Period
        SET arrival = arrival_date
        WHERE dispatch = dispatch_date AND arrival = old_arrival_date;
        
        UPDATE Flight
        SET arrival = arrival_date
        WHERE FlightId = Flight;
        execute immediate 'alter table flight enable constraint FLIGHT_PERIOD_FK';
        execute immediate 'alter table period enable constraint PERIOD_ARRIVAL_FK';
    ELSE
        RAISE missing_data;
    END IF;
EXCEPTION
    WHEN missing_data THEN
        dbms_output.put_line('No such flight or destination airport!');
END;