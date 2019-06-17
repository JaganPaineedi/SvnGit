
/****** Object:  StoredProcedure [dbo].[ssp_RDLTransitionCareVisitInformationOutpatient]    Script Date: 07/26/2018 16:23:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLTransitionCareVisitInformationOutpatient]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLTransitionCareVisitInformationOutpatient]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLTransitionCareVisitInformationOutpatient]    Script Date: 07/26/2018 16:23:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[ssp_RDLTransitionCareVisitInformationOutpatient] @DocumentVersionId INT
AS
/******************************************************************************                                      
**  File: ssp_RDLTransitionCareVisitInformationOutpatient.sql                    
**  Name: ssp_RDLTransitionCareVisitInformationOutpatient                    
**  Desc:                     
**                                      
**  Return values: <Return Values>                                     
**                                       
**  Called by: <Code file that calls>                                        
**                                                    
**  Parameters:   @DocumentVersionId                                   
                
*******************************************************************************                                      
**  Change History                                      
*******************************************************************************                                      
**  Date:  Author:    Description:                                      
**  -------- --------   -------------------------------------------                 
          
** 17/08/2017 Ravichandra   why: Visit Information (Outpatient)           
         why: Meaningful Use - Stage 3 > Tasks #25.2 Transition of Care - PDF   
** 23/07/2018  Ravichandra	What: checked Service.Status 71-Show.75-Complete and casting to a date type for DateOfService    
							Why : KCMHSAS - Support  #1099 Summary of Care - issues (summary for all bugs)             
*******************************************************************************/
BEGIN
	SET NOCOUNT ON;

	DECLARE @FromDate DATE
		,@ToDate DATE
	DECLARE @TransitionType CHAR(1)
	DECLARE @ClientId INT

	BEGIN TRY
		SELECT TOP 1 @FromDate = cast(T.FromDate AS DATE)
			,@ToDate = cast(T.ToDate AS DATE)
			,@TransitionType = T.TransitionType
			,@ClientId = D.ClientId
		FROM TransitionOfCareDocuments T
		JOIN Documents D ON D.InProgressDocumentVersionId = T.DocumentVersionId
		WHERE ISNULL(T.RecordDeleted, 'N') = 'N'
			AND T.DocumentVersionId = @DocumentVersionId
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
  
		CREATE TABLE #OPDetails (
		    ServiceId Int
			,TransitionType VARCHAR(100)
			,AdmissionDate VARCHAR(20)
			,ProcedureCodeName VARCHAR(250)
			,ICD9Code VARCHAR(20)
			,ICD10Code VARCHAR(20)
			,SNOMED VARCHAR(30)
			,EncounterDiagnosis INT
			,ICD10Desc VARCHAR(max)
			,DSMVCodeId varchar(20)
			)

		INSERT INTO #OPDetails (
			ServiceId
			,TransitionType
			,AdmissionDate
			,ProcedureCodeName
			,ICD9Code
			,ICD10Code
			,ICD10Desc
			,DSMVCodeId
			)
		SELECT DISTINCT S.ServiceId, CASE 
				WHEN ISNULL(@TransitionType, '') = 'O'
					THEN 'Outpatient'
				WHEN ISNULL(@TransitionType, '') = 'I'
					THEN 'Inpatient'
				WHEN ISNULL(@TransitionType, '') = 'P'
					THEN 'Primary Care'
				END TransitionType
			,Convert(VARCHAR(10), S.DateOfService, 101) AS AdmissionDate
			,PC.ProcedureCodeName
			,REPLACE(REPLACE(SD.ICD9Code, '&amp;', ''), 'nbsp;', '') AS ICD9Code
			,REPLACE(REPLACE(SD.ICD10Code, '&amp;', ''), 'nbsp;', '') AS ICD10Code
			-- ,SD.[Order] AS EncounterDiagnosis    
			,icd10.ICDDescription AS ICD10Desc
			,SD.DSMVCodeId
		FROM Documents D
		JOIN Services S ON D.ServiceId = S.ServiceId
		JOIN ProcedureCodes PC ON PC.ProcedureCodeId = S.ProcedureCodeId
		LEFT JOIN ServiceDiagnosis SD ON SD.ServiceId = S.ServiceId AND ISNULL(SD.RecordDeleted, 'N') = 'N'
        LEFT JOIN dbo.DiagnosisICD10Codes icd10 ON icd10.ICD10Code = SD.ICD10Code and SD.DSMVCodeId = icd10.ICD10CodeId  
    AND ISNULL(icd10.RecordDeleted, 'N') = 'N'
		WHERE D.ClientId = @ClientId
			AND (
				@FromDate <= CAST(S.DateOfService AS DATE)
				AND CAST(S.DateOfService AS DATE) <= @ToDate  --23/07/2018  Ravichandra
				)
			AND ISNULL(D.RecordDeleted, 'N') = 'N'
			AND ISNULL(PC.RecordDeleted, 'N') = 'N'
			AND ISNULL(S.RecordDeleted, 'N') = 'N'
			AND S.[Status] IN (71,75) --71-Show.75-Complete  23/07/2018  Ravichandra

		UPDATE CD
		SET CD.SNOMED = (
				SELECT DISTINCT TOP 1 S.SNOMEDCTCode
				FROM ICD10SNOMEDCTMapping ICDMapping
				JOIN dbo.SNOMEDCTCodes S ON S.SNOMEDCTCodeId = ICDMapping.SNOMEDCTCodeId
					AND ISNULL(S.RecordDeleted, 'N') = 'N'
					AND ISNULL(ICDMapping.RecordDeleted, 'N') = 'N'
				WHERE CD.ICD10Code = ICDMapping.ICD10CodeId
				)
		FROM #OPDetails CD 

		
		SELECT  TransitionType
			,AdmissionDate
			,'' AS DischargedDate
			,ProcedureCodeName
			,ICD9Code
			,ICD10Code
			,SNOMED
			,ICD10Desc
		FROM #OPDetails
		ORDER BY AdmissionDate ASC
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) +
		 '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLTransitionCareVisitInformationOutpatient') 
		 + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' +
		  CONVERT(VARCHAR, ERROR_STATE())

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


