/****** Object:  StoredProcedure [dbo].[SSP_PCGetAppointmentCommentAndClientPhone]    Script Date: 11/18/2011 16:25:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_PCGetAppointmentCommentAndClientPhone]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_PCGetAppointmentCommentAndClientPhone]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE Procedure [dbo].[SSP_PCGetAppointmentCommentAndClientPhone]
	@ClientId int,
	@AppointmentId int
AS

/******************************************************************************
**		File: SSP_PCGetAppointmentCommentAndClientPhone
**		Name: Stored_Procedure_Name
**		Desc: To get Client Details according to appointment from reception page.(#Task No. 35) Primary Care - Summit Pointe
**
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:			Author:			Description:
**		--------		--------		-------------------------------------------
**		15-May-2014		Ponnin			Added DoNotContact (DNC) text after the phone number if it is checked in Client information Detail page. 
**	    05-Jan-2016		Alok Kumar		Modified to fetch multiple records(to display all Phone Number of the clients) 
										for the task #362 - MFS - Customization Issue Tracking 
**     08 Jan 2016		Revathi			what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.       
										why:task #609, Network180 Customization 
*******************************************************************************/

BEGIN
	DECLARE @Comment VARCHAR(max)
	DECLARE @Name VARCHAR(102)

	SELECT @Comment = isnull(Description, '')
	FROM Appointments
	WHERE AppointmentId = @AppointmentId	
	
		SELECT @Name =	(SELECT CASE 
					WHEN ISNULL(ClientType, 'I') = 'I'
						THEN ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '')
					ELSE ISNULL(OrganizationName, '')
					END ) 
	from Clients where clientid = @ClientId 

	IF EXISTS (
			SELECT 1
			FROM ClientPhones
			WHERE ClientId = @ClientId AND ISNULL(RecordDeleted, 'N') = 'N'
			)
	BEGIN
		SELECT @AppointmentId AS AppointmentId
			,gc.CodeName AS PhoneTypes
			,cp.PhoneNumber + CASE 
				WHEN cp.DoNotContact = 'Y'
					THEN ' (DNC)'
				ELSE ''
				END AS PhoneNumber
			,@Comment AS comment
			,@Name AS Name
		FROM ClientPhones cp
		INNER JOIN GlobalCodes gc ON gc.GlobalCodeId = cp.PhoneType
		WHERE ClientId = @ClientId
			AND ISNULL(cp.RecordDeleted, 'N') = 'N'
	END
	ELSE
	BEGIN
		SELECT @AppointmentId AS AppointmentId
			,'' AS PhoneTypes
			,'' AS PhoneNumber
			,@Comment AS comment
			,@Name AS Name
		FROM Appointments
		WHERE AppointmentId = @AppointmentId
	END
END