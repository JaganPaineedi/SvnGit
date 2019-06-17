IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_InitCustomDiagnosisStandardInitializationNew]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_InitCustomDiagnosisStandardInitializationNew]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[ssp_InitCustomDiagnosisStandardInitializationNew]                          
(                                                      
 @ClientId int,                        
 @StaffID int,                      
 @CustomParameters xml                                                                    
)                                                                              
As                                                                                
 /*********************************************************************/                                                                                          
 /* Stored Procedure:[ssp_InitCustomDiagnosisStandardInitializationNew]*/                                                                      
 /* Creation Date: 19 May 2014                                         */                                                                                          
 /*                                                                    */                                                                                          
 /* Purpose: To Initialize                                             */                                                                                         
 /*                                                                    */                                                                                          
 /* Created By: Bernardin                                              */                                                                                
 /*                                                                    */                                                                                          
 /*   Updates:                                                         */                                                                                          
 /*       Date              Author                  Purpose            */                                                                                          
       
 /*       15/09/2014        Bernardin               ICD9 to ICD10 Conversion implemented on initialization */   
 /*       17/09/2014        Bernardin               Initialized "DocumentDiagnosis" in else part also*/ 
 /*       19/01/2015        Bernardin               Added column "Comments" in "DocumentDiagnosisCodes" table */ 
  /*      11/02/2015        Bernardin               Removed " and a.DocumentCodeId=1601" condition to initialize latest signed document even if it is custom document */
  /*      11/02/2015        Bernardin               Added "SNOMEDCTCodes" table to display "SNOMEDCTCode" and "SNOMEDCTDescription" column values in Grid */
  /*      08/31/2015        Dhanil                changed condtion to get latest document version ida.EffectiveDate <=  getDate() task #308.8  Keypoint enviornmrntal issues tracking*/
  /*      08/31/2015        Bernardin             Added condition to check DSMV codes.Diagnosis Changes (ICD10) Task# 34*/
   /*    01/09/2015          Bernardin             Assign DiagnosisType as Additional if the DiagnosisType = NULL. CEI - Environment Issues Tracking Task# 216*/
   /*    01/09/2015          Bernardin             Selected records from DiagnosisIIICodes as well. Diagnosis Changes(ICD10) Task# 35*/
   /*    22/09/2015			Chethan N				What : Added RecordDeleted check for DocumentDiagnosis table 
													Why : Philhaven-Support task # 39 */
	/*   10/20/2015			Deej					changed the logic of the DocumentDiagnosisFactors join to ensure that not initializing with null if there is not entry in the table */
 /*		 02/26/2016			mlightner				What: Modified to populate @OtherMedicalCondition in ICD10 section.
													Why: Key Point Support Go Live #89*/
      /*   13/07/2017	    	Sunil.D		 	        What:Dummy Column Added  To Enable Education Info Button Based On column Name In Custom Grid 
					        			    	   Why:#24 Meaning Full Use
												  */
/*        19 MAR 2018        Akwinass              Added code to skip service diagnosis document when "NoteReplacement" column value is 'Y' in services table (Task #589.1 in Engineering Improvement Initiatives- NBL(I))*/
 /*********************************************************************/                                                  
                                                 
Begin                                                            
                        
Begin try                                                 
              
Declare @LatestICD10DocumentVersionID int
Declare @LatestICD9DocumentVersionID int 
Declare @GAF int = 0
Declare @OtherMedicalCondition varchar(max)
Declare @Value Varchar(5)
Declare @usercode varchar(100)

Select @usercode =usercode from Staff where StaffId=@StaffID
  
Set @Value = (Select Value from SystemConfigurationKeys Where [Key] = 'InitializeAxisIVToFactorsLookupInDSM5')
             
