/****** Object:  StoredProcedure [dbo].[csp_RDLCustomAssessments]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomAssessments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomAssessments]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomAssessments]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create   PROCEDURE   [dbo].[csp_RDLCustomAssessments]        
(
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010   
)                
AS                
          
Begin          
/************************************************************************/                                                
/* Stored Procedure: [csp_RDLCustomAssessments]							*/                                                                             
/* Copyright: 2006 Streamline SmartCare									*/                                                                                      
/* Creation Date:  Jan 03 ,2008											*/                                                
/*																		*/                                                
/* Purpose: Gets Data from CustomAssessments,SystemConfigurations,		*/
/*			Staff,Documents,Clients,GlobalCodes,Pharmacy				*/                                               
/*																		*/                                              
/* Input Parameters: DocumentID,Version									*/                                              
/* Output Parameters:													*/                                                
/* Purpose: Use For Rdl Report											*/                                      
/* Calls:																*/                                                
/* Author: Vikas Vyas													*/                                                
/*********************************************************************/                  
  
SELECT	SystemConfig.OrganizationName
		,C.LastName + '', '' + C.FirstName as ClientName
        ,C.DOB as DOB
        ,Case C.Sex   
            When ''F'' then ''Female''        
			When ''M'' then ''Male''  
			Else ''''        
		 End As Sex
		,GCMaritalStatus.CodeName as MaritalStatus   
        ,Documents.ClientID
        ,Documents.EffectiveDate       
        ,Documents.CreatedDate as CreatedDate
        ,Documents.ModifiedDate as ModifyDate  
        ,S.FirstName + '' '' + S.LastName + '', '' + GC.CodeName as ClinicianName 
        ,Case [AssessmentType] 
			When ''I'' then ''Initial'' 
			When ''A'' then ''Annual'' 
			When ''U'' then ''Update'' 
		 End as [AssessmentType]
		,ReasonForUpdate
		,GCTGeneral.CodeName as [TeamOrProgram]  
		,Case [Population] 
			When ''A'' then ''Adult'' 
			When ''C'' then ''Child'' 
		 End as [Population]
		,GCREFERRALSOURCE.CodeName as [ReferralSource]  
		,[PresentingProblem]  
		,[PresentingProblemDetails]  
		,[PrimaryCarePhysician]  
		,[CurrentHealth]  
		,[FamilyMedicalHistory]  
		,[EatingHabits]  
		,[EatingHabitsTxPlan]  
		,[SleepingHabits]  
		,[SleepingHabitsTxPlan]  
		,[NKMA] as [NKMA]
		,[MedicalIssues]  
		,[MedicalIssuesTxPlan]  
		,[CurrentMedications]  
		,[OtherMedications]  
		,Phar.PharmacyName as [Pharmacy]

	--TxHistory  
		,Case CA.TxHistoryTherapy when ''Y'' then '', Therapy'' else '''' end +                                   
		 case CA.TxHistoryOutpatient when ''Y'' then '', Psychiatric  Treatment - Outpatient or Consultant'' else '''' end +                                   
		 case CA.TxHistoryInpatient when ''Y'' then '', Psychiatric  Inpatient'' else '''' end +                                   
		 case CA.TxHistoryCrisis when ''Y'' then '', Crisis Intervention'' else '''' end +                                   
		 case CA.TxHistoryResidential when ''Y'' then '', Residential'' else '''' end +                                   
		 case CA.TxHistoryCaseManagement when ''Y'' then '', Case Management'' else '''' end +                                   
		 case CA.TxHistorySA when ''Y'' then '', Substance Abuse Treatment'' else '''' end +                                   
		 case CA.TxHistoryHome when ''Y'' then '', In Home Services'' else '''' end +                                   
		 case CA.TxHistoryOther when ''Y'' then '', Other'' else '''' end                                    
		 as TxHistory    
	--End  
		,[TxHistoryOtherText]  
		,[TxHistoryDetail]  
		,[TxHistoryHopitalization]  
		,[PreviousDiagnosis]  
    
      
		,Case NaturalSupportSufficiency
			When ''PD'' then ''Needs are met by paid supports''        
			When ''UM'' then ''Needs are unmet''  
			When ''PN'' then ''Needs are met by natural and paid supports''        
			When ''NA'' then ''Needs are met by natural supports''  
			Else ''''        
		 End As [NaturalSupportSufficiency]

		,Case IncreasedSupport
			When ''Y'' then ''Client  desire increased support''        
			When ''N'' then ''Client does not desire increased support''  
			Else ''''        
		 End As [IncreasedSupport]

		,[NaturalSupportTxPlan]  
	    ,[ClientStrengths]  
		,[SocialHistory]  
		,[SocialHistoryTxPlan]  
		,[Relationships]  
		,[RelationshipsTxPlan]  
		,[LeisureIssues]  
		,[LeisureIssuesTxPlan]  
		,[FinancialIssues]  
		,[FinancialIssuesTxPlan]  
		,[ClientHasSSI]  
		,[ClientHasSSDI]
        
--Start LegalIssues  
		,case ca.LegalIssuesGuardian when ''Y'' then '', Has a Legal Guardian'' else '''' end +                                   
		 case ca.LegalIssuesProbation when ''Y'' then '', On Probation'' else '''' end +                                   
		 case ca.LegalIssuesHistory when ''Y'' then '', History with court but no longer involved'' else '''' end +                                   
		 case ca.LegalIssuesCourtCase when ''Y'' then '', Involved in court case'' else '''' end +                                   
		 case ca.LegalIssuesParole when ''Y'' then '', On Parole'' else '''' end +                                   
		 case ca.LegalIssuesPending when ''Y'' then '', Charges pending'' else '''' end +                         
		 case ca.LegalCourtOrdered when ''Y'' then '', Court-Ordered'' else '''' end +                         
		 case ca.LegalEmancipatedMinor when ''Y'' then '', Emancipated minor'' else '''' end +                         
		 case ca.LegalWithoutParentalKnowledge when ''Y'' then '', Minor in services without parental services'' else '''' end +                         
		 case ca.LegalIssuesDivorce when ''Y'' then '', Divorce in process'' else '''' end +                                   
		 case ca.LegalIssuesOther when ''Y'' then '', Other legal issues'' else '''' end                                   
		 as CheckBoxLegalIssues    
--End  
  
		,[LegalIssuesOtherText]
      
 --Start LegalIssuesForChildren  
		,case ca.LegalIssuesProtective when ''Y'' then '', Involved with Proactive Services'' else '''' end +                                   
		 case ca.LegalIssuesCustody when ''Y'' then '', Custody Issues'' else '''' end +                                   
		 case ca.LegalWardOfCourt when ''Y'' then '', Ward of Court'' else '''' end +                         
		 case ca.LegalUnderJointCustody when ''Y'' then '', Under joint custody arrangements'' else '''' end +                         
		 case ca.LegalUnderSoleCustody when ''Y'' then '', under sole custody arrangements'' else '''' end +                         
		 case ca.LegalTherapeuticVisitations when ''Y'' then '', Involved in therapeutic supervised visitation'' else '''' end +                         
		 case ca.LegalPreAdoptionAgreement when ''Y'' then '', Pre-adoption arrangement'' else '''' end                         
		 as CheckBoxLegalIssuesForChildren
--End  
        
		,[LegalIssues]  
		,[LegalIssuesTxPlan]  
		,[Education]  
		,[EducationTxPlan]  
		,[Employment]  
		,[EmploymentTxPlan]  
		,[Sexuality]  
		,[SexualityTxPlan]  
		,[Ethnicity]  
		,[EthnicityTxPlan]  
		,CA.[LivingArrangement]  
		,[LivingArrangementTxPlan]  
		,GCLIVINGARRANGEMENT.CodeName as [TypeOfLivingSituation]  
		,[Abuse]  
		,[AbuseTxPlan]
        
        
--Start Abuse  
		,case ca.AbusePhysicalVictim when ''Y'' then '', Physical Victim'' else '''' end +                                   
		 case ca.AbusePhysicalPerpatrator when ''Y'' then '', Physical Perpatrator'' else '''' end +                                   
		 case ca.AbuseSexualVictim when ''Y'' then '', Sexual Victim'' else '''' end +                          
		 case ca.AbuseSexualPerpatrator when ''Y'' then '', Sexual Perpatrator'' else '''' end +                                   
		 case ca.AbuseEmotionalVictim when ''Y'' then '', Emotional Victim'' else '''' end +                                   
		 case ca.AbuseEmotionalPerpatrator when ''Y'' then '', Emotional Perpatrator'' else '''' end                                   
		 as CheckBoxAbuses  
--End         
  
		,[NoSafetyConcerns]  
  
-- Start Safety  
		,case ca.SafetyFire when ''Y'' then '', Fire'' else '''' end +                                   
		 case ca.SafetyPedestrian when ''Y'' then '', Pedestrian'' else '''' end +                                   
		 case ca.SafetyStrangers when ''Y'' then '', Response to Strangers'' else '''' end +                                   
		 case ca.SafetyCleanEnvironment when ''Y'' then '', Cleanliness of environment'' else '''' end +                                   
		 case ca.SafetyRulesLaws when ''Y'' then '', Weak or no Knowledge of rules and laws'' else '''' end +                                   
		 case ca.SafetyUnstableLiving when ''Y'' then '', Unstable living situation'' else '''' end +                                   
		 case ca.SafetyHeatUtility when ''Y'' then '', Unsafe source of heat or other utility concerns'' else '''' end +                                   
		 case ca.SafetyImpulsive when ''Y'' then '', Impulsive'' else '''' end +                                   
		 case ca.SafetyHarmSelf when ''Y'' then '', Tendency to harm self'' else '''' end +                                   
		 case ca.SafetyUnsafeLocation when ''Y'' then '', Home is unsafe neighbourhood or location'' else '''' end +                                   
		 case ca.SafetyEmergencyServices when ''Y'' then '', Difficulty using or assessing emergency services'' else '''' end +                                   
		 case ca.SafetyWeaponsAccess when ''Y'' then '', Access to weapons'' else '''' end                                   
		 as CheckBoxSafety
--End     
  
		,CA.[Safety]   as [Safety]
		,[SafetyTxPlan]  
		,[LOF]  
		,[LOFTxPlan]  
		,[MentalHealthFamilyHistory]  
		,[ClinicalSummary]  
      
      
		,Case SummaryAppropriate  
			When ''Y'' then ''Client is appropiate for Treatment''        
			When ''N'' then ''Client is Not appropiate for Treatment''  
			Else ''''        
		 End As SummaryAppropriate  

		,[SummaryAppropriateText]  

--     ,[SummaryReferrals]  
  
		,Case SummaryReferrals
			When ''Y'' then ''Outside Referrals  given''        
			When ''N'' then ''Outside Referrals Not given''  
			Else ''''        
		 End As SummaryReferrals

		,[SummaryReferralsText]  
		,[CrisisPlanClientDesire]  
		,[CrisisPlanMoreInfo]  
		,[CrisisPlan]  
		,[CrisisPlanTxPlan]
  
--Start Service  
		,case ca.ServicesIndividual when ''Y'' then '', Individual'' else '''' end +                                   
		 case ca.ServicesConjoint when ''Y'' then '', ConJoint'' else '''' end +                                   
		 case ca.ServicesFamily when ''Y'' then '', Family'' else '''' end +                                   
		 case ca.ServicesMedicationI when ''Y'' then '', Medication Management Level I'' else '''' end +                                   
		 case ca.ServicesMedicationII when ''Y'' then '', Medication Management Level II'' else '''' end +                                   
		 case ca.ServicesCaseManagement when ''Y'' then '', Case Management'' else '''' end +                                   
		 case ca.ServicesSupportedEmployment when ''Y'' then '', Supported Employement'' else '''' end +                                   
		 case ca.ServicesACT when ''Y'' then '', Act'' else '''' end +                         
		 case ca.ServicesOther when ''Y'' then '', Other-'' else '''' end                                   
		 as CheckBoxServices  
--End    

		,[ServicesOtherText]  
		,[TreatmentFrequency]  
		,[ClientAccommodation]  
		,GCAssignedTeam.CodeName as [AssignedTeam]  
		,GCAssignedClinician.LastName  + '', '' + GCAssignedClinician.FirstName  as  [AssignedClinician]  
        ,Staff1.LastName + '', '' + Staff1.FirstName as [NotifyStaff1]              
		,Staff2.LastName + '', '' + Staff2.FirstName as[NotifyStaff2]              
		,Staff3.LastName + '', '' + Staff3.FirstName as[NotifyStaff3]              
		,Staff4.LastName + '', '' + Staff4.FirstName as [NotifyStaff4]              
		,[NotificationMessage]  
		,[NotificationSent]  
		,[PrePlanParticipants]  
		,[PrePlanFacilitator]  
		,[PrePlanAssessments]  
		,[PrePlanTimeLocation]  
		,[PrePlanIssuesAvoid]  
		,[PrePlanSource]  
		,GCAuthorizationTeam.CodeName as [AuthorizationTeam]  
		,[ProceduresComment]  
		,[AuthorizationSent]  
		,Case [ExistingAdvanceDirective] 
			When ''Y'' Then ''Yes''
			When ''N'' Then ''No''
			Else ''''
		 End as [ExistingAdvanceDirective]
		,Case [CopyAdvanceDirective]  
			When ''Y'' Then ''Yes''
			When ''N'' Then ''No''
			Else ''''
		 End as [CopyAdvanceDirective]
		,Case [MoreInformationAdvanceDirective]
			When ''Y'' Then ''Yes''
			When ''N'' Then ''No''
			Else ''''
		 End as [MoreInformationAdvanceDirective]
		       
---Start Symptom  
		,case CA.symptomAnger when ''Y'' then '', Anger'' else '''' end +                         
		 case CA.SymptomAnxiousness when ''Y'' then '', Anxiousness'' else '''' end +                         
		 case CA.SymptomConcomitantMedical when ''Y'' then '', Concomitant Medical Condition'' else '''' end +                                    
		 case CA.SymptomDecreasedEnergy when ''Y'' then '', Decreased Energy'' else '''' end +                         
		 case CA.SymptomDelusions when ''Y'' then '', Delusions'' else '''' end +                        
		 case CA.SymptomDepressedMood when ''Y'' then '', Depressed Mood'' else '''' end +                                  
		 case CA.SymptomDisruption when ''Y'' then '', Disruption of thought process / content'' else '''' end +                        
		 case CA.SymptomDissociativeState when ''Y'' then '', Dissociative State'' else '''' end +                         
		 case CA.SymptomEmotionalTraumaVictim when ''Y'' then '', Emotional/Physical/Sexual Trauma Victim'' else '''' end +                         
		 case CA.SymptomEmotionalTraumaPerpetrator when ''Y'' then '', Emotional/Physical/Sexual Trauma Perpetrator'' else '''' end +                                    
		 case CA.SymptomElevatedMood when ''Y'' then '', Elevated Mood'' else '''' end +                        
		 case CA.SymptomGrief when ''Y'' then '', Grief'' else '''' end +                          
		 case CA.SymptomGuilt when ''Y'' then '', Guilt'' else '''' end +                        
		 case CA.SymptomHallucinations when ''Y'' then '', Hallucinations'' else '''' end +                        
		 case CA.SymptomHopelessness when ''Y'' then '', Hopelessness'' else '''' end +                         
		 case CA.SymptomHyperactivity when ''Y'' then '', Hyperactivity'' else '''' end +                          
		 case CA.SymptomImpulsiveness when ''Y'' then '', Impulsiveness'' else '''' end +                
		 case CA.SymptomIrritability when ''Y'' then '', Irritability'' else '''' end +                                   
		 case CA.SymptomObsession when ''Y'' then '', Obsession/Compulsion'' else '''' end +                                   
		 case CA.SymptomOppositionalism when ''Y'' then '', Oppositionalism'' else '''' end +                                   
		 case CA.SymptomPanicAttacks when ''Y'' then '', Panic Attacks'' else '''' end +                                   
		 case CA.SymptomParanoia when ''Y'' then '', Paranoia'' else '''' end +                                   
		 case CA.SymptomSomaticComplaints when ''Y'' then '', Somatic Complaints'' else '''' end +                                   
		 case CA.SymptomWorthlessness when ''Y'' then '', Worthlessness'' else '''' end                                   
		 as CheckBoxSymptom   
---End  

		,[Changeeatinghabits]  
		,[Changesleepinghabits]  
		,[SpiritualityTx]   
		,[SpiritualityText]  
		,[AssistanceWithNone] 
        
--Start Assistance  
		,case ca.AssistanceWithShowering when ''Y'' then '', Showering'' else '''' end +                                   
		 case ca.AssistanceWithToileting when ''Y'' then '', Toileting'' else '''' end +                            
 		 case ca.AssistanceWithBrushingTeeth when ''Y'' then '', Brushing Teeth'' else '''' end +                                   
		 case ca.AssistanceWithDressing when ''Y'' then '', Dressing'' else '''' end +                       
		 case ca.AssistanceWithFeedingSelf when ''Y'' then '', Feeding Self'' else '''' end +                                   
		 case ca.AssistanceWithPreparingMeals when ''Y'' then '', Preparing Meals'' else '''' end +                                   
		 case ca.AssistanceWithMobility when ''Y'' then '', Mobility'' else '''' end +                                   
		 case ca.AssistanceWithParticipatingActivites when ''Y'' then '', Participating in Activites'' else '''' end +                                   
		 case ca.AssistanceWithArrangingTransportation when ''Y'' then '', Arranging/Accessing Transportation'' else '''' end +                                   
		 case ca.AssistanceWithCommunicatingPeople when ''Y'' then '', Communicating with People'' else '''' end +                                  
		 case ca.AssistanceWithSelfDirection when ''Y'' then '', Self Direction'' else '''' end +                                   
		 case ca.AssistanceWithFinancialIndependence when ''Y'' then '', Capacity for Financial Independence'' else '''' end +                                   
		 case ca.AssistanceWithPlanningActivities when ''Y'' then '', Planning Activities'' else '''' end +                                   
		 case ca.AssistanceWithReading when ''Y'' then '', Reading'' else '''' end +            
		 case ca.AssistanceWithGrooming when ''Y'' then '', Grooming'' else '''' end +          
		 case ca.AssistanceWithMealPrep when ''Y'' then '', Meal Prep'' else '''' end +          
		 case ca.AssistanceWithTelephoneUse when ''Y'' then '', Telephone Use'' else '''' end +          
		 case ca.AssistanceWithLaundry when ''Y'' then '', Laundry'' else '''' end +          
		 case ca.AssistanceWithShopping when ''Y'' then '', Shopping'' else '''' end +          
		 case ca.AssistanceWithHousecleaning when ''Y'' then '', Housecleaning'' else '''' end                                                
		 as CheckBoxAssistance
--End  
		,[AssistanceWithOther]  
		,[AssistanceWithOtherText]  
		,[ConcernNone]
       
--Start ConcernReading  
		,case ca.ConcernReading when ''Y'' then '', Reading'' else '''' end +                                   
		 case ca.ConcernSpeech when ''Y'' then '', Speech'' else '''' end +                                   
		 case ca.ConcernMotorSkills when ''Y'' then '', Fine Motor Skills'' else '''' end +                                   
		 case ca.ConcernSchoolPerformanceGrades when ''Y'' then '', School Performance/Grades'' else '''' end +                                   
		 case ca.ConcernSchoolBehavior when ''Y'' then '', School Behavior'' else '''' end +                                   
		 case ca.ConcernToileting when ''Y'' then '',  Toileting'' else '''' end +                                  
		 case ca.ConcernSocializationSkills when ''Y'' then '', Socialization Skills'' else '''' end +                                   
		 case ca.ConcernAttentionTask when ''Y'' then '', Attention to Task'' else '''' end +                                   
		 case ca.ConcernHomeBehavior when ''Y'' then '', Home Behavior'' else '''' end +                                   
		 case ca.ConcernPsychomotorSkills when ''Y'' then '', Psychomotor Skills'' else '''' end +                                  
		 case ca.ConcernDevelopmentalMilestones when ''Y'' then '',Achieving Developmental Milestones'' else '''' end                                    
		 as CheckBoxConcern   
--End  
		,[ConcernOther]  
		,[ConcernOtherText]
		,[DiagnosisDocumentId]  
		,[MaladaptiveBehaviorsTxPlan]  
		,[MaladaptiveBehaviors]  
		,[ReasonForUpdate]  
  
		,Case CCD.UnprotectedSex  
			When ''NAS'' then ''Not Asked''        
			When ''NAN'' then ''Declined To Answer''  
			When ''N''  then ''No''  
			When ''Y'' then ''Yes''        
			Else ''''        
		 End As UnprotectedSex  
     
		,Case CCD.InfectedSex  
			When ''NAS'' then ''Not Asked''        
			When ''NAN'' then ''Declined To Answer''  
			When ''N''  then ''No''  
			When ''Y'' then ''Yes''        
			Else ''''        
		 End As InfectedSex  
     
		,Case CCD.InjectDrugSex  
			When ''NAS'' then ''Not Asked''        
			When ''NAN'' then ''Declined To Answer''  
			When ''N''  then ''No''  
			When ''Y'' then ''Yes''        
			Else ''''        
		 End As InjectDrugSex  
  
		,Case CCD.InjectedDrugs  
			When ''NAS'' then ''Not Asked''        
			When ''NAN'' then ''Declined To Answer''  
			When ''N''  then ''No''  
			When ''Y'' then ''Yes''        
			Else ''''			
		 End As InjectedDrugs  
  
		,Case CCD.PaidSex  
			When ''NAS'' then ''Not Asked''        
			When ''NAN'' then ''Declined To Answer''  
			When ''N''  then ''No''  
			When ''Y'' then ''Yes''        
			Else ''''        
		 End As PaidSex  
  
		,CCD.WeightLoss as WeightLoss  
		,CCD.NightSweats as NightSweats  
		,CCD.PersistentFatigue as PersistentFatigue  
		,CCD.UnexplainedFever as UnexplainedFever  
		,CCD.PersistentCough as PersistentCough  
		,CCD.ChangeBowelUrine as ChangeBowelUrine  
		,CCD.YellowishSkin as YellowishSkin  
	  
		,Case CCD.TuberculosisTest  
			When ''Y'' then ''Yes''  
			When ''N'' then ''No''  
			Else ''''  
		 End as TuberculosisTest  
	   
		,Case CCD.WithinLastYear  
			When ''Y'' then ''Yes''  
			When ''N'' then ''No''  
			Else ''''  
		 End as WithinLastYear  
	   
		,Case CCD.TestResults  
			When ''Y'' then ''Positive''  
			When ''N'' then ''Negative''  
			Else ''''  
		 End as TestResults  
	  
		,CCD.Comment as Comment  
		,CPPC.Participants as Participants
		,CPPC.Facilitator as Facilitator
		,CPPC.Assessments as Assessments
		,CPPC.TimeLocation as  TimeLocation
		,CPPC.ISsuesToAvoid as ISsuesToAvoid
		,CPPC.SourceOfPrePlanningInformation as SourceOfPrePlanningInformation
		,CPPC.CommunicationAccomodations as CommunicationAccomodations
		,CPPC.WishToDiscuss as WishToDiscuss

		,Case CPPC.SelfDetermination
			When ''N'' then ''No, does not desire''
			When ''Y'' then ''Yes, referral made'' 
			else ''''
		 End as SelfDetermination

		,Case CPPC.FiscalIntermediary
			When ''N'' then ''No, does not desire''
			When ''Y'' then ''Yes, referral made'' 
			else ''''
		 End as FiscalIntermediary

		,CPPC.PCPInformationPamphletGiven as PCPInformationPamphletGiven
		,CPPC.PCPInformationDiscussed   as PCPInformationDiscussed                                       
   
--FROM [dbo].[CustomAssessments] CA Inner Join Documents On CA.DocumentId=Documents.DocumentId   
FROM [dbo].[CustomAssessments] CA 
join DocumentVersions dv on dv.DocumentVersionId = ca.DocumentVersionId and isnull(dv.RecordDeleted,''N'')<>''Y'' 
Join Documents On dv.DocumentId=Documents.DocumentId   
and Isnull(Documents.RecordDeleted,''N'')<> ''Y''      
Left join Staff S on Documents.AuthorId= S.StaffId and isnull(S.RecordDeleted,''N'')<>''Y''          
Left join Clients C on Documents.ClientId= C.ClientId and isnull(C.RecordDeleted,''N'')<>''Y''      
Left Join GlobalCodes GC On S.Degree=GC.GlobalCodeId and isNull(GC.RecordDeleted,''N'')<>''Y''     
Left Join GlobalCodes GCTGeneral On CA.TeamGeneral=GCTGeneral.GlobalCodeId and Isnull(GCTGeneral.RecordDeleted,''N'')<>''Y''  
Left Join GlobalCodes GCREFERRALSOURCE on GCREFERRALSOURCE.Globalcodeid=CA.REFERRALSOURCE and Isnull(GCREFERRALSOURCE.RecordDeleted,''N'')<>''Y''                                 
Left join GlobalCodes GCLIVINGARRANGEMENT on GCLIVINGARRANGEMENT.GlobalCodeId=CA.TypeOfLivingSituation   
Left join GlobalCodes GCMaritalStatus on   C.MaritalStatus=GCMaritalStatus.Globalcodeid and Isnull(GCMaritalStatus.RecordDeleted,''N'')<>''Y''  
Left join GlobalCodes GCAssignedTeam on GCAssignedTeam.globalcodeid=CA.AssignedTeam
Left join GlobalCodes GCAuthorizationTeam on GCAuthorizationTeam.globalcodeid=CA.AuthorizationTeam       
and   Isnull(GCAuthorizationTeam.RecordDeleted,''N'')<>''Y''                       
--Left join CustomCommunicableDiseaseRiskAssessments CCD on CCD.documentid=documents.documentid and CA.version=CCD.version    
Left join CustomCommunicableDiseaseRiskAssessments CCD on CCD.DocumentVersionId=documents.CurrentDocumentVersionId  --Modified by Anuj Dated 03-May-2010      
and Isnull(CCD.RecordDeleted,''N'')<>''Y''                                                                 
Left Join Pharmacies Phar on Phar.PharmacyId=CA.Pharmacy and Isnull(Phar.RecordDeleted,''N'')<>''Y''  
left join Staff GCAssignedClinician on GCAssignedClinician.Staffid=CA.AssignedClinician 
Left Join Staff Staff1 On CA.NotifyStaff1=Staff1.StaffId   and isnull(Staff1.RecordDeleted,''N'')<>''Y''                
Left Join Staff Staff2 On CA.NotifyStaff2=Staff2.StaffId   and isnull(Staff2.RecordDeleted,''N'')<>''Y''                      
Left Join Staff Staff3 On CA.NotifyStaff3=Staff3.StaffId   and isnull(Staff3.RecordDeleted,''N'')<>''Y''                     
Left Join Staff Staff4 On CA.NotifyStaff4=Staff4.StaffId   and isnull(Staff4.RecordDeleted,''N'')<>''Y''  
--Left Join  CustomPrePlanningChecklists CPPC On Documents.DocumentId=CPPC.DocumentId and CA.Version=CPPC.Version 
Left Join  CustomPrePlanningChecklists CPPC On Documents.CurrentDocumentVersionId=CPPC.DocumentVersionId   --Modified by Anuj Dated 03-May-2010 
and isnull(CPPC.RecordDeleted,''N'')<>''Y''
Cross Join SystemConfigurations as SystemConfig      
--Where ISNull(CA.RecordDeleted,''N'')<>''Y'' and CA.Documentid=@DocumentId and CA.Version=@Version        
Where ISNull(CA.RecordDeleted,''N'')<>''Y'' and CA.DocumentVersionId=@DocumentVersionId    --Modified by Anuj Dated 03-May-2010       
    
--Checking For Errors                                                
If (@@error!=0)                                                
	Begin                                                
		RAISERROR  20006   ''[csp_RDLCustomAssessments] : An Error Occured''                                                 
		Return                                                
	End   
End
' 
END
GO
