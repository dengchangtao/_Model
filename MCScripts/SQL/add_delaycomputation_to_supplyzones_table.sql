ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN delaycomputation interval;
COMMENT ON COLUMN "LeakMonitorApp".supplyzones.delaycomputation IS 'delay of computation';
