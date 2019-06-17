/****** Object:  StoredProcedure [dbo].[ssp_GetActiveProblems]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_GetActiveProblems'
		)
	DROP PROCEDURE [dbo].[ssp_GetActiveProblems]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetActiveProblems]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetActiveProblems] @ClientId INT = NULL
	,@Type VARCHAR(10) = NULL
	,@DocumentVersionId INT = NULL
	,@FromDate DATETIME = NULL
	,@ToDate DATETIME = NULL
	,@JsonResult VARCHAR(MAX) = NULL OUTPUT
AS
-- =============================================                            
-- Author:  Vijay                            
-- Create date: July 24, 2017                            
-- Description: Retrieves Active Problems details            
-- Task:   MUS3 - Task#25.4, 30, 31 and 32                            
/*                            
 Modified Date	Author		Reason  
 12/12/2017		Ravichandra	changes done for new requirement 
							Meaningful Use Stage 3 task 68 - Summary of Care                    
 23/07/2018		Ravichandra	What: casting to a date type for EffectiveDate  
							Why : KCMHSAS - Support  #1099 Summary of Care - issues (summary for all bugs) 
-- ============================================= */                           
BEGIN
	BEGIN TRY
		DECLARE @LatestICD10DocumentVersionID INT

		SET @LatestICD10DocumentVersionID = (
				SELECT TOP 1 a.CurrentDocumentVersionId
				FROM Documents a
				INNER JOIN DocumentCodes Dc ON Dc.DocumentCodeid = a.DocumentCodeid
				WHERE a.ClientId = @ClientID
					AND CAST(a.EffectiveDate AS DATE)<= CAST(getDate() AS DATE)
					AND a.STATUS = 22
					AND Dc.DiagnosisDocument = 'Y'
					AND a.DocumentCodeId = 1601
					AND isNull(a.RecordDeleted, 'N') <> 'Y'
					AND isNull(Dc.RecordDeleted, 'N') <> 'Y'
				ORDER BY a.EffectiveDate DESC
					,a.ModifiedDate DESC
				)

		IF @ClientId IS NOT NULL
		BEGIN
				;

			WITH ActiveProblemsResults
			AS (
				SELECT DISTINCT c.ClientId
					--,c.SSN AS Identifier  --External ids for this item            
					,CASE 
						WHEN DC.ICD9Code = '462'
							THEN 'Resolved'
						WHEN DC.ICD9Code = '486'
							THEN 'Resolved'
						WHEN DC.ICD9Code = '574.21'
							THEN 'Resolved'
						WHEN ISNULL(DC.ICD9Code, '') = ''
							THEN 'Resolved'
						ELSE 'Active'
						END AS ClinicalStatus -- RDL+FHIR active | recurrence | inactive | remission | resolved            
					,'' AS VerificationStatus -- provisional | differential | confirmed | refuted | entered-in-error | unknown            
					         
					,ISNULL(C.LastName, '') + '' + ISNULL(C.FirstName, '') AS [Subject] --Reference            
					,(
						SELECT max(EpisodeNumber)
						FROM ClientEpisodes
						WHERE ClientId = C.ClientId
							AND ISNULL(RecordDeleted, 'N') = 'N'
						) AS Context --Reference            
					,CONVERT(VARCHAR(10), ba.StartDate, 101) AS Start --OnsetPeriod            
					,CONVERT(VARCHAR(10), ba.EndDate, 101) AS [End] --OnsetPeriod            
					,CONVERT(VARCHAR(10), civ.EmergencyRoomArrival, 101) AS AbatementPeriodStart
					,CONVERT(VARCHAR(10), civ.EmergencyRoomDeparture, 101) AS AbatementPeriodEnd
					,CONVERT(VARCHAR(10), civ.AdmitDecision, 101) AS AssertedDate
					,ISNULL(C.LastName, '') + '' + ISNULL(C.FirstName, '') AS Asserter --Reference            
					   
					,dbo.ssf_GetGlobalCodeNameById(ba.STATUS) AS StageAssessment --Reference            
					     
					,DDD.ICDDescription AS EvidenceDetail
				FROM Clients c
				JOIN dbo.DocumentDiagnosisCodes DC ON DC.DocumentVersionId = @LatestICD10DocumentVersionID
				LEFT JOIN dbo.SNOMEDCTCodes s ON s.SNOMEDCTCode = DC.SNOMEDCODE
				LEFT JOIN DiagnosisICD10Codes DDD ON DDD.ICD10CodeId = DC.ICD10CodeId
				LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
				LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId)
				       
				WHERE c.ClientId = @ClientId
					AND c.Active = 'Y'
					AND ISNULL(c.RecordDeleted, 'N') = 'N'
				
				UNION
				
				SELECT DISTINCT c.ClientId
					         
					,CASE 
						WHEN DC.ICD9Code = '462'
							THEN 'Resolved'
						WHEN DC.ICD9Code = '486'
							THEN 'Resolved'
						WHEN DC.ICD9Code = '574.21'
							THEN 'Resolved'
						WHEN ISNULL(DC.ICD9Code, '') = ''
							THEN 'Resolved'
						ELSE 'Active'
						END AS ClinicalStatus -- RDL+FHIR active | recurrence | inactive | remission | resolved            
					,dbo.ssf_GetGlobalCodeNameById(cpb.ProblemStatus) AS VerificationStatus -- provisional | differential | confirmed | refuted | entered-in-error | unknown            
					         
					,ISNULL(C.LastName, '') + '' + ISNULL(C.FirstName, '') AS [Subject] --Reference            
					,(
						SELECT max(EpisodeNumber)
						FROM ClientEpisodes
						WHERE ClientId = C.ClientId
							AND ISNULL(RecordDeleted, 'N') = 'N'
						) AS Context --Reference            
					,CONVERT(VARCHAR(10), ba.StartDate, 101) AS Start --OnsetPeriod            
					,CONVERT(VARCHAR(10), ba.EndDate, 101) AS [End] --OnsetPeriod            
					,CONVERT(VARCHAR(10), civ.EmergencyRoomArrival, 101) AS AbatementPeriodStart
					,CONVERT(VARCHAR(10), civ.EmergencyRoomDeparture, 101) AS AbatementPeriodEnd
					,CONVERT(VARCHAR(10), civ.AdmitDecision, 101) AS AssertedDate
					,ISNULL(C.LastName, '') + '' + ISNULL(C.FirstName, '') AS Asserter --Reference            
					--,'' AS StageSummary            
					,dbo.ssf_GetGlobalCodeNameById(ba.STATUS) AS StageAssessment --Reference            
					--,'' AS EvidenceCode            
					,DDD.ICDDescription AS EvidenceDetail
				--,'' AS Note            
				FROM Clients c
				LEFT JOIN ClientProblems cpb ON cpb.ClientId = c.ClientId
					AND C.PrimaryClinicianId = cpb.StaffId
				--AND (        
				-- cpb.StartDate >= @fromDate        
				-- AND cpb.EndDate <= @toDate        
				-- )        
				LEFT JOIN dbo.DocumentDiagnosisCodes DC ON DC.DocumentVersionId = @LatestICD10DocumentVersionID
					AND DC.ICD10CodeId = cpb.ICD10CodeId
				LEFT JOIN DiagnosisICD10Codes DDD ON DDD.ICD10CodeId = cpb.ICD10CodeId
				LEFT JOIN dbo.SNOMEDCTCodes s ON s.SNOMEDCTCode = DC.SNOMEDCODE
				LEFT JOIN [Services] sr ON (sr.ClientId = c.ClientId)
				--AND (        
				-- sr.DateOfService >= @fromDate        
				-- AND sr.EndDateOfService <= @toDate        
				-- )        
				LEFT JOIN ClientInpatientVisits civ ON civ.ClientId = c.ClientId
				LEFT JOIN BedAssignments ba ON (ba.ClientInpatientVisitId = civ.ClientInpatientVisitId)
				--AND (        
				-- ba.StartDate >= @FromDate        
				-- AND ba.EndDate <= @ToDate        
				-- )        
				--LEFT JOIN Documents d ON d.ClientId = c.ClientId            
				WHERE c.ClientId = @ClientId
					--AND (ISNULL(@DocumentVersionId, '')='' OR d.CurrentDocumentVersionId = @DocumentVersionId)            
					AND c.Active = 'Y'
					AND ISNULL(c.RecordDeleted, 'N') = 'N'
				)
			SELECT @JsonResult = ISNULL(dbo.smsf_FlattenedJSON((
							SELECT *
							FROM ActiveProblemsResults
							ORDER BY EvidenceDetail
							FOR XML path
								,ROOT
							)), '')
		END
		ELSE IF @DocumentVersionId IS NOT NULL
		BEGIN
			DECLARE @RDLFromDate DATE
			DECLARE @RDLToDate DATE
			DECLARE @RDLClientId INT

			SELECT TOP 1 @RDLFromDate = cast(T.FromDate AS DATE)
				,@RDLToDate = cast(T.ToDate AS DATE)
				,@Type = T.TransitionType
				,@RDLClientId = D.ClientId
			FROM TransitionOfCareDocuments T
			JOIN Documents D ON D.InProgressDocumentVersionId = T.DocumentVersionId
			WHERE ISNULL(T.RecordDeleted, 'N') = 'N'
				AND T.DocumentVersionId = @DocumentVersionId
				AND ISNULL(D.RecordDeleted, 'N') = 'N'

			CREATE TABLE #ClientDiag (
				ClientId INT
				,ClientName VARCHAR(150)
				,EffectiveDate DATETIME
				,StartDate DATE
				,EndDate DATE
				,ICD9Code VARCHAR(20)
				,Remission INT
				,ICD9Desc VARCHAR(max)
				,ICD10Code VARCHAR(20)
				,ICD10Desc VARCHAR(max)
				,SNOMEDCodeICD9 VARCHAR(max)
				,SNOMEDCodeICD10 VARCHAR(20)
				,SNOMEDCTDescription VARCHAR(max)
				,ACTIVE VARCHAR(1)
				,DiagnosisType VARCHAR(250)
				,Duplicate CHAR(1) DEFAULT 'N'
				)

			INSERT INTO #ClientDiag (
				ClientId
				,ClientName
				,EffectiveDate
				,ICD9Code
				,Remission
				,ICD9Desc
				,ICD10Code
				,ICD10Desc
				,SNOMEDCodeICD9
				,SNOMEDCodeICD10
				,SNOMEDCTDescription
				,ACTIVE
				,EndDate
				,DiagnosisType
				)
			SELECT DISTINCT a.ClientId
				,(a.FirstName + ' ' + a.LastName) AS ClientName
				,b.EffectiveDate
				,
				-- ds.SignatureDate , -- b.EffectiveDate AS SignatureDate ,                
				c.ICD9Code
				,c.Remission
				,REPLACE((
						SELECT DISTINCT ICD9Codes.ICDDescription + CHAR(13) + CHAR(10)
						FROM dbo.DiagnosisICDCodes ICD9Codes
						WHERE ICD9Codes.ICDCode = c.ICD9Code
						FOR XML PATH('')
						), '&#x0D;', CHAR(13) + CHAR(10)) AS ICD9Desc
				,c.ICD10Code
				,icd10.ICDDescription AS ICD10Desc
				,REPLACE((
						SELECT DISTINCT e.SNOMEDCTCode + CHAR(13) + CHAR(10)
						FROM dbo.ICD9SNOMEDCTMapping d
						INNER JOIN dbo.SNOMEDCTCodes e ON e.SNOMEDCTCodeId = d.SNOMEDCTCodeId
						WHERE d.ICD9Code = c.ICD9Code
						FOR XML PATH('')
						), '&#x0D;', '  ') AS SNOMEDCodeICD9
				,
				--e.SNOMEDCTDescription AS SNOMEDDescICD9 ,                
				c.SNOMEDCODE AS SNOMEDCodeICD10
				,s.SNOMEDCTDescription
				,'Y' AS ACTIVE
				,'12/31/2199' AS EndDate
				,gc.codename AS DiagnosisType
			FROM Clients a
			INNER JOIN Documents b ON b.ClientId = a.ClientId
				AND ISNULL(a.RecordDeleted, 'N') = 'N'
				AND ISNULL(b.RecordDeleted, 'N') = 'N'
			INNER JOIN dbo.DocumentVersions dv ON dv.DocumentId = b.DocumentId
				AND ISNULL(dv.RecordDeleted, 'N') = 'N'
			INNER JOIN dbo.DocumentDiagnosis dd ON dd.DocumentVersionId = dv.DocumentVersionId
				AND ISNULL(dd.RecordDeleted, 'N') = 'N'
			INNER JOIN dbo.DocumentDiagnosisCodes c ON c.DocumentVersionId = b.CurrentDocumentVersionId
				AND ISNULL(c.RecordDeleted, 'N') = 'N'
			INNER JOIN dbo.DocumentSignatures ds ON ds.SignedDocumentVersionId = dv.DocumentVersionId
				AND ISNULL(ds.RecordDeleted, 'N') = 'N'
			LEFT JOIN dbo.SNOMEDCTCodes s ON s.SNOMEDCTCode = c.SNOMEDCODE
			INNER JOIN dbo.DiagnosisICD10Codes icd10 ON icd10.ICD10Code = c.ICD10Code
				AND icd10.ICD10CodeId = c.ICD10CodeId
			INNER JOIN GlobalCodes gc ON c.DiagnosisType = gc.globalcodeid
				AND ISNULL(gc.RecordDeleted, 'N') = 'N'
			WHERE b.STATUS = 22
				AND b.DocumentCodeId = 1601
				AND a.ClientId = @RDLClientId

			--AND CAST(b.EffectiveDate AS DATE) >= CAST(ISNULL(@StartDate, '12/31/1901') AS DATE)                
			-- AND CAST(b.EffectiveDate AS DATE) <=CAST(ISNULL(@EndDate, '12/31/2199') AS DATE)                
			-- update Startdate               
			UPDATE c
			SET c.StartDate = cd.StartDate
			FROM #ClientDiag c
			JOIN (
				SELECT MIN(CAST(c.EffectiveDate AS DATE)) AS StartDate
					,c.EffectiveDate
					,c.ICD10Code
				FROM #ClientDiag c
				GROUP BY c.ICD10Code
					,c.EffectiveDate
				) cd ON c.ICD10Code = cd.ICD10Code
				AND c.EffectiveDate = cd.EffectiveDate

			UPDATE c
			SET c.EndDate = (
					SELECT TOP 1 c1.StartDate
					FROM #ClientDiag c1
					WHERE c1.StartDate > cd.EndDate
					ORDER BY c1.StartDate ASC
					)
			FROM #ClientDiag c
			JOIN (
				SELECT CD1.ICD10Code
					,max(CD1.EffectiveDate) AS EndDate
				FROM #ClientDiag CD1
				WHERE NOT EXISTS (
						SELECT 1
						FROM #ClientDiag CD2
						WHERE CD1.ICD10Code = CD2.ICD10Code
							AND CD1.EffectiveDate < CD2.EffectiveDate
						)
					AND EXISTS (
						SELECT 1
						FROM #ClientDiag CD3
						WHERE CD1.ICD10Code <> CD3.ICD10Code
							AND CD1.EffectiveDate < CD3.EffectiveDate
						)
				GROUP BY CD1.ICD10Code
				) CD ON c.ICD10Code = cd.ICD10Code

			UPDATE CD
			SET CD.SNOMEDCodeICD10 = (
					SELECT DISTINCT TOP 1 S.SNOMEDCTCode
					FROM dbo.ICD10SNOMEDCTMapping ICDMapping
					INNER JOIN dbo.SNOMEDCTCodes S ON S.SNOMEDCTCodeId = ICDMapping.SNOMEDCTCodeId
					INNER JOIN Documents b ON b.ClientId = @ClientId
						AND b.DocumentCodeId = 1601
						AND b.STATUS = 22
					INNER JOIN dbo.DocumentDiagnosisCodes c ON c.DocumentVersionId = b.CurrentDocumentVersionId
						AND ISNULL(b.RecordDeleted, 'N') = 'N'
						AND ISNULL(c.RecordDeleted, 'N') = 'N'
					WHERE ICDMapping.ICD10CodeId = c.ICD10Code
					)
			FROM #ClientDiag CD
			WHERE CD.SNOMEDCodeICD10 IS NULL

			UPDATE #ClientDiag
			SET EndDate = NULL
			WHERE EndDate = '2199-12-31'

			UPDATE c
			SET c.duplicate = 'Y'
			FROM #ClientDiag c
			JOIN (
				SELECT startDate
					,ICD10Code
					,ROW_NUMBER() OVER (
						PARTITION BY ICD10Code ORDER BY startDate
							,ICD10Code
						) AS RRank
				FROM #ClientDiag
				WHERE EndDate IS NULL
				) I ON c.startDate = I.startDate
				AND c.ICD10Code = I.ICD10Code
				AND RRank > 1

			SELECT DISTINCT @RDLClientId AS ClientId
				,ICD9Code
				,ICD10Code
				,SNOMEDCodeICD10 AS SNOMEDCode
				,ICD10Desc AS Description
				,CASE isnull(EndDate, '')
					WHEN ''
						THEN 'Active'
					ELSE 'Completed'
					END AS ClinicalStatus
				,convert(VARCHAR(10), StartDate, 101) AS EffectiveDate
				,convert(VARCHAR(10), EndDate, 101) AS EndDate
				,RTRIM(replace([dbo].GetClientAgeByDOB((
								SELECT DOB
								FROM Clients C
								WHERE C.ClientId = @RDLClientId
									AND ISNULL(c.RecordDeleted, 'N') = 'N'
								), @RDLClientId), 'Years', '')) AS Age
			FROM #ClientDiag b
			WHERE CAST(b.EffectiveDate AS DATE) >= CAST(ISNULL(@RDLFromDate, '12/31/1901') AS DATE)
				AND CAST(b.EffectiveDate AS DATE) <= CAST(ISNULL(@RDLToDate, '12/31/2199') AS DATE)
				AND b.duplicate = 'N'
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetActiveProblems') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                           
				16
				,-- Severity.                                                                                  
				1 -- State.                                                                              
				);
	END CATCH
END
