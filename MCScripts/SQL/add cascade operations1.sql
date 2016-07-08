-- Foreign Key: "LeakMonitorApp".fk_dma_id
-- ALTER TABLE "LeakMonitorApp".computationmap DROP CONSTRAINT fk_dma_id;
ALTER TABLE "LeakMonitorApp".computationmap
  ADD CONSTRAINT fk_dma_id FOREIGN KEY (dma_id)
      REFERENCES "LeakMonitorApp".supplyzones (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;

-- Foreign Key: "LeakMonitorApp".fk_dma_id
-- ALTER TABLE "LeakMonitorApp".computeddata DROP CONSTRAINT fk_dma_id;
ALTER TABLE "LeakMonitorApp".computeddata
  ADD CONSTRAINT fk_dma_id FOREIGN KEY (timeserieid)
      REFERENCES "LeakMonitorApp".supplyzones (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;
	  