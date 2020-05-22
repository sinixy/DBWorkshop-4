CREATE OR REPLACE PACKAGE info_pkg IS
    TYPE airport_row IS RECORD (
        FlightId    FLIGHT.FlightId%TYPE,
        source      FLIGHT.source%TYPE,
        destination FLIGHT.destination%TYPE
    );
    TYPE airport_table IS TABLE OF airport_row;

    FUNCTION select_YearAiportInfo (
        aiport_city   VARCHAR2,
        airport_year  INTEGER
    ) RETURN airport_table
	PIPELINED;

    PROCEDURE update_arrival(
		flight              NUMBER,
		arrival_date        Timestamp,
		destination_airport VARCHAR
	);
END info_pkg;
/
CREATE OR REPLACE PACKAGE BODY info_pkg IS
	FUNCTION select_YearAiportInfo (
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

	PROCEDURE update_arrival(
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
END;
