
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitCustomDiagnosisInitializationForAssessment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitCustomDiagnosisInitializationForAssessment]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
                    
CREATE PROCEDURE  [dbo].[ssp_InitCustomDiagnosisInitializationForAssessment]                                  
(                                                                                                                                                              
 @DocumentVersionId int ,
 @CurrentAuthorId int          
)                  
As                    
 /* Stored Procedure: [ssp_InitCustomDiagnosisInitializationForAssessment]   */                                                                                                                                                                                 
  
    
 /* Copyright: 2006 Streamline SmartCare            */    
 /* Creation Date:  19/August/2015               */                                                                                                                                                                                                            
 /*                      */                                                                                                                                                                                                         
 /* Purpose: To Initialize ICD 9 or ICD 10 values        */                                                                                                                                                                                             
                                  
 /*********************************************************************/                       
  BEGIN                  
  BEGIN TRY 
  DECLARE @DSMV CHAR(1)
  Declare @GAF INT
  declare @usercode varchar(100);
  Declare @OtherMedicalCondition varchar(max)
  
  Select @usercode = UserCode from Staff Where StaffId = @CurrentAuthorId
  
   IF EXISTS (select 1 from DocumentDiagnosis where DocumentVersionId = @DocumentVersionId)
     BEGIN
       SET @DSMV = 'Y'
     END
     IF EXISTS (select 1 from DiagnosesIandII where DocumentVersionId = @DocumentVersionId)
     BEGIN
       SET @DSMV = 'N'
     END
     
     IF @DSMV = 'Y'
     BEGIN
     SELECT Placeholder.TableName 
      ,@usercode AS CreatedBy
      ,GETDATE() AS CreatedDate
      ,@usercode AS ModifiedBy
      ,GETDATE() AS ModifiedDate
      ,DDC.RecordDeleted 
      ,DDC.DeletedDate
      ,DDC.DeletedBy
      ,ISNULL(DDC.DocumentVersionId,-1) AS DocumentVersionId
      ,DDC.ICD10CodeId
      ,DDC.ICD10Code
      ,DDC.ICD9Code                                                              
      ,DDC.DiagnosisType
      ,DDC.RuleOut
      ,DDC.Billable                                                                
      ,DDC.Severity
      ,DDC.DiagnosisOrder
      ,DDC.Specifier
      ,DDC.Remission
      ,DDC.[Source]       
      ,ICD10.ICDDescription AS DSMDescription
      ,case DDC.RuleOut when 'Y' then 'R/O' else '' end as RuleOutText
      ,dbo.csf_GetGlobalCodeNameById(DDC.DiagnosisType)as 'DiagnosisTypeText'
      ,dbo.csf_GetGlobalCodeNameById(DDC.Severity) as 'SeverityText'
      ,DDC.Comments
      ,DDC.SNOMEDCODE
      ,SNC.SNOMEDCTDescription
      FROM (SELECT 'DocumentDiagnosisCodes' AS TableName) AS Placeholder  
      LEFT JOIN DocumentDiagnosisCodes DDC ON ( DDC.DocumentVersionId = @DocumentVersionId  
      AND ISNULL(DDC.RecordDeleted,'N') <> 'Y' )
      INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = DDC.ICD10CodeId
      LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = DDC.SNOMEDCODE 
      
      SELECT Placeholder.TableName
	,@usercode AS [CreatedBy]  
	,GETDATE() AS [CreatedDate]  
	,@usercode AS [ModifiedBy]  
	,GETDATE() AS [ModifiedDate]  
	,ISNULL(DD.DocumentVersionId,-1) AS DocumentVersionId 
	,DD.ScreeeningTool
	,DD.OtherMedicalCondition
	,DD.FactorComments
	,DD.GAFScore
	,DD.WHODASScore
	,DD.CAFASScore 
	FROM (SELECT 'DocumentDiagnosis' AS TableName) AS Placeholder  
      LEFT JOIN DocumentDiagnosis DD ON ( DD.DocumentVersionId = @DocumentVersionId AND ISNULL(DD.RecordDeleted,'N') <> 'Y' )
     END
     ELSE IF @DSMV = 'N'
     BEGIN
     
  Set @GAF = (Select AxisV from DiagnosesV Where DocumentVersionId = @DocumentVersionId)
  Set @OtherMedicalCondition = (Select Specification from DiagnosesIII Where DocumentVersionId = @DocumentVersionId)
  SELECT 'DocumentDiagnosisCodes' AS TableName
      ,@usercode AS CreatedBy
      ,GETDATE() AS CreatedDate
      ,@usercode AS ModifiedBy
      ,GETDATE() AS ModifiedDate
      ,DIandII.RecordDeleted 
      ,DIandII.DeletedDate
      ,DIandII.DeletedBy
      ,ISNULL(DIandII.DocumentVersionId,-1) AS DocumentVersionId
      ,CASE WHEN (SELECT COUNT(SubMapping.ICD9Code) AS Rcount
                    FROM  DiagnosisICD10ICD9Mapping AS SubMapping INNER JOIN
                      DiagnosisICD10Codes AS DSMVCodes ON SubMapping.ICD10CodeId = DSMVCodes.ICD10CodeId INNER JOIN
                      DiagnosesIAndII ON SubMapping.ICD9Code = DiagnosesIAndII.DSMCode
               WHERE DSMVCodes.ICD10Code IS NOT NULL AND SubMapping.ICD9Code = Mapping.ICD9Code AND
                DiagnosesIAndII.DocumentVersionId = @DocumentVersionId AND ISNULL(DiagnosesIAndII.RecordDeleted,'N') <> 'Y' ) > 1 THEN '<img src="../App_Themes/Includes/Images/Alert2.png" title="Diagnosis '+ Mapping.ICD9Code +' has been converted to '+ DSMVCodes.ICD10Code+'"/>     '+ DSMVCodes.ICDDescription ELSE DSMVCodes.ICDDescription END AS DSMDescription
      ,DSMVCodes.ICD10Code  + case DSMVCodes.DSMVCode when 'Y' then '*' else '' end AS ICD10Code
      ,Mapping.ICD9Code                                                                
      ,DSMVCodes.ICD10CodeId 
      ,DIandII.DiagnosisType
      ,DIandII.RuleOut
      ,DIandII.Billable                                                                
      ,DIandII.Severity
      --,DIandII.DSMVersion
      ,DIandII.DiagnosisOrder
      ,Convert(Varchar(max),DIandII.Specifier) AS Specifier
      ,DIandII.[Source]
      ,DIandII.Remission
      ,case DIandII.RuleOut when 'Y' then 'R/O' else '' end as RuleOutText
      , dbo.csf_GetGlobalCodeNameById(DIandII.DiagnosisType)as 'DiagnosisTypeText' 
      ,dbo.csf_GetGlobalCodeNameById(DIandII.Severity) as 'SeverityText'     
      , CASE WHEN (SELECT COUNT(SubMapping.ICD9Code) AS Rcount
                    FROM  DiagnosisICD10ICD9Mapping AS SubMapping INNER JOIN
                      DiagnosisICD10Codes AS DSMVCodes ON SubMapping.ICD10CodeId = DSMVCodes.ICD10CodeId INNER JOIN
                      DiagnosesIAndII ON SubMapping.ICD9Code = DiagnosesIAndII.DSMCode
               WHERE DSMVCodes.ICD10Code IS NOT NULL AND SubMapping.ICD9Code = Mapping.ICD9Code AND
                DiagnosesIAndII.DocumentVersionId = @DocumentVersionId AND ISNULL(DiagnosesIAndII.RecordDeleted,'N') <> 'Y' ) > 1 THEN 'Y' ELSE 'N' END AS MultipleDiagnosis  
      ,@DocumentVersionId AS ICD9DocumentVersionId
      FROM (SELECT 'DiagnosesIAndII' AS TableName) AS Placeholder  
      LEFT JOIN DiagnosesIAndII DIandII ON ( DIandII.DocumentVersionId = @DocumentVersionId  
      AND ISNULL(DIandII.RecordDeleted,'N') <> 'Y' )
      left outer join DiagnosisICD10ICD9Mapping Mapping on  DIandII.DSMCode = Mapping.ICD9Code
      INNER JOIN DiagnosisICD10Codes DSMVCodes ON Mapping.ICD10CodeId = DSMVCodes.ICD10CodeId
      WHERE DSMVCodes.ICD10Code IS NOT NULL 
      UNION
      SELECT 'DocumentDiagnosisCodes' AS TableName
                ,DIII.CreatedBy
				,DIII.CreatedDate
				,DIII.ModifiedBy
				,DIII.ModifiedDate
				,DIII.RecordDeleted
				,DIII.DeletedDate
				,DIII.DeletedBy
				,- 1 AS DocumentVersionId
				,CASE WHEN (SELECT COUNT(SubMapping.ICD9Code) AS Rcount
                    FROM  DiagnosisICD10ICD9Mapping AS SubMapping INNER JOIN
                      DiagnosisICD10Codes AS DSMVCodes ON SubMapping.ICD10CodeId = DSMVCodes.ICD10CodeId INNER JOIN
                      DiagnosesIIICodes ON SubMapping.ICD9Code = DiagnosesIIICodes.ICDCode
               WHERE DSMVCodes.ICD10Code IS NOT NULL AND SubMapping.ICD9Code = Mapping.ICD9Code AND
                DiagnosesIIICodes.DocumentVersionId = @DocumentVersionId AND ISNULL(DiagnosesIIICodes.RecordDeleted,'N') <> 'Y' ) > 1 THEN '<img src="../App_Themes/Includes/Images/Alert2.png" title="Diagnosis '+ Mapping.ICD9Code +' has been converted to '+ DSMVCodes.ICD10Code+'"/>     '+ DSMVCodes.ICDDescription ELSE DSMVCodes.ICDDescription END AS DSMDescription
				,DSMVCodes.ICD10Code + case DSMVCodes.DSMVCode when 'Y' then '*' else '' end AS ICD10Code
				,DIII.ICDCode AS ICD9Code
				,DSMVCodes.ICD10CodeId 
				,142 AS DiagnosisType
				,NULL AS RuleOut
				,DIII.Billable
				,NULL AS Severity
				,CONVERT(INT,ROWCOUNT_BIG()) AS DiagnosisOrder
				,NULL AS Specifier
				,NULL AS [Source]
				,NULL AS Remission
				,'' AS RuleOutText
				,dbo.csf_GetGlobalCodeNameById(142)as 'DiagnosisTypeText' 
				,NULL AS 'SeverityText'
				, CASE WHEN (SELECT COUNT(SubMapping.ICD9Code) AS Rcount
                    FROM  DiagnosisICD10ICD9Mapping AS SubMapping INNER JOIN
                      DiagnosisICD10Codes AS DSMVCodes ON SubMapping.ICD10CodeId = DSMVCodes.ICD10CodeId INNER JOIN
                      DiagnosesIIICodes ON SubMapping.ICD9Code = DiagnosesIIICodes.ICDCode
               WHERE DSMVCodes.ICD10Code IS NOT NULL AND SubMapping.ICD9Code = Mapping.ICD9Code AND
                DiagnosesIIICodes.DocumentVersionId = @DocumentVersionId AND ISNULL(DiagnosesIIICodes.RecordDeleted,'N') <> 'Y' ) > 1 THEN 'Y' ELSE 'N' END AS MultipleDiagnosis  
            ,@DocumentVersionId AS ICD9DocumentVersionId
			FROM (SELECT 'DiagnosesIIICodes' AS TableName) AS Placeholder  
			   LEFT JOIN DiagnosesIIICodes DIII ON ( DIII.DocumentVersionId = @DocumentVersionId  
			  AND ISNULL(DIII.RecordDeleted,'N') <> 'Y' )
			  left outer join DiagnosisICD10ICD9Mapping Mapping on  DIII.ICDCode = Mapping.ICD9Code
			  INNER JOIN DiagnosisICD10Codes DSMVCodes ON Mapping.ICD10CodeId = DSMVCodes.ICD10CodeId
			  WHERE DSMVCodes.ICD10Code IS NOT NULL 
     
      SELECT Placeholder.TableName
	,@usercode AS [CreatedBy]  
	,GETDATE() AS [CreatedDate]  
	,@usercode As [ModifiedBy]  
	,GETDATE() AS [ModifiedDate]   
	,ISNULL(DD.DocumentVersionId,-1) AS DocumentVersionId 
	,DD.ScreeeningTool
	,@OtherMedicalCondition AS OtherMedicalCondition
	,DD.FactorComments
	,case @GAF when 0 then DD.GAFScore else @GAF end as GAFScore
	,DD.WHODASScore
	,DD.CAFASScore 
	FROM (SELECT 'DocumentDiagnosis' AS TableName) AS Placeholder  
      LEFT JOIN DocumentDiagnosis DD ON ( DD.DocumentVersionId = @DocumentVersionId AND ISNULL(DD.RecordDeleted,'N') <> 'Y' )

     END
     ELSE
     BEGIN
       SELECT 'DocumentDiagnosis' AS TableName
	,@usercode AS [CreatedBy]  
	,GETDATE() AS [CreatedDate]  
	,@usercode AS [ModifiedBy]  
	,GETDATE() AS [ModifiedDate]  
	,-1 AS DocumentVersionId 
	,DD.ScreeeningTool
	,DD.OtherMedicalCondition
	,DD.FactorComments
	,DD.GAFScore
	,DD.WHODASScore
	,DD.CAFASScore 
	FROM  
   systemconfigurations s  
   LEFT OUTER JOIN DocumentDiagnosis DD  
    ON s.Databaseversion = -1 
     END
  
  END TRY                                            
                                              
  BEGIN CATCH                                      
  DECLARE @Error varchar(8000)                                                                                                                                                   
  SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                                                                               
     
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_InitCustomDiagnosisInitializationForAssessment')                                                                                                             
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                                                                                                                        
   + '*****' + Convert(varchar,ERROR_STATE())                                                                                           
  RAISERROR                                                                                                             
 (                                                                             
  @Error, -- Message text.                                                                                                                                                  
  16, -- Severity.                                                                                                                                                                                                                                       
  1 -- State.                                             
  );                                              
END CATCH                                               
                                             
 END   
  