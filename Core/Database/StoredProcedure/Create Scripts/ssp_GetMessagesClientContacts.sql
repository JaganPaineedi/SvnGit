
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetMessagesClientContacts]    Script Date: 06/17/2015 05:56:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetMessagesClientContacts]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_GetMessagesClientContacts]
GO


GO

/****** Object:  StoredProcedure [dbo].[ssp_GetMessagesClientContacts]    Script Date: 06/17/2015 05:56:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_GetMessagesClientContacts]
	/*************************************************************/
	/* Stored Procedure: dbo.ssp_GetMessagesClientContacts	             */
	/* Creation Date:  Nov 04 2014                                 */
	/* Purpose: To Get Client Contacts 				 */
	/*  Date                  Author                 Purpose     */
	/* Nov 04 2014            Varun           Created     */
	
	/*************************************************************/
	@ClientId INT
AS
BEGIN
	BEGIN TRY
		SELECT S.StaffId
 ,(Select LastName + ', ' + FirstName from ClientContacts where ClientContactId=S.TempClientContactId and ClientId=S.TempClientId) AS Contact
FROM Staff S
WHERE (ISNULL(S.RecordDeleted, 'N') <> 'Y')
 AND (S.TempClientId = @ClientId)
 AND S.TempClientContactId is not null
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetMessagesClientContacts') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.          
				16
				,-- Severity.          
				1 -- State.          
				);
	END CATCH
END

GO

