/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryGeneral]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_RDLClinicalSummaryGeneral'
		)
	DROP PROCEDURE [dbo].[ssp_RDLClinicalSummaryGeneral]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummaryGeneral]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummaryGeneral] @ServiceId INT = NULL
	,@ClientId INT = NULL
	,@DocumentVersionId INT = NULL
AS
/******************************************************************************          
**  File: ssp_RDLClinicalSummaryGeneral.sql          
**  Name: ssp_RDLClinicalSummaryGeneral  3368506        
**  Desc: Provides general client information for the Clinical Summary and CCR/CCD          
**          
**  Return values: <Return Values>          
**          
**  Called by: <Code file that calls>          
**          
**  Parameters:          
**  Input   Output          
**  ServiceId      -----------          
**          
**  Created By: Veena S Mani          
**  Date:  Feb 25 2014          
*******************************************************************************          
**  Change History          
*******************************************************************************          
**  Date:  Author:    Description:          
**  -------- --------   -------------------------------------------          
**  02/05/2014  Veena S Mani  Added parameters ClientId and EffectiveDate-Meaningful Use #18           
**  19/05/2014  Veena S Mani        Added parameters DocumentId and removed EffectiveDate to make SP reusable for MeaningfulUse #7,#18 and #24.Also added the logic for the same.                      
**  14/05/2014  Veena S Mani        Taking values from Appointments,if the ProgressNote is associated to the appointment.        
    03/09/2014  Revathi             what:check RecordDeleted , avoid Ambiguous column        
                                    why:task#36 MeaningfulUse               
 02/03/2016  Ravichandra   what: format  MainPhone like (XXX) XXX-XXXX        
         why: Meaningful Use Stage 2 Tasks#48 Clinial Summary - PDF Issues     
 09/10/2017  Ravichandra   what:   corrected the MainPhone format        
         why: Meaningful Use Stage 3 Tasks#24.5 Clinial Summary - PDF Issues
 12/12/2017 Ravichandra		  changes done for new requirement 
						  Meaningful Use Stage 3 task 68 - Summary of Care    
23/07/2018  Ravichandra		What:  casting to a date type for EnrolledDate and DischargedDate
							Why : KCMHSAS - Support  #1099 Summary of Care - issues (summary for all bugs)            
--------  --------    -------------------------------------------                   
*******************************************************************************/
BEGIN
	SET NOCOUNT ON;

	DECLARE @ProgramId INT
	DECLARE @FromDate DATE
		,@ToDate DATE

	BEGIN TRY
		SELECT TOP 1 @FromDate = cast(FromDate AS DATE)
			,@ToDate = cast(ToDate AS DATE)
		FROM TransitionOfCareDocuments
		WHERE ISNULL(RecordDeleted, 'N') = 'N'
			AND DocumentVersionId = @DocumentVersionId

		SELECT TOP 1 @ProgramId = CP.ProgramId
		FROM ClientPrograms CP
		WHERE CP.ClientId = (
				SELECT TOP 1 ClientId
				FROM Documents
				WHERE InProgressDocumentVersionId = @DocumentVersionId
					AND ISNULL(RecordDeleted, 'N') = 'N'
				)
			AND PrimaryAssignment = 'Y'
			
			--23/07/2018  Ravichandra
			AND (
				(
					@FromDate >= CAST(CP.EnrolledDate AS DATE)
					AND (
						CP.DischargedDate IS NULL
						OR (
							CAST(CP.DischargedDate AS DATE) <= @ToDate
							AND CAST(CP.DischargedDate AS DATE) >= @FromDate
							)
						)
					)
				OR (
					@FromDate <= CAST(CP.EnrolledDate AS DATE)
					AND CAST(CP.EnrolledDate AS DATE) <= @ToDate
					)
				OR (
					@FromDate <= CAST(CP.EnrolledDate AS DATE)
					AND (
						CP.DischargedDate IS NULL
						OR CAST(CP.DischargedDate AS DATE) >= @ToDate
						)
					)
				)
			AND Isnull(CP.RecordDeleted, 'N') = 'N'

		SELECT A.AgencyName AS OrganizationName
			,P.City
			,P.Address + ' ' + P.City + ' ' + P.STATE + ' ' + P.ZipCode AS AgencyAddress --ProgramAddress      
			,CASE 
				WHEN ISNULL(P.IntakePhoneText, '') <> ''
					THEN '(' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(P.IntakePhoneText, '(', ''), ')', ''), '-', ''), ' ', ''), 1, 3) + ')' + ' ' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(P.IntakePhoneText, '(', ''), ')', ''), '-', ''), ' ', ''), 4, 3) --09/10/2017  Ravichandra  
						+ '-' + SUBSTRING(REPLACE(REPLACE(REPLACE(REPLACE(P.IntakePhoneText, '(', ''), ')', ''), '-', ''), ' ', ''), 7, 4)
				ELSE ''
				END AS MainPhone
			,'' AS DATE --CONVERT(VARCHAR(10), S.StartTime, 101) AS DATE        
			,SF1.Lastname + ', ' + SF1.FirstName AS ProgramCoordinator
			,SF.Name AS Provider
		FROM agency A
		CROSS JOIN Documents D
		CROSS JOIN Programs P
		LEFT JOIN Staff SF1 ON SF1.Staffid = P.ProgramManager
		LEFT JOIN ClientPrimaryCareReferrals CP1 ON CP1.ClientId = D.ClientId
			AND ISNULL(CP1.RecordDeleted, 'N') = 'N'
		LEFT JOIN ExternalReferralProviders SF ON SF.ExternalReferralProviderId = CP1.ProviderName
		WHERE (D.InProgressDocumentVersionId = @DocumentVersionId)
			AND P.ProgramId = @ProgramId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClinicalSummaryGeneral') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.          
				16
				,-- Severity.          
				1 -- State.          
				);
	END CATCH
END
