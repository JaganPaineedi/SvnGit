-- Copyright: Streamline Healthcare Solutions    
-- "Psychiatric Note"  
-- Purpose: Script for Task #10 Camino customization
--    
-- Author:  Lakshmi Kanth
-- Date:    13-11-2015

-----INSERT INTO RecodeCategories Table 
declare @categoryId int
declare @ErrVal Int
Declare @GlobalCodeId Int
IF NOT EXISTS(SELECT CategoryCode,CategoryName from RecodeCategories WHERE CategoryCode='XPSYCHIATRICNOTEPRESENTINGPROBLEM')
INSERT INTO RecodeCategories(CategoryCode,CategoryName,Description,MappingEntity)
VALUES( 'XPSYCHIATRICNOTEPRESENTINGPROBLEM','PSYCHIATRICNOTEPRESENTINGPROBLEM',
         'This category is used to enable/disable commentbox in General tab.',
         null) 
         
else
UPDATE recodecategories
SET    categorycode = 'XPSYCHIATRICNOTEPRESENTINGPROBLEM',
       categoryname = 'PSYCHIATRICNOTEPRESENTINGPROBLEM',
       description ='This category is used to enable/disable commentbox in General tab.',
		mappingentity = null
WHERE  categorycode = 'XPSYCHIATRICNOTEPRESENTINGPROBLEM'  
	