set @LatestICD10DocumentVersionID =(SELECT  top 1   a.CurrentDocumentVersionId
FROM         Documents AS a INNER JOIN
                      DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId INNER JOIN
                      DocumentDiagnosis AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId                                                     
where a.ClientId = @ClientId and a.EffectiveDate <=  getDate()                                                       
and a.Status = 22 and Dc.DiagnosisDocument='Y' and isNull(a.RecordDeleted,'N')<>'Y' and isNull(Dc.RecordDeleted,'N')<>'Y' and ISNULL(DDC.RecordDeleted,'N')<>'Y' 
--19 MAR 2018  Akwinass  
AND NOT EXISTS(SELECT 1 FROM Services S WHERE S.ServiceId = a.ServiceId AND ISNULL(S.RecordDeleted, 'N') = 'N' AND ISNULL(S.NoteReplacement, 'N') = 'Y')
order by a.EffectiveDate desc,a.ModifiedDate desc) 
                                                                                                              
 
If @LatestICD10DocumentVersionID IS NOT NULL    
BEGIN
SELECT Placeholder.TableName 
      ,DDC.CreatedBy
      ,DDC.CreatedDate
      ,DDC.ModifiedBy
      ,DDC.ModifiedDate
      ,DDC.RecordDeleted 
      ,DDC.DeletedDate
      ,DDC.DeletedBy
      ,ISNULL(DDC.DocumentVersionId,-1) AS DocumentVersionId
      ,DDC.ICD10CodeId
      ,DDC.ICD10Code
      ,DDC.ICD9Code                                                              
      ,ISNULL(DDC.DiagnosisType,142) AS DiagnosisType
      ,DDC.RuleOut
      ,DDC.Billable                                                                
      ,DDC.Severity
      ,DDC.DiagnosisOrder
      ,'Dummy' as   EducationInfoButton  
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
      LEFT JOIN DocumentDiagnosisCodes DDC ON ( DDC.DocumentVersionId = @LatestICD10DocumentVersionID  
      AND ISNULL(DDC.RecordDeleted,'N') <> 'Y' )
      INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = DDC.ICD10CodeId
      LEFT JOIN SNOMEDCTCodes SNC ON SNC.SNOMEDCTCode = DDC.SNOMEDCODE 
      
	select @OtherMedicalCondition = OtherMedicalCondition from dbo.DocumentDiagnosis where DocumentVersionId = @LatestICD10DocumentVersionID	-- mlightner 02/26/2016

  IF(@Value = 'Y' OR @Value = 'N')
   BEGIN
	  SELECT Placeholder.TableName
	  ,@usercode as [CreatedBy]  
	  ,GETDATE() as [CreatedDate]  
	  ,@usercode as [ModifiedBy]  
	  ,GETDATE() as [ModifiedDate]  
	  ,ISNULL(DDF.DocumentVersionId,-1) AS DocumentVersionId 
	  ,FactorId
	  ,dbo.csf_GetGlobalCodeNameById(FactorId)  as 'Factors' 
	FROM (SELECT 'DocumentDiagnosisFactors' AS TableName) AS Placeholder  
      INNER JOIN DocumentDiagnosisFactors DDF ON ( DDF.DocumentVersionId = @LatestICD10DocumentVersionID AND ISNULL(DDF.RecordDeleted,'N') <> 'Y' ) 
      AND FactorId IS NOT NULL
  END
      
END
ELSE
BEGIN
set @LatestICD9DocumentVersionID =(SELECT Top 1 a.CurrentDocumentVersionId
FROM         Documents AS a INNER JOIN
                      DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId LEFT OUTER JOIN
                      DiagnosesIAndII AS DIAndII ON a.CurrentDocumentVersionId = DIAndII.DocumentVersionId LEFT OUTER JOIN
                      DiagnosesIIICodes AS DIII ON a.CurrentDocumentVersionId = DIII.DocumentVersionId                                                                              
where a.ClientId = @ClientId and a.EffectiveDate <=  getDate()                                                       
and a.Status = 22    and Dc.DiagnosisDocument='Y' and isNull(a.RecordDeleted,'N')<>'Y' and isNull(Dc.RecordDeleted,'N')<>'Y' and isNull(DIAndII.RecordDeleted,'N')<>'Y' and isNull(DIII.RecordDeleted,'N')<>'Y'
--19 MAR 2018  Akwinass  
AND NOT EXISTS(SELECT 1 FROM Services S WHERE S.ServiceId = a.ServiceId AND ISNULL(S.RecordDeleted, 'N') = 'N' AND ISNULL(S.NoteReplacement, 'N') = 'Y')
order by a.EffectiveDate desc,a.ModifiedDate desc)

