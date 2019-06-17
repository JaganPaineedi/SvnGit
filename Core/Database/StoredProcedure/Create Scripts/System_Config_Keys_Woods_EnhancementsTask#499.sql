/*  Date				Author		Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*  09-Oct-2017	        Ajay		To display Authorization amount description. Woods-Enhancements:Task#499                        	                    */
/*  --------------------------------------------------------------------------------------------------------------------------------*/
IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'SetDescriptionForAuthorizationAmount' 
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[Key]
		,Value
		,[Description] 
		,Modules
		,Comments
		,ShowKeyForViewingAndEditing
		,AcceptedValues
		)
	VALUES (
		'SetDescriptionForAuthorizationAmount'
		,'The dollar amount used on an authorization is updated based on the amount paid, not the charge amount.'
		,'The dollar amount used on an authorization is updated based on the amount paid, not the charge amount.' 
		,'Authorization Details'
		,'The dollar amount used on an authorization is updated based on the amount paid, not the charge amount.'
		,'Y'
		,'Any text to display Authorization amount description'
		  )
END 
GO

