/****** Object:  StoredProcedure [dbo].[csp_InitCustomSUDischarges]    Script Date: 06/30/2014 18:06:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitCustomSUDischarges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitCustomSUDischarges]
GO

/****** Object:  StoredProcedure [dbo].[csp_InitCustomSUDischarges]    Script Date: 06/30/2014 18:06:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[csp_InitCustomSUDischarges] (
	@ClientID INT
	,@StaffID INT
	,@CustomParameters XML
	)
AS
-- =============================================    
-- Author      : Akwinass.D 
-- Date        : 06/MAR/2015  
-- Purpose     : Initializing SP Created. 
-- 23-March-2015 SuryaBalan Copied from Valley New Directions for Task #8 New Directions-Customization
-- 20-May-2015   SuryaBalan Copied from Valley New Directions for Task #8.01 New Directions-Customization
--Fixed -In the SU discharge document, the last face to face contact should be pulling in from the last date of service in the 
--client record where the status is complete. It is not pulling forward even though there are several completed services in the client record.
-- =============================================   
BEGIN
	BEGIN TRY
	DECLARE @LatestDocumentVersionID INT
	
	SELECT TOP 1 @LatestDocumentVersionID = CurrentDocumentVersionId
	FROM CustomDocumentSUDischarges CDCD
	INNER JOIN Documents Doc ON CDCD.DocumentVersionId = Doc.CurrentDocumentVersionId
	WHERE Doc.ClientId = @ClientID
		AND Doc.[Status] = 22
		AND ISNULL(CDCD.RecordDeleted, 'N') = 'N'
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
	ORDER BY Doc.EffectiveDate DESC
		,Doc.ModifiedDate DESC
			
	DECLARE @LatestSUAdmissionDocumentVersionID INT
	DECLARE @SUAdmissionDrugNameOne INT
	DECLARE @SUAdmissionFrequencyOne INT
	DECLARE @SUAdmissionDrugNameTwo INT
	DECLARE @SUAdmissionFrequencyTwo INT
	DECLARE @SUAdmissionDrugNameThree INT
	DECLARE @SUAdmissionFrequencyThree INT
	DECLARE @SUAdmissionsTobaccoUse INT
	DECLARE @LivingArrangement INT
	DECLARE @EmploymentStatus INT
	DECLARE @Education INT
	DECLARE @SUAdmissionDrugNameOneText VARCHAR(250)
	DECLARE @SUAdmissionFrequencyOneText VARCHAR(250)
	DECLARE @SUAdmissionDrugNameTwoText VARCHAR(250)
	DECLARE @SUAdmissionFrequencyTwoText VARCHAR(250)
	DECLARE @SUAdmissionDrugNameThreeText VARCHAR(250)
	DECLARE @SUAdmissionFrequencyThreeText VARCHAR(250)
	DECLARE @SUAdmissionsTobaccoUseText VARCHAR(250)
	DECLARE @LastFacetoFace Datetime

	SELECT TOP 1 @LatestSUAdmissionDocumentVersionID = CurrentDocumentVersionId
	FROM CustomDocumentSUAdmissions CDCD
	INNER JOIN Documents Doc ON CDCD.DocumentVersionId = Doc.CurrentDocumentVersionId
	WHERE Doc.ClientId = @ClientID
		AND Doc.[Status] = 22
		AND ISNULL(CDCD.RecordDeleted, 'N') = 'N'
		AND ISNULL(Doc.RecordDeleted, 'N') = 'N'
	ORDER BY Doc.EffectiveDate DESC
		,Doc.ModifiedDate DESC
		
    Select top 1 @LastFacetoFace = DateOfService from dbo.Services where ClientId=@ClientID and dbo.Services.Status=75 order by DateOfService desc
    
	CREATE TABLE #SUAdmission (SUAdmissionID INT IDENTITY(1,1),DrugName INT,Frequency INT,DrugNameText VARCHAR(250),FrequencyText VARCHAR(250))

	INSERT INTO #SUAdmission(DrugName,Frequency,DrugNameText,FrequencyText)
	SELECT DrugName1,Frequency1,GC1.CodeName,GC2.CodeName FROM CustomDocumentSUAdmissions CDSA JOIN GlobalCodes GC ON CDSA.PreferredUsage1 = GC.GlobalCodeId LEFT JOIN GlobalCodes GC1 ON CDSA.DrugName1 = GC1.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON CDSA.Frequency1 = GC2.GlobalCodeId WHERE documentversionid = @LatestSUAdmissionDocumentVersionID AND ISNULL(GC.CodeName,'') = 'Primary'
	INSERT INTO #SUAdmission(DrugName,Frequency,DrugNameText,FrequencyText)
	SELECT DrugName2,Frequency2,GC1.CodeName,GC2.CodeName FROM CustomDocumentSUAdmissions CDSA JOIN GlobalCodes GC ON CDSA.PreferredUsage2 = GC.GlobalCodeId LEFT JOIN GlobalCodes GC1 ON CDSA.DrugName2 = GC1.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON CDSA.Frequency2 = GC2.GlobalCodeId WHERE documentversionid = @LatestSUAdmissionDocumentVersionID AND ISNULL(GC.CodeName,'') = 'Primary'
	INSERT INTO #SUAdmission(DrugName,Frequency,DrugNameText,FrequencyText)
	SELECT DrugName3,Frequency3,GC1.CodeName,GC2.CodeName FROM CustomDocumentSUAdmissions CDSA JOIN GlobalCodes GC ON CDSA.PreferredUsage3 = GC.GlobalCodeId LEFT JOIN GlobalCodes GC1 ON CDSA.DrugName3 = GC1.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON CDSA.Frequency3 = GC2.GlobalCodeId WHERE documentversionid = @LatestSUAdmissionDocumentVersionID AND ISNULL(GC.CodeName,'') = 'Primary'

	INSERT INTO #SUAdmission(DrugName,Frequency,DrugNameText,FrequencyText)
	SELECT DrugName1,Frequency1,GC1.CodeName,GC2.CodeName FROM CustomDocumentSUAdmissions CDSA JOIN GlobalCodes GC ON CDSA.PreferredUsage1 = GC.GlobalCodeId LEFT JOIN GlobalCodes GC1 ON CDSA.DrugName1 = GC1.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON CDSA.Frequency1 = GC2.GlobalCodeId WHERE documentversionid = @LatestSUAdmissionDocumentVersionID AND ISNULL(GC.CodeName,'') = 'Secondary'
	INSERT INTO #SUAdmission(DrugName,Frequency,DrugNameText,FrequencyText)
	SELECT DrugName2,Frequency2,GC1.CodeName,GC2.CodeName FROM CustomDocumentSUAdmissions CDSA JOIN GlobalCodes GC ON CDSA.PreferredUsage2 = GC.GlobalCodeId LEFT JOIN GlobalCodes GC1 ON CDSA.DrugName2 = GC1.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON CDSA.Frequency2 = GC2.GlobalCodeId WHERE documentversionid = @LatestSUAdmissionDocumentVersionID AND ISNULL(GC.CodeName,'') = 'Secondary'
	INSERT INTO #SUAdmission(DrugName,Frequency,DrugNameText,FrequencyText)
	SELECT DrugName3,Frequency3,GC1.CodeName,GC2.CodeName FROM CustomDocumentSUAdmissions CDSA JOIN GlobalCodes GC ON CDSA.PreferredUsage3 = GC.GlobalCodeId LEFT JOIN GlobalCodes GC1 ON CDSA.DrugName3 = GC1.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON CDSA.Frequency3 = GC2.GlobalCodeId WHERE documentversionid = @LatestSUAdmissionDocumentVersionID AND ISNULL(GC.CodeName,'') = 'Secondary'

	INSERT INTO #SUAdmission(DrugName,Frequency,DrugNameText,FrequencyText)
	SELECT DrugName1,Frequency1,GC1.CodeName,GC2.CodeName FROM CustomDocumentSUAdmissions CDSA JOIN GlobalCodes GC ON CDSA.PreferredUsage1 = GC.GlobalCodeId LEFT JOIN GlobalCodes GC1 ON CDSA.DrugName1 = GC1.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON CDSA.Frequency1 = GC2.GlobalCodeId WHERE documentversionid = @LatestSUAdmissionDocumentVersionID AND ISNULL(GC.CodeName,'') = 'Tertiary'
	INSERT INTO #SUAdmission(DrugName,Frequency,DrugNameText,FrequencyText)
	SELECT DrugName2,Frequency2,GC1.CodeName,GC2.CodeName FROM CustomDocumentSUAdmissions CDSA JOIN GlobalCodes GC ON CDSA.PreferredUsage2 = GC.GlobalCodeId LEFT JOIN GlobalCodes GC1 ON CDSA.DrugName2 = GC1.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON CDSA.Frequency2 = GC2.GlobalCodeId WHERE documentversionid = @LatestSUAdmissionDocumentVersionID AND ISNULL(GC.CodeName,'') = 'Tertiary'
	INSERT INTO #SUAdmission(DrugName,Frequency,DrugNameText,FrequencyText)
	SELECT DrugName3,Frequency3,GC1.CodeName,GC2.CodeName FROM CustomDocumentSUAdmissions CDSA JOIN GlobalCodes GC ON CDSA.PreferredUsage3 = GC.GlobalCodeId LEFT JOIN GlobalCodes GC1 ON CDSA.DrugName3 = GC1.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON CDSA.Frequency3 = GC2.GlobalCodeId WHERE documentversionid = @LatestSUAdmissionDocumentVersionID AND ISNULL(GC.CodeName,'') = 'Tertiary'

	INSERT INTO #SUAdmission(DrugName,Frequency,DrugNameText,FrequencyText)
	SELECT DrugName1,Frequency1,GC1.CodeName,GC2.CodeName FROM CustomDocumentSUAdmissions CDSA JOIN GlobalCodes GC ON CDSA.PreferredUsage1 = GC.GlobalCodeId LEFT JOIN GlobalCodes GC1 ON CDSA.DrugName1 = GC1.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON CDSA.Frequency1 = GC2.GlobalCodeId WHERE documentversionid = @LatestSUAdmissionDocumentVersionID AND ISNULL(GC.CodeName,'') = ''
	INSERT INTO #SUAdmission(DrugName,Frequency,DrugNameText,FrequencyText)
	SELECT DrugName2,Frequency2,GC1.CodeName,GC2.CodeName FROM CustomDocumentSUAdmissions CDSA JOIN GlobalCodes GC ON CDSA.PreferredUsage2 = GC.GlobalCodeId LEFT JOIN GlobalCodes GC1 ON CDSA.DrugName2 = GC1.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON CDSA.Frequency2 = GC2.GlobalCodeId WHERE documentversionid = @LatestSUAdmissionDocumentVersionID AND ISNULL(GC.CodeName,'') = ''
	INSERT INTO #SUAdmission(DrugName,Frequency,DrugNameText,FrequencyText)
	SELECT DrugName3,Frequency3,GC1.CodeName,GC2.CodeName FROM CustomDocumentSUAdmissions CDSA JOIN GlobalCodes GC ON CDSA.PreferredUsage3 = GC.GlobalCodeId LEFT JOIN GlobalCodes GC1 ON CDSA.DrugName3 = GC1.GlobalCodeId LEFT JOIN GlobalCodes GC2 ON CDSA.Frequency3 = GC2.GlobalCodeId WHERE documentversionid = @LatestSUAdmissionDocumentVersionID AND ISNULL(GC.CodeName,'') = ''


	SELECT @SUAdmissionDrugNameOne = DrugName,@SUAdmissionFrequencyOne = Frequency,@SUAdmissionDrugNameOneText = DrugNameText,@SUAdmissionFrequencyOneText = FrequencyText FROM #SUAdmission WHERE SUAdmissionID = 1
	SELECT @SUAdmissionDrugNameTwo = DrugName,@SUAdmissionFrequencyTwo = Frequency,@SUAdmissionDrugNameTwoText = DrugNameText,@SUAdmissionFrequencyTwoText = FrequencyText FROM #SUAdmission WHERE SUAdmissionID = 2
	SELECT @SUAdmissionDrugNameThree = DrugName,@SUAdmissionFrequencyThree = Frequency,@SUAdmissionDrugNameThreeText = DrugNameText,@SUAdmissionFrequencyThreeText = FrequencyText FROM #SUAdmission WHERE SUAdmissionID = 3
    SELECT @SUAdmissionsTobaccoUse = TobaccoUse,@SUAdmissionsTobaccoUseText = GC.CodeName,@LivingArrangement = LivingArrangement,@EmploymentStatus = EmploymentStatus,@Education = EnrolledEducation FROM CustomDocumentSUAdmissions CDSA LEFT JOIN GlobalCodes GC ON CDSA.TobaccoUse = GC.GlobalCodeId WHERE CDSA.DocumentVersionId = @LatestSUAdmissionDocumentVersionID
    
	DROP TABLE #SUAdmission

	SELECT 'CustomDocumentSUDischarges' AS TableName
		,- 1 AS DocumentVersionId
		,'' AS CreatedBy
		,GETDATE() AS CreatedDate
		,'' AS ModifiedBy
		,GETDATE() AS ModifiedDate
		,CDSD.DateOfDischarge
		,CDSD.DischargeReason
		,@SUAdmissionDrugNameOne AS SUAdmissionDrugNameOne
		,@SUAdmissionFrequencyOne AS SUAdmissionFrequencyOne
		,@SUAdmissionDrugNameTwo AS SUAdmissionDrugNameTwo
		,@SUAdmissionFrequencyTwo AS SUAdmissionFrequencyTwo
		,@SUAdmissionDrugNameThree AS SUAdmissionDrugNameThree
		,@SUAdmissionFrequencyThree AS SUAdmissionFrequencyThree
		,@SUAdmissionsTobaccoUse AS SUAdmissionsTobaccoUse
		,@LivingArrangement AS LivingArrangement
		,@EmploymentStatus AS EmploymentStatus
		,@Education AS Education
		,@SUAdmissionDrugNameOneText AS SUAdmissionDrugNameOneText
		,@SUAdmissionFrequencyOneText AS SUAdmissionFrequencyOneText
		,@SUAdmissionDrugNameTwoText AS SUAdmissionDrugNameTwoText
		,@SUAdmissionFrequencyTwoText AS SUAdmissionFrequencyTwoText
		,@SUAdmissionDrugNameThreeText AS SUAdmissionDrugNameThreeText
		,@SUAdmissionFrequencyThreeText AS SUAdmissionFrequencyThreeText
		,@SUAdmissionsTobaccoUseText AS SUAdmissionsTobaccoUseText
		,@LastFacetoFace as LastFaceToFaceDate
	FROM systemconfigurations s
	LEFT OUTER JOIN CustomDocumentSUDischarges CDSD ON CDSD.DocumentVersionId = @LatestDocumentVersionID
	END TRY

	BEGIN CATCH
	END CATCH

END

GO


