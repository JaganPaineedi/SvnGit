/******************************************************************************    
** Name: Rx Screen 
--  
-- Purpose: Script to add entries in GlobalCodeCategories, GlobalCodes for ClientMedicationScriptActivities.Reason to update with the Script Failure status reason to differenciate from Electronic Failure. 
-- Engineering Improvement Initiatives- NBL(I) Task# 267
-- When E-prescription fails we need to fax the prescription to the pharmacy  
-- Author:  Malathi Shiva  
-- Date:    12 Dec 2015 
--   
-- *****Histroy****   
**********************************************************************************/ 

DECLARE @Category VARCHAR(15)
SET @Category = 'SCRIPTREASON'

DECLARE @CodeName VARCHAR(15)
SET @CodeName = 'Script Failure'

--GlobalCodeCategories Enties
IF NOT EXISTS(SELECT Category 
              FROM   GlobalCodeCategories 
              WHERE  Category = @Category) 
  BEGIN 
      INSERT INTO GlobalCodeCategories 
                  (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit,[Description],UserDefinedCategory,HasSubcodes) 
      VALUES     (@Category,@Category,'Y','Y','Y','Y','[Description] - 2F79530A-96F1-4DA4-8A24-89FD063DFAB0','N','Y') 
  END 

--GlobalCodes Enties
IF NOT EXISTS(SELECT GlobalCodeId 
              FROM   GlobalCodes 
              WHERE  Category = @Category and CodeName = @CodeName) 
  BEGIN 
      INSERT INTO GlobalCodes 
                  (Category,CodeName,Active,CannotModifyNameOrDelete) 
      VALUES     (@Category,@CodeName,'Y','N') 
  END 

GO 
