--new columns - support for computing ili & unit leak values
ALTER TABLE "LeakMonitorApp".leakageresults ADD COLUMN ili real;
ALTER TABLE "LeakMonitorApp".leakageresults ALTER COLUMN ili SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".leakageresults ADD COLUMN unitleak_length real;
ALTER TABLE "LeakMonitorApp".leakageresults ALTER COLUMN unitleak_length SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".leakageresults ADD COLUMN unitleak_serviceno real;
ALTER TABLE "LeakMonitorApp".leakageresults ALTER COLUMN unitleak_serviceno SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".leakageresults ADD COLUMN avginflow real;
ALTER TABLE "LeakMonitorApp".leakageresults ALTER COLUMN avginflow SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN unitleak_servicepipes real;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN unitleak_servicepipes SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN ili real;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN ili SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN avginflow real;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN avginflow SET STORAGE PLAIN;

--new columns - support for limits
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN limit_min_inflowts integer;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN limit_min_inflowts SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN limit_max_inflowts integer;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN limit_max_inflowts SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN limit_leak real;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN limit_leak SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN limit_movingavgleak real;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN limit_movingavgleak SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN limit_unitleak_length real;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN limit_unitleak_length SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN limit_unitleak_serviceno real;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN limit_unitleak_serviceno SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN limit_movingavg_diff1m real;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN limit_movingavg_diff1m SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN limit_movingavg_diff3m real;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN limit_movingavg_diff3m SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN limit_movingavg_diff6m real;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN limit_movingavg_diff6m SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN limit_movingavg_diff1y real;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN limit_movingavg_diff1y SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN limit_leak_ell_diff real;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN limit_ell_leak_diff SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN limit_tstype integer;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN limit_tstype SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN limit_tstype SET DEFAULT 0;
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN limit_returnperiod real;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN limit_returnperiod SET STORAGE PLAIN;
ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN limit_avginflow real;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN limit_avginflow SET STORAGE PLAIN;

--set values to new attribute
UPDATE "LeakMonitorApp".supplyzones SET limit_tstype=1 WHERE id=-1;
UPDATE "LeakMonitorApp".supplyzones SET limit_tstype=0 WHERE id>-1;
      
--edited columns - support for time part of events
ALTER TABLE "LeakMonitorApp".events ALTER COLUMN "date" type timestamp without time zone;

--new table limit_tstype & fill data
CREATE TABLE "LeakMonitorApp".limit_tstype
(
  id integer NOT NULL,
  "name" text,
  CONSTRAINT pk_limit_tstype_id PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "LeakMonitorApp".limit_tstype OWNER TO "LeakMonitorApp";
INSERT INTO "LeakMonitorApp".limit_tstype (id, name) VALUES (0, 'Default');
INSERT INTO "LeakMonitorApp".limit_tstype (id, name) VALUES (1, 'Consumption only');
INSERT INTO "LeakMonitorApp".limit_tstype (id, name) VALUES (2, 'Consumption with leakage');

--new events
INSERT INTO "LeakMonitorApp".eventtype (id, eventname) VALUES (8, 'LIMIT_DMAINFLOW_BELOW_%');
INSERT INTO "LeakMonitorApp".eventtype (id, eventname) VALUES (9, 'LIMIT_DMAINFLOW_ABOVE_%');
INSERT INTO "LeakMonitorApp".eventtype (id, eventname) VALUES (10, 'LIMIT_LEAK_ABOVE_%');
INSERT INTO "LeakMonitorApp".eventtype (id, eventname) VALUES (11, 'LIMIT_MOVINGAVG_ABOVE_%');
INSERT INTO "LeakMonitorApp".eventtype (id, eventname) VALUES (12, 'LIMIT_UNIT_LENGTH_ABOVE_%');
INSERT INTO "LeakMonitorApp".eventtype (id, eventname) VALUES (13, 'LIMIT_UNIT_SERVICEPIPES_ABOVE_%');
INSERT INTO "LeakMonitorApp".eventtype (id, eventname) VALUES (14, 'LIMIT_MOVINGAVG_DIFF1M_ABOVE_%');
INSERT INTO "LeakMonitorApp".eventtype (id, eventname) VALUES (15, 'LIMIT_MOVINGAVG_DIFF3M_ABOVE_%');
INSERT INTO "LeakMonitorApp".eventtype (id, eventname) VALUES (16, 'LIMIT_MOVINGAVG_DIFF6M_ABOVE_%');
INSERT INTO "LeakMonitorApp".eventtype (id, eventname) VALUES (17, 'LIMIT_MOVINGAVG_DIFF1Y_ABOVE_%');
INSERT INTO "LeakMonitorApp".eventtype (id, eventname) VALUES (18, 'LIMIT_LEAK_ELL_DIFF_ABOVE_%');
INSERT INTO "LeakMonitorApp".eventtype (id, eventname) VALUES (19, 'LIMIT_RETURNPERIOD_BELOW_%');
INSERT INTO "LeakMonitorApp".eventtype (id, eventname) VALUES (20, 'LIMIT_AVGINFLOW_ABOVE_%');

--new foreign key
ALTER TABLE "LeakMonitorApp".supplyzones
  ADD CONSTRAINT fk_supplyzones_limittstype FOREIGN KEY (limit_tstype)
      REFERENCES "LeakMonitorApp".limit_tstype (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;
