-- Table: "LeakMonitorApp".sensors_scada_multiplicator
-- DROP TABLE "LeakMonitorApp".sensors_scada_multiplicator;
CREATE TABLE "LeakMonitorApp".sensors_scada_multiplicator
(
  id serial NOT NULL,
  multiplicatorname text NOT NULL,
  CONSTRAINT pk_sensorsscadamultiplicator PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "LeakMonitorApp".sensors_scada_multiplicator
  OWNER TO "LeakMonitorApp";
COMMENT ON TABLE "LeakMonitorApp".sensors_scada_multiplicator
  IS 'Multipolicator coefficients which can be used for importing of data for accumulated value sensors.';

  
-- Table: "LeakMonitorApp".sensors_scada_multiplicator_data
-- DROP TABLE "LeakMonitorApp".sensors_scada_multiplicator_data;
CREATE TABLE "LeakMonitorApp".sensors_scada_multiplicator_data
(
  mult_id integer NOT NULL,
  coeff_h real NOT NULL,
  coeff_m real NOT NULL,
  CONSTRAINT pk_sensors_scada_multiplicator_data PRIMARY KEY (mult_id, coeff_h),
  CONSTRAINT fk_sensorsscadamultiplicator_dataid FOREIGN KEY (mult_id)
      REFERENCES "LeakMonitorApp".sensors_scada_multiplicator (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
  OIDS=FALSE
);
ALTER TABLE "LeakMonitorApp".sensors_scada_multiplicator_data
  OWNER TO "LeakMonitorApp";
COMMENT ON TABLE "LeakMonitorApp".sensors_scada_multiplicator_data
  IS 'Multipolicator coefficients which can be used for importing of data for accumulated value sensors.';

  
-- Column: import_mult_id
-- ALTER TABLE "LeakMonitorApp".sensors_scada DROP COLUMN import_mult_id;
ALTER TABLE "LeakMonitorApp".sensors_scada ADD COLUMN import_mult_id integer;
COMMENT ON COLUMN "LeakMonitorApp".sensors_scada.import_mult_id IS 'ID from multiplicator table';

-- Foreign Key: "LeakMonitorApp".fk_sensormulriplicator
-- ALTER TABLE "LeakMonitorApp".sensors_scada DROP CONSTRAINT fk_sensormulriplicator;
ALTER TABLE "LeakMonitorApp".sensors_scada
  ADD CONSTRAINT fk_sensormulriplicator FOREIGN KEY (import_mult_id)
      REFERENCES "LeakMonitorApp".sensors_scada_multiplicator (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;

INSERT INTO "LeakMonitorApp".sensors_scada_types VALUES (4, 'accumulated state value dependent coeff'); 
ALTER TABLE "LeakMonitorApp".measureddata DROP CONSTRAINT fk_flagid;
