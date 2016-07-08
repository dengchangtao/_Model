ALTER TABLE "LeakMonitorApp".sensorfails ADD COLUMN have_data boolean;
ALTER TABLE "LeakMonitorApp".sensorfails ALTER COLUMN have_data SET DEFAULT false;
COMMENT ON COLUMN "LeakMonitorApp".sensorfails.have_data IS 'if true then sensorfail ended';