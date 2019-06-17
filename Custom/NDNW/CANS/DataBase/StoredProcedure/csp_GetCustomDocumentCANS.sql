IF EXISTS (SELECT * FROM sysobjects WHERE type = 'P' AND name = 'csp_GetCustomDocumentCANS')
	BEGIN
		DROP  Procedure  csp_GetCustomDocumentCANS
	END

GO

CREATE PROC [dbo].[csp_GetCustomDocumentCANS] --196
(@DocumentVersionId int)  
AS  

/************************************************************************/                                                              
/* Stored Procedure: csp_GetCustomDocumentCANS      */                                                     
/*        */                                                              
/* Creation Date:  July-03-2013           */                                                              
/*                  */                                                              
/* Purpose: Gets Data for csp_GetCustomDocumentCANS     */                                                             
/* Input Parameters: DocumentVersionId        */                                                            
/* Output Parameters:             */                                                              
/* Calls:                */  
                                                                                                                          
/* Author: Md Hussain Khusro            */     
/* Data Modifications:                                               */                        
/*                                                                   */                        
/*   Updates:                                                          */                                     
/*       Date              Author                  Purpose            */
/*	20/Nov/2013			Md Hussain Khusro		Added 13 New Columns for Life Domain section wrt task #120 Philhaven Developement */
/*	25/Nov/2013			Md Hussain Khusro		Added 3 New Columns and removed 6 existing columns wrt task #120 Philhaven Developement	*/
/*********************************************************************/ 
BEGIN TRY   
SELECT [CDCG].DocumentVersionId,
[CDCG].CreatedBy,
[CDCG].CreatedDate,
[CDCG].ModifiedBy,
[CDCG].ModifiedDate,
[CDCG].RecordDeleted,
[CDCG].DeletedBy,
[CDCG].DeletedDate,
[CDCG].DocumentType,
[CDCG].Psychosis,
[CDCG].AngerManagement,
[CDCG].SubstanceAbuse,
[CDCG].DepressionAnxiety,
[CDCG].Attachment,
[CDCG].AttentionDefictImpluse,
[CDCG].AdjustmenttoTrauma,
[CDCG].OppositionalBehavior,
[CDCG].AntisocialBehavior,
[CDCG].[Safety],
[CDCG].Resources,
[CDCG].Supervision,
[CDCG].Knowledge,
[CDCG].Involvement,
[CDCG].Organization,
[CDCG].Development,
[CDCG].PhysicalBehavioralHealth,
[CDCG].ResidentialStability,
[CDCG].Abuse,
[CDCG].Neglect,
[CDCG].Exploitation,
[CDCG].Permanency,
[CDCG].ChildSafety,
[CDCG].EmotionalCloseness,
[CDCG].LDFFamily,
[CDCG].LDFSchoolBehavior,
[CDCG].LDFSleep,
[CDCG].LDFLivingSituation,
[CDCG].LDFSchoolAttendance,
[CDCG].LDFJobFunctioning,
[CDCG].LDFSchoolAchievement,
[CDCG].LDFPhysicalMedical,			
[CDCG].LDFSexualDevelopment,		
[CDCG].LDFIntellectualDevelopmental,
dbo.csf_GetGlobalCodeNameById([CS].LivingArrangement) as LivingArrangement
  FROM CustomDocumentCANSGenerals CDCG LEFT JOIN DocumentVersions DV ON DV.DocumentVersionId=CDCG.DocumentVersionId
	LEFT JOIN  Documents DS ON DS.DocumentId=DV.DocumentId 
	LEFT JOIN Clients CS ON DS.ClientId=CS.ClientId
	WHERE ISNull(CDCG.RecordDeleted,'N')='N' AND CDCG.DocumentVersionId=@DocumentVersionId  

  SELECT [CDCYS].DocumentVersionId,
[CDCYS].CreatedBy,
[CDCYS].CreatedDate,
[CDCYS].ModifiedBy,
[CDCYS].ModifiedDate,
[CDCYS].RecordDeleted,
[CDCYS].DeletedBy,
[CDCYS].DeletedDate,
[CDCYS].Family,
[CDCYS].Optimism,
[CDCYS].Vocational,
[CDCYS].Resiliency,
[CDCYS].Educational,
[CDCYS].Interpersonal,
[CDCYS].Resourcefulness,
[CDCYS].CommunityLife,
[CDCYS].TalentInterests,
[CDCYS].SpiritualReligious,
[CDCYS].RelationPerformance,
[CDCYS].DangertoSelf,
[CDCYS].ViolentThinking,
[CDCYS].Elopement,
[CDCYS].SocialBehavior,
[CDCYS].OtherSelfHarm,
[CDCYS].DangertoOthers,
[CDCYS].CrimeDelinquency,
[CDCYS].Commitment,
[CDCYS].SexuallyAbusive,
[CDCYS].SchoolBehavior,
[CDCYS].SexualDevelopment 

  FROM CustomDocumentCANSYouthStrengths CDCYS LEFT JOIN DocumentVersions DV ON DV.DocumentVersionId=CDCYS.DocumentVersionId
	LEFT JOIN  Documents DS ON DS.DocumentId=DV.DocumentId 
	--LEFT JOIN Clients CS ON DS.ClientId=CS.ClientId 
  WHERE ISNull(CDCYS.RecordDeleted,'N')='N' AND CDCYS.DocumentVersionId=@DocumentVersionId  
  
  SELECT [CDCM].DocumentVersionId,
[CDCM].CreatedBy,
[CDCM].CreatedDate,
[CDCM].ModifiedBy,
[CDCM].ModifiedDate,
[CDCM].RecordDeleted,
[CDCM].DeletedBy,
[CDCM].DeletedDate,
[CDCM].SeverityofUse,
[CDCM].DurationofUse,
[CDCM].PeerInfluences,
[CDCM].StageofRecovery,
[CDCM].ParentalInfluences,
[CDCM].PhysicalAbuse,
[CDCM].EmotionalAbuse,
[CDCM].WitnessofViolence,
[CDCM].SexualAbuse,
[CDCM].MedicalTrauma

  FROM CustomDocumentCANSModules CDCM LEFT JOIN DocumentVersions DV ON DV.DocumentVersionId=CDCM.DocumentVersionId
	LEFT JOIN  Documents DS ON DS.DocumentId=DV.DocumentId 
	--LEFT JOIN Clients CS ON DS.ClientId=CS.ClientId 
  WHERE ISNull(CDCM.RecordDeleted,'N')='N' AND CDCM.DocumentVersionId=@DocumentVersionId  
    
END TRY  
BEGIN CATCH  
  declare @Error varchar(8000)                        
  set @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                         
  + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_GetCustomDocumentConsentforTreatment')                         
  + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                          
  + '*****' + Convert(varchar,ERROR_STATE())                        
  RAISERROR                         
  (                        
   @Error, -- Message text.                        
   16,  -- Severity.                        
   1  -- State.                        
  );   
END CATCH  
