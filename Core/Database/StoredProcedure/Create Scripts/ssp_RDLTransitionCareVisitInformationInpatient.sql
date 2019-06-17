/****** Object:  StoredProcedure [dbo].[ssp_RDLTransitionCareVisitInformationInpatient]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_RDLTransitionCareVisitInformationInpatient'
		)
	DROP PROCEDURE [dbo].[ssp_RDLTransitionCareVisitInformationInpatient]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLTransitionCareVisitInformationInpatient]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLTransitionCareVisitInformationInpatient] @DocumentVersionId INT
AS
/******************************************************************************                                      
**  File: ssp_RDLTransitionCareVisitInformationInpatient.sql                    
**  Name: ssp_RDLTransitionCareVisitInformationInpatient  3368528                  
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
          
** 17/08/2017 Ravichandra   why: Visit Information (Inpatient)           
         why: Meaningful Use - Stage 3 > Tasks #25.2 Transition of Care - PDF                      
*******************************************************************************/
BEGIN
	SET NOCOUNT ON;

	DECLARE @FromDate DATE
		,@ToDate DATE
	DECLARE @TransitionType CHAR(1)
	DECLARE @ClientId INT

	BEGIN TRY
		------SELECT TOP 1 @FromDate = cast(FromDate AS DATE)  
		------ ,@ToDate = cast(ToDate AS DATE)  
		------ ,@TransitionType = TransitionType  
		------ ,@ClientId = D.ClientId  
		------FROM TransitionOfCareDocuments T  
		------JOIN Documents D ON D.InProgressDocumentVersionId = T.DocumentVersionId  
		------WHERE ISNULL(T.RecordDeleted, 'N') = 'N'  
		------ AND DocumentVersionId = @DocumentVersionId  
		------ AND ISNULL(D.RecordDeleted, 'N') = 'N'  
		------IF @TransitionType <> 'I'  
		------BEGIN  
		------ RETURN  
		------END  
		------CREATE TABLE #OPDetails (  
		------ TransitionType VARCHAR(100)  
		------ ,AdmissionDate VARCHAR(20)  
		------ ,DischargedDate VARCHAR(20)  
		------ ,ProcedureCodeName VARCHAR(250)  
		------ ,ICD9Code VARCHAR(20)  
		------ ,ICD10Code VARCHAR(20)  
		------ ,SNOMED VARCHAR(30)  
		------ ,EncounterDiagnosis INT  
		------ ,ICD10Desc VARCHAR(max)  
		------ )  
		------INSERT INTO #OPDetails (  
		------ TransitionType  
		------ ,AdmissionDate  
		------ ,DischargedDate  
		------ ,ProcedureCodeName  
		------ ,ICD9Code  
		------ ,ICD10Code  
		------ ,ICD10Desc  
		------ )  
		------SELECT CASE   
		------  WHEN ISNULL(@TransitionType, '') = 'O'  
		------   THEN 'Outpatient'  
		------  WHEN ISNULL(@TransitionType, '') = 'I'  
		------   THEN 'Inpatient'  
		------  WHEN ISNULL(@TransitionType, '') = 'P'  
		------   THEN 'Primary Care'  
		------  END TransitionType  
		------ ,Convert(VARCHAR(10), CIV.AdmitDate, 101) AS AdmissionDate  
		------ ,CONVERT(VARCHAR(10), CIV.DischargedDate, 101) AS DischargedDate  
		------ ,PC.ProcedureCodeName  
		------ ,REPLACE(REPLACE(SD.ICD9Code, '&amp;', ''), 'nbsp;', '') AS ICD9Code  
		------ ,REPLACE(REPLACE(SD.ICD10Code, '&amp;', ''), 'nbsp;', '') AS ICD10Code  
		------ --,SD.[Order] AS EncounterDiagnosis     
		------ ,icd10.ICDDescription AS ICD10Desc  
		------FROM Documents D  
		------JOIN Services S ON D.ServiceId = S.ServiceId  
		------JOIN ProcedureCodes PC ON PC.ProcedureCodeId = S.ProcedureCodeId  
		------LEFT JOIN ServiceDiagnosis SD ON SD.ServiceId = S.ServiceId  
		------LEFT JOIN dbo.DiagnosisICD10Codes icd10 ON icd10.ICD10Code = SD.ICD10Code  
		------JOIN ClientInpatientVisits AS CIV ON CIV.ClientId = D.ClientId  
		------JOIN BedAssignments BA ON BA.ClientInpatientVisitId = CIV.ClientInpatientVisitId  
		------WHERE D.ClientId = @ClientId  
		------ AND (  
		------  @FromDate <= S.DateOfService  
		------  AND S.DateOfService <= @ToDate  
		------  )  
		------ --AND (@FromDate <= D.EffectiveDate              
		------ --    AND D.EffectiveDate <= @ToDate              
		------ --    )           
		------ --AND (@FromDate <= CAST(CIV.AdmitDate As Date)  
		------ --    AND ISNULL(CIV.DischargedDate,@ToDate) <= @ToDate          
		------ -- )             
		------ AND ISNULL(D.RecordDeleted, 'N') = 'N'  
		------ AND ISNULL(PC.RecordDeleted, 'N') = 'N'  
		------ AND ISNULL(SD.RecordDeleted, 'N') = 'N'  
		------ AND ISNULL(S.RecordDeleted, 'N') = 'N'  
		------UPDATE CD  
		------SET CD.SNOMED = (  
		------  SELECT DISTINCT TOP 1 S.SNOMEDCTCode  
		------  FROM ICD10SNOMEDCTMapping ICDMapping  
		------  JOIN dbo.SNOMEDCTCodes S ON S.SNOMEDCTCodeId = ICDMapping.SNOMEDCTCodeId  
		------   AND ISNULL(S.RecordDeleted, 'N') = 'N'  
		------   AND ISNULL(ICDMapping.RecordDeleted, 'N') = 'N'  
		------  WHERE CD.ICD10Code = ICDMapping.ICD10CodeId  
		------  )  
		------FROM #OPDetails CD  
		------SELECT TransitionType  
		------ ,AdmissionDate  
		------ ,DischargedDate  
		------ ,ProcedureCodeName  
		------ ,ICD9Code  
		------ ,ICD10Code  
		------ ,SNOMED  
		------ ,ICD10Desc  
		------FROM #OPDetails  
		EXEC ssp_RDLTransitionCareVisitInformationOutpatient @DocumentVersionId
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLTransitionCareVisitInformationInpatient') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '** 
 
***' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.                                                                                   
				16
				,-- Severity.                                                                       
				1 -- State.                                                                       
				);
	END CATCH
END
