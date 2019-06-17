/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummarySmoking]     ******/
IF EXISTS (
		SELECT 1
		FROM INFORMATION_SCHEMA.ROUTINES
		WHERE SPECIFIC_SCHEMA = 'dbo'
			AND SPECIFIC_NAME = 'ssp_RDLClinicalSummarySmoking'
		)
	DROP PROCEDURE [dbo].[ssp_RDLClinicalSummarySmoking]
GO

/****** Object:  StoredProcedure [dbo].[ssp_RDLClinicalSummarySmoking]     ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO  

CREATE PROCEDURE [dbo].[ssp_RDLClinicalSummarySmoking] @ServiceId INT = NULL    
 ,@ClientId INT = NULL    
 ,@DocumentVersionId INT    
AS    
/******************************************************************************                                          
**  File: ssp_RDLClinicalSummarySmoking.sql                        
**  Name: ssp_RDLClinicalSummarySmoking  @DocumentVersionId=3314687                     
**  Desc:                         
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
**  -------- --------    -------------------------------------------                           
**  02/05/2014   Veena S Mani        Added parameters ClientId and EffectiveDate-Meaningful Use #18                          
**  19/05/2014  Veena S Mani        Added parameters DocumentId and removed EffectiveDate to make SP reusable for MeaningfulUse #7,#18 and #24.Also added the logic for the same.                          
**  14/07/2014   Veena S Mani        Added a filter to show only the recent document.                     
    03/09/2014  Revathi   what:check RecordDeleted , avoid Ambiguous column                    
         why:task#36 MeaningfulUse                            
**  10/06/2014  Pradeep.A    Added GroupBy condition  
	12/12/2017		Ravichandra	changes done for new requirement 
							Meaningful Use Stage 3 task 68 - Summary of Care 
**  23/07/2018		Ravichandra	What: casting to a date type for HealthRecordDate, HealthDataTemplateId = 110  checked with dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALS')  and CH.HealthDataAttributeId = 123 with dbo.ssf_RecodeValuesCurrent('SMOKINGSTATUS') 
								Why : KCMHSAS - Support  #1099 Summary of Care - issues (summary for all bugs)                       
*******************************************************************************/    
BEGIN    
 -- SET NOCOUNT ON added to prevent extra result sets from                        
 -- interfering with SELECT statements.                        
 SET NOCOUNT ON;    
    
 DECLARE @DOS DATETIME = NULL    
 DECLARE @DOSLatest DATETIME = NULL    
 --Declare @ClientId INT                  
 DECLARE @Type CHAR(1)    
 DECLARE @FromDate DATE    
  ,@ToDate DATE    
    
 BEGIN TRY    
  BEGIN    
   SELECT TOP 1 @DOS = D.EffectiveDate    
    ,@ClientId = D.ClientId    
    ,@FromDate = cast(T.FromDate AS DATE)    
    ,@ToDate = cast(T.ToDate AS DATE)    
    ,@Type = T.TransitionType    
   FROM Documents D    
   JOIN TransitionOfCareDocuments T ON T.DocumentVersionId = D.InProgressDocumentVersionId    
   WHERE D.InProgressDocumentVersionId = @DocumentVersionId    
    AND ISNULL(D.RecordDeleted, 'N') = 'N'    
    AND ISNULL(T.RecordDeleted, 'N') = 'N'    
    
   CREATE TABLE #SmokingSection (    
    HealthDataAttributeId INT    
    ,HealthRecordDate DATETIME    
    ,SmokingStatus VARCHAR(250)    
    ,SmokingEndDate VARCHAR(50)    
    ,[DATE] DATETIME    
    ,SNOMED VARCHAR(250)    
    )    
    
   INSERT INTO #SmokingSection    
   SELECT ch.HealthDataAttributeId    
    ,CH.HealthRecordDate    
    ,dbo.csf_GetGlobalCodeNameById(FLOOR(CH.Value))    
    ,NULL AS SmokingEndDate    
    ,NULL    
    ,G.ExternalCode1 AS SNOMED    
   FROM ClientHealthDataAttributes CH    
   JOIN GlobalCodes G ON CH.Value = G.GlobalCodeId    
   WHERE CH.ClientId = @ClientId    
    --AND CH.HealthDataTemplateId = 110    
    --AND CH.HealthDataAttributeId = 123  
    
    --KCMHSAS - Support #1099
    AND CH.HealthDataTemplateId IN (
				SELECT IntegerCodeId
				FROM dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALS')
				)
    AND CH.HealthDataAttributeId IN (
					SELECT IntegerCodeId
					FROM dbo.ssf_RecodeValuesCurrent('SMOKINGSTATUS')
					)
    AND ISNULL(CH.RecordDeleted, 'N') = 'N'    
    AND CAST(CH.HealthRecordDate AS DATE) BETWEEN @FromDate AND  @ToDate  
   ORDER BY CH.HealthRecordDate DESC    
    
   UPDATE s    
   SET s.SmokingEndDate = ch.Value    
   FROM #SmokingSection s    
   JOIN ClientHealthDataAttributes CH ON s.HealthRecordDate = ch.HealthRecordDate    
   WHERE CH.ClientId = @ClientId    
   
    --KCMHSAS - Support #1099
    AND CH.HealthDataTemplateId IN (
				SELECT IntegerCodeId
				FROM dbo.ssf_RecodeValuesCurrent('MEANINGFULUSEVITALS')
				)  
   -- AND CH.HealthDataAttributeId = 1357   
     AND CH.HealthDataAttributeId IN (
					SELECT IntegerCodeId
					FROM dbo.ssf_RecodeValuesCurrent('SMOKINGENDDATE') --KCMHSAS - Support #1099
					) 
    AND CAST(CH.HealthRecordDate AS DATE) >= @FromDate    
    AND CAST(CH.HealthRecordDate AS DATE) <= @ToDate    
    AND ISNULL(CH.RecordDeleted, 'N') = 'N'    
    
   SELECT DISTINCT CONVERT(VARCHAR, HealthRecordDate, 107) AS [DATE]    
    ,CONVERT(VARCHAR, SmokingEndDate, 107) AS SmokingEndDate    
    ,SmokingStatus    
    ,SNOMED    
   FROM #SmokingSection    
  END    
 END TRY    
    
 BEGIN CATCH    
  DECLARE @Error VARCHAR(8000)    
    
  SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_RDLClinicalSummarySmoking') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY    
    ()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())    
    
  RAISERROR (    
    @Error    
    ,-- Message text.                                                                                       
    16    
    ,-- Severity.                                                                              
    1 -- State.                                                                           
    );    
 END CATCH    
END 