Set @GAF = (Select AxisV from DiagnosesV Where DocumentVersionId = @LatestICD9DocumentVersionID)
Set @OtherMedicalCondition = (Select Specification from DiagnosesIII Where DocumentVersionId = @LatestICD9DocumentVersionID)
  
  SELECT 'DocumentDiagnosisCodes' AS TableName
      ,DIandII.CreatedBy
      ,DIandII.CreatedDate
      ,DIandII.ModifiedBy
      ,DIandII.ModifiedDate
      ,DIandII.RecordDeleted 
      ,DIandII.DeletedDate
      ,DIandII.DeletedBy
      ,ISNULL(DIandII.DocumentVersionId,-1) AS DocumentVersionId
      ,CASE WHEN (SELECT COUNT(SubMapping.ICD9Code) AS Rcount
                    FROM  DiagnosisICD10ICD9Mapping AS SubMapping INNER JOIN
                      DiagnosisICD10Codes AS DSMVCodes ON SubMapping.ICD10CodeId = DSMVCodes.ICD10CodeId INNER JOIN
                      DiagnosesIAndII ON SubMapping.ICD9Code = DiagnosesIAndII.DSMCode
               WHERE DSMVCodes.ICD10Code IS NOT NULL AND SubMapping.ICD9Code = Mapping.ICD9Code AND
                DiagnosesIAndII.DocumentVersionId = @LatestICD9DocumentVersionID AND ISNULL(DiagnosesIAndII.RecordDeleted,'N') <> 'Y' ) > 1 THEN '<img src="../App_Themes/Includes/Images/Alert2.png" title="Diagnosis '+ Mapping.ICD9Code +' has been converted to '+ DSMVCodes.ICD10Code+'"/>     '+ DSMVCodes.ICDDescription ELSE DSMVCodes.ICDDescription END AS DSMDescription
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
                DiagnosesIAndII.DocumentVersionId = @LatestICD9DocumentVersionID AND ISNULL(DiagnosesIAndII.RecordDeleted,'N') <> 'Y' ) > 1 THEN 'Y' ELSE 'N' END AS MultipleDiagnosis  
      ,@LatestICD9DocumentVersionID AS ICD9DocumentVersionId
      FROM (SELECT 'DiagnosesIAndII' AS TableName) AS Placeholder  
      LEFT JOIN DiagnosesIAndII DIandII ON ( DIandII.DocumentVersionId = @LatestICD9DocumentVersionID  
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
                DiagnosesIIICodes.DocumentVersionId = @LatestICD9DocumentVersionID AND ISNULL(DiagnosesIIICodes.RecordDeleted,'N') <> 'Y' ) > 1 THEN '<img src="../App_Themes/Includes/Images/Alert2.png" title="Diagnosis '+ Mapping.ICD9Code +' has been converted to '+ DSMVCodes.ICD10Code+'"/>     '+ DSMVCodes.ICDDescription ELSE DSMVCodes.ICDDescription END AS DSMDescription
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
                DiagnosesIIICodes.DocumentVersionId = @LatestICD9DocumentVersionID AND ISNULL(DiagnosesIIICodes.RecordDeleted,'N') <> 'Y' ) > 1 THEN 'Y' ELSE 'N' END AS MultipleDiagnosis  
            ,@LatestICD9DocumentVersionID AS ICD9DocumentVersionId
			FROM (SELECT 'DiagnosesIIICodes' AS TableName) AS Placeholder  
			   LEFT JOIN DiagnosesIIICodes DIII ON ( DIII.DocumentVersionId = @LatestICD9DocumentVersionID  
			  AND ISNULL(DIII.RecordDeleted,'N') <> 'Y' )
			  left outer join DiagnosisICD10ICD9Mapping Mapping on  DIII.ICDCode = Mapping.ICD9Code
			  INNER JOIN DiagnosisICD10Codes DSMVCodes ON Mapping.ICD10CodeId = DSMVCodes.ICD10CodeId
			  WHERE DSMVCodes.ICD10Code IS NOT NULL 
			  
