/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
-- Purpose: Global Code Entries for "Payment EOB" for Task #840 - Renaissance - Dev Items.
--  
-- Author:  Akwinass
-- Date:    04-MAR-2016
--  
-- *****History****  
*********************************************************************************/


IF EXISTS (SELECT * FROM GlobalCodes WHERE Category = 'IMAGEASSOCIATEDWITH')
BEGIN
	IF NOT EXISTS(SELECT 1 from GlobalCodes where GlobalCodeId = 5830)
	BEGIN
		SET IDENTITY_INSERT GlobalCodes ON
		INSERT INTO GlobalCodes (GlobalCodeId,Category,CodeName,[Description],Active,CannotModifyNameOrDelete,SortOrder)
		VALUES (5830,'IMAGEASSOCIATEDWITH','Payment EOB',NULL,'Y','N',NULL)
		SET IDENTITY_INSERT GlobalCodes OFF
	END
END