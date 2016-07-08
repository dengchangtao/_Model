DELETE FROM computeddata WHERE time>'2010-10-01';
DELETE FROM nrwcomputeddata WHERE time>'2010-10-01';
DELETE FROM events WHERE date>'2010-10-01';
DELETE FROM leakageresults WHERE date>'2010-10-01';
DELETE FROM expensedata WHERE date>'2010-10-01';
UPDATE supplyzones SET actualleakage=0;
UPDATE supplyzones SET yearleakage=0;
UPDATE supplyzones SET reductionprice=0;
UPDATE supplyzones SET reduction_retperiod=0;
UPDATE supplyzones SET unitleak=0;
UPDATE supplyzones SET ell=0;
update supplyzones set minmin_weekavgmin=NULL;
update supplyzones set minmin_absolutmin=NULL;
update supplyzones set moving_avg_actual=NULL;
update supplyzones set moving_avg_diff1m=NULL;
update supplyzones set moving_avg_diff3m=NULL;
update supplyzones set moving_avg_diff6m=NULL;
update supplyzones set moving_avg_diff1y=NULL;

