/*  Date					Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*  22-March-2016	    	SystemConfigurationKeys 'SERVICESSTRUCTUREDSPECIFICLOCATION' For Service note and Service Detail to Show and HideDetails Button Spring River - Customizations #18   */
/*  --------------------------------------------------------------------------------------------------------------------------------*/
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'SERVICESSTRUCTUREDSPECIFICLOCATION'
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
		'SERVICESSTRUCTUREDSPECIFICLOCATION'
		,'N'
		,'Purpose of this Key to show and hide Details button in Service note and Service Details page'
		,'Y,N. Default value should be Y'
		,''
		  )
END

GO

