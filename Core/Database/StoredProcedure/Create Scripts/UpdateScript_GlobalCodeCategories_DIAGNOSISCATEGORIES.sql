
/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- 
-- Purpose: To Update GlobalCodeCategories.Category value to 'N' for the Category 'DIAGNOSISCATEGORIES' for Spring River - Environment Issues Tracking #11 
--  
-- Author:  Irfan
-- Date:    30-Aug-2016
 
*********************************************************************************/

IF EXISTS (
		SELECT 1
		FROM GlobalCodeCategories
		WHERE Category = 'DIAGNOSISCATEGORIES'
		)
BEGIN
	UPDATE GlobalCodeCategories
	SET UserDefinedCategory = 'N'
	WHERE Category = 'DIAGNOSISCATEGORIES'
END
GO

