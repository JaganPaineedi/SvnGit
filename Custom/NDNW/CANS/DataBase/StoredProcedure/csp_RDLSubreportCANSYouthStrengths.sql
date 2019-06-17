IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubreportCANSYouthStrengths]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubreportCANSYouthStrengths]
GO
      
 CREATE Procedure [dbo].[csp_RDLSubreportCANSYouthStrengths] --196
 @DocumentVersionId as int          
 AS
  /*********************************************************************/                                                                                            
 /* Stored Procedure: csp_RDLSubreportCANSYouthStrengths     */                                                                                   
 /* Creation Date:  05/July/2013                                     */                                                                                            
 /* Purpose: To Get The Information of  Document-CANS*/                                                                                           
 /* Input Parameters: @DocumentVersionId         */                                                                                          
 /* Output Parameters:              */                                                                                           
 /* Return:                 */                                                                                            
 /*                                                                    */                                                                                            
 /* Author: Md Hussain Khusro            */    
 /* Data Modifications:                                               */                                                                                            
 /* Updates:                                                          */                                                                                            
 /* Date              Author                  Purpose      */           
 /*															*/       
 /*********************************************************************/  
BEGIN          
SELECT CDCYS.[DocumentVersionId]
,Case When Family='N' then 'N/A' else 
 case when Family='U' then 'Unknown'  else
 case when Family='0' then '0-No Evidence of Problems' else
 case when Family='1' then '1-History, Mild'  else
 case when Family='2' then '2-Moderate' else
 case when Family='3' then '3-Severe'  
 end end end end end end as Family

