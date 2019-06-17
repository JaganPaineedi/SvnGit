IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLDocumentCALOCUS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLDocumentCALOCUS]  
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[ssp_RDLDocumentCALOCUS] (@DocumentVersionId INT)
AS
/***********************************************************************************/
/* Stored Procedure: [ssp_RDLDocumentCALOCUS] 1306292 1306288       */
/* Creation Date:  DEC 1 ,2018                                                    */
/* Purpose: RDL Data from DocumentCALOCUS	   */
/* Input Parameters: @DocumentVersionId                                            */
/* Purpose: Use For Rdl Report                                                     */
/* Author: Bibhu		*/
/* What : created Report for DocumentCALOCUS					*/
/* whay : Task #21 	MHP - Enhancements                              */
/*******************************************************************************************************************************/

BEGIN
	BEGIN TRY
	
	
	DECLARE @OrganizationName varchar(250)
	Declare @TotalScore INT  
    SELECT TOP 1 @OrganizationName = OrganizationName from SystemConfigurations    
	
   
   SELECT 
    @OrganizationName AS OrganizationName
    ,D.ClientId 
	,ISNULL(C.LastName, '') + ' ' + ISNULL(C.FirstName, '') AS ClientName
	,CONVERT(VARCHAR(10), D.EffectiveDate, 101)  AS EffectiveDate				
	,CONVERT(VARCHAR(10), C.DOB, 101) AS DOB		
	,DC.DocumentName	
	,DocumentVersionId		
	,CALocusScore		
	,(SELECT CodeName from dbo.GlobalCodes WHERE Category='CALOCUSLEVEL' AND IsNull(RecordDeleted,'N')<>'Y' AND Active='Y' AND ExternalCode1= CAST(CAST(CALocusScore AS INT) AS VARCHAR))AS CALocusScoreText
	,CAST(RiskOfHarmScore AS INTEGER) as RiskOfHarmScore
	,CAST(FunctionalStatusScore AS INTEGER) as FunctionalStatusScore
	,CAST(CoMorbidityScore AS INTEGER) as CoMorbidityScore
	,CAST(RecoveryEnvironmentStressScore AS INTEGER) as RecoveryEnvironmentStressScore
	,CAST(RecoveryEnvironmentSupportScore AS INTEGER) as RecoveryEnvironmentSupportScore
	,CAST(ResiliencyTreatmentHistoryScore AS INTEGER) as ResiliencyTreatmentHistoryScore
	,CAST(TreatmentAcceptanceEngagementChildScore AS INTEGER) as TreatmentAcceptanceEngagementChildScore
	,CAST(TreatmentAcceptanceEngagementParentScore AS INTEGER) as TreatmentAcceptanceEngagementParentScore
	,EvaluationNotes
	,CAST(( RiskOfHarmScore+FunctionalStatusScore+CoMorbidityScore+RecoveryEnvironmentStressScore+RecoveryEnvironmentSupportScore+ResiliencyTreatmentHistoryScore+TreatmentAcceptanceEngagementChildScore+TreatmentAcceptanceEngagementParentScore) AS INTEGER) as TotalScore 	
	,DL.CurrentLevelOfCare
	,CASE
		WHEN CAST(CALocusScore AS INTEGER)=0 Then 'Basic Services for Prevention and Maintenance' 
		When CAST(CALocusScore AS INTEGER)=1 Then 'Level One – Recovery Maintenance and Health Management'
		When CAST(CALocusScore AS INTEGER) =2 Then 'Level Two – Low Intensity Community Based Services'
		When CAST(CALocusScore AS INTEGER) =3 Then 'Level Three – High Intensity Community Based Services'
		When CAST(CALocusScore AS INTEGER) =4 Then 'Level Four – Medically Monitored Non-Residential Services'
		When CAST(CALocusScore AS INTEGER) =5 Then 'Level Five – Medically Monitored Residential Services'
		When CAST(CALocusScore AS INTEGER) =6 Then 'Level Six – Medically Managed Residential Services'
		Else ''
	End	As	RecommendedDisposition
	,dbo.ssf_GetGlobalCodeNameById(DL.ActualDisposition) AS ActualDisposition 
	,dbo.ssf_GetGlobalCodeNameById(DL.ReasonForVariance) AS ReasonForVariance 
	,dbo.ssf_GetGlobalCodeNameById(DL.ProgramReferredTo) AS ProgramReferredTo 	
	FROM DocumentCALOCUS DL
    INNER JOIN Documents D ON D.InProgressDocumentVersionId=DL.DocumentVersionId 
    INNER JOIN Clients C ON C.ClientId=D.ClientId
    INNER JOIN DOcumentCodes DC ON DC.DocumentCodeId=D.DocumentCodeId      
	WHERE  DL.DocumentVersionId=@DocumentVersionId 
		AND ISNULL(DL.RecordDeleted, 'N') = 'N'
		AND ISNULL(D.RecordDeleted, 'N') = 'N'
		AND ISNULL(C.RecordDeleted, 'N') = 'N'   
		AND ISNULL(DC.RecordDeleted, 'N') = 'N'     
		
		
  END TRY  
 BEGIN CATCH  
  DECLARE @Error VARCHAR(8000)  
  
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLDocumentCALOCUS') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())  
  
  RAISERROR (  
    @Error  
    ,-- Message text.  
    16  
    ,-- Severity.  
    1 -- State.  
    );  
 END CATCH  
END    