
IF OBJECT_ID('csp_JobToDoDocumentsDeleteForInactiveClients', 'P') IS NOT NULL
	DROP PROCEDURE csp_JobToDoDocumentsDeleteForInactiveClients
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_JobToDoDocumentsDeleteForInactiveClients]
AS
/**********************************************************************
Stored Procedure:	dbo.csp_JobToDoDocumentsDeleteForInactiveClients

Creation Date:		2018-09-19

Purpose:			Mark as Record Deleted all documents defined in recode 'XNDNWToDoDocumentsDeleteForInactiveClients'
					for which the client has become inactive with the exception of documents which are already
					in progress

Updates:
Date		Author			Purpose
2018-09-19	JStedman		Created ; New Directions Enh 848

**********************************************************************/
BEGIN

	BEGIN TRY

		DECLARE @CurrDate datetime = GETDATE(); 
		DECLARE @ClientsAffected TABLE (ClientId int, DocumentId int, DocumentCodeId int, AuthorId int, DeletedBy varchar(30));

		UPDATE d SET
			d.RecordDeleted = 'Y'
			, d.DeletedBy = d.CreatedBy
			, d.DeletedDate = @CurrDate
		OUTPUT
			INSERTED.ClientId
			, INSERTED.DocumentId
			, INSERTED.DocumentCodeId
			, INSERTED.AuthorId
			, INSERTED.DeletedBy
		INTO
			@ClientsAffected
		FROM
			dbo.Documents AS d
				INNER JOIN dbo.Clients AS c ON c.ClientId = d.ClientId
				INNER JOIN dbo.DocumentCodes AS dc ON dc.DocumentCodeId = d.DocumentCodeId AND ISNULL(dc.RecordDeleted, 'N') = 'N'
				INNER JOIN dbo.DocumentVersions AS dv ON dv.DocumentVersionId = d.InProgressDocumentVersionId
		WHERE
			d.[Status] = 20								--i.e. To Do
				AND d.DocumentCodeId IN (
					SELECT
						IntegerCodeId
					FROM
						dbo.ssf_RecodeValuesAsOfDate('XNDNWToDoDocumentsDeleteForInactiveClients', d.EffectiveDate) AS s_r
				)
				AND c.Active = 'N'
				AND NOT EXISTS (
					SELECT	*
					FROM	dbo.Documents AS d2
					WHERE	( d2.RecordDeleted IS NULL OR d2.RecordDeleted = 'N' )
							AND d2.ClientId = d.ClientId  
							AND d2.DocumentCodeId = d.DocumentCodeId  
							AND d2.AuthorId = d.AuthorId  
							AND d2.Status = 21			--i.e. In Progress  
				)
				AND ( d.RecordDeleted IS NULL OR d.RecordDeleted = 'N' )
				--AND d.AuthorId = 614					--Test Code
		;

		--Delete the Alert(s)

		----Test Code
		--SELECT * FROM @ClientsAffected;

		UPDATE a SET a.RecordDeleted = 'Y', a.DeletedBy = t_ca.DeletedBy, a.DeletedDate = @CurrDate
		FROM
			dbo.Alerts AS a
				INNER JOIN @ClientsAffected AS t_ca ON t_ca.ClientId = a.ClientId AND t_ca.AuthorId = a.ToStaffId
				INNER JOIN dbo.Documents AS d ON d.DocumentId = a.DocumentId
		WHERE
			( a.RecordDeleted IS NULL OR a.RecordDeleted = 'N' )
				AND d.DocumentCodeId = t_ca.DocumentCodeId
				AND a.Unread = 'Y'
		;

	END TRY

	BEGIN CATCH

		DECLARE @Error VARCHAR(8000);

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_JobToDoDocumentsDeleteForInactiveClients') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE());

		RAISERROR (
			@Error,	-- Message text.                                                                                                            
			16,		-- Severity.                                                                                                            
			1		-- State.                                                                                                            
		);

	END CATCH

END;

GO

