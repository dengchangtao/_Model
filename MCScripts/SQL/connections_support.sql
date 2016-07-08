CREATE TABLE connections (
    id integer NOT NULL,
    name text NOT NULL,
    connection_type_id integer DEFAULT 1 NOT NULL,
    connection_string text,
    loginuser text,
    loginpassword text,
    specific_file_path text
);
COMMENT ON COLUMN connections.specific_file_path IS 'Path to file with specific parameters';
CREATE TABLE connectiontype (
    id integer NOT NULL,
    name text NOT NULL
);
CREATE TABLE importtemp (
    id integer NOT NULL,
    "time" timestamp without time zone,
    value real
);
ALTER TABLE ONLY connections
    ADD CONSTRAINT pk_connections_id PRIMARY KEY (id);
ALTER TABLE ONLY connectiontype
    ADD CONSTRAINT pk_connectiontype_id PRIMARY KEY (id);
ALTER TABLE ONLY connections
    ADD CONSTRAINT fk_connections_connectiontype FOREIGN KEY (connection_type_id) REFERENCES connectiontype(id);


ALTER TABLE sensors_scada ADD channel integer DEFAULT 1 NOT NULL;
ALTER TABLE sensors_scada MODIFY connectionid integer NOT NULL;

INSERT INTO connectiontype (id,name) VALUES (1,'ORACLE Server');
INSERT INTO connectiontype (id,name) VALUES (2,'MS SQL Server');
INSERT INTO connectiontype (id,name) VALUES (3,'SEBA Data File');
INSERT INTO connections (id,name,connection_type_id,connection_string,loginuser,loginpassword) VALUES (1,'Default MSSQL',2,'EDIT THIS !!!','EDIT THIS !!!','EDIT THIS !!!');
UPDATE sensors_scada SET channel=1;

COMMENT ON COLUMN sensors_scada.channel IS 'Channel number - used for definition of timeserie in file with more timeseries (one-based indexing)';

