/****** Object:  StoredProcedure [dbo].[SSP_PMGetServiceCommentAndClientPhone]    Script Date: 11/18/2011 16:25:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_PMGetServiceCommentAndClientPhone]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_PMGetServiceCommentAndClientPhone]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO


CREATE PROCEDURE [dbo].[SSP_PMGetServiceCommentAndClientPhone] 
	@ClientId INT,
	@ServiceId INT
AS
/******************************************************************************  
**  File:   
**  Name: Stored_Procedure_Name  
**  Desc:   
**  
**  This template can be customized:  
**                
**  Return values:  
**   
**  Called by:     
**                
**  Parameters:  
**  Input       Output  
**     ----------       -----------  
**  
**  Auth:   
**  Date:   
*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:   Author:   Description:  
**  --------  --------  -------------------------------------------  
**  04/27/2011  dharvey   Added RecordDeleted check to prevent pulling  
          outdated phone numbers  
**  12-May-2014  Ponnin   Added DoNotContact (DNC) text after the phone number if it is checked in Client information Detail page.           
**	05-Jan-2016	 Alok Kumar		Modified to fetch multiple records(to display all Phone Number of the clients)
								 for the task #362 - MFS - Customization Issue Tracking
**     08 Jan 2016		Revathi	 what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.       
								 why:task #609, Network180 Customization    
*******************************************************************************/

BEGIN
	DECLARE @Comment VARCHAR(max)
	DECLARE @Name VARCHAR(102)

	SELECT @Comment = isnull(Comment, '')
	FROM Services
	WHERE ServiceID = @ServiceId

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
		SELECT @ServiceId AS ServiceId
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
		WHERE cp.ClientId = @ClientId
			AND ISNULL(cp.RecordDeleted, 'N') = 'N'
	END
	ELSE
	BEGIN
		SELECT @ServiceId AS ServiceId
			,'' AS PhoneTypes
			,'' AS PhoneNumber
			,@Comment AS comment
			,@Name AS Name
		FROM Services
		WHERE ServiceID = @ServiceId
	END
END