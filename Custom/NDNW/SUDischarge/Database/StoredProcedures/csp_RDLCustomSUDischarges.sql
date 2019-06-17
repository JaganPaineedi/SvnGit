/****** Object:  StoredProcedure [dbo].[csp_RDLCustomSUDischarges]    Script Date: 10/15/2014 18:27:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomSUDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomSUDischarges]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLCustomSUDischarges]    Script Date: 10/15/2014 18:27:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_RDLCustomSUDischarges] (@DocumentVersionId INT)
AS
/*************************************************************************************/
/* Stored Procedure: [csp_RDLCustomSUDischarges]                                 */
/* Creation Date:  FEB 25th ,2015                                                    */
/* Purpose: Gets Data from CustomDocumentDayPrograms   */
/* Input Parameters: @DocumentVersionId                                              */
/* Purpose: Use For Rdl Report                                                       */
/* Author: Akwinass                                                                  */
-- 23-March-2015 SuryaBalan Copied from Valley New Directions for Task #8 New Directions-Customization
-- 23-March-2015 SuryaBalan Added 2 fields NumberOfSelfHelpGroupsAttendedLast30Days,LastFaceToFaceDate from Valley New Directions for Task #8 New Directions-Customization
/*************************************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @OrganizationName VARCHAR(250)
		DECLARE @ClientName VARCHAR(100)
		DECLARE @ClinicianName VARCHAR(100)
		DECLARE @ClientID INT
		DECLARE @EffectiveDate VARCHAR(10)
		DECLARE @DOB VARCHAR(10)
		DECLARE @DocumentName  VARCHAR(100)
		
		SELECT TOP 1 @OrganizationName = OrganizationName
		FROM SystemConfigurations
		
		SELECT @ClientName = C.LastName + ', ' + C.FirstName
			,@ClinicianName = S.LastName + ', ' + S.FirstName + ' ' + isnull(GC.CodeName, '')
			,@ClientID = Documents.ClientID
			,@EffectiveDate = CASE 
				WHEN Documents.EffectiveDate IS NOT NULL
					THEN CONVERT(VARCHAR(10), Documents.EffectiveDate, 101)
				ELSE ''
				END
			,@DOB = CASE 
				WHEN C.DOB IS NOT NULL
					THEN CONVERT(VARCHAR(10), C.DOB, 101)
				ELSE ''
				END
			,@DocumentName = DocumentCodes.DocumentName 
		FROM Documents
		JOIN Staff S ON Documents.AuthorId = S.StaffId
		JOIN Clients C ON Documents.ClientId = C.ClientId
			AND isnull(C.RecordDeleted, 'N') <> 'Y'
		JOIN DocumentVersions dv ON dv.DocumentId = documents.DocumentId
		INNER JOIN DocumentCodes on DocumentCodes.DocumentCodeid= Documents.DocumentCodeId      
			AND ISNULL(DocumentCodes.RecordDeleted,'N')='N' 
		LEFT JOIN GlobalCodes GC ON S.Degree = GC.GlobalCodeId
		WHERE dv.DocumentVersionId = @DocumentVersionId
			AND isnull(Documents.RecordDeleted, 'N') = 'N'
				
		SELECT ISNULL(@OrganizationName, '') AS OrganizationName
			,ISNULL(@DocumentName, '') AS DocumentName
			,ISNULL(@ClientName, '') AS ClientName
			,ISNULL(@ClinicianName, '') AS ClinicianName
			,ISNULL(@ClientID, '') AS ClientID
			,ISNULL(@EffectiveDate, '') AS EffectiveDate
			,ISNULL(@DOB, '') AS DOB
			,CASE 
				WHEN DateOfDischarge IS NOT NULL
					THEN CONVERT(VARCHAR(10), DateOfDischarge, 101)
				ELSE ''
				END DateOfDischarge
			,ISNULL(GC1.CodeName,'') AS DischargeReason
			,ISNULL(GC2.CodeName,'') AS SUAdmissionDrugNameOne
			,ISNULL(GC3.CodeName,'') AS SUAdmissionFrequencyOne
			,ISNULL(GC4.CodeName,'') AS SUDischargeFrequencyOne
			,ISNULL(GC5.CodeName,'') AS SUAdmissionDrugNameTwo
			,ISNULL(GC6.CodeName,'') AS SUAdmissionFrequencyTwo
			,ISNULL(GC7.CodeName,'') AS SUDischargeFrequencyTwo
			,ISNULL(GC8.CodeName,'') AS SUAdmissionDrugNameThree
			,ISNULL(GC9.CodeName,'') AS SUAdmissionFrequencyThree
			,ISNULL(GC10.CodeName,'') AS SUDischargeFrequencyThree
			,ISNULL(GC11.CodeName,'') AS SUAdmissionsTobaccoUse
			,ISNULL(GC12.CodeName,'') AS SUDischargeTobaccoUse
			,ISNULL(GC13.CodeName,'') AS LivingArrangement
			,ISNULL(GC14.CodeName,'') AS EmploymentStatus
			,ISNULL(GC15.CodeName,'') AS Education
			,CAST(NumberOfArrests AS VARCHAR(10)) AS NumberOfArrests
			,ISNULL(GC16.CodeName,'') AS SocialSupport
			,NumberOfSelfHelpGroupsAttendedLast30Days
			,CASE 
				WHEN LastFaceToFaceDate IS NOT NULL
					THEN CONVERT(VARCHAR(10), LastFaceToFaceDate, 101)
				ELSE ''
				END LastFaceToFaceDate			
			
		FROM CustomDocumentSUDischarges CDSD
		LEFT JOIN GlobalCodes GC1 ON CDSD.DischargeReason = GC1.GlobalCodeId
		LEFT JOIN GlobalCodes GC2 ON CDSD.SUAdmissionDrugNameOne = GC2.GlobalCodeId
		LEFT JOIN GlobalCodes GC3 ON CDSD.SUAdmissionFrequencyOne = GC3.GlobalCodeId
		LEFT JOIN GlobalCodes GC4 ON CDSD.SUDischargeFrequencyOne = GC4.GlobalCodeId
		LEFT JOIN GlobalCodes GC5 ON CDSD.SUAdmissionDrugNameTwo = GC5.GlobalCodeId
		LEFT JOIN GlobalCodes GC6 ON CDSD.SUAdmissionFrequencyTwo = GC6.GlobalCodeId
		LEFT JOIN GlobalCodes GC7 ON CDSD.SUDischargeFrequencyTwo = GC7.GlobalCodeId
		LEFT JOIN GlobalCodes GC8 ON CDSD.SUAdmissionDrugNameThree = GC8.GlobalCodeId
		LEFT JOIN GlobalCodes GC9 ON CDSD.SUAdmissionFrequencyThree = GC9.GlobalCodeId
		LEFT JOIN GlobalCodes GC10 ON CDSD.SUDischargeFrequencyThree = GC10.GlobalCodeId
		LEFT JOIN GlobalCodes GC11 ON CDSD.SUAdmissionsTobaccoUse = GC11.GlobalCodeId
		LEFT JOIN GlobalCodes GC12 ON CDSD.SUDischargeTobaccoUse = GC12.GlobalCodeId
		LEFT JOIN GlobalCodes GC13 ON CDSD.LivingArrangement = GC13.GlobalCodeId
		LEFT JOIN GlobalCodes GC14 ON CDSD.EmploymentStatus = GC14.GlobalCodeId
		LEFT JOIN GlobalCodes GC15 ON CDSD.Education = GC15.GlobalCodeId
		LEFT JOIN GlobalCodes GC16 ON CDSD.SocialSupport = GC16.GlobalCodeId
		WHERE CDSD.DocumentVersionId = @DocumentVersionId
			AND isnull(CDSD.RecordDeleted, 'N') = 'N'

	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLCustomSUDischarges') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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