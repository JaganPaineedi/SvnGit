/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateInternalCollections]    Script Date: 12/12/2014 10:30:03 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_PostUpdateInternalCollections]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_PostUpdateInternalCollections]
GO

/****** Object:  StoredProcedure [dbo].[ssp_PostUpdateInternalCollections]    Script Date: 12/12/2014 10:30:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_PostUpdateInternalCollections] @ScreenKeyId INT
	,@StaffId INT
	,@CurrentUser VARCHAR(30)
	,@CustomParameters XML
AS
/*********************************************************************/
/* Stored Procedure: dbo.ssp_PostUpdateInternalCollections           */
/* Creation Date:    27/AUG/2015                                     */
/*                                                                   */
/* Purpose:  To Create Flag for Delinquent                           */
/*                                                                   */
/* Input Parameters:                                                 */
/* @ScreenKeyId, @StaffId, @CurrentUser, @CustomParameters           */
/* Called By: Internal Collections Details Page                      */
/* Updates:                                                          */
/* Date                   Author        Purpose                      */
/* 27-AUG-2015            Akwinass      Created.                     */
/* 13-Jan-2017			  Irfan			What: Added call of this scsp 'scsp_PostUpdateInternalCollections' to create a flag 
											 'Account in Collections. Safety Check Only' for Internal Collections.  
										Why:  AspenPointe - Implementation -#184 */ 
/*********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @PaymentArrangementDelinquent CHAR(1)
		DECLARE @ClientId INT

		SELECT TOP 1 @ClientId = ClientId
			,@PaymentArrangementDelinquent = PaymentArrangementDelinquent
		FROM Collections
		WHERE CollectionId = @ScreenKeyId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		DECLARE @FlagTypeId INT
		DECLARE @ClientNoteId INT

		SELECT TOP 1 @FlagTypeId = FlagTypeId
		FROM FlagTypes
		WHERE FlagType = 'Payment arrangement missed, check communications'
			AND ISNULL(RecordDeleted, 'N') = 'N'

		IF ISNULL(@PaymentArrangementDelinquent, 'N') = 'Y'
		BEGIN
			IF @FlagTypeId > 0
			BEGIN
				IF EXISTS (
						SELECT 1
						FROM ClientNotes
						WHERE NoteType = @FlagTypeId
							AND CreatedBy = 'SYSTEM'
						)
				BEGIN
					SELECT TOP 1 @ClientNoteId = ClientNoteId
					FROM ClientNotes
					WHERE NoteType = @FlagTypeId
						AND CreatedBy = 'SYSTEM'

					UPDATE ClientNotes
					SET ModifiedBy = 'SYSTEM'
						,ModifiedDate = GETDATE()
						,ClientId = @ClientId
						,Note = 'Delinquent'
						,Active = 'Y'
						,StartDate = GETDATE()
						,EndDate = NULL
						,RecordDeleted = NULL
						,DeletedBy = NULL
						,DeletedDate = NULL
					WHERE ClientNoteId = @ClientNoteId
				END
				ELSE
				BEGIN
					INSERT INTO [ClientNotes] (
						[CreatedBy]
						,[CreatedDate]
						,[ModifiedBy]
						,[ModifiedDate]
						,[ClientId]
						,[NoteType]
						,[Note]
						,[Active]
						,[StartDate]
						,[EndDate]
						)
					VALUES (
						'SYSTEM'
						,GETDATE()
						,'SYSTEM'
						,GETDATE()
						,@ClientId
						,@FlagTypeId
						,'Delinquent'
						,'Y'
						,GETDATE()
						,NULL
						)
				END
			END
		END
		ELSE
		BEGIN
			IF EXISTS (
					SELECT 1
					FROM ClientNotes
					WHERE NoteType = @FlagTypeId
						AND CreatedBy = 'SYSTEM'
					)
			BEGIN
				UPDATE ClientNotes
				SET RecordDeleted = 'Y'
					,DeletedBy = 'SYSTEM'
					,DeletedDate = GETDATE()
				WHERE NoteType = @FlagTypeId
					AND CreatedBy = 'SYSTEM'
			END
		END
		
		-- Added on 13-Jan-2017 by Irfan
		IF EXISTS (
				SELECT *
				FROM sys.objects
				WHERE object_id = OBJECT_ID(N'[dbo].[scsp_PostUpdateInternalCollections]')
					AND type IN (
						N'P'
						,N'PC'
						)
				)
		BEGIN
			EXEC scsp_PostUpdateInternalCollections @ScreenKeyId
				,@StaffId
				,@CurrentUser
				,@CustomParameters
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'ssp_PostUpdateInternalCollections') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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

