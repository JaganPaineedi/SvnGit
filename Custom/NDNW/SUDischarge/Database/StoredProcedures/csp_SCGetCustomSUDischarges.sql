/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomSUDischarges]    Script Date: 03/10/2015 14:29:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomSUDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomSUDischarges]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomSUDischarges]    Script Date: 03/10/2015 14:29:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[csp_SCGetCustomSUDischarges] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [csp_SCGetCustomSUDischarges]   */
/*       Date              Author                  Purpose                   */
/*       06/MAR/2015      Akwinass               To Retrieve Data           */
-- 23-March-2015 SuryaBalan Copied from Valley New Directions for Task #8 New Directions-Customization
-- 23-March-2015 SuryaBalan Added new Columns Severity1,Severity2,Severity3 Task #8 New Directions-Customization
/*********************************************************************/
BEGIN
	BEGIN TRY
		 SELECT CDSD.[DocumentVersionId]
			,CDSD.[CreatedBy]
			,CDSD.[CreatedDate]
			,CDSD.[ModifiedBy]
			,CDSD.[ModifiedDate]
			,CDSD.[RecordDeleted]
			,CDSD.[DeletedBy]
			,CDSD.[DeletedDate]
			,CDSD.[DateOfDischarge]
			,CDSD.[DischargeReason]
			,CDSD.[SUAdmissionDrugNameOne]
			,CDSD.[SUAdmissionFrequencyOne]
			,CDSD.[SUDischargeFrequencyOne]
			,CDSD.[SUAdmissionDrugNameTwo]
			,CDSD.[SUAdmissionFrequencyTwo]
			,CDSD.[SUDischargeFrequencyTwo]
			,CDSD.[SUAdmissionDrugNameThree]
			,CDSD.[SUAdmissionFrequencyThree]
			,CDSD.[SUDischargeFrequencyThree]
			,CDSD.[SUAdmissionsTobaccoUse]
			,CDSD.[SUDischargeTobaccoUse]
			,CDSD.[LivingArrangement]
			,CDSD.[EmploymentStatus]
			,CDSD.[Education]
			,CDSD.[NumberOfArrests]
			,CDSD.[SocialSupport]
			,GC1.CodeName AS SUAdmissionDrugNameOneText
			,GC2.CodeName AS SUAdmissionFrequencyOneText
			,GC3.CodeName AS SUAdmissionDrugNameTwoText
			,GC4.CodeName AS SUAdmissionFrequencyTwoText
			,GC5.CodeName AS SUAdmissionDrugNameThreeText
			,GC6.CodeName AS SUAdmissionFrequencyThreeText
			,GC7.CodeName AS SUAdmissionsTobaccoUseText
			,CDSD.NumberOfSelfHelpGroupsAttendedLast30Days
			,CDSD.LastFaceToFaceDate
			,CDSD.PreferredUsage1
			,CDSD.DrugName1
			,CDSD.Frequency1
			,CDSD.Route1
			,CDSD.AgeOfFirstUseText1
			,CDSD.AgeOfFirstUse1
			,CDSD.PreferredUsage2
			,CDSD.DrugName2
			,CDSD.Frequency2
			,CDSD.Route2
			,CDSD.AgeOfFirstUseText2
			,CDSD.AgeOfFirstUse2
			,CDSD.PreferredUsage3
			,CDSD.DrugName3
			,CDSD.Frequency3
			,CDSD.Route3
			,CDSD.AgeOfFirstUseText3
			,CDSD.AgeOfFirstUse3
			,CDSD.Severity1
			,CDSD.Severity2
			,CDSD.Severity3

		FROM [CustomDocumentSUDischarges] CDSD
		LEFT JOIN GlobalCodes GC1 ON CDSD.[SUAdmissionDrugNameOne] = GC1.GlobalCodeId
		LEFT JOIN GlobalCodes GC2 ON CDSD.[SUAdmissionFrequencyOne] = GC2.GlobalCodeId		
		LEFT JOIN GlobalCodes GC3 ON CDSD.[SUAdmissionDrugNameTwo] = GC3.GlobalCodeId
		LEFT JOIN GlobalCodes GC4 ON CDSD.[SUAdmissionFrequencyTwo] = GC4.GlobalCodeId		
		LEFT JOIN GlobalCodes GC5 ON CDSD.[SUAdmissionDrugNameThree] = GC5.GlobalCodeId
		LEFT JOIN GlobalCodes GC6 ON CDSD.[SUAdmissionFrequencyThree] = GC6.GlobalCodeId		
		LEFT JOIN GlobalCodes GC7 ON CDSD.[SUAdmissionsTobaccoUse] = GC7.GlobalCodeId		
		WHERE CDSD.DocumentVersionId = @DocumentVersionId
			AND ISNULL(CDSD.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_SCGetCustomSUDischarges') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


