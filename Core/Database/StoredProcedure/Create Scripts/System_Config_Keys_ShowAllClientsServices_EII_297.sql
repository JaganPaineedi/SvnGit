/*  Date				Author		Purpose																							*/
/*  --------------------------------------------------------------------------------------------------------------------------------*/
/*  22-March-2016	    Gautam		Created.Engineering Improvement Initiatives- NBL(I) > Tasks#297 > Services/Notes List Page (Updated 2/3) 	                        	                    */
/*  --------------------------------------------------------------------------------------------------------------------------------*/
IF NOT EXISTS (
		SELECT *
		FROM SystemConfigurationKeys
		WHERE [KEY] = 'ShowAllClientsServices'
			AND ISNULL(RecordDeleted, 'N') = 'N'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		[Key]
		,Value
		,[Description]
		,AcceptedValues
		,Modules
		,Comments
		)
	VALUES (
		'ShowAllClientsServices'
		,'Y'
		,'when the Client Access permission of "Clinician in Program which Shares Clients" and the user does not have "All Clients",
		 then on the Services/Notes List page - that the user would ONLY be able to see those services that are in a Program that 
		 is associated to the User Account.'
		,'Y , N . Default value should be Y'
		,'Services/ Notes'
		,'when the Client Access permission of "Clinician in Program which Shares Clients" and the user does not have "All Clients",
		 then on the Services/Notes List page - that the user would ONLY be able to see those services that are in a Program that 
		 is associated to the User Account.'
		  )
END
ELSE
	BEGIN
		update SystemConfigurationKeys
		set [value]='Y'
		where [key]='ShowAllClientsServices'
	END
GO

