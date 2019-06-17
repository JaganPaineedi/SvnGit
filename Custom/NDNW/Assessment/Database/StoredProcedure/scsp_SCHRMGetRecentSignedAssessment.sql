

/****** Object:  StoredProcedure [dbo].[scsp_SCHRMGetRecentSignedAssessment]    Script Date: 02/03/2015 13:29:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCHRMGetRecentSignedAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCHRMGetRecentSignedAssessment]
GO


/****** Object:  StoredProcedure [dbo].[scsp_SCHRMGetRecentSignedAssessment]    Script Date: 02/03/2015 13:29:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[scsp_SCHRMGetRecentSignedAssessment] (
	@ClientId INT
	,@AssessmentType CHAR
	,@LatestDocumentVersionID INT
	,@ClientAge VARCHAR(50)
	,@AxisIAxisIIOut VARCHAR(100)
	,@InitialRequestDate DATETIME
	,@ClientDOB VARCHAR(50)
	,@CurrentAuthorId INT
	)
AS
/*********************************************************************/
/* Stored Procedure: [[[scsp_SCHRMGetRecentSignedAssessment]]]   */
/* Copyright: 2006 Streamline SmartCare            */
/* Creation Date:  24/Feb/2010               */
/*                      */
/* Purpose: To Initialize CustomPAAssessments Documents        */
/*                      */
/* Input Parameters:  @ClientID, @AxisIAxisIIOut, @clientAge,@LatestDocumentVersionID,@AssessmentType   eg:- 14309,92,'N'    */
/* Output Parameters:                 */
/* Return:                    */
/* Called By:CustomDocuments Class Of DataService          */
/* Calls:                    */
/*                      */
/* Data Modifications:           */
/*                      */
/*   Updates:       */
/*       Date              Author               Purpose             */
/*       Sandeep Singh       */
/*  3rd Nov2011   Rakesh garg Comment the DiagnosesV_InitializeProcess  w.r.f to task 383 in Sc web phase II bugs/Features As Axis need not pencil */
/**********************************************************************/
BEGIN
	BEGIN TRY
		SET NOCOUNT ON

		DECLARE @ClientAgeNum VARCHAR(50)

		SET @ClientAgeNum = Substring(@ClientAge, 1, CHARINDEX(' ', @ClientAge))

		IF (@AssessmentType = 'U')
		BEGIN
			--Find Any latest signed DocumentVersionId for this Client                                                       
			EXEC csp_GetRecentSignedHRMAsssessment @ClientID
				,@AxisIAxisIIOut
				,@ClientAge
				,@AssessmentType
				,@LatestDocumentVersionId
				,@InitialRequestDate
				,@ClientDOB
				,@CurrentAuthorId
		END
		ELSE
			IF (@AssessmentType = 'A')
			BEGIN
				EXEC csp_GetRecentSignedHRMAsssessment @ClientID
					,@AxisIAxisIIOut
					,@ClientAge
					,@AssessmentType
					,@LatestDocumentVersionId
					,@InitialRequestDate
					,@ClientDOB
					,@CurrentAuthorId

			END
			ELSE
				IF (@AssessmentType = 'I')
				BEGIN
					--Check for a previous signed HRM assessment of type “Screen” effective within CustomConfigurations.ScreenAssessmentExpirationDays of the current assessment                                          
					DECLARE @LatestDocumentVersionIDForScreenTypeAssessment INT
					DECLARE @LatestDocumentVersionIDForScreenTypeAssessmentEffectiveDate DATETIME
					DECLARE @ScreenTypeAssessment CHAR(1)
					DECLARE @DocumentExpiryDate DATETIME

					SET @LatestDocumentVersionIDForScreenTypeAssessment = - 1

					DECLARE @ScreenAssessmentExpirationDays INT

					SELECT @ScreenAssessmentExpirationDays = ScreenAssessmentExpirationDays
					FROM CustomConfigurations

					SET @LatestDocumentVersionIDForScreenTypeAssessment = (
							SELECT TOP 1 ISNULL(DocumentVersionId, 0)
							FROM CustomHRMAssessments C
								,Documents D
							WHERE C.DocumentVersionId = D.CurrentDocumentVersionId
								AND D.ClientId = @ClientID
								AND C.AssessmentType = 'S'
								AND D.STATUS = 22
								AND IsNull(C.RecordDeleted, 'N') = 'N'
								AND IsNull(D.RecordDeleted, 'N') = 'N'
							ORDER BY D.EffectiveDate DESC
							)

					SELECT @LatestDocumentVersionIDForScreenTypeAssessmentEffectiveDate = EffectiveDate
					FROM Documents
					WHERE CurrentDocumentVersionId = @LatestDocumentVersionIDForScreenTypeAssessment

					SET @ScreenTypeAssessment = 'N'

					IF (
							@ScreenAssessmentExpirationDays > 0
							AND ISNULL(@LatestDocumentVersionIDForScreenTypeAssessment, 0) > 0
							)
					BEGIN
						--Calculate Expiry Date                                          
						SELECT @DocumentExpiryDate = DATEADD(DAY, @ScreenAssessmentExpirationDays, @LatestDocumentVersionIDForScreenTypeAssessmentEffectiveDate)

						IF (GETDATE() <= @DocumentExpiryDate)
						BEGIN
							SET @ScreenTypeAssessment = 'Y'
						END
						ELSE -- In case Expiry Calculation                                          
						BEGIN
							SET @ScreenTypeAssessment = 'N'
						END
					END

					IF (@ScreenTypeAssessment = 'Y')
						--- Get Last Signed Screen Type Assessment                                          
					BEGIN
						EXEC csp_GetRecentSignedHRMAsssessment @ClientID
							,@AxisIAxisIIOut
							,@ClientAge
							,@AssessmentType
							,@LatestDocumentVersionIDForScreenTypeAssessment
							,@InitialRequestDate
							,@ClientDOB
							,@CurrentAuthorId
					END
					ELSE -- Get Default Intialization                                          
					BEGIN
						EXEC csp_InitCustomHRMAssessmentDefaultIntialization @ClientId
							,@AxisIAxisIIOut
							,@ClientAge
							,@AssessmentType
							,@InitialRequestDate
							,@LatestDocumentVersionID
							,@ClientDOB
							,@CurrentAuthorId
					END
				END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'csp_InitCustomHRMAssessmentsStandardInitialization') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

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


