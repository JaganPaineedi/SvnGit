/****** Object:  StoredProcedure [dbo].[ssp_RDLTransitionCareSummaryMain]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_RDLTransitionCareSummaryMain'
		)
	DROP PROCEDURE [dbo].[ssp_RDLTransitionCareSummaryMain]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLTransitionCareSummaryMain]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLTransitionCareSummaryMain] (
	@ClientId INT = NULL
	,@Type VARCHAR(10) = NULL
	,@DocumentVersionId INT = NULL
	,@FromDate DATETIME = NULL
	,@ToDate DATETIME = NULL
	,@JsonResult VARCHAR(MAX) = NULL OUTPUT
	)
AS
/******************************************************************************              
**  File: ssp_RDLTransitionCareSummaryMain.sql              
**  Name: ssp_RDLTransitionCareSummaryMain  3368564              
**  Desc: Provides general client information for the Clinical Summary              
**              
**  Return values:              
**              
**  Called by:              
**              
**  Parameters:              
**  Input   Output              
**  ClientId      -----------              
**              
**  Created By: Veena S Mani              
**  Date:  Apr 22 2014              
*******************************************************************************              
**  Change History              
*******************************************************************************              
**  Date:   Author:    Description:              
    19/05/14  Veena S Mani      Created              
                  
    DATE:   Modified By:   Description:              
    05/04/2017  Sunil.D    To get Client Name and DOB for client in RDL RDLTransitionCareSummaryMain Footer.              
          #1060 Renaissance Dev Items              
   DATE:   Modified By:   Description:                 
   12/12/2017 Ravi		  changes done for new requirement 
						  Meaningful Use Stage 3 task 68 - Summary of Care               
**  --------  --------    -------------------------------------------    
**  23/07/2018	Ravi	What: added System Configuration keys for  Visibility settings on the report
								Why : KCMHSAS - Support  #1099 Summary of Care - issues (summary for all bugs)   
**  16/11/2018	Ravi	What: added @NoKnownAllergies variables  for  Visibility settings on the report of allergies 
								Why : Journey-Support Go Live > Tasks #353> SC: Summary of Care: Allergies - PDF not pulling 'No Known Allergies' correctly     
*******************************************************************************/
BEGIN
	SET NOCOUNT ON;

	BEGIN TRY
		----Added by Sunil.D------               
		DECLARE @Client VARCHAR(250)
		DECLARE @DOB VARCHAR(50)
		DECLARE @TransitionType CHAR(1)
		DECLARE @Startdate DATE
			,@EndDate DATE
		DECLARE @StaffName VARCHAR(500)
		DECLARE @Provider VARCHAR(500)
		DECLARE @ConfidentialityCode VARCHAR(50)
		DECLARE @ConfidentialityCodeText VARCHAR(max)
		DECLARE @Location VARCHAR(100)

		DECLARE @NoKnownAllergies CHAR(1) 
		SELECT TOP 1 @Location = CASE 
				WHEN T.LocationId = - 1
					THEN 'All Locations'
				WHEN ISNULL(T.LocationId, 0) <> 0
					THEN L.LocationName
				ELSE ''
				END
		FROM TransitionOfCareDocuments T
		LEFT JOIN Locations L ON T.LocationId = L.LocationId
		WHERE T.DocumentVersionId = @DocumentVersionId

		SELECT TOP 1 @Client = (
				CASE 
					WHEN ISNULL(C.ClientType, 'I') = 'I'
						THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
					ELSE ISNULL(C.OrganizationName, '')
					END
				)
			,@NoKnownAllergies=ISNULL(C.NoKnownAllergies,'N')
			,@DOB = CONVERT(VARCHAR(10), c.DOB, 101)
			,@TransitionType = T.TransitionType
			,@Startdate = cast(FromDate AS DATE)
			,@EndDate = cast(ToDate AS DATE)
			,@StaffName = ISNULL(S.Firstname, '') + ' ' + ISNULL(S.LastName, '')
			,@ConfidentialityCode = CASE 
				WHEN ISNULL(T.ConfidentialityCode, '') = 'N'
					THEN 'Normal'
				WHEN ISNULL(T.ConfidentialityCode, '') = 'R'
					THEN 'Restricted'
				WHEN ISNULL(T.ConfidentialityCode, '') = 'V'
					THEN 'Very Restricted'
				ELSE ''
				END
			,@ConfidentialityCodeText = CASE 
				WHEN ISNULL(T.ConfidentialityCode, '') = 'N'
					THEN (
							SELECT Value
							FROM SystemConfigurationKeys
							WHERE [Key] = 'TextForNormalConfidentialityCodeOnSummaryOfCare'
							)
				WHEN ISNULL(T.ConfidentialityCode, '') = 'R'
					THEN (
							SELECT Value
							FROM SystemConfigurationKeys
							WHERE [Key] = 'TextForRestrictedConfidentialityCodeOnSummaryOfCare'
							)
				WHEN ISNULL(T.ConfidentialityCode, '') = 'V'
					THEN (
							SELECT Value
							FROM SystemConfigurationKeys
							WHERE [Key] = 'TextForVeryRestrictedConfidentialityCodeOnSummaryOfCare'
							)
				ELSE ''
				END
			,@Provider = ISNULL(SS.LastName, '') + ' ' + ISNULL(SS.Firstname, '')
		FROM Documents D
		INNER JOIN Clients C ON C.ClientId = D.ClientId
		JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = D.InProgressDocumentVersionId
		LEFT JOIN Staff S ON S.StaffId = D.AuthorId
		LEFT JOIN Staff SS ON SS.StaffId = T.ProviderId
		WHERE InProgressDocumentVersionId = @DocumentVersionId
			AND IsNull(D.RecordDeleted, 'N') = 'N'
			AND IsNull(C.RecordDeleted, 'N') = 'N'

		-----------              
		SELECT c.ClientId
			---Added by Sunil.D               
			,@Client AS ClientName
			,@DOB AS DOB
			,@TransitionType AS TransitionType
			,CASE 
				WHEN ISNULL(@TransitionType, '') = 'I'
					THEN 'Inpatient'
				WHEN ISNULL(@TransitionType, '') = 'O'
					THEN 'Outpatient'
				WHEN ISNULL(@TransitionType, '') = 'P'
					THEN 'Primary Care'
				ELSE ''
				END AS Transition
			,CONVERT(VARCHAR(10), @Startdate, 101) AS Startdate
			,CONVERT(VARCHAR(10), @EndDate, 101) AS EndDate
			,@StaffName AS AuthorName
			,@ConfidentialityCode AS ConfidentialityCode
			,@ConfidentialityCodeText AS ConfidentialityCodeText
			,'Treatment' AS PurposeOfUse
			,@Provider AS Provider
			,DC.DocumentName
			,DC.DocumentCodeId
			,@Location AS Location
			,@NoKnownAllergies AS NoKnownAllergies
			-------------              
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareSummaryGeneralInfo'
				) AS ShowTransitionCareSummaryGeneralInfo
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareSummaryClientInfo'
				) AS ShowTransitionCareSummaryClientInfo
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowSummaryOfCareAuthorOfDocument'
				) AS ShowSummaryOfCareAuthorOfDocument
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareSummaryCareTeam'
				) AS ShowTransitionCareSummaryCareTeam
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareSummaryDiagnosis'
				) AS ShowTransitionCareSummaryDiagnosis
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareSummaryVitals'
				) AS ShowTransitionCareSummaryVitals
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareSummaryAllergies'
				) AS ShowTransitionCareSummaryAllergies
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareSummarySmokingStatus'
				) AS ShowTransitionCareSummarySmokingStatus
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareSummaryCurrentMedication'
				) AS ShowTransitionCareSummaryCurrentMedication
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareSummaryImmunizations'
				) AS ShowTransitionCareSummaryImmunizations
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareSummaryRadiologyResultReviewed'
				) AS ShowTransitionCareSummaryRadiologyResultReviewed
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareSummaryProcedure'
				) AS ShowTransitionCareSummaryProcedure
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareFunctionalStatus'
				) AS ShowTransitionCareFunctionalStatus
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareCognitiveStatus'
				) AS ShowTransitionCareCognitiveStatus
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareAssessmentandPlanTreatment'
				) AS ShowTransitionCareAssessmentandPlanTreatment
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareOutpatientVisitInfo'
				) AS ShowTransitionCareOutpatientVisitInfo
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionInpatientVisitInfo'
				) AS ShowTransitionInpatientVisitInfo
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareUDI'
				) AS ShowTransitionCareUDI
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareSummaryMostRecentLevelofFunctioning'
				) AS ShowTransitionCareSummaryMostRecentLevelofFunctioning
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareSummaryReasonforReferral'
				) AS ShowTransitionCareSummaryReasonforReferral
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareSummaryGoalsObjectives'
				) AS ShowTransitionCareSummaryGoalsObjectives
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowEncounterEventDocumentationOnSummaryOfCare'
				) AS ShowEncounterEventDocumentationOnSummaryOfCare
				
				--23/07/2018	Ravi
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareSummaryFamilyHistory'
				) AS ShowTransitionCareSummaryFamilyHistory
				
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareSummaryDiagnosticImagingReports'
				) AS ShowTransitionCareSummaryDiagnosticImagingReports
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareAdmissionDiagnosis'
			) AS ShowTransitionCareAdmissionDiagnosis	
			
			,(
				SELECT value
				FROM systemconfigurationkeys
				WHERE [key] = 'ShowTransitionCareHospitalCourse'
			) AS ShowTransitionCareHospitalCourse	
			
			,(
			SELECT value
			FROM systemconfigurationkeys
			WHERE [key] = 'ShowTransitionCareDischargeDiagnosis'
			) AS ShowTransitionCareDischargeDiagnosis	
			
		 ,(
			SELECT value
			FROM systemconfigurationkeys
			WHERE [key] = 'ShowTransitionCareDischargeMedications'
			) AS ShowTransitionCareDischargeMedications	
			
		FROM Documents C
		INNER JOIN DocumentCodes DC ON DC.DocumentCodeId = C.DocumentCodeId
		WHERE C.InProgressDocumentVersionId = @DocumentVersionId
			AND ISNULL(C.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_RDLTransitionCareSummaryMain') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,16
				,1
				);
	END CATCH
END
