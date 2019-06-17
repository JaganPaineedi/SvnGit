-- Update stat. for MeaningfulUseMeasureTargets set Target=50
-- Harbor - Support, #1498 - MU: eRX CMS Measure
update MeaningfulUseMeasureTargets
set Target=50
where MeasureType=8683 and Stage=9373
and isnull(RecordDeleted,'N')='N'