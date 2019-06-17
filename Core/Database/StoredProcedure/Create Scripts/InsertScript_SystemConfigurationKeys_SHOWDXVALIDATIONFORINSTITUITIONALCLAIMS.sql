/*  Date					Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*  04-DEC-2017	    	SystemConfigurationKeys 'SHOWDXVALIDATIONFORINSTITUITIONALCLAIMS' to show the validation for the Instituitional claims KCMHSAS - Support #960.48   */
/*  --------------------------------------------------------------------------------------------------------------------------------*/
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'SHOWDXVALIDATIONFORINSTITUITIONALCLAIMS'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[Key]
		,Value
		,[Description]
		,AcceptedValues
		,Comments
		)
	VALUES (
		'SHOWDXVALIDATIONFORINSTITUITIONALCLAIMS'
		,'Y'
		,'Purpose of this Key to Show the validation for the Instituitional claims'
		,'Y,N'
		,''
		  )
END

GO

