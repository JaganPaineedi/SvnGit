-- Global codes script for category MEANINGFULUSEMEASURE and related Global codes Add Global Codes for 'Stage 2 – Modified’
-- Gautam       4th  Jan 2015  

IF NOT EXISTS(SELECT Category from GlobalCodeCategories WHERE Category='MeaningFulUseStages')
BEGIN
INSERT INTO GlobalCodeCategories(Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes,UsedInCareManagement)
VALUES('MEANINGFULUSESTAGES','MEANINGFULUSESTAGES','Y','N','Y','Y','Category for MEANINGFULUSE Stages','N','N','Y') 
END
GO 

  
IF NOT EXISTS(SELECT * FROM   GlobalCodes WHERE  GlobalcodeId=9373) 
  BEGIN 
      SET IDENTITY_INSERT GlobalCodes ON
      INSERT INTO GlobalCodes 
                  (GlobalcodeId,Category, 
                   CodeName, 
                   Code,
                   Active, 
                   CannotModifyNameOrDelete,SortOrder,ExternalCode2) 
      VALUES     (9373,'MEANINGFULUSESTAGES', 
                  'Stage2 – Modified', 'STAGE2-MODIFIED',
                  'Y', 
                  'N',3,null) 
    SET IDENTITY_INSERT GlobalCodes OFF              
  END 
ELSE 
  BEGIN 
      UPDATE GlobalCodes 
      SET    Category = 'MEANINGFULUSESTAGES', 
             CodeName = 'Stage2 – Modified',
             Code='STAGE2-MODIFIED' ,
             Active = 'Y', 
             CannotModifyNameOrDelete = 'N' ,
             SortOrder=3,
             ExternalCode2=null
      WHERE  GlobalcodeId = 9373
             AND Category = 'MEANINGFULUSESTAGES' 
  END 
  

      UPDATE GlobalCodes 
      SET    Category = 'MEANINGFULUSESTAGES', 
             CodeName = 'Stage3',
             Code='Stage3' ,
             Active = 'Y', 
             CannotModifyNameOrDelete = 'N' ,
             SortOrder=4,
             ExternalCode2=null
      WHERE  GlobalcodeId = 8768 
             AND Category = 'MEANINGFULUSESTAGES' 

  
