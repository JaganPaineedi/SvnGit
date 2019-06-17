IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetDataDiagnosisNew]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetDataDiagnosisNew]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[ssp_SCGetDataDiagnosisNew]                          
(                                                      
@DocumentVersionId INT                                                                   
)                                                                              
As                                                                                
 /*********************************************************************/                                                                                          
 /* Stored Procedure:[ssp_SCGetDataDiagnosisNew]*/                                                                      
 /* Creation Date: 19 May 2014                                         */                                                                                          
 /*                                                                    */                                                                                          
 /* Purpose: To Initialize                                             */                                                                                         
 /*                                                                    */                                                                                          
 /* Created By: Bernardin                                              */                                                                                
 /*                                                                    */                                                                                          
 /*   Updates:                                                         */                                                                                          
 /*       Date              Author                  Purpose            */                                                                                          
       
 /*    23/09/2014          Bernardin             Join with DiagnosisDSMVCodes and DocumentDiagnosisCodes using DSMVCodeId column*/   
 /*    19/01/2015          Bernardin             Added column "Comments" in "DocumentDiagnosisCodes" table */
 /*    11/02/2015          Bernardin             Added "SNOMEDCTCodes" table to display "SNOMEDCTCode" and "SNOMEDCTDescription" column values in Grid */
 /*    21/07/2015          Bernardin             Added condition to check document status is In Progress.Pines-Support task# 417*/
 /*    01/09/2015          Bernardin             Assign DiagnosisType as Additional if the DiagnosisType = NULL. CEI - Environment Issues Tracking Task# 216*/
 /*    oct/09/2015          Hemant                Added condition to check document status is In To Be Reviewed.Harbor - Support: #730 DA :-Diagnosis tab was empty*/
 /*	   Nov/30/2015			Chethan N			 What : Returning @DocumentVersionId instead of '-1'
												 Why : Harbor - Support task# 743
	   17-April-2017      Sachin				What : Added ORDER BY D.DiagnosisOrder to show the Order by Column in Diagnosis List Grid.										 
												  Task : Key Point - Support Go Live #747 						
	   30-06-2017      Venkatesh				What : Commented the line Insert Into Diagnosis										 
														Task : Camino - Support Go Live #151 */
/*	  13/07/2017	  Sunil.D		 	 	What:Dummy Column Added  To Enable Education Info Button Based On column Name In Custom Grid 
					        			    	Why:#24 Meaning Full Use
												  */
/*	08/30/2017		Msood				What: Added RecordDeleted Check and Top 1 statement
										Why: Allegan - Support Task# 1119
*/												  
												  
 /*********************************************************************/                                                  
                                                 
Begin                                                            
                        
Begin try   
                                           
IF EXISTS (SELECT DocumentDiagnosisId FROM DocumentDiagnosis WHERE DocumentVersionId = @DocumentVersionId)
BEGIN
SELECT  D.DocumentDiagnosisCodeId
,D.CreatedBy
,D.CreatedDate
,D.ModifiedBy
,D.ModifiedDate
,D.RecordDeleted
,D.DeletedDate
,D.DeletedBy
,D.DocumentVersionId
,D.ICD10CodeId
,D.ICD10Code
,D.ICD9Code
,ISNULL(D.DiagnosisType,142) AS DiagnosisType
,D.RuleOut
,D.Billable
,D.Severity
,'Dummy' as   EducationInfoButton  
,D.DiagnosisOrder
,D.Specifier
,D.Remission
,D.[Source]
,DSM.ICDDescription AS DSMDescription
,case D.RuleOut when 'Y' then 'R/O' else '' end as RuleOutText
,dbo.csf_GetGlobalCodeNameById(D.DiagnosisType) as 'DiagnosisTypeText'
,dbo.csf_GetGlobalCodeNameById(D.Severity) as 'SeverityText' 
,D.Comments 
,D.SNOMEDCODE
,SNC.SNOMEDCTDescription
FROM  DocumentDiagnosisCodes AS D INNER JOIN              
       DiagnosisICD10Codes AS DSM ON DSM.ICD10CodeId = D.ICD10CodeId LEFT JOIN
       SNOMEDCTCodes AS SNC ON SNC.SNOMEDCTCode = D.SNOMEDCODE           
 WHERE (D.DocumentVersionId = @DocumentVersionId) AND (ISNULL(D.RecordDeleted, 'N') = 'N')  
 ORDER BY D.DiagnosisOrder  -- 17-April-2017  Sachin
       
