SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
GO
CREATE PROCEDURE ssp_SCGetSentEmails @SentEmailId INT
AS /******************************************************************************
**		File: ssp_SCGetSentEmails.sql
**		Name: ssp_SCGetSentEmails
**		Desc: 
**
**		This template can be customized:
**              
**		Return values:
** 
**		Called by:   
**              
**		Parameters:
**		Input							Output
**     ----------							-----------
**
**		Auth: 
**		Date: 
*******************************************************************************
**		Change History
*******************************************************************************
**		Date:		    Author:				    Description:
**		--------		--------				-------------------------------------------
**	    11/25/2016      jcarlson			    created
*******************************************************************************/ 
    BEGIN
	
        BEGIN TRY
        SELECT a.SentEmailId, a.CreatedBy, a.CreatedDate, a.ModifiedBy, a.ModifiedDate, a.RecordDeleted, a.DeletedBy, a.DeletedDate, a.StaffId, a.ClientId, a.MessageTo,
             a.MessageFrom, a.MessageCC, a.MessageBCC, a.MessageSubject, a.MessageBody
		FROM dbo.SentEmails AS a 
		WHERE a.SentEmailId = @SentEmailId

		SELECT b.SentEmailAttachmentId, b.CreatedBy, b.CreatedDate, b.ModifiedBy, b.ModifiedDate, b.RecordDeleted, b.DeletedBy, b.DeletedDate, b.SentEmailId,
             b.AttachmentName, CONVERT(VARBINARY(max),NULL) AS AttachmentData, b.AttachmentMimeType, b.DocumentVersionId
		FROM dbo.SentEmailAttachments AS b
		WHERE b.SentEmailId = @SentEmailId


        END TRY

        BEGIN CATCH
            DECLARE @Error VARCHAR(8000);

            SET @Error = CONVERT(VARCHAR , ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000) , ERROR_MESSAGE())
                + '*****' + ISNULL(CONVERT(VARCHAR , ERROR_PROCEDURE()) , 'ssp_SCGetSentEmails') + '*****'
                + CONVERT(VARCHAR , ERROR_LINE()) + '*****' + CONVERT(VARCHAR , ERROR_SEVERITY()) + '*****'
                + CONVERT(VARCHAR , ERROR_STATE());

            RAISERROR (
				@Error
				,-- Message text.                                                                     
				16
				,-- Severity.                                                            
				1 -- State.                                                         
				);
        END CATCH;
    END;


GO

