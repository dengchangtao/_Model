ALTER TABLE "LeakMonitorApp".supplyzones ADD COLUMN forcecompute boolean;
ALTER TABLE "LeakMonitorApp".supplyzones ALTER COLUMN forcecompute SET DEFAULT false;
COMMENT ON COLUMN "LeakMonitorApp".supplyzones.forcecompute IS 'use this to force compute - ignore missing data etc.';