SELECT DocumentDiagnosisId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedDate
,DeletedBy
,DocumentVersionId
,ScreeeningTool
,OtherMedicalCondition
,FactorComments
,GAFScore
,WHODASScore
,CAFASScore
,NoDiagnosis
FROM DocumentDiagnosis WHERE (DocumentVersionId = @DocumentVersionId) AND (ISNULL(RecordDeleted, 'N') = 'N')  

SELECT DocumentDiagnosisFactorId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedDate
,DeletedBy
,DocumentVersionId
,FactorId
,dbo.csf_GetGlobalCodeNameById(FactorId)  as 'Factors'
FROM DocumentDiagnosisFactors 
 WHERE (DocumentVersionId = @DocumentVersionId) AND (ISNULL(RecordDeleted, 'N') = 'N') 
 
 END
 ELSE
 BEGIN
 -- Msood 8/30/2017
 IF (@DocumentVersionId > -1 AND (Select Top 1 [status] from Documents Where CurrentDocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,'N')='N') in (21,25)) --oct/09/2015 Hemant  
 BEGIN

 --INSERT INTO DocumentDiagnosis (DocumentVersionId) VALUES (@DocumentVersionId)
  
 SELECT DocumentDiagnosisId
,CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,RecordDeleted
,DeletedDate
,DeletedBy
,DocumentVersionId
,ScreeeningTool
,OtherMedicalCondition
,FactorComments
,GAFScore
,WHODASScore
,CAFASScore
,NoDiagnosis
FROM DocumentDiagnosis WHERE (DocumentVersionId = @DocumentVersionId) AND (ISNULL(RecordDeleted, 'N') = 'N')  
END
-- Msood 8/30/2017
IF (@DocumentVersionId > -1 AND (Select top 1 [status] from Documents Where CurrentDocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,'N')='N') = 22)
BEGIN
Declare @GAF int = 0
Declare @OtherMedicalCondition varchar(max)
declare @usercode varchar(100);
select @usercode =usercode from Staff where StaffId IN (Select AuthorId from Documents Where CurrentDocumentVersionId = @DocumentVersionId) 
-- Msood 8/30/2017
Set @GAF = (Select Top 1 AxisV from DiagnosesV Where DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,'N')='N')
-- Msood 8/30/2017
Set @OtherMedicalCondition = (Select Top 1 Specification from DiagnosesIII Where DocumentVersionId = @DocumentVersionId and isnull(RecordDeleted,'N')='N')
  
  SELECT 'DocumentDiagnosisCodes' AS TableName
      ,@usercode as CreatedBy
      ,GETDATE() as CreatedDate
      ,@usercode as ModifiedBy
      ,GETDATE() as ModifiedDate
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
      ,DSMVCodes.ICD10Code + case DSMVCodes.DSMVCode when 'Y' then '*' else '' end AS ICD10Code  
      ,Mapping.ICD9Code                                                                
      ,DSMVCodes.ICD10CodeId 
      ,ISNULL(DIandII.DiagnosisType,142) AS DiagnosisType
      ,DIandII.RuleOut
      ,DIandII.Billable                                                                
      ,DIandII.Severity
      --,DIandII.DSMVersion
      ,'Dummy' as   EducationInfoButton 
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
                ,@usercode as CreatedBy
				,GETDATE() as CreatedDate
				,@usercode as ModifiedBy
				,GETDATE() as ModifiedDate
				,DIII.RecordDeleted
				,DIII.DeletedDate
				,DIII.DeletedBy
				,@DocumentVersionId AS DocumentVersionId -- Chethan N changes -- Nov 30th
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
				,'Dummy' as   EducationInfoButton 
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
		,@usercode as [CreatedBy]  
		,GETDATE() as [CreatedDate]  
		,@usercode as [ModifiedBy]  
		,GETDATE() as [ModifiedDate]  
		,@DocumentVersionId AS DocumentVersionId 
		,DD.ScreeeningTool
		,@OtherMedicalCondition AS OtherMedicalCondition
		,DD.FactorComments
		,case @GAF when 0 then DD.GAFScore else @GAF end as GAFScore
		,DD.WHODASScore
		,DD.CAFASScore 
		FROM (SELECT 'DocumentDiagnosis' AS TableName) AS Placeholder  
			  LEFT JOIN DocumentDiagnosis DD ON ( DD.DocumentVersionId = @DocumentVersionId AND ISNULL(DD.RecordDeleted,'N') <> 'Y' )
END


 END

END TRY                                                                
                                                                                                           
BEGIN CATCH                      
DECLARE @Error varchar(8000)                                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                 
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_SCGetDataDiagnosisNew')                                                                                                 
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