/*  Date						Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*  15-Desc-2017	 Vaibhav   	Adding System configuration for Fax functionality */
/*  --------------------------------------------------------------------------------------------------------------------------------*/
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'EnableFaxinMyReports'
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
		'EnableFaxinMyReports'
		,'Y'
		,'Enable Fax in My Reports '
		,'Y/N'
		,''
		  )
END

GO

