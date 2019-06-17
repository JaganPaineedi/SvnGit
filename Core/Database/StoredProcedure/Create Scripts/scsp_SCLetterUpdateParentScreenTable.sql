/****** Object:  StoredProcedure [dbo].[scsp_SCLetterUpdateParentScreenTable]    Script Date: 08/13/2015 16:12:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCLetterUpdateParentScreenTable]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCLetterUpdateParentScreenTable]
GO

/****** Object:  StoredProcedure [dbo].[scsp_SCLetterUpdateParentScreenTable]    Script Date: 08/13/2015 16:12:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[scsp_SCLetterUpdateParentScreenTable] (
	@ParentTableName VARCHAR(800)
	,@ParentPrimaryKeyName VARCHAR(800)
	,@ParentPrimarykeyValue VARCHAR(800)
	,@LetterId INT
	,@UserCode VARCHAR(100)
	,@PageAction VARCHAR(100)
	)
AS
/*********************************************************************/
/* Stored Procedure: [scsp_SCLetterUpdateParentScreenTable]               */
/* Creation By:  Akwinass                                    */
/* Creation Date:  27/AUG/2015                                    */
/* Purpose: To Perform Custom Manipulation */
/* Input Parameters:   @ParentTableName, @ParentPrimaryKeyName, @ParentPrimarykeyValue, @LetterId, @UserCode, @PageAction*/
/*********************************************************************/
BEGIN TRY
	IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = @ParentTableName)
    BEGIN 
		IF COL_LENGTH(@ParentTableName, @ParentPrimaryKeyName) IS NOT NULL AND COL_LENGTH(@ParentTableName, 'LetterId') IS NOT NULL
		BEGIN		
			IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME = 'CollectionStatusHistory')
			BEGIN
				IF @ParentPrimaryKeyName = 'CollectionId' AND @PageAction = 'LetterNew'
				BEGIN
					DECLARE @CollectionId INT = @ParentPrimarykeyValue
					DECLARE @LetterTemplateId INT
					DECLARE @TemplateName VARCHAR(100)
					DECLARE @ClientId INT
					
					SELECT TOP 1 @ClientId = ClientId
					FROM Collections
					WHERE CollectionId = @CollectionId
						AND ISNULL(RecordDeleted, 'N') = 'N'

					SELECT TOP 1 @LetterTemplateId = LetterTemplateId
					FROM Letters
					WHERE LetterId = @LetterId
						AND ISNULL(RecordDeleted, 'N') = 'N'
						
					SELECT TOP 1 @TemplateName = TemplateName
					FROM LetterTemplates
					WHERE LetterTemplateId = @LetterTemplateId
						AND ISNULL(RecordDeleted, 'N') = 'N'
					
					DECLARE @CollectionStatus INT
							
					IF @TemplateName = 'First Letter Sent'
					BEGIN
						SELECT TOP 1 @CollectionStatus = GlobalCodeId			
						FROM GlobalCodes
						WHERE ISNULL(Category, '') = 'COLLECTIONSTATUS'
							AND ISNULL(Code, '') = 'FLS'
							AND ISNULL(RecordDeleted, 'N') = 'N'
							AND ISNULL(Active, 'N') = 'Y'
					END
					ELSE IF @TemplateName = 'Second Letter Sent'
					BEGIN
						SELECT TOP 1 @CollectionStatus = GlobalCodeId			
						FROM GlobalCodes
						WHERE ISNULL(Category, '') = 'COLLECTIONSTATUS'
							AND ISNULL(Code, '') = 'SLS'
							AND ISNULL(RecordDeleted, 'N') = 'N'
							AND ISNULL(Active, 'N') = 'Y'
					END
					ELSE IF @TemplateName = 'Third Letter Sent'
					BEGIN
						SELECT TOP 1 @CollectionStatus = GlobalCodeId			
						FROM GlobalCodes
						WHERE ISNULL(Category, '') = 'COLLECTIONSTATUS'
							AND ISNULL(Code, '') = 'TLS'
							AND ISNULL(RecordDeleted, 'N') = 'N'
							AND ISNULL(Active, 'N') = 'Y'
					END
					
					IF @CollectionStatus > 0
					BEGIN
						INSERT INTO [CollectionStatusHistory] (
							[CreatedBy]
							,[CreatedDate]
							,[ModifiedBy]
							,[ModifiedDate]
							,[CollectionId]
							,[CollectionDate]
							,[CollectionStatus]
							,[Balance]
							,[IsDeletable]
							)
						VALUES (
							@UserCode
							,GETDATE()
							,@UserCode
							,GETDATE()
							,@CollectionId
							,GETDATE()
							,@CollectionStatus
							,(SELECT TOP 1 CurrentBalance FROM Clients C WHERE C.ClientId = @ClientId AND ISNULL(C.RecordDeleted, 'N') = 'N')
							,'N'
							)
					END

				END
			END		
		END
    END
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'scsp_SCLetterUpdateParentScreenTable') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.      
			16
			,-- Severity.      
			1 -- State.      
			);
END CATCH

GO


