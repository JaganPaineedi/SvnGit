/****** Object:  StoredProcedure [dbo].[csp_PostSignatureUpdateAssessmentSafetyCrisisPlan]    Script Date: 12/08/2014 12:45:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_PostSignatureUpdateAssessmentSafetyCrisisPlan]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_PostSignatureUpdateAssessmentSafetyCrisisPlan]
GO

/****** Object:  StoredProcedure [dbo].[csp_PostSignatureUpdateAssessmentSafetyCrisisPlan]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_PostSignatureUpdateAssessmentSafetyCrisisPlan] (@DocumentVersionId INT)
AS
/******************************************************************** */
/* Stored Procedure: [csp_PostSignatureUpdateAssessmentSafetyCrisisPlan]                   */
/* Creation Date:  24/FEB/2015                                        */
/* Purpose: To Initialize                                             */
/* Called By: Safety/Crisis Plan Post signature updates                             */
/* Calls:                                                             */
/*                                                                    */
/* Data Modifications:                                                */
/*   Updates:                                                         */
/*  24/FEB/2015 	SuryaBalan		Post update SP for Safety/Crisis Plan Document  */
/*  19/March/2015 	SuryaBalan Added csp_CreateMessageAndAlertForSafetyCrisisPlanReview for Alert Messages*/
/**********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @ClientId INT
		DECLARE @ToDoDocumentId INT
		DECLARE @CurrentUserId VARCHAR(20)
		DECLARE @CurrentUserCode VARCHAR(20)
		DECLARE @AssignedTo INT
		DECLARE @ToDoEffectiveDate DATETIME
		DECLARE @ToDoDueDate DATETIME
		DECLARE @DocumentCodeId INT
		DECLARE @EffectiveDate DATETIME
		DECLARE @ToDoDocumentVersionId INT
		DECLARE @DocumentId INT
		DECLARE @SignerCount INT

		SELECT TOP 1 @ClientId = ClientId
			,@EffectiveDate = EffectiveDate
			,@DocumentCodeId = DocumentCodeId
			,@AssignedTo = AuthorId
			,@DocumentId = DocumentId
		FROM Documents
		WHERE CurrentDocumentVersionid = @DocumentVersionId
		
		SELECT @SignerCount = COUNT(1)
		FROM DocumentSignatures ds
		WHERE ds.DocumentId = @DocumentId
			AND ds.SignatureDate IS NOT NULL
			AND ISNULL(ds.RecordDeleted, 'N') = 'N'

		IF @SignerCount = 1
		BEGIN
			IF (SELECT TOP 1 PrimaryClinicianId FROM Clients WHERE ClientId = @ClientId) IS NOT NULL
			BEGIN
				SELECT TOP 1 @AssignedTo = PrimaryClinicianId
				FROM Clients
				WHERE ClientId = @ClientId
			END
            DECLARE @DateReviewed DATETIME
            DECLARE @ReviewEveryXDays INT
            DECLARE @SafetyCrisisPlanReviewed CHAR(1)
            
            SELECT TOP 1 @SafetyCrisisPlanReviewed = CDSAS.SafetyCrisisPlanReviewed
            FROM CustomSafetyCrisisPlanReviews CDSAS
            WHERE CDSAS.DocumentVersionId = @DocumentVersionId
				AND isnull(CDSAS.RecordDeleted, 'N') = 'N'
				
			 SELECT TOP 1 @ReviewEveryXDays = CDSAS.ReviewEveryXDays,@DateReviewed= CDSAS.DateReviewed
            FROM CustomSafetyCrisisPlanReviews CDSAS
            WHERE CDSAS.DocumentVersionId = @DocumentVersionId
				AND isnull(CDSAS.RecordDeleted, 'N') = 'N'
            
            IF(@SafetyCrisisPlanReviewed !='')
            BEGIN 
				IF(@SafetyCrisisPlanReviewed = 'Y' and @ReviewEveryXDays is not null) --SafetyPlan Based
				BEGIN
				 SET @ToDoEffectiveDate = (SELECT DATEADD(day, @ReviewEveryXDays, @EffectiveDate))
				END
				
				ELSE IF (@SafetyCrisisPlanReviewed = 'N' and @ReviewEveryXDays is not null) --CrisisPlan Based
				BEGIN
				  SET @ToDoEffectiveDate = (SELECT DATEADD(day, @ReviewEveryXDays, @EffectiveDate))
				END
            END
			

			IF @ToDoEffectiveDate IS NOT NULL --AND @ToDoDueDate IS NOT NULL
			BEGIN
				IF NOT EXISTS (
						SELECT DocumentId
						FROM Documents
						WHERE [Status] = 20
							AND documentcodeid = 10018
							AND CAST(EffectiveDate AS DATE) = CAST(@ToDoEffectiveDate AS DATE)
						)
				BEGIN
				 EXEC csp_CreateMessageAndAlertForSafetyCrisisPlanReview @DocumentVersionId,@AssignedTo  
				 
					INSERT INTO Documents (
						ClientId
						,DocumentCodeId
						,EffectiveDate
						--,DueDate
						,[Status]
						,AuthorId
						,DocumentShared
						,SignedByAuthor
						,SignedByAll
						,ToSign
						,CurrentVersionStatus
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						)
					VALUES (
						@ClientId
						,@DocumentCodeId
						,CONVERT(DATE, @ToDoEffectiveDate, 101)
						--,CONVERT(DATE, @ToDoDueDate, 101)
						,20
						,@AssignedTo
						,'Y'
						,'N'
						,'N'
						,NULL
						,20
						,'SYSTEM'
						,GETDATE()
						,'SYSTEM'
						,GETDATE()
						)

					SET @ToDoDocumentId = @@IDENTITY

					-- Insert new document version  
					INSERT INTO DocumentVersions (
						DocumentId
						,Version
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						,ModifiedDate
						)
					VALUES (
						@ToDoDocumentId
						,1
						,'SYSTEM'
						,GETDATE()
						,'SYSTEM'
						,GETDATE()
						)

					SET @ToDoDocumentVersionId = @@IDENTITY

					-- Insert new CustomDocumentReleaseOfInformations   
					INSERT INTO CustomDocumentStandAloneSafetyCrisisPlans ( --CustomDocumentASAMs
						DocumentVersionId
						,ModifiedDate
						,CreatedBy
						,CreatedDate
						,ModifiedBy
						)
					VALUES (
						@ToDoDocumentVersionId
						,GETDATE()
						,'SYSTEM'
						,GETDATE()
						,'SYSTEM'
						)

					-- Set document current and in progress document version id to newly created document version id  
					UPDATE d
					SET CurrentDocumentVersionId = @ToDoDocumentVersionId
						,InProgressDocumentVersionId = @ToDoDocumentVersionId
					FROM Documents d
					WHERE d.DocumentId = @ToDoDocumentId
				END
			END
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomRegistrations') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


