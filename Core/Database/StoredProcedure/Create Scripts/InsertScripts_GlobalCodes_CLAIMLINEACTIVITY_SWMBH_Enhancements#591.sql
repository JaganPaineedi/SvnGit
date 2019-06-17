/********************************************************************************
--
-- Copyright:   Streamline Healthcare Solutions
-- Author:	    K. Soujanya
-- CreatedDate: 06/Sep/2018
-- Purpose:     To insert a new entry into Globalcodes for the GlobalCodeCategory 'CLAIMLINEACTIVITY',Task #591 - SWMBH - Enhancements
*********************************************************************************/
IF NOT EXISTS (
		SELECT GlobalCodeId
		FROM GlobalCodes
		WHERE GlobalCodeId = 2015
			AND Category = 'CLAIMLINEACTIVITY'
		)
BEGIN
	SET IDENTITY_INSERT GlobalCodes ON

	INSERT INTO globalcodes (
	     GlobalCodeId
		,Category
		,CodeName
		,Code
		,Description
		,Active
		,CannotModifyNameOrDelete
		,SortOrder
		)
	VALUES (
	    2015
		,'CLAIMLINEACTIVITY'
		,'Manual Pend'
		,'ManualPend'
		,NULL
		,'Y'
		,'Y'
		,NULL
		)

	SET IDENTITY_INSERT GlobalCodes OFF
END