IF(@Value = 'Y')
   BEGIN
	  
		DECLARE @PrimarySupport Char(1)
		DECLARE @SocialEnvironment Char(1)
		DECLARE @Educational Char(1)
		DECLARE @Occupational Char(1)
		DECLARE @Housing Char(1)
		DECLARE @Economic Char(1)
		DECLARE @HealthcareServices Char(1)
		DECLARE @Legal Char(1)
		DECLARE @Other Char(1)


		CREATE TABLE #FactorsLookup(
		TableName Varchar(25) NULL,
		CreatedBy VarChar(30) NOT NULL,
		CreatedDate DateTime NOT NULL,
		ModifiedBy VarChar(30) NOT NULL,
		ModifiedDate DateTime NOT NULL,
		DocumentVersionId Int NULL,
		FactorId Int NULL,
		Factors  Varchar(70) NULL
		)

		Select @PrimarySupport = PrimarySupport,@SocialEnvironment = SocialEnvironment,@Educational = Educational,@Occupational = Occupational,@Housing = Housing,@Economic = Economic,@HealthcareServices = HealthcareServices,@Legal = Legal,@Other = Other from DiagnosesIV Where DocumentVersionId = @LatestICD9DocumentVersionID

		IF @PrimarySupport = 'Y'
		INSERT INTO #FactorsLookup(TableName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,DocumentVersionId,FactorId,Factors) 
		SELECT Placeholder.TableName
		,@usercode as [CreatedBy]  
		,GETDATE() as [CreatedDate]  
		,@usercode as [ModifiedBy]  
		,GETDATE() as [ModifiedDate]  
		,ISNULL(DDF.DocumentVersionId,-1) AS DocumentVersionId 
		,8810 AS FactorId
		,dbo.csf_GetGlobalCodeNameById(8810)  as 'Factors' 
		FROM (SELECT 'DocumentDiagnosisFactors' AS TableName) AS Placeholder  
			  INNER JOIN DocumentDiagnosisFactors DDF ON ( DDF.DocumentVersionId = @LatestICD9DocumentVersionID AND ISNULL(DDF.RecordDeleted,'N') <> 'Y' ) AND FactorId IS NOT NULL

		IF @SocialEnvironment = 'Y'
		INSERT INTO #FactorsLookup(TableName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,DocumentVersionId,FactorId,Factors)
		 SELECT Placeholder.TableName
		,@usercode as [CreatedBy]  
		,GETDATE() as [CreatedDate]  
		,@usercode as [ModifiedBy]  
		,GETDATE() as [ModifiedDate]  
		,ISNULL(DDF.DocumentVersionId,-1) AS DocumentVersionId 
		,8811 AS FactorId
		,dbo.csf_GetGlobalCodeNameById(8811)  as 'Factors' 
		FROM (SELECT 'DocumentDiagnosisFactors' AS TableName) AS Placeholder  
			  INNER JOIN DocumentDiagnosisFactors DDF ON ( DDF.DocumentVersionId = @LatestICD9DocumentVersionID AND ISNULL(DDF.RecordDeleted,'N') <> 'Y' ) AND FactorId IS NOT NULL
		 
		 IF @Educational = 'Y'
		 INSERT INTO #FactorsLookup(TableName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,DocumentVersionId,FactorId,Factors)
		 SELECT Placeholder.TableName
		,@usercode as [CreatedBy]  
		,GETDATE() as [CreatedDate]  
		,@usercode as [ModifiedBy]  
		,GETDATE() as [ModifiedDate]  
		,ISNULL(DDF.DocumentVersionId,-1) AS DocumentVersionId 
		,8812 AS FactorId
		,dbo.csf_GetGlobalCodeNameById(8812)  as 'Factors' 
		FROM (SELECT 'DocumentDiagnosisFactors' AS TableName) AS Placeholder  
			  INNER JOIN DocumentDiagnosisFactors DDF ON ( DDF.DocumentVersionId = @LatestICD9DocumentVersionID AND ISNULL(DDF.RecordDeleted,'N') <> 'Y' ) AND FactorId IS NOT NULL

		IF @Occupational = 'Y'    
		 INSERT INTO #FactorsLookup(TableName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,DocumentVersionId,FactorId,Factors)
		 SELECT Placeholder.TableName
		,@usercode as [CreatedBy]  
		,GETDATE() as [CreatedDate]  
		,@usercode as [ModifiedBy]  
		,GETDATE() as [ModifiedDate]  
		,ISNULL(DDF.DocumentVersionId,-1) AS DocumentVersionId 
		,8813 AS FactorId
		,dbo.csf_GetGlobalCodeNameById(8813)  as 'Factors' 
		FROM (SELECT 'DocumentDiagnosisFactors' AS TableName) AS Placeholder  
			  INNER JOIN DocumentDiagnosisFactors DDF ON ( DDF.DocumentVersionId = @LatestICD9DocumentVersionID AND ISNULL(DDF.RecordDeleted,'N') <> 'Y' ) AND FactorId IS NOT NULL  

		IF @Housing = 'Y'  
		 INSERT INTO #FactorsLookup(TableName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,DocumentVersionId,FactorId,Factors)
		 SELECT Placeholder.TableName
		,@usercode as [CreatedBy]  
		,GETDATE() as [CreatedDate]  
		,@usercode as [ModifiedBy]  
		,GETDATE() as [ModifiedDate]  
		,ISNULL(DDF.DocumentVersionId,-1) AS DocumentVersionId 
		,8814 AS FactorId
		,dbo.csf_GetGlobalCodeNameById(8814)  as 'Factors' 
		FROM (SELECT 'DocumentDiagnosisFactors' AS TableName) AS Placeholder  
			  INNER JOIN DocumentDiagnosisFactors DDF ON ( DDF.DocumentVersionId = @LatestICD9DocumentVersionID AND ISNULL(DDF.RecordDeleted,'N') <> 'Y' ) AND FactorId IS NOT NULL
		      
		IF @Economic = 'Y'  
		 INSERT INTO #FactorsLookup(TableName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,DocumentVersionId,FactorId,Factors)
		 SELECT Placeholder.TableName
		,@usercode as [CreatedBy]  
		,GETDATE() as [CreatedDate]  
		,@usercode as [ModifiedBy]  
		,GETDATE() as [ModifiedDate]  
		,ISNULL(DDF.DocumentVersionId,-1) AS DocumentVersionId 
		,8815 AS FactorId
		,dbo.csf_GetGlobalCodeNameById(8815)  as 'Factors' 
		FROM (SELECT 'DocumentDiagnosisFactors' AS TableName) AS Placeholder  
			  INNER JOIN DocumentDiagnosisFactors DDF ON ( DDF.DocumentVersionId = @LatestICD9DocumentVersionID AND ISNULL(DDF.RecordDeleted,'N') <> 'Y' ) AND FactorId IS NOT NULL
		      
		IF @HealthcareServices = 'Y'  
		 INSERT INTO #FactorsLookup(TableName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,DocumentVersionId,FactorId,Factors)
		 SELECT Placeholder.TableName
		,@usercode as [CreatedBy]  
		,GETDATE() as [CreatedDate]  
		,@usercode as [ModifiedBy]  
		,GETDATE() as [ModifiedDate]  
		,ISNULL(DDF.DocumentVersionId,-1) AS DocumentVersionId 
		,8816 AS FactorId
		,dbo.csf_GetGlobalCodeNameById(8816)  as 'Factors' 
		FROM (SELECT 'DocumentDiagnosisFactors' AS TableName) AS Placeholder  
			  INNER JOIN DocumentDiagnosisFactors DDF ON ( DDF.DocumentVersionId = @LatestICD9DocumentVersionID AND ISNULL(DDF.RecordDeleted,'N') <> 'Y' ) AND FactorId IS NOT NULL
		      
		IF @Legal = 'Y'  
		 INSERT INTO #FactorsLookup(TableName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,DocumentVersionId,FactorId,Factors)
		 SELECT Placeholder.TableName
		,@usercode as [CreatedBy]  
		,GETDATE() as [CreatedDate]  
		,@usercode as [ModifiedBy]  
		,GETDATE() as [ModifiedDate]  
		,ISNULL(DDF.DocumentVersionId,-1) AS DocumentVersionId 
		,8817 AS FactorId
		,dbo.csf_GetGlobalCodeNameById(8817)  as 'Factors' 
		FROM (SELECT 'DocumentDiagnosisFactors' AS TableName) AS Placeholder  
			  INNER JOIN DocumentDiagnosisFactors DDF ON ( DDF.DocumentVersionId = @LatestICD9DocumentVersionID AND ISNULL(DDF.RecordDeleted,'N') <> 'Y' ) AND FactorId IS NOT NULL 
		      
		IF @Other = 'Y'  
		 INSERT INTO #FactorsLookup(TableName,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,DocumentVersionId,FactorId,Factors)
		 SELECT Placeholder.TableName
		,@usercode as [CreatedBy]  
		,GETDATE() as [CreatedDate]  
		,@usercode as [ModifiedBy]  
		,GETDATE() as [ModifiedDate]  
		,ISNULL(DDF.DocumentVersionId,-1) AS DocumentVersionId 
		,8818 AS FactorId
		,dbo.csf_GetGlobalCodeNameById(8818)  as 'Factors' 
		FROM (SELECT 'DocumentDiagnosisFactors' AS TableName) AS Placeholder  
			  INNER JOIN DocumentDiagnosisFactors DDF ON ( DDF.DocumentVersionId = @LatestICD9DocumentVersionID AND ISNULL(DDF.RecordDeleted,'N') <> 'Y' ) AND FactorId IS NOT NULL
		      
		      
		Select * from #FactorsLookup

		DROP TABLE #FactorsLookup
	  
END
			  
END

SELECT Placeholder.TableName
,@usercode as [CreatedBy]  
,GETDATE() as [CreatedDate]  
,@usercode as [ModifiedBy]  
,GETDATE() as [ModifiedDate]  
,ISNULL(DD.DocumentVersionId,-1) AS DocumentVersionId 
,DD.ScreeeningTool
,@OtherMedicalCondition AS OtherMedicalCondition
,DD.FactorComments
,case @GAF when 0 then DD.GAFScore else @GAF end as GAFScore
,DD.WHODASScore
,DD.CAFASScore 
FROM (SELECT 'DocumentDiagnosis' AS TableName) AS Placeholder  
      LEFT JOIN DocumentDiagnosis DD ON ( DD.DocumentVersionId = @LatestICD10DocumentVersionID AND ISNULL(DD.RecordDeleted,'N') <> 'Y' )
      
end try                                                                  
                                                                                                           
BEGIN CATCH                      
DECLARE @Error varchar(8000)                                                                   
SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                                 
    + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'ssp_InitCustomDiagnosisStandardInitializationNew')                                                                                                 
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