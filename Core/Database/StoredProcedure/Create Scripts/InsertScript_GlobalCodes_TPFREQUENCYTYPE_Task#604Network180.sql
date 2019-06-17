/*************************************************************************************/
/* Author : Arjun K R                                                                */
/* Date : 20 Nov 2015                                                                */
/* Purpose : Insert script for custom global codes                                   */
/*************************************************************************************/

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE GlobalCodeId=178)
	BEGIN
	    SET IDENTITY_INSERT GlobalCodes ON
			INSERT INTO GlobalCodes(GlobalCodeId,Category,CodeName,Code,Description,Active,CannotModifyNameOrDelete,SortOrder,ExternalCode1,ExternalSource1,ExternalCode2,ExternalSource2,Bitmap)
			VALUES(178,'TPFREQUENCYTYPE','Fiscal Year Quarterly','Fiscal Year Quarterly','Fiscal Year Quarterly','Y','Y',1,NULL,NULL,NULL,NULL,NULL) 
	    SET IDENTITY_INSERT GlobalCodes OFF
	END
GO