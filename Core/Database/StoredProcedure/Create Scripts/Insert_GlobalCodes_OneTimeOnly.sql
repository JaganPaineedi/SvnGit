/********************************************************************************                                                   
--  
-- Copyright: Streamline Healthcare Solutions  
--  
-- Purpose: Adding global codes for MAR  
-- Author : Seema Thakur 
-- Date  : 03-Mar-2016
-- Purpose: To bind dropdowns and globalcodes in MAR.
*********************************************************************************/ 

-- INSERT INTO GlobalCodeCategories Table for category XMARDisplay --
IF NOT EXISTS(Select GlobalCodeId FROM GlobalCodes WHERE CodeName='One Time Only' AND Category='XMARDisplay')
BEGIN
INSERT INTO GlobalCodes(Category,CodeName,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap,Code)
VALUES('XMARDisplay','One Time Only',NULL,'Y','Y',NULL,NULL,NULL,NULL,NULL,NULL,'One Time Only')
END