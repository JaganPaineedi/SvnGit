IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubreportCANSModules]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubreportCANSModules]
GO
      
 CREATE Procedure [dbo].[csp_RDLSubreportCANSModules] --160
 @DocumentVersionId as int          
 AS
  /*********************************************************************/                                                                                            
 /* Stored Procedure: csp_RDLSubreportCANSModules     */                                                                                   
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
 /*	25-07-2012		Md Hussain Khusro		Added Join Condition to fetch 2 columns from CustomDocumentCANSGenerals table */       
 /*********************************************************************/  
BEGIN          
SELECT 

CDCM.[DocumentVersionId],
CDCG.SubstanceAbuse, 
CDCG.AdjustmenttoTrauma
  ,Case When SeverityofUse='N' then 'N/A' else 
 case when SeverityofUse='U' then 'Unknown'  else
 case when SeverityofUse='0' then '0-No Evidence of Problems' else
 case when SeverityofUse='1' then '1-History, Mild'  else
 case when SeverityofUse='2' then '2-Moderate' else
 case when SeverityofUse='3' then '3-Severe'  
 end end end end end end as SeverityofUse
 
  ,Case When DurationofUse='N' then 'N/A' else 
 case when DurationofUse='U' then 'Unknown'  else
 case when DurationofUse='0' then '0-No Evidence of Problems' else
 case when DurationofUse='1' then '1-History, Mild'  else
 case when DurationofUse='2' then '2-Moderate' else
 case when DurationofUse='3' then '3-Severe'  
 end end end end end end as DurationofUse
 
  ,Case When PeerInfluences='N' then 'N/A' else 
 case when PeerInfluences='U' then 'Unknown'  else
 case when PeerInfluences='0' then '0-No Evidence of Problems' else
 case when PeerInfluences='1' then '1-History, Mild'  else
 case when PeerInfluences='2' then '2-Moderate' else
 case when PeerInfluences='3' then '3-Severe'  
 end end end end end end as PeerInfluences
 
  ,Case When StageofRecovery='N' then 'N/A' else 
 case when StageofRecovery='U' then 'Unknown'  else
 case when StageofRecovery='0' then '0-No Evidence of Problems' else
 case when StageofRecovery='1' then '1-History, Mild'  else
 case when StageofRecovery='2' then '2-Moderate' else
 case when StageofRecovery='3' then '3-Severe'  
 end end end end end end as StageofRecovery
 
  ,Case When ParentalInfluences='N' then 'N/A' else 
 case when ParentalInfluences='U' then 'Unknown'  else
 case when ParentalInfluences='0' then '0-No Evidence of Problems' else
 case when ParentalInfluences='1' then '1-History, Mild'  else
 case when ParentalInfluences='2' then '2-Moderate' else
 case when ParentalInfluences='3' then '3-Severe'  
 end end end end end end as ParentalInfluences
 
  ,Case When PhysicalAbuse='N' then 'N/A' else 
 case when PhysicalAbuse='U' then 'Unknown'  else
 case when PhysicalAbuse='0' then '0-No Evidence of Problems' else
 case when PhysicalAbuse='1' then '1-History, Mild'  else
 case when PhysicalAbuse='2' then '2-Moderate' else
 case when PhysicalAbuse='3' then '3-Severe'  
 end end end end end end as PhysicalAbuse
 
  ,Case When EmotionalAbuse='N' then 'N/A' else 
 case when EmotionalAbuse='U' then 'Unknown'  else
 case when EmotionalAbuse='0' then '0-No Evidence of Problems' else
 case when EmotionalAbuse='1' then '1-History, Mild'  else
 case when EmotionalAbuse='2' then '2-Moderate' else
 case when EmotionalAbuse='3' then '3-Severe'  
 end end end end end end as EmotionalAbuse
 
  ,Case When WitnessofViolence='N' then 'N/A' else 
 case when WitnessofViolence='U' then 'Unknown'  else
 case when WitnessofViolence='0' then '0-No Evidence of Problems' else
 case when WitnessofViolence='1' then '1-History, Mild'  else
 case when WitnessofViolence='2' then '2-Moderate' else
 case when WitnessofViolence='3' then '3-Severe'  
 end end end end end end as WitnessofViolence
 
  ,Case When SexualAbuse='N' then 'N/A' else 
 case when SexualAbuse='U' then 'Unknown'  else
 case when SexualAbuse='0' then '0-No Evidence of Problems' else
 case when SexualAbuse='1' then '1-History, Mild'  else
 case when SexualAbuse='2' then '2-Moderate' else
 case when SexualAbuse='3' then '3-Severe'  
 end end end end end end as SexualAbuse
 
  ,Case When MedicalTrauma='N' then 'N/A' else 
 case when MedicalTrauma='U' then 'Unknown'  else
 case when MedicalTrauma='0' then '0-No Evidence of Problems' else
 case when MedicalTrauma='1' then '1-History, Mild'  else
 case when MedicalTrauma='2' then '2-Moderate' else
 case when MedicalTrauma='3' then '3-Severe'  
 end end end end end end as MedicalTrauma
 
 
FROM CustomDocumentCANSGenerals AS CDCG
LEFT JOIN CustomDocumentCANSModules AS CDCM ON CDCG.DocumentVersionId=CDCM.DocumentVersionId
LEFT JOIN DocumentVersions DV ON DV.DocumentVersionId=CDCM.DocumentVersionId
LEFT JOIN  Documents DS ON DS.DocumentId=DV.DocumentId 
Where CDCM.[DocumentVersionId]=@DocumentVersionId AND ISNULL(CDCM.RecordDeleted,'N') <> 'Y' 
 --Checking For Errors    
If (@@error!=0)    
 Begin    
  RAISERROR  20006   'csp_RDLSubreportCANSModules : An Error Occured'    
  Return    
 End    
End   