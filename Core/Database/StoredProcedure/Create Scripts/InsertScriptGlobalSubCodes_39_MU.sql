 -- Insert / Update script for GlobalSubCodes and MeaningfulUseMeasureTargets for widgets Patient Portal(8697)
 -- Meaningful Use - Stage 3 > Tasks#39 > Stage 2 Modified changes
 IF EXISTS (SELECT 1 FROM GlobalCodes WHERE GlobalCodeId=8697  and isnull(RecordDeleted,'N')='N')
	BEGIN
		IF NOT EXISTS(SELECT 1 FROM GlobalSubCodes WHERE GlobalSubCodeId=6211 and isnull(RecordDeleted,'N')='N')
			BEGIN
			SET IDENTITY_INSERT GlobalSubCodes ON
			INSERT INTO GlobalSubCodes (GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder)
			VALUES					  (6211,8697,'Measure 1 2016','Y','N',1)
			SET IDENTITY_INSERT GlobalSubCodes OFF     
			END
		ELSE
		 BEGIN		 
		    UPDATE GlobalSubCodes SET SubCodeName='Measure 1 2016' WHERE GlobalSubCodeId=6211 AND GlobalCodeId=8697
		 END
		
		IF NOT EXISTS(SELECT 1 FROM GlobalSubCodes WHERE GlobalSubCodeId=6261 and isnull(RecordDeleted,'N')='N')
			BEGIN
			SET IDENTITY_INSERT GlobalSubCodes ON
			INSERT INTO GlobalSubCodes (GlobalSubCodeId,GlobalCodeId,SubCodeName,Active,CannotModifyNameOrDelete,SortOrder)
			VALUES					  (6261,8697,'Measure 1 2017','Y','N',2)
			SET IDENTITY_INSERT GlobalSubCodes OFF     
			END
		ELSE
		 BEGIN		 
		    UPDATE GlobalSubCodes SET SubCodeName='Measure 1 2017',SortOrder=2 WHERE GlobalSubCodeId=6261 AND GlobalCodeId=8697
		    UPDATE GlobalSubCodes SET SortOrder=3 WHERE GlobalSubCodeId=6212 AND GlobalCodeId=8697
		 END 
		 
	END
	
IF NOT EXISTS(SELECT * FROM   MeaningfulUseMeasureTargets WHERE  MeasureType=8697 and MeasureSubType=6261 and 
					Stage=9373 and isnull(RecordDeleted,'N')='N') 
  BEGIN 
      
      INSERT INTO MeaningfulUseMeasureTargets 
                  (MeasureType,
					MeasureSubType ,
					Stage,
					[Target],
					DisplayWidgetNameAs) 
      VALUES     (8697,6261,9373,5,'Patient Portal') 
               
  END 
ELSE 
  BEGIN 
      UPDATE MeaningfulUseMeasureTargets 
      SET    [Target]=5,DisplayWidgetNameAs='Patient Portal'
      WHERE  MeasureType=8697 and MeasureSubType=6261 and Stage=9373 --Satge2 Modified
  END 
  