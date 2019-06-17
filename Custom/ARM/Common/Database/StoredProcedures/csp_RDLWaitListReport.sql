--USE [ARMSmartcareTrain]
--GO

/****** Object:  StoredProcedure [dbo].[csp_RDLWaitListReport]    Script Date: 7/6/2018 2:23:26 PM ******/
DROP PROCEDURE [dbo].[csp_RDLWaitListReport]
GO

/****** Object:  StoredProcedure [dbo].[csp_RDLWaitListReport]    Script Date: 7/6/2018 2:23:26 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[csp_RDLWaitListReport] @ClientDiagnosis VARCHAR(MAX)
	,@AsOfDate DATE
	/******************************************************************************************/
	--  6/30/2017	MJensen	Created for ARM-Enhancements task #665
	--  7/06/2018   mraymond - ARM Support Go Live #933. Removed GetGlobalCodeName function on DocumentASAMs.FinalDeterminationComments retrieval. Changed ReasonNotAtRecLOC from VARCHAR(100) to VARCHAR(MAX)
	/******************************************************************************************/
AS
BEGIN TRY
	CREATE TABLE #SelectedDiagnosis (DiagnosisCode VARCHAR(20))

	INSERT INTO #SelectedDiagnosis
	SELECT Item
	FROM dbo.fnSplit(@ClientDiagnosis, ',')

	CREATE TABLE #Report (
		ClientId INT
		,ClientEpisodeId INT
		,LastKnownResidence VARCHAR(500)
		,CountyOfResidence VARCHAR(100)
		,ResidenceType VARCHAR(100)
		,PartialLastName CHAR(2)
		,YearOfBirth INT
		,Gender VARCHAR(15)
		,LastSSNDigits CHAR(4)
		,DateOfFirstContact DATE
		,DateAssesmentOffered DATE
		,DateAssessmentCompleted DATE
		,Diagnosis VARCHAR(200)
		,TreatmentOfferedDate DATE
		,TreatementStartDate DATE
		,RecommendedLevelOfCare VARCHAR(100)
		,LevelOfCare VARCHAR(100)
		,ReasonNotAtRecLOC VARCHAR(MAX)
		)

	-- select clients that have selected diagnosis on most recent diag doc b4 as of date
	INSERT INTO #Report (
		ClientId
		,ClientEpisodeId
		)
	SELECT DISTINCT d.ClientId
		,ce.ClientEpisodeId
	FROM DocumentDiagnosisCodes ddc
	JOIN DocumentVersions dv ON dv.DocumentVersionId = ddc.DocumentVersionId
	JOIN Documents d ON d.DocumentId = dv.DocumentId
	JOIN #SelectedDiagnosis sd ON ddc.ICD10Code = sd.DiagnosisCode
	JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
	JOIN ClientEpisodes ce ON ce.ClientId = d.ClientId
	WHERE d.EffectiveDate <= @AsOfDate
		AND ISNULL(ddc.RecordDeleted, 'N') = 'N'
		AND ISNULL(dv.RecordDeleted, 'N') = 'N'
		AND ISNULL(d.RecordDeleted, 'N') = 'N'
		AND ISNULL(ce.RecordDeleted, 'N') = 'N'
		AND dc.DiagnosisDocument = 'Y'
		AND NOT EXISTS (
			SELECT 1
			FROM Documents d1
			JOIN DocumentCodes dc1 ON dc1.DocumentCodeId = d1.DocumentCodeId
			WHERE d1.EffectiveDate <= @AsOfDate
				AND d1.EffectiveDate > d.EffectiveDate
				AND d1.ClientId = d.ClientId
				AND dc1.DiagnosisDocument = 'Y'
				AND ISNULL(d1.RecordDeleted, 'N') = 'N'
			)
		AND (
			ce.DischargeDate IS NULL
			OR CAST(ce.DischargeDate AS DATE) > @AsOfDate
			)
		AND CAST(ce.RegistrationDate AS DATE) <= @AsOfDate

	UPDATE R
	SET LastKnownResidence = ca.Display
	FROM #Report R
	JOIN ClientAddresses ca ON ca.ClientId = R.ClientId
	WHERE ca.AddressType = 90
		AND ISNULL(ca.RecordDeleted, 'N') = 'N'

	-- override home address with temp if it exists
	UPDATE R
	SET LastKnownResidence = ca.Display
	FROM #Report R
	JOIN ClientAddresses ca ON ca.ClientId = R.ClientId
	WHERE ca.AddressType = 92
		AND ISNULL(ca.RecordDeleted, 'N') = 'N'

	UPDATE R
	SET R.CountyOfResidence = ct.CountyName
		,r.ResidenceType = dbo.GetGlobalCodeName(c.LivingArrangement)
		,r.PartialLastName = SUBSTRING(c.LastName, 1, 2)
		,r.YearOfBirth = ISNULL(YEAR(c.DOB), 0)
		,r.Gender = ISNULL(c.Sex, '')
		,r.LastSSNDigits = REPLACE(CAST(c.ssn % 10000 AS CHAR(4)), ' ', '0')
		,r.DateOfFirstContact = ce.InitialRequestDate
		,r.DateAssesmentOffered = ce.AssessmentFirstOffered
		,r.TreatmentOfferedDate = ce.TxStartFirstOffered
	FROM #Report R
	JOIN Clients c ON c.ClientId = R.ClientId
	JOIN ClientEpisodes ce ON ce.ClientEpisodeId = r.ClientEpisodeId
	LEFT JOIN Counties ct ON ct.CountyFIPS = c.CountyOfResidence
	WHERE ISNULL(ce.RecordDeleted, 'N') = 'N'

	UPDATE R
	SET r.DateAssessmentCompleted = CAST(s.DateOfService AS DATE)
	FROM #Report R
	JOIN Services S ON s.ClientId = R.ClientId
	WHERE s.ProcedureCodeId IN (
			289
			,254
			,247
			,223
			,203
			)
		AND s.STATUS = 75
		AND ISNULL(s.RecordDeleted, 'N') = 'N'
		AND CAST(s.DateOfService AS DATE) <= @AsOfDate
		AND NOT EXISTS (
			SELECT 1
			FROM Services s1
			WHERE s1.ClientId = r.ClientId
				AND s1.ProcedureCodeId IN (
					289
					,254
					,247
					,223
					,203
					)
				AND s1.STATUS = 75
				AND ISNULL(s1.RecordDeleted, 'N') = 'N'
				AND CAST(s1.DateOfService AS DATE) <= @AsOfDate
				AND s1.DateOfService > s.DateOfService
			)

	UPDATE Rt
	SET Rt.Diagnosis = stuff((
				SELECT ', ' + ddc.ICD10Code
				FROM #Report R
				JOIN Documents d ON r.ClientId = d.ClientId
					AND ISNULL(d.RecordDeleted, 'N') = 'N'
				JOIN DocumentVersions dv ON dv.DocumentVersionId = d.CurrentDocumentVersionId
					AND ISNULL(dv.RecordDeleted, 'N') = 'N'
				JOIN DocumentDiagnosisCodes ddc ON dv.DocumentVersionId = ddc.DocumentVersionId
					AND ISNULL(ddc.RecordDeleted, 'N') = 'N'
				JOIN DocumentCodes dc ON dc.DocumentCodeId = d.DocumentCodeId
				WHERE dc.DiagnosisDocument = 'Y'
					AND d.STATUS = 22
					AND CAST(d.EffectiveDate AS DATE) <= @AsOfDate
					AND r.ClientId = rt.ClientId
					AND NOT EXISTS (
						SELECT 1
						FROM Documents d1
						JOIN DocumentCodes dc1 ON dc1.DocumentCodeId = d1.DocumentCodeId
						WHERE CAST(d1.EffectiveDate AS DATE) <= @AsOfDate
							AND (
								d1.EffectiveDate > d.EffectiveDate
								OR (
									d1.EffectiveDate = d.EffectiveDate
									AND d1.ModifiedDate > d.ModifiedDate
									)
								)
							AND d1.ClientId = r.ClientId
							AND dc1.DiagnosisDocument = 'Y'
							AND d1.STATUS = 22
							AND ISNULL(d1.RecordDeleted, 'N') = 'N'
						)
				ORDER BY ddc.DiagnosisOrder
				FOR XML PATH('')
				), 1, 1, '')
	FROM #Report Rt

	UPDATE R
	SET R.RecommendedLevelOfCare = ISNULL(dbo.GetGlobalCodeName(da.IndicatedReferredLevel), '')
		,r.LevelOfCare = ISNULL(dbo.GetGlobalCodeName(da.ProvidedLevel), '')
		,r.ReasonNotAtRecLOC = ISNULL(da.FinalDeterminationComments, '')
	FROM #Report R
	JOIN documents d ON d.ClientId = R.ClientId
	JOIN DocumentVersions dv ON dv.DocumentId = d.DocumentId
	JOIN DocumentASAMs da ON da.DocumentVersionId = dv.DocumentVersionId
	WHERE d.DocumentCodeId = 2701
		AND d.STATUS = 22
		AND d.effectiveDate < @asofdate
		AND ISNULL(d.RecordDeleted, 'N') = 'N'
		AND ISNULL(dv.RecordDeleted, 'N') = 'N'
		AND ISNULL(da.RecordDeleted, 'N') = 'N'
		AND NOT EXISTS (
			SELECT 1
			FROM Documents d1
			WHERE d1.DocumentCodeId = 2701
				AND d1.STATUS = 22
				AND d1.effectiveDate < @asofdate
				AND d1.EffectiveDate > d.EffectiveDate
				AND ISNULL(d1.RecordDeleted, 'N') = 'N'
			)

	UPDATE R
	SET r.TreatementStartDate = CAST(s.DateOfService AS DATE)
	FROM #Report R
	JOIN Services S ON S.ClientId = R.ClientId
	WHERE s.STATUS = 75
		AND ISNULL(s.RecordDeleted, 'N') = 'N'
		AND CAST(s.DateOfService AS DATE) > r.DateAssessmentCompleted
		AND NOT EXISTS (
			SELECT 1
			FROM services s1
			WHERE s1.ClientId = r.ClientId
				AND s1.STATUS = 75
				AND ISNULL(s1.RecordDeleted, 'N') = 'N'
				AND CAST(s1.DateOfService AS DATE) > r.DateAssessmentCompleted
				AND s1.DateOfService < s.DateOfService
			)

	SELECT ClientId
		,LastKnownResidence
		,CountyOfResidence
		,ResidenceType
		,PartialLastName
		,YearOfBirth
		,Gender
		,LastSSNDigits
		,DateOfFirstContact
		,DateAssesmentOffered
		,DateAssessmentCompleted
		,Diagnosis
		,TreatmentOfferedDate
		,TreatementStartDate
		,RecommendedLevelOfCare
		,LevelOfCare
		,ReasonNotAtRecLOC
	FROM #Report
	ORDER BY ClientId
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RDLWaitListReport') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.  
			16
			,-- Severity.  
			1 -- State.  
			);
END CATCH


GO


