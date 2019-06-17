--insert/Update script for Targets
-- 14-Nov-2018  Gautam   What: Added code to include Lab and Radiology for MU Stage2 modified.
--              Meaningful Use - Environment Issues Tracking > Tasks#5 > Stage 2 Modified Report - Non-Face to Face services counted in denominator counts  

IF EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8680 and MeasureSubType=6177 and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      update MeaningfulUseMeasureTargets
      set [Target]= 60
      WHERE  MeasureType=8680 and MeasureSubType=6177 and 
					Stage=9373 and isnull(RecordDeleted,'N')='N'
  END 
  			
					
  IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8680 and MeasureSubType=6178 and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8680,6178,9373,30,'CPOE') 
               
  END
  
    IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8680 and MeasureSubType=6179 and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8680,6179,9373,30,'CPOE') 
               
  END