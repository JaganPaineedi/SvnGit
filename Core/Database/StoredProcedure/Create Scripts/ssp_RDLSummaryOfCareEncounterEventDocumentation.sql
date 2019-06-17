/****** Object:  StoredProcedure [dbo].[ssp_RDLSummaryOfCareEncounterEventDocumentation]    Script Date: 07/25/2018 19:11:21 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLSummaryOfCareEncounterEventDocumentation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLSummaryOfCareEncounterEventDocumentation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLSummaryOfCareEncounterEventDocumentation]    Script Date: 07/25/2018 19:11:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLSummaryOfCareEncounterEventDocumentation] @DocumentVersionId INT
AS
-- =============================================          
-- Author:  Ravi          
-- Create date: sep 13, 2017          
-- Description: Retrieves Procedures details    
-- Task:   MUS3 - Task#25.2         
/*          
 Modified Date	Author		Reason  
 12/12/2017		Ravichandra	changes done for new requirement 
							Meaningful Use Stage 3 task 68 - Summary of Care        
 23/07/2018  Ravichandra	What: checked Service.Status 71-Show.75-Complete and casting to a date type for DateOfService  and Get Type values from SNOMEDCTCodes
							Why : KCMHSAS - Support  #1099 Summary of Care - issues (summary for all bugs)  
11-14-2018     BFagaly   changed code to show results in RDL for Type,CodeType and Code for summary of care document  also comment out the above code(Per Tom R) by Ravichandra as this code 
                          was never released for Kalamazoo(task was closed)
-- =============================================   */
BEGIN
	BEGIN TRY
		DECLARE @FromDate DATE
		DECLARE @ToDate DATE
		DECLARE @ClientId INT
		DECLARE @Type CHAR(1)

		SELECT TOP 1 @FromDate = cast(T.FromDate AS DATE)
			,@ToDate = cast(T.ToDate AS DATE)
			,@Type = T.TransitionType
			,@ClientId = D.ClientId
		FROM TransitionOfCareDocuments T
		JOIN Documents D ON D.InProgressDocumentVersionId = T.DocumentVersionId
		WHERE ISNULL(T.RecordDeleted, 'N') = 'N'
			AND T.DocumentVersionId = @DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'

		--CREATE TABLE #EncounterEventDocumentation (
		--	ServiceId INT
		--	,ProcedureCodeId INT
		--	,ProcedureCodeName VARCHAR(250)
		--	,Type VARCHAR(max)
		--	,CodeType VARCHAR(250)
		--	,Code VARCHAR(25)
		--	,ICD10Code VARCHAR(20)
		--	,DSMVCodeId VARCHAR(20)
		--	)

		--INSERT INTO #EncounterEventDocumentation (
		--	ServiceId
		--	,ProcedureCodeId
		--	,ProcedureCodeName
		--	,Type
		--	,CodeType
		--	,Code
		--	,ICD10Code
		--	,DSMVCodeId
		--	)

			SELECT PC.ProcedureCodeName AS ProcedureCodeName
             , DC.ICDDescription AS 'Type'
             , CASE WHEN DC.DSMVCode=NULL Then 'ICD10' ELSE 'DSMV'  END AS 'CodeType' 
             , SD.ICD10Code AS 'Code'
        FROM [Services] s
	    JOIN ProcedureCodes PC ON PC.ProcedureCodeId = s.ProcedureCodeId
		JOIN ServiceDiagnosis SD ON SD.ServiceId=S.ServiceId
	    JOIN DiagnosisICD10Codes DC ON DC.ICD10CodeId=SD.DSMVCodeId
		WHERE S.ClientId = @ClientId
			AND s.DateOfService >= @FromDate
			AND s.EndDateOfService <= @ToDate
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND ISNULL(PC.RecordDeleted, 'N') = 'N'
			AND ISNULL(SD.RecordDeleted, 'N') = 'N'
		--SELECT distinct S.ServiceId
		--	,PC.ProcedureCodeId
		--	,PC.ProcedureCodeName AS ProcedureCodeName
		--	,NULL AS Type --23/07/2018  Ravichandra
		--	,dbo.ssf_GetGlobalCodeNameById(PC.ExternalSource2) AS 'CodeType'
		--	,PC.ExternalCode2 AS 'Code'
		--	 ,SD.ICD10Code
		--	, SD.DSMVCodeId
		--FROM [Services] s
		--JOIN ProcedureCodes PC ON PC.ProcedureCodeId = s.ProcedureCodeId
		--LEFT JOIN ServiceDiagnosis SD ON SD.ServiceId = S.ServiceId
		--	AND ISNULL(SD.RecordDeleted, 'N') = 'N'
		-----23/07/2018  Ravichandra
		--WHERE S.ClientId = @ClientId
		--	--23/07/2018  Ravichandra
		--	AND S.[Status] IN (
		--		71
		--		,75
		--		) --71-Show, 75-Complete
		--	AND CAST(s.DateOfService AS DATE) >= @FromDate
		--	AND CAST(s.EndDateOfService AS DATE) <= @ToDate
		--	AND ISNULL(S.RecordDeleted, 'N') = 'N'
		--	AND ISNULL(PC.RecordDeleted, 'N') = 'N'
		--ORDER BY S.ServiceId

		--UPDATE T
		--SET Type = CASE 
		--		WHEN ISNULL(SN.SNOMEDCTCode, '') <> ''
		--			THEN SN.SNOMEDCTDescription
		--		ELSE ''
		--		END
		--FROM #EncounterEventDocumentation T
		--JOIN dbo.DiagnosisICD10Codes icd10 ON icd10.ICD10Code = T.ICD10Code
		--	AND T.DSMVCodeId = icd10.ICD10CodeId
		--	AND ISNULL(icd10.RecordDeleted, 'N') = 'N'
		--JOIN ICD10SNOMEDCTMapping ICDMapping ON ICDMapping.ICD10CodeId = icd10.ICD10Code
		--	AND ISNULL(ICDMapping.RecordDeleted, 'N') = 'N'
		--JOIN dbo.SNOMEDCTCodes SN ON SN.SNOMEDCTCodeId = ICDMapping.SNOMEDCTCodeId
		--WHERE ISNULL(SN.RecordDeleted, 'N') = 'N'

		--SELECT ServiceId
		--	,ProcedureCodeId
		--	,ProcedureCodeName
		--	,Type
		--	,CodeType
		--	,Code
		--FROM #EncounterEventDocumentation
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLSummaryOfCareEncounterEventDocumentation') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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


