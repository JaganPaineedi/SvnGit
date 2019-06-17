/*************************************************************************************                                                   
-- Purpose: Update script for GROUPNOTETYPE.
--  
-- Author:  Akwinass
-- Date:    13-APRIL-2016
--  
-- *****History****  
**************************************************************************************/
UPDATE GlobalCodes
SET SortOrder = 1
WHERE GlobalCodeId = 9383
	AND Category = 'GROUPNOTETYPE'

UPDATE GlobalCodes
SET SortOrder = 2
WHERE GlobalCodeId = 9384
	AND Category = 'GROUPNOTETYPE'

UPDATE GlobalCodes
SET SortOrder = 3
WHERE GlobalCodeId = 9385
	AND Category = 'GROUPNOTETYPE'

UPDATE GlobalCodes
SET SortOrder = 4
WHERE GlobalCodeId = 9386
	AND Category = 'GROUPNOTETYPE'
