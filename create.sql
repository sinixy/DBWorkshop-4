CREATE TABLE arrival (
    arrival TIMESTAMP NOT NULL
);

ALTER TABLE arrival ADD CONSTRAINT arrival_pk PRIMARY KEY ( arrival );

CREATE TABLE destination (
    destination VARCHAR2(128) NOT NULL
);

ALTER TABLE destination ADD CONSTRAINT destination_pk PRIMARY KEY ( destination );

CREATE TABLE dispatch (
    dispatch TIMESTAMP NOT NULL
);

ALTER TABLE dispatch ADD CONSTRAINT dispatch_pk PRIMARY KEY ( dispatch );

CREATE TABLE flight (
    flightid     INTEGER NOT NULL,
    source       VARCHAR2(128) NOT NULL,
    destination  VARCHAR2(128) NOT NULL,
    dispatch     TIMESTAMP NOT NULL,
    arrival      TIMESTAMP NOT NULL
);

ALTER TABLE flight ADD CONSTRAINT flight_pk PRIMARY KEY ( flightid );

CREATE TABLE period (
    dispatch  TIMESTAMP NOT NULL,
    arrival   TIMESTAMP NOT NULL
);

ALTER TABLE period ADD CONSTRAINT period_pk PRIMARY KEY ( dispatch,
                                                          arrival );

CREATE TABLE source (
    source VARCHAR2(128) NOT NULL
);

ALTER TABLE source ADD CONSTRAINT source_pk PRIMARY KEY ( source );

CREATE TABLE sourcedest (
    source       VARCHAR2(128) NOT NULL,
    destination  VARCHAR2(128) NOT NULL
);

ALTER TABLE sourcedest ADD CONSTRAINT sourcedest_pk PRIMARY KEY ( source,
                                                                  destination );

ALTER TABLE flight
    ADD CONSTRAINT flight_period_fk FOREIGN KEY ( dispatch,
                                                  arrival )
        REFERENCES period ( dispatch,
                            arrival );

ALTER TABLE flight
    ADD CONSTRAINT flight_sourcedest_fk FOREIGN KEY ( source,
                                                      destination )
        REFERENCES sourcedest ( source,
                                destination );

ALTER TABLE period
    ADD CONSTRAINT period_arrival_fk FOREIGN KEY ( arrival )
        REFERENCES arrival ( arrival );

ALTER TABLE period
    ADD CONSTRAINT period_dispatch_fk FOREIGN KEY ( dispatch )
        REFERENCES dispatch ( dispatch );

ALTER TABLE sourcedest
    ADD CONSTRAINT sourcedest_destination_fk FOREIGN KEY ( destination )
        REFERENCES destination ( destination );

ALTER TABLE sourcedest
    ADD CONSTRAINT sourcedest_source_fk FOREIGN KEY ( source )
        REFERENCES source ( source );