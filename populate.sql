INSERT INTO Source(source)
VALUES('London');
INSERT INTO Source(source)
VALUES('Kyiv');
INSERT INTO Source(source)
VALUES('New York');

INSERT INTO Destination(destination)
VALUES('Vienna');
INSERT INTO Destination(destination)
VALUES('Tokyo');
INSERT INTO Destination(destination)
VALUES('Berlin');

INSERT INTO SourceDest(source, destination)
VALUES('London', 'Vienna');
INSERT INTO SourceDest(source, destination)
VALUES('Kyiv', 'Tokyo');
INSERT INTO SourceDest(source, destination)
VALUES('New York', 'Berlin');

ALTER SESSION SET nls_timestamp_format = 'YYYY-MM-DD HH24:MI:SS.FF';
INSERT INTO Dispatch(dispatch)
VALUES('2016-01-07 00:34:00');
INSERT INTO Dispatch(dispatch)
VALUES('2016-10-03 13:53:00');
INSERT INTO Dispatch(dispatch)
VALUES('2018-02-19 19:36:00');

INSERT INTO Arrival(arrival)
VALUES('2016-01-07 04:30:00');
INSERT INTO Arrival(arrival)
VALUES('2016-10-03 21:20:00');
INSERT INTO Arrival(arrival)
VALUES('2018-02-20 02:30:00');

INSERT INTO Period(dispatch, arrival)
VALUES('2016-01-07 00:34:00', '2016-01-07 04:30:00');
INSERT INTO Period(dispatch, arrival)
VALUES('2016-10-03 13:53:00', '2016-10-03 21:20:00');
INSERT INTO Period(dispatch, arrival)
VALUES('2018-02-19 19:36:00', '2018-02-20 02:30:00');

INSERT INTO Flight(FlightId, source, destination, dispatch, arrival)
VALUES(123, 'London', 'Vienna', '2016-01-07 00:34:00', '2016-01-07 04:30:00');
INSERT INTO Flight(FlightId, source, destination, dispatch, arrival)
VALUES(1, 'Kyiv', 'Tokyo', '2016-10-03 13:53:00', '2016-10-03 21:20:00');
INSERT INTO Flight(FlightId, source, destination, dispatch, arrival)
VALUES(53, 'New York', 'Berlin', '2018-02-19 19:36:00', '2018-02-20 02:30:00');