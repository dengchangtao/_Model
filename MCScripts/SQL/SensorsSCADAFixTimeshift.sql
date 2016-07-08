ALTER TABLE sensors_scada DROP COLUMN import_timeshift;
ALTER TABLE sensors_scada ADD import_timeshift_min double precision DEFAULT 0;
