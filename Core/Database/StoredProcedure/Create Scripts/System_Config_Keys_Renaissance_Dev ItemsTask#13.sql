/*  Date				Author		Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*  09-Oct-2017	        Ajay		The system should create a program assignment only when one does not exist and discharge if one exists.
                                     Renaissance - Dev Items:Task#13                        	                    */
/*  --------------------------------------------------------------------------------------------------------------------------------*/
IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'SETAUTOPROGRAMASSIGNMENTDISCHARGE' 
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
		'SETAUTOPROGRAMASSIGNMENTDISCHARGE'
		,'Y'
		,'The system should create a program assignment only when one does not exist and discharge if one exists.' 
		,'Census Management'
		,'The system should create a program assignment only when one does not exist and discharge if one exists.'
		,'Y'
		,'Y,N'
		  )
END 
GO

