/*  Date					Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*  01-Jan-2018	    	SystemConfigurationKeys 'MAKEDESCRIPTIONBOXASREQUIRED' For Authorization Request to validate Description on authorization attachments. */
/*						Ref: #478 Network180 Support Go Live	*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'MAKEDESCRIPTIONBOXASREQUIRED'
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
		'MAKEDESCRIPTIONBOXASREQUIRED'
		,'No'
		,'Read as Make Description Box As Required. Default Value = No. This will be the existing system behavior where "Description" textbox on "Upload File Detail" screen (when coming from Authorization request) is NOT required. Yes = With this value, system will display a validation message to the user stating that "Description" field on "Upload File Detail" screen (when coming from Authorization request) is required.'
		,'Yes,No. Default value should be No.'
		,'This key is being done as requested by customer.'
		  )
END

GO
