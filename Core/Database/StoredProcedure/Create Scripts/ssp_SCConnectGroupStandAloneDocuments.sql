 IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'ssp_SCConnectGroupStandAloneDocuments')
	BEGIN
		DROP  Procedure  ssp_SCConnectGroupStandAloneDocuments
	END
GO
    
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCConnectGroupStandAloneDocuments] (
	@ServiceId INT
	,@StaffId INT	
	)

/********************************************************************************                                                 
** Stored Procedure: ssp_SCConnectGroupStandAloneDocuments                                                    
**                                                  
** Copyright: Streamline Healthcate Solutions                                                    
** Updates:                                                                                                         
** Date            Author              Purpose   
** 14-APRIL-2016   Akwinass			   What:To Connect Group Stand Alone Documents      
**									   Why:task #167.1 Valley - Support Go Live  
** History
-- 24-May-2016       Vamsi         What: Added Serviceid is null condition
--								   Why: Valley - Support Go Live # 492
** 24-MAR-2017   Akwinass			   What:Included GroupId      
**									   Why:Task:#5 in StarCare - Customizations 
*********************************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @DocumentId INT = 0
		DECLARE @ClientId INT = 0
		DECLARE @DocumentCodeId INT = 0
		DECLARE @DateOfService DATETIME
		DECLARE @UserCode VARCHAR(30)
		DECLARE @GroupId INT = 0
		
		SELECT TOP 1 @UserCode = UserCode
		FROM Staff
		WHERE StaffId = @StaffId
			AND isnull(RecordDeleted, 'N') = 'N'
		
		SELECT TOP 1 @ClientId = S.ClientId
			,@DocumentCodeId = GNDC.ServiceNoteCodeId
			,@DateOfService = S.DateOfService
			,@GroupId = G.GroupId
		FROM Services S
		JOIN GroupServices GS ON S.GroupServiceId = GS.GroupServiceId
		JOIN Groups G ON GS.GroupId = G.GroupId
		JOIN GroupNoteDocumentCodes GNDC ON G.GroupNoteDocumentCodeId = GNDC.GroupNoteDocumentCodeId
		WHERE S.ServiceId = @ServiceId
			AND isnull(S.RecordDeleted, 'N') = 'N'
			AND isnull(GS.RecordDeleted, 'N') = 'N'
			AND isnull(G.RecordDeleted, 'N') = 'N'
			AND isnull(GNDC.RecordDeleted, 'N') = 'N'
			AND g.GroupNoteType IN (9384,9385)
					
		IF EXISTS (
				SELECT 1
				FROM GroupStandAloneDocuments gsad
				INNER JOIN Documents d ON gsad.DocumentId = d.DocumentId
					AND gsad.ClientId = d.ClientId
				WHERE gsad.ServiceId = @ServiceId
					AND gsad.StaffId = @StaffId
					AND isnull(d.RecordDeleted, 'N') = 'N'
					AND isnull(gsad.RecordDeleted, 'N') = 'N'
				)
		BEGIN			
			SELECT TOP 1 @DocumentId = D.DocumentId
			FROM GroupStandAloneDocuments gsad
			INNER JOIN Documents d ON gsad.DocumentId = d.DocumentId AND gsad.ClientId = d.ClientId
			INNER JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
			INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = d.CurrentVersionStatus
			INNER JOIN Staff a ON a.StaffId = d.AuthorId
			INNER JOIN Screens sr ON d.DocumentCodeId = sr.DocumentCodeId
			WHERE gsad.ClientId = @ClientId
				AND gsad.ServiceId = @ServiceId
				AND isnull(d.RecordDeleted, 'N') = 'N'
				AND isnull(sr.RecordDeleted, 'N') = 'N'
				AND isnull(gsad.RecordDeleted, 'N') = 'N'	
				AND d.DocumentCodeId = @DocumentCodeId
				AND d.[Status] = 22
				AND d.ServiceId IS NULL
				AND gsad.StaffId = @StaffId
			ORDER BY d.ModifiedDate DESC
			
			IF ISNULL(@DocumentId,0) = 0
			BEGIN
				SELECT TOP 1 @DocumentId = D.DocumentId
				FROM GroupStandAloneDocuments gsad
				INNER JOIN Documents d ON gsad.DocumentId = d.DocumentId AND gsad.ClientId = d.ClientId
				INNER JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
				INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = d.CurrentVersionStatus
				INNER JOIN Staff a ON a.StaffId = d.AuthorId
				INNER JOIN Screens sr ON d.DocumentCodeId = sr.DocumentCodeId
				WHERE gsad.ClientId = @ClientId
					AND gsad.ServiceId = @ServiceId
					AND gsad.GroupId = @GroupId
					AND isnull(d.RecordDeleted, 'N') = 'N'
					AND isnull(sr.RecordDeleted, 'N') = 'N'
					AND isnull(gsad.RecordDeleted, 'N') = 'N'	
					AND d.DocumentCodeId = @DocumentCodeId
					AND d.[Status] <> 23
					AND d.ServiceId IS NULL
					AND gsad.StaffId = @StaffId
				ORDER BY d.ModifiedDate DESC
			END
		END
		ELSE
		BEGIN		
			SELECT TOP 1 @DocumentId = D.DocumentId
			FROM Documents d
			INNER JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
			INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = d.CurrentVersionStatus
			INNER JOIN Staff a ON a.StaffId = d.AuthorId
			INNER JOIN Screens sr ON d.DocumentCodeId = sr.DocumentCodeId
			WHERE d.ClientID = @ClientId
				AND isnull(d.RecordDeleted, 'N') = 'N'
				AND isnull(sr.RecordDeleted, 'N') = 'N'	
				AND d.DocumentCodeId = @DocumentCodeId
				AND CAST(d.EffectiveDate AS DATE) = CAST(@DateOfService AS DATE)
				AND d.[Status] = 22
				AND d.AuthorId = @StaffId
				AND d.ServiceId IS NULL
			ORDER BY d.ModifiedDate DESC
			
			IF ISNULL(@DocumentId,0) = 0
			BEGIN
				SELECT TOP 1 @DocumentId = D.DocumentId
				FROM Documents d
				INNER JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
				INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = d.CurrentVersionStatus
				INNER JOIN Staff a ON a.StaffId = d.AuthorId
				INNER JOIN Screens sr ON d.DocumentCodeId = sr.DocumentCodeId
				WHERE d.ClientID = @ClientId
					AND isnull(d.RecordDeleted, 'N') = 'N'
					AND isnull(sr.RecordDeleted, 'N') = 'N'	
					AND d.DocumentCodeId = @DocumentCodeId
					AND CAST(d.EffectiveDate AS DATE) = CAST(@DateOfService AS DATE)
					AND d.[Status] NOT IN (20,23)
					AND d.AuthorId = @StaffId
					AND d.ServiceId IS NULL
				ORDER BY d.ModifiedDate DESC
					
			END					
		END
		
		IF ISNULL(@DocumentId, 0) > 0 AND NOT EXISTS (SELECT 1 FROM GroupStandAloneDocuments WHERE GroupId = @GroupId AND ClientId = @ClientId AND StaffId = @StaffId AND ServiceId = @ServiceId AND DocumentId = @DocumentId AND isnull(RecordDeleted, 'N') = 'N')
		BEGIN
			INSERT INTO GroupStandAloneDocuments ([CreatedBy],[CreatedDate],[ModifiedBy],[ModifiedDate],[GroupId],[ClientId],[StaffId],[ServiceId],[DocumentId])
			VALUES (@UserCode,GETDATE(),@UserCode,GETDATE(),@GroupId,@ClientId,@StaffId,@ServiceId,@DocumentId)
		END	
		ELSE IF ISNULL(@DocumentId, 0) = 0
		BEGIN				
			SELECT TOP 1 @DocumentId = D.DocumentId
			FROM Documents d
			INNER JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
			INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = CASE WHEN (d.AuthorId = @StaffId OR d.ReviewerId = @StaffId) THEN d.CurrentVersionStatus ELSE d.[Status] END
			INNER JOIN Staff a ON a.StaffId = d.AuthorId
			INNER JOIN Screens sr ON d.DocumentCodeId = sr.DocumentCodeId
			WHERE d.ClientID = @ClientId
				AND isnull(d.RecordDeleted, 'N') = 'N'
				AND isnull(sr.RecordDeleted, 'N') = 'N'	
				AND d.DocumentCodeId = @DocumentCodeId
				AND CAST(d.EffectiveDate AS DATE) = CAST(@DateOfService AS DATE)
				AND d.[Status] = 22
				AND d.ServiceId IS NULL
				AND (d.AuthorId = @StaffId OR d.ProxyId = @StaffId OR d.ReviewerId = @StaffId OR d.DocumentShared = 'Y')
			ORDER BY d.ModifiedDate DESC
			
			IF ISNULL(@DocumentId,0) = 0
			BEGIN
				SELECT TOP 1 @DocumentId = D.DocumentId
				FROM Documents d
				INNER JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
				INNER JOIN GlobalCodes gcs ON gcs.GlobalCodeId = CASE WHEN (d.AuthorId = @StaffId OR d.ReviewerId = @StaffId) THEN d.CurrentVersionStatus ELSE d.[Status] END
				INNER JOIN Staff a ON a.StaffId = d.AuthorId
				INNER JOIN Screens sr ON d.DocumentCodeId = sr.DocumentCodeId
				WHERE d.ClientID = @ClientId
					AND isnull(d.RecordDeleted, 'N') = 'N'
					AND isnull(sr.RecordDeleted, 'N') = 'N'	
					AND d.DocumentCodeId = @DocumentCodeId
					AND CAST(d.EffectiveDate AS DATE) = CAST(@DateOfService AS DATE)
					AND d.[Status] <> 23
					AND d.ServiceId IS NULL
					AND (d.AuthorId = @StaffId OR d.ProxyId = @StaffId OR d.ReviewerId = @StaffId OR d.DocumentShared = 'Y')
				ORDER BY d.ModifiedDate DESC
			END
		END			

		IF ISNULL(@DocumentId, 0) > 0
		BEGIN
			SELECT TOP 1 sr.ScreenType
				,sr.ScreenId
				,d.DocumentId
				,@ClientId AS ClientId
				,sr.TabId
				,@GroupId AS GroupId
			FROM Documents d
			INNER JOIN Screens sr ON d.DocumentCodeId = sr.DocumentCodeId
			WHERE isnull(d.RecordDeleted, 'N') = 'N'
				AND isnull(sr.RecordDeleted, 'N') = 'N'
				AND d.DocumentId = @DocumentId
		END
		ELSE
		BEGIN
			SELECT TOP 1 sr.ScreenType
				,sr.ScreenId
				,0 AS DocumentId
				,@ClientId AS ClientId
				,sr.TabId
				,@GroupId AS GroupId
			FROM DocumentCodes dc
			INNER JOIN Screens sr ON dc.DocumentCodeId = sr.DocumentCodeId
			WHERE isnull(dc.RecordDeleted, 'N') = 'N'
				AND isnull(sr.RecordDeleted, 'N') = 'N'
				AND dc.DocumentCodeId = @DocumentCodeId
		END
	END TRY

      BEGIN CATCH
          DECLARE @error VARCHAR(8000)

          SET @error= CONVERT(VARCHAR, Error_number()) + '*****'
                      + CONVERT(VARCHAR(4000), Error_message())
                      + '*****'
                      + Isnull(CONVERT(VARCHAR, Error_procedure()),
                      'ssp_SCConnectGroupStandAloneDocuments')
                      + '*****' + CONVERT(VARCHAR, Error_line())
                      + '*****' + CONVERT(VARCHAR, Error_severity())
                      + '*****' + CONVERT(VARCHAR, Error_state())

          RAISERROR (@error,-- Message text.
                     16,-- Severity.
                     1 -- State.
          );
      END CATCH
  END 