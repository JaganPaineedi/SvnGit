/********************************************************************************
--
-- Copyright:   Streamline Healthcare Solutions
-- Author:	    Neha
-- CreatedDate: 31/July/2018
-- Purpose:     To insert a new entry into Globalcodes for the GlobalCodeCategory 'ALERTTYPE'
*********************************************************************************/
IF NOT EXISTS (SELECT TOP 1 GlobalCodeId
	FROM GlobalCodes
	WHERE Category = 'ALERTTYPE'
		AND CodeName = 'Services'
		AND Active = 'Y'
		AND ISNULL(RecordDeleted, 'N') = 'N')
	
BEGIN
	INSERT INTO [GlobalCodes] (
		[Category]
		,[CodeName]
		,[Code]
		,[Description]
		,[Active]
		,[CannotModifyNameOrDelete]
		)
	VALUES (
		'ALERTTYPE'
		,'Services'
		,'Services'
		,NULL
		,'Y'
		,'Y'
		)
END