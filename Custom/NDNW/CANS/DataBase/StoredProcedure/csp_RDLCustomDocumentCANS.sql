IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomDocumentCANS]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomDocumentCANS]
GO
      
 CREATE Procedure [dbo].[csp_RDLCustomDocumentCANS]  --196
 @DocumentVersionId as int          
 AS
  /*********************************************************************/                                                                                            
 /* Stored Procedure: csp_RDLCustomDocumentCANS     */                                                                                   
 /* Creation Date:  05/July/2013                                     */                                                                                            
 /* Purpose: To Get The Information of  Document-CANS*/                                                                                           
 /* Input Parameters: @DocumentVersionId         */                                                                                          
 /* Output Parameters:              */                                                                                           
 /* Return:                 */                                                                                            
 /*                                                                    */                                                                                            
 /* Author: Md Hussain Khusro             */    
 /* Data Modifications:                                               */                                                                                            
 /* Updates:                                                          */                                                                                            
 /* Date              Author                  Purpose      */           
/*	20/Nov/2013		Md Hussain Khusro		Added 13 New Column for Life Domain section wrt task #120 Philhaven Developement */  
/*	25/Nov/2013		Md Hussain Khusro		Added 3 New Columns and removed 6 existing columns wrt task #120 Philhaven Developement	*/     
/* 	28 Mar 2014	    Veena 		            To get the details for Footer	*/  
/* 08 Apr 2014	    Veena				    To get the latest RegistrationDate for @AdmitDate	*/ 
 /*********************************************************************/  
BEGIN    

Declare @AdmitDate varchar(10)   
set @AdmitDate=''  

--To get the AdmitDate for Footer
SELECT TOP 1 @AdmitDate = CONVERT(VARCHAR(10),CE.RegistrationDate,101)        
FROM Documents DS             
JOIN ClientEpisodes CE ON DS.ClientId=CE.ClientId            
WHERE InProgressDocumentVersionId = @DocumentVersionId AND ISNULL(CE.RecordDeleted,'N') = 'N' 
AND ISNULL(CE.RecordDeleted,'N') = 'N' ORDER BY CE.EpisodeNumber DESC  
      
SELECT CDCG.[DocumentVersionId],
dbo.csf_GetGlobalCodeNameById(DocumentType) as DocumentType,
(select OrganizationName from SystemConfigurations) as AgencyName,
ISNULL(CS.LastName + ', ','') + CS.FirstName as ClientName,
CS.ClientId,
dbo.csf_GetGlobalCodeNameById(CS.LivingArrangement) as LivingArrangement,
--CONVERT(VARCHAR(10),CS.DOB,101) as DOB,
CONVERT(VARCHAR(10),DS.EffectiveDate,101) as EffectiveDate 

,Case When Psychosis='N' then 'N/A' else 
 case when Psychosis='U' then 'Unknown'  else
 case when Psychosis='0' then '0-No Evidence of Problems' else
 case when Psychosis='1' then '1-History'  else
 case when Psychosis='2' then '2-Moderate' else
 case when Psychosis='3' then '3-Severe'  
 end end end end end end as Psychosis 
 
,Case When AngerManagement='N' then 'N/A' else 
 case when AngerManagement='U' then 'Unknown'  else
 case when AngerManagement='0' then '0-No Evidence of Problems' else
 case when AngerManagement='1' then '1-History'  else
 case when AngerManagement='2' then '2-Moderate' else
 case when AngerManagement='3' then '3-Severe'  
 end end end end end end as AngerManagement
 
,Case When SubstanceAbuse='N' then 'N/A' else 
 case when SubstanceAbuse='U' then 'Unknown'  else
 case when SubstanceAbuse='0' then '0-No Evidence of Problems' else
 case when SubstanceAbuse='1' then '1-History'  else
 case when SubstanceAbuse='2' then '2-Moderate' else
 case when SubstanceAbuse='3' then '3-Severe'  
 end end end end end end as SubstanceAbuse
 
,Case When DepressionAnxiety='N' then 'N/A' else 
 case when DepressionAnxiety='U' then 'Unknown'  else
 case when DepressionAnxiety='0' then '0-No Evidence of Problems' else
 case when DepressionAnxiety='1' then '1-History'  else
 case when DepressionAnxiety='2' then '2-Moderate' else
 case when DepressionAnxiety='3' then '3-Severe'  
 end end end end end end as DepressionAnxiety
 
 ,Case When Attachment='N' then 'N/A' else 
 case when Attachment='U' then 'Unknown'  else
 case when Attachment='0' then '0-No Evidence of Problems' else
 case when Attachment='1' then '1-History'  else
 case when Attachment='2' then '2-Moderate' else
 case when Attachment='3' then '3-Severe'  
 end end end end end end as Attachment
 
 ,Case When AttentionDefictImpluse='N' then 'N/A' else 
 case when AttentionDefictImpluse='U' then 'Unknown'  else
 case when AttentionDefictImpluse='0' then '0-No Evidence of Problems' else
 case when AttentionDefictImpluse='1' then '1-History'  else
 case when AttentionDefictImpluse='2' then '2-Moderate' else
 case when AttentionDefictImpluse='3' then '3-Severe'  
 end end end end end end as AttentionDefictImpluse
 
 ,Case When AdjustmenttoTrauma='N' then 'N/A' else 
 case when AdjustmenttoTrauma='U' then 'Unknown'  else
 case when AdjustmenttoTrauma='0' then '0-No Evidence of Problems' else
 case when AdjustmenttoTrauma='1' then '1-History'  else
 case when AdjustmenttoTrauma='2' then '2-Moderate' else
 case when AdjustmenttoTrauma='3' then '3-Severe'  
 end end end end end end as AdjustmenttoTrauma
 
 ,Case When OppositionalBehavior='N' then 'N/A' else 
 case when OppositionalBehavior='U' then 'Unknown'  else
 case when OppositionalBehavior='0' then '0-No Evidence of Problems' else
 case when OppositionalBehavior='1' then '1-History'  else
 case when OppositionalBehavior='2' then '2-Moderate' else
 case when OppositionalBehavior='3' then '3-Severe'  
 end end end end end end as OppositionalBehavior
 
 ,Case When AntisocialBehavior='N' then 'N/A' else 
 case when AntisocialBehavior='U' then 'Unknown'  else
 case when AntisocialBehavior='0' then '0-No Evidence of Problems' else
 case when AntisocialBehavior='1' then '1-History'  else
 case when AntisocialBehavior='2' then '2-Moderate' else
 case when AntisocialBehavior='3' then '3-Severe'  
 end end end end end end as AntisocialBehavior
 
 ,Case When CDCG.Safety='N' then 'N/A' else 
 case when CDCG.Safety='U' then 'Unknown'  else
 case when CDCG.Safety='0' then '0-No Evidence' else
 case when CDCG.Safety='1' then '1-Minimal Needs'  else
 case when CDCG.Safety='2' then '2-Moderate Needs' else
 case when CDCG.Safety='3' then '3-Severe Needs'  
 end end end end end end as Safety
 
 ,Case When Resources='N' then 'N/A' else 
 case when Resources='U' then 'Unknown'  else
 case when Resources='0' then '0-No Evidence' else
 case when Resources='1' then '1-Minimal Needs'  else
 case when Resources='2' then '2-Moderate Needs' else
 case when Resources='3' then '3-Severe Needs'  
 end end end end end end as Resources
 
  ,Case When Supervision='N' then 'N/A' else 
 case when Supervision='U' then 'Unknown'  else
 case when Supervision='0' then '0-No Evidence' else
 case when Supervision='1' then '1-Minimal Needs'  else
 case when Supervision='2' then '2-Moderate Needs' else
 case when Supervision='3' then '3-Severe Needs'  
 end end end end end end as Supervision
 
  ,Case When Knowledge='N' then 'N/A' else 
 case when Knowledge='U' then 'Unknown'  else
 case when Knowledge='0' then '0-No Evidence' else
 case when Knowledge='1' then '1-Minimal Needs'  else
 case when Knowledge='2' then '2-Moderate Needs' else
 case when Knowledge='3' then '3-Severe Needs'  
 end end end end end end as Knowledge
 
  ,Case When Involvement='N' then 'N/A' else 
 case when Involvement='U' then 'Unknown'  else
 case when Involvement='0' then '0-No Evidence' else
 case when Involvement='1' then '1-Minimal Needs'  else
 case when Involvement='2' then '2-Moderate Needs' else
 case when Involvement='3' then '3-Severe Needs'  
 end end end end end end as Involvement
 
  ,Case When Organization='N' then 'N/A' else 
 case when Organization='U' then 'Unknown'  else
 case when Organization='0' then '0-No Evidence' else
 case when Organization='1' then '1-Minimal Needs'  else
 case when Organization='2' then '2-Moderate Needs' else
 case when Organization='3' then '3-Severe Needs'  
 end end end end end end as Organization
 
  ,Case When Development='N' then 'N/A' else 
 case when Development='U' then 'Unknown'  else
 case when Development='0' then '0-No Evidence' else
 case when Development='1' then '1-Minimal Needs'  else
 case when Development='2' then '2-Moderate Needs' else
 case when Development='3' then '3-Severe Needs'  
 end end end end end end as Development
 
  ,Case When PhysicalBehavioralHealth='N' then 'N/A' else 
 case when PhysicalBehavioralHealth='U' then 'Unknown'  else
 case when PhysicalBehavioralHealth='0' then '0-No Evidence' else
 case when PhysicalBehavioralHealth='1' then '1-Minimal Needs'  else
 case when PhysicalBehavioralHealth='2' then '2-Moderate Needs' else
 case when PhysicalBehavioralHealth='3' then '3-Severe Needs'  
 end end end end end end as PhysicalBehavioralHealth
 
  ,Case When ResidentialStability='N' then 'N/A' else 
 case when ResidentialStability='U' then 'Unknown'  else
 case when ResidentialStability='0' then '0-No Evidence' else
 case when ResidentialStability='1' then '1-Minimal Needs'  else
 case when ResidentialStability='2' then '2-Moderate Needs' else
 case when ResidentialStability='3' then '3-Severe Needs'  
 end end end end end end as ResidentialStability
 
  ,Case When Abuse='N' then 'N/A' else 
 case when Abuse='U' then 'Unknown'  else
 case when Abuse='0' then '0-No Evidence of Problems' else
 case when Abuse='1' then '1-History'  else
 case when Abuse='2' then '2-Moderate' else
 case when Abuse='3' then '3-Severe'  
 end end end end end end as Abuse
 
  ,Case When Neglect='N' then 'N/A' else 
 case when Neglect='U' then 'Unknown'  else
 case when Neglect='0' then '0-No Evidence of Problems' else
 case when Neglect='1' then '1-History'  else
 case when Neglect='2' then '2-Moderate' else
 case when Neglect='3' then '3-Severe'  
 end end end end end end as Neglect
 
  ,Case When Exploitation='N' then 'N/A' else 
 case when Exploitation='U' then 'Unknown'  else
 case when Exploitation='0' then '0-No Evidence of Problems' else
 case when Exploitation='1' then '1-History'  else
 case when Exploitation='2' then '2-Moderate' else
 case when Exploitation='3' then '3-Severe'  
 end end end end end end as Exploitation
 
  ,Case When Permanency='N' then 'N/A' else 
 case when Permanency='U' then 'Unknown'  else
 case when Permanency='0' then '0-No Evidence of Problems' else
 case when Permanency='1' then '1-History'  else
 case when Permanency='2' then '2-Moderate' else
 case when Permanency='3' then '3-Severe'  
 end end end end end end as Permanency
 
  ,Case When ChildSafety='N' then 'N/A' else 
 case when ChildSafety='U' then 'Unknown'  else
 case when ChildSafety='0' then '0-No Evidence of Problems' else
 case when ChildSafety='1' then '1-History'  else
 case when ChildSafety='2' then '2-Moderate' else
 case when ChildSafety='3' then '3-Severe'  
 end end end end end end as ChildSafety
 
  ,Case When EmotionalCloseness='N' then 'N/A' else 
 case when EmotionalCloseness='U' then 'Unknown'  else
 case when EmotionalCloseness='0' then '0-No Evidence of Problems' else
 case when EmotionalCloseness='1' then '1-History'  else
 case when EmotionalCloseness='2' then '2-Moderate' else
 case when EmotionalCloseness='3' then '3-Severe'  
 end end end end end end as EmotionalCloseness
 
 ,Case When LDFFamily='N' then 'N/A' else 
 case when LDFFamily='U' then 'Unknown'  else
 case when LDFFamily='0' then '0-No Evidence of Problems' else
 case when LDFFamily='1' then '1-History, Mild'  else
 case when LDFFamily='2' then '2-Moderate' else
 case when LDFFamily='3' then '3-Severe'  
 end end end end end end as LDFFamily
 
 ,Case When LDFSchoolBehavior='N' then 'N/A' else 
 case when LDFSchoolBehavior='U' then 'Unknown'  else
 case when LDFSchoolBehavior='0' then '0-No Evidence of Problems' else
 case when LDFSchoolBehavior='1' then '1-History, Mild'  else
 case when LDFSchoolBehavior='2' then '2-Moderate' else
 case when LDFSchoolBehavior='3' then '3-Severe'  
 end end end end end end as LDFSchoolBehavior
 
 ,Case When LDFSleep='N' then 'N/A' else 
 case when LDFSleep='U' then 'Unknown'  else
 case when LDFSleep='0' then '0-No Evidence of Problems' else
 case when LDFSleep='1' then '1-History, Mild'  else
 case when LDFSleep='2' then '2-Moderate' else
 case when LDFSleep='3' then '3-Severe'  
 end end end end end end as LDFSleep
  
 ,Case When LDFLivingSituation='N' then 'N/A' else 
 case when LDFLivingSituation='U' then 'Unknown'  else
 case when LDFLivingSituation='0' then '0-No Evidence of Problems' else
 case when LDFLivingSituation='1' then '1-History, Mild'  else
 case when LDFLivingSituation='2' then '2-Moderate' else
 case when LDFLivingSituation='3' then '3-Severe'  
 end end end end end end as LDFLivingSituation
 
 ,Case When LDFSchoolAttendance='N' then 'N/A' else 
 case when LDFSchoolAttendance='U' then 'Unknown'  else
 case when LDFSchoolAttendance='0' then '0-No Evidence of Problems' else
 case when LDFSchoolAttendance='1' then '1-History, Mild'  else
 case when LDFSchoolAttendance='2' then '2-Moderate' else
 case when LDFSchoolAttendance='3' then '3-Severe'  
 end end end end end end as LDFSchoolAttendance
 
 
 ,Case When LDFJobFunctioning='N' then 'N/A' else 
 case when LDFJobFunctioning='U' then 'Unknown'  else
 case when LDFJobFunctioning='0' then '0-No Evidence of Problems' else
 case when LDFJobFunctioning='1' then '1-History, Mild'  else
 case when LDFJobFunctioning='2' then '2-Moderate' else
 case when LDFJobFunctioning='3' then '3-Severe'  
 end end end end end end as LDFJobFunctioning
 
 ,Case When LDFSchoolAchievement='N' then 'N/A' else 
 case when LDFSchoolAchievement='U' then 'Unknown'  else
 case when LDFSchoolAchievement='0' then '0-No Evidence of Problems' else
 case when LDFSchoolAchievement='1' then '1-History, Mild'  else
 case when LDFSchoolAchievement='2' then '2-Moderate' else
 case when LDFSchoolAchievement='3' then '3-Severe'  
 end end end end end end as LDFSchoolAchievement
 
  ,Case When LDFPhysicalMedical='N' then 'N/A' else 
 case when LDFPhysicalMedical='U' then 'Unknown'  else
 case when LDFPhysicalMedical='0' then '0-No Evidence of Problems' else
 case when LDFPhysicalMedical='1' then '1-History, Mild'  else
 case when LDFPhysicalMedical='2' then '2-Moderate' else
 case when LDFPhysicalMedical='3' then '3-Severe'  
 end end end end end end as LDFPhysicalMedical
 
  ,Case When LDFSexualDevelopment='N' then 'N/A' else 
 case when LDFSexualDevelopment='U' then 'Unknown'  else
 case when LDFSexualDevelopment='0' then '0-No Evidence of Problems' else
 case when LDFSexualDevelopment='1' then '1-History, Mild'  else
 case when LDFSexualDevelopment='2' then '2-Moderate' else
 case when LDFSexualDevelopment='3' then '3-Severe'  
 end end end end end end as LDFSexualDevelopment
 
  ,Case When LDFIntellectualDevelopmental='N' then 'N/A' else 
 case when LDFIntellectualDevelopmental='U' then 'Unknown'  else
 case when LDFIntellectualDevelopmental='0' then '0-No Evidence of Problems' else
 case when LDFIntellectualDevelopmental='1' then '1-History, Mild'  else
 case when LDFIntellectualDevelopmental='2' then '2-Moderate' else
 case when LDFIntellectualDevelopmental='3' then '3-Severe'  
 end end end end end end as LDFIntellectualDevelopmental
 ,@AdmitDate AS AdmitDate
,ISNULL(CS.LastName + ', ','') + CS.FirstName + ' (' + CONVERT(VARCHAR(10),CS.ClientId) + ')' AS ClientNameF 
,CONVERT(VARCHAR(10),CS.DOB,101) as DOB
FROM [CustomDocumentCANSGenerals] AS CDCG
--LEFT JOIN CustomDocumentCANSModules AS CDCM ON CDCG.DocumentVersionId=CDCM.DocumentVersionId
LEFT JOIN DocumentVersions DV ON DV.DocumentVersionId=CDCG.DocumentVersionId
LEFT JOIN  Documents DS ON DS.DocumentId=DV.DocumentId 
LEFT JOIN Clients CS ON DS.ClientId=CS.ClientId
 Where CDCG.[DocumentVersionId]=@DocumentVersionId AND ISNULL(CDCG.RecordDeleted,'N') <> 'Y' --AND ISNULL(CDCM.RecordDeleted,'N') <> 'Y'
  
 --Checking For Errors    
If (@@error!=0)    
 Begin    
  RAISERROR  20006   'csp_RDLCustomDocumentCANS : An Error Occured'    
  Return    
 End    
End    