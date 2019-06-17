-- MeaningfulUseMeasureTargets script for Stage2 Modified
-- why : Meaningful Use, Task	#66 - Stage 2 - Modified   
--	Gautam		5th Jan 2016

  
  IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8682  and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8682,null,9373,80,'Problem List') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=80,DisplayWidgetNameAs='Problem List'
      WHERE  MeasureType=8682 and Stage=9373 --Satge2 Modified
  END 
  
 

  --Stage2
  
  IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8680 and MeasureSubType=6177 and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8680,6177,9373,30,'CPOE') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=30,DisplayWidgetNameAs='CPOE'
      WHERE  MeasureType=8680 and MeasureSubType=6177 and Stage=9373 --Satge2 Modified
  END 
  
 
  IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8683  and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8683,null,9373,40,'e-Prescribing') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=40,DisplayWidgetNameAs='e-Prescribing'
      WHERE  MeasureType=8683 and Stage=9373 --Satge2
  END
  
IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8686  and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8686,null,9373,80,'Demographics') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=80,DisplayWidgetNameAs='Demographics'
      WHERE  MeasureType=8686 and Stage=9373 --Satge2
  END

IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8687  and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8687,null,9373,80,'Vitals') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=80,DisplayWidgetNameAs='Vitals'
      WHERE  MeasureType=8687 and Stage=9373 --Satge2
  END	

IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8688  and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8688,null,9373,80,'Smoking Status') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=80,DisplayWidgetNameAs='Smoking Status'
      WHERE  MeasureType=8688 and Stage=9373 --Satge2
  END	

IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8694  and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8694,null,9373,55,'Lab Results') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=55,DisplayWidgetNameAs='Lab Results'
      WHERE  MeasureType=8694 and Stage=9373 --Satge2
  END  


  IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8697  and MeasureSubType=6211 and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8697,6211,9373,50,'Patient Portal') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=50,DisplayWidgetNameAs='Patient Portal'
      WHERE  MeasureType=8697 and MeasureSubType=6211 and Stage=9373 --Satge2
  END 
  
IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8697  and MeasureSubType=6212 and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8697,6212,9373,.01,'Patient Portal') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=.01,DisplayWidgetNameAs='Patient Portal'
      WHERE  MeasureType=8697 and MeasureSubType=6212 and Stage=9373 --Satge2
  END 
  
  IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8698  and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8698,null,9373,10,'Patient Education') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=10,DisplayWidgetNameAs='Patient Education'
      WHERE  MeasureType=8698 and Stage=9373 --Satge2
  END 
  
  IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8699  and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8699,null,9373,50,'Medication Reconciliation') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=50,DisplayWidgetNameAs='Medication Reconciliation'
      WHERE  MeasureType=8699 and Stage=9373 --Satge2
  END 

      
--  IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8700  and MeasureSubType=6213 and 
--					Stage=9373 and isnull(RecordDeleted,'N')='N') 
--  BEGIN 
      
--      INSERT INTO MeaningfulUseMeasureTargets 
--                  (MeasureType,
--					MeasureSubType ,
--					Stage,
--					[Target],
--					DisplayWidgetNameAs) 
--      VALUES     (8700,6213,9373,50,'Health Information Exchange') -- change name from Summary of care to Health Information Exchange’
               
--  END 
--ELSE 
--  BEGIN 
--      UPDATE MeaningfulUseMeasureTargets 
--      SET    [Target]=50,DisplayWidgetNameAs='Health Information Exchange'
--      WHERE  MeasureType=8700 and MeasureSubType=6213 and Stage=9373 --Satge2
  --END 
  
 IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8700  and MeasureSubType=6214 and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8700,6214,9373,10,'Health Information Exchange') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=10,DisplayWidgetNameAs='Health Information Exchange'
      WHERE  MeasureType=8700 and MeasureSubType=6214 and Stage=9373 --Satge2
  END 
  
IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8703  and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8703,null,9373,5,'Secure Messages') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=5,DisplayWidgetNameAs='Secure Messages'
      WHERE  MeasureType=8703 and Stage=9373 --Satge2
  END 
 
-- IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8704  and 
--					Stage=9373 and isnull(RecordDeleted,'N')='N') 
--  BEGIN 
      
--      INSERT INTO MeaningfulUseMeasureTargets 
--                  (MeasureType,
--					MeasureSubType ,
--					Stage,
--					[Target],
--					DisplayWidgetNameAs) 
--      VALUES     (8704,null,9373,30,'Service Notes') 
               
--  END 
--ELSE 
--  BEGIN 
--      UPDATE MeaningfulUseMeasureTargets 
--      SET    [Target]=30,DisplayWidgetNameAs='Service Notes'
--      WHERE  MeasureType=8704 and Stage=9373 --Satge2
--  END 
  
--IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8705  and 
--					Stage=9373 and isnull(RecordDeleted,'N')='N') 
--  BEGIN 
      
--      INSERT INTO MeaningfulUseMeasureTargets 
--                  (MeasureType,
--					MeasureSubType ,
--					Stage,
--					[Target],
--					DisplayWidgetNameAs) 
--      VALUES     (8705,null,9373,10,'Imaging Results') 
               
--  END 
--ELSE 
--  BEGIN 
--      UPDATE MeaningfulUseMeasureTargets 
--      SET    [Target]=10,DisplayWidgetNameAs='Imaging Results'
--      WHERE  MeasureType=8705 and Stage=9373 --Satge2
--  END 
  
--IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8706  and 
--					Stage=9373 and isnull(RecordDeleted,'N')='N') 
--  BEGIN 
      
--      INSERT INTO MeaningfulUseMeasureTargets 
--                  (MeasureType,
--					MeasureSubType ,
--					Stage,
--					[Target],
--					DisplayWidgetNameAs) 
--      VALUES     (8706,null,9373,20,'Family Health History') 
               
--  END 
--ELSE 
--  BEGIN 
--      UPDATE MeaningfulUseMeasureTargets 
--      SET    [Target]=20,DisplayWidgetNameAs='Family Health History'
--      WHERE  MeasureType=8706 and Stage=9373 --Satge2
--  END 
  
--  IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8706  and 
--					Stage=8767 and isnull(RecordDeleted,'N')='N') 
--  BEGIN 
      
--      INSERT INTO MeaningfulUseMeasureTargets 
--                  (MeasureType,
--					MeasureSubType ,
--					Stage,
--					[Target],
--					DisplayWidgetNameAs) 
--      VALUES     (8706,null,8767,20,'Family Health History') 
               
--  END 
--ELSE 
--  BEGIN 
--      UPDATE MeaningfulUseMeasureTargets 
--      SET    [Target]=20,DisplayWidgetNameAs='Family Health History'
--      WHERE  MeasureType=8706 and Stage=8767 --Satge2
--  END 
  
  
  IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8707  and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8707,null,9373,50,'Advance Directives') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=50,DisplayWidgetNameAs='Advance Directives'
      WHERE  MeasureType=8707 and Stage=9373 --Satge2
  END 
  
  IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8708  and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8708,null,9373,20,'Structured Lab') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=20,DisplayWidgetNameAs='Structured Lab'
      WHERE  MeasureType=8708 and Stage=9373 --Satge2
  END 
  
  IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8709  and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8709,null,9373,10,'eMAR') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=10,DisplayWidgetNameAs='eMAR'
      WHERE  MeasureType=8709 and Stage=9373 --Satge2
  END 
  
--  IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8696  and 
--					Stage=8767 and isnull(RecordDeleted,'N')='N') 
--  BEGIN 
      
--      INSERT INTO MeaningfulUseMeasureTargets 
--                  (MeasureType,
--					MeasureSubType ,
--					Stage,
--					[Target],
--					DisplayWidgetNameAs) 
--      VALUES     (8696,null,8767,20,'Reminders') 
               
--  END 
--ELSE 
--  BEGIN 
--      UPDATE MeaningfulUseMeasureTargets 
--      SET    [Target]=20,DisplayWidgetNameAs='Reminders'
--      WHERE  MeasureType=8696 and Stage=8767 --Satge2
--  END 