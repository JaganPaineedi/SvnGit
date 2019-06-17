/*  Date					Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*  22-March-2016	    	SystemConfigurationKeys ExcludePaidServicesFromReallocation, Engineering Improvement Initiatives #330 */
/*  --------------------------------------------------------------------------------------------------------------------------------*/
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'ExcludePaidServicesFromReallocation'
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
		'ExcludePaidServicesFromReallocation'
		,'Y'
		,'Purpose of this Key is to exclude Paid Services from Reallocation process'
		,'Y, N, NULL. Default value should be Y'
		,'Purpose of this Key is to exclude Paid Services from Reallocation process'
		  )
END
ELSE
	BEGIN
		update SystemConfigurationKeys
		set [value]='Y',[Description]='Purpose of this Key is to exclude Paid Services from Reallocation process'
			,AcceptedValues='Y, N, NULL. Default value should be Y'
			,Comments='Purpose of this Key is to exclude Paid Services from Reallocation process'
		where [key]='ExcludePaidServicesFromReallocation'
	END
GO