,Case When Optimism='N' then 'N/A' else 
 case when Optimism='U' then 'Unknown'  else
 case when Optimism='0' then '0-No Evidence of Problems' else
 case when Optimism='1' then '1-History, Mild'  else
 case when Optimism='2' then '2-Moderate' else
 case when Optimism='3' then '3-Severe'  
 end end end end end end as Optimism
 
 ,Case When Vocational='N' then 'N/A' else 
 case when Vocational='U' then 'Unknown'  else
 case when Vocational='0' then '0-No Evidence of Problems' else
 case when Vocational='1' then '1-History, Mild'  else
 case when Vocational='2' then '2-Moderate' else
 case when Vocational='3' then '3-Severe'  
 end end end end end end as Vocational
 
 ,Case When Resiliency='N' then 'N/A' else 
 case when Resiliency='U' then 'Unknown'  else
 case when Resiliency='0' then '0-No Evidence of Problems' else
 case when Resiliency='1' then '1-History, Mild'  else
 case when Resiliency='2' then '2-Moderate' else
 case when Resiliency='3' then '3-Severe'  
 end end end end end end as Resiliency
 
 ,Case When Educational='N' then 'N/A' else 
 case when Educational='U' then 'Unknown'  else
 case when Educational='0' then '0-No Evidence of Problems' else
 case when Educational='1' then '1-History, Mild'  else
 case when Educational='2' then '2-Moderate' else
 case when Educational='3' then '3-Severe'  
 end end end end end end as Educational
 
 ,Case When Interpersonal='N' then 'N/A' else 
 case when Interpersonal='U' then 'Unknown'  else
 case when Interpersonal='0' then '0-No Evidence of Problems' else
 case when Interpersonal='1' then '1-History, Mild'  else
 case when Interpersonal='2' then '2-Moderate' else
 case when Interpersonal='3' then '3-Severe'  
 end end end end end end as Interpersonal
 
 ,Case When Resourcefulness='N' then 'N/A' else 
 case when Resourcefulness='U' then 'Unknown'  else
 case when Resourcefulness='0' then '0-No Evidence of Problems' else
 case when Resourcefulness='1' then '1-History, Mild'  else
 case when Resourcefulness='2' then '2-Moderate' else
 case when Resourcefulness='3' then '3-Severe'  
 end end end end end end as Resourcefulness
 
 ,Case When CommunityLife='N' then 'N/A' else 
 case when CommunityLife='U' then 'Unknown'  else
 case when CommunityLife='0' then '0-No Evidence of Problems' else
 case when CommunityLife='1' then '1-History, Mild'  else
 case when CommunityLife='2' then '2-Moderate' else
 case when CommunityLife='3' then '3-Severe'  
 end end end end end end as CommunityLife
 
 ,Case When TalentInterests='N' then 'N/A' else 
 case when TalentInterests='U' then 'Unknown'  else
 case when TalentInterests='0' then '0-No Evidence of Problems' else
 case when TalentInterests='1' then '1-History, Mild'  else
 case when TalentInterests='2' then '2-Moderate' else
 case when TalentInterests='3' then '3-Severe'  
 end end end end end end as TalentInterests
 
 ,Case When SpiritualReligious='N' then 'N/A' else 
 case when SpiritualReligious='U' then 'Unknown'  else
 case when SpiritualReligious='0' then '0-No Evidence of Problems' else
 case when SpiritualReligious='1' then '1-History, Mild'  else
 case when SpiritualReligious='2' then '2-Moderate' else
 case when SpiritualReligious='3' then '3-Severe'  
 end end end end end end as SpiritualReligious
 
 ,Case When RelationPerformance='N' then 'N/A' else 
 case when RelationPerformance='U' then 'Unknown'  else
 case when RelationPerformance='0' then '0-No Evidence of Problems' else
 case when RelationPerformance='1' then '1-History, Mild'  else
 case when RelationPerformance='2' then '2-Moderate' else
 case when RelationPerformance='3' then '3-Severe'  
 end end end end end end as RelationPerformance
 
 ,Case When DangertoSelf='N' then 'N/A' else 
 case when DangertoSelf='U' then 'Unknown'  else
 case when DangertoSelf='0' then '0-No Evidence of Problems' else
 case when DangertoSelf='1' then '1-History, Mild'  else
 case when DangertoSelf='2' then '2-Moderate' else
 case when DangertoSelf='3' then '3-Severe'  
 end end end end end end as DangertoSelf
 
 ,Case When ViolentThinking='N' then 'N/A' else 
 case when ViolentThinking='U' then 'Unknown'  else
 case when ViolentThinking='0' then '0-No Evidence of Problems' else
 case when ViolentThinking='1' then '1-History, Mild'  else
 case when ViolentThinking='2' then '2-Moderate' else
 case when ViolentThinking='3' then '3-Severe'  
 end end end end end end as ViolentThinking
 
 ,Case When Elopement='N' then 'N/A' else 
 case when Elopement='U' then 'Unknown'  else
 case when Elopement='0' then '0-No Evidence of Problems' else
 case when Elopement='1' then '1-History, Mild'  else
 case when Elopement='2' then '2-Moderate' else
 case when Elopement='3' then '3-Severe'  
 end end end end end end as Elopement
 
 ,Case When SocialBehavior='N' then 'N/A' else 
 case when SocialBehavior='U' then 'Unknown'  else
 case when SocialBehavior='0' then '0-No Evidence of Problems' else
 case when SocialBehavior='1' then '1-History, Mild'  else
 case when SocialBehavior='2' then '2-Moderate' else
 case when SocialBehavior='3' then '3-Severe'  
 end end end end end end as SocialBehavior
 
 ,Case When OtherSelfHarm='N' then 'N/A' else 
 case when OtherSelfHarm='U' then 'Unknown'  else
 case when OtherSelfHarm='0' then '0-No Evidence of Problems' else
 case when OtherSelfHarm='1' then '1-History, Mild'  else
 case when OtherSelfHarm='2' then '2-Moderate' else
 case when OtherSelfHarm='3' then '3-Severe'  
 end end end end end end as OtherSelfHarm
 
 ,Case When DangertoOthers='N' then 'N/A' else 
 case when DangertoOthers='U' then 'Unknown'  else
 case when DangertoOthers='0' then '0-No Evidence of Problems' else
 case when DangertoOthers='1' then '1-History, Mild'  else
 case when DangertoOthers='2' then '2-Moderate' else
 case when DangertoOthers='3' then '3-Severe'  
 end end end end end end as DangertoOthers
 
 ,Case When CrimeDelinquency='N' then 'N/A' else 
 case when CrimeDelinquency='U' then 'Unknown'  else
 case when CrimeDelinquency='0' then '0-No Evidence of Problems' else
 case when CrimeDelinquency='1' then '1-History, Mild'  else
 case when CrimeDelinquency='2' then '2-Moderate' else
 case when CrimeDelinquency='3' then '3-Severe'  
 end end end end end end as CrimeDelinquency
 
 ,Case When Commitment='N' then 'N/A' else 
 case when Commitment='U' then 'Unknown'  else
 case when Commitment='0' then '0-No Evidence of Problems' else
 case when Commitment='1' then '1-History, Mild'  else
 case when Commitment='2' then '2-Moderate' else
 case when Commitment='3' then '3-Severe'  
 end end end end end end as Commitment
 
 ,Case When SexuallyAbusive='N' then 'N/A' else 
 case when SexuallyAbusive='U' then 'Unknown'  else
 case when SexuallyAbusive='0' then '0-No Evidence of Problems' else
 case when SexuallyAbusive='1' then '1-History, Mild'  else
 case when SexuallyAbusive='2' then '2-Moderate' else
 case when SexuallyAbusive='3' then '3-Severe'  
 end end end end end end as SexuallyAbusive
 
 ,Case When SchoolBehavior='N' then 'N/A' else 
 case when SchoolBehavior='U' then 'Unknown'  else
 case when SchoolBehavior='0' then '0-No Evidence of Problems' else
 case when SchoolBehavior='1' then '1-History, Mild'  else
 case when SchoolBehavior='2' then '2-Moderate' else
 case when SchoolBehavior='3' then '3-Severe'  
 end end end end end end as SchoolBehavior
 
 ,Case When SexualDevelopment='N' then 'N/A' else 
 case when SexualDevelopment='U' then 'Unknown'  else
 case when SexualDevelopment='0' then '0-No Evidence of Problems' else
 case when SexualDevelopment='1' then '1-History, Mild'  else
 case when SexualDevelopment='2' then '2-Moderate' else
 case when SexualDevelopment='3' then '3-Severe'  
 end end end end end end as SexualDevelopment
 
 
 FROM CustomDocumentCANSYouthStrengths AS CDCYS
LEFT JOIN DocumentVersions DV ON DV.DocumentVersionId=CDCYS.DocumentVersionId
LEFT JOIN  Documents DS ON DS.DocumentId=DV.DocumentId 
Where CDCYS.[DocumentVersionId]=@DocumentVersionId AND ISNULL(CDCYS.RecordDeleted,'N') <> 'Y' 
 --Checking For Errors    
If (@@error!=0)    
 Begin    
  RAISERROR  20006   'csp_RDLSubreportCANSYouthStrengths : An Error Occured'    
  Return    
 End    
End 
 
 