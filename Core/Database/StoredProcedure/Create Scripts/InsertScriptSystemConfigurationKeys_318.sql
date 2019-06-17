/*  Date					Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*  22-March-2016	    	SystemConfigurationKeys ExcludePaidServicesFromReallocation, Engineering Improvement Initiatives #318 */
/*  --------------------------------------------------------------------------------------------------------------------------------*/
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'ENABLEBATCHSCANNING'
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
		'ENABLEBATCHSCANNING'
		,'N'
		,'Purpose of this Key to show and hide Batch scanning button on scanning list page'
		,'Y, N, NULL. Default value should be N'
		,''
		  )
END

GO

