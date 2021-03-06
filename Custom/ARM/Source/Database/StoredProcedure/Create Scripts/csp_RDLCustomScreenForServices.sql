/****** Object:  StoredProcedure [dbo].[csp_RDLCustomScreenForServices]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomScreenForServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomScreenForServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomScreenForServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE  [dbo].[csp_RDLCustomScreenForServices]     
(                      
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)                      
As                      
                              
Begin                              
/************************************************************************/                                
/* Stored Procedure: csp_RDLCustomScreenForServices						*/                       
/* Copyright: 2006 Streamline SmartCare									*/                                
/* Creation Date:  Oct 24th, 2007										*/                                
/*																		*/                                
/* Purpose: Gets Data for ScreenForServices								*/                               
/*																		*/                              
/* Input Parameters: DocumentID,Version									*/                              
/* Output Parameters:													*/                                
/* Purpose: Use For Rdl Report											*/                      
/* Calls:																*/                                
/* Author: Ranjeetb														*/ 
/* Modified by: Rupali Patil											*/
/* Modified date: 6/6/2008												*/                               
/* Modified by: Added ClientID in select list							*/                               
/************************************************************************/                                 
SELECT	d.ClientID
		,[DateOfScreen]
		,[EventStartTime]
		,[DispositionTime]
		,[EventStopTime] 
		,[ElapsedTimeOfScreen]
		,Staff.FirstName + '', '' + Staff.LastName as [ScreeningCompletedBy]  
		,County.CountyName as  [County]        
		,[OtherCounty]
		,gcEthnicity.CodeName as [Ethnicity]
		,gcMaritalStatus.CodeName as MaritalStatus     
		,CSFS.Sex as [Sex]  
		,[ClientName]
		,[CMHCaseNumber]
		,CSFS.SSN as [SSN]
		,[DateOfBirth]
		,[ClientAddress]
		,[ClientCity]
		,[ClientState]
		,[ClientZip]
		,ClientCounty.CountyName as [ClientCounty]
		,[ClientHomePhone]
		,[EmergencyContact]
		,gcRelationWithClient.CodeName as [RelationWithClient]   
		,[EmergencyPhone]
		,[GuardianName]
		,[GuardianPhone]
		,[ReferralSourceType]
		,[OtherReferral]
		,[ReferralSouceName]
		,[Location]
		,[Phone]
		,[ReferralSourceContacted]
		,[ReferralSourceContactedDetail]
		,[JustificationForReferral]
		,[Aggressive]
		,[AWOLRisk]
		,[AWOLRiskDetail]
		,[Physical]
		,[PhysicalDetail]
		,[Ideation]
		,[IdeationDetail]
		,[SexualActingOut]
		,[SexualActingOutDetail]
		,[Verbal]
		,[VerbalDetail]
		,[DestructionOfProperty]
		,[DestructionOfPropertyDetail]
		,[History]
		,[ChargesPending]
		,[ChargesPendingDetail]
		,[JailHold]
		,[CurrentSuicidalIdeation]
		,[ActiveSuicidal]
		,[PassiveSuicidal]
		,[SuicidalIdeationWithin48Hours]
		,[SuicidalIdeationWithin14Days]
		,[SuicidalEgoSyntonic]
		,[SuicidalEgoDystonic]
		,[EgoExplanation]
		,[HasPlan]
		,[HasPlanDetail]
		,[AccessToMeans]
		,[AccessToMeansDetail]
		,[HistorySuicidalAttempts]
		,[HistoryFamily]
		,[Diagnosis]
		,[PreviousRescue]
		,[FamilySupport]
		,[FamilyUnwillingToHelp]
		,[Dependence]
		,[ConstrictedThinking]
		,[EgosyntonicAttitude]
		,[Helplessness]
		,[Hopelessness]
		,[MakingPreparations]
		,[NoAmbivalence]
		,[SelfHarmfulBehaviour]
		,[SelfHarmfulBehaviourDetail]
		,[OutcomeDetail]
		,[UnableToObtain]
		,[NumberOfInpatient]
		,[DateOfRecentInpatient]
		,[Facility]
		,[PreviosOutpatientTreatment]
		,[LastSeen]
		,[CurrentTherapist]
		,[NameOfPrimaryCarePhysician]
		,[PhysicianPhone]
		,[Allergies]
		,[CurrentHealthConcerns]
		,gcConsumerRequested.CodeName as [ConsumerRequested]
		,[OtherRequested]
		,gcRecommended.CodeName as [Recommended] 
		,[OtherRecommended]
		,[RequestNotAuthorized]
		,gcHospitalizationStatus.CodeName as [HospitalizationStatus]    
		,[FacilityName]
		,[OtherFacilityName]
		,[Summary]
		,[NoSubstanceUseSuspected]
		,[FamilySUHistory]
		,[ClientSUHistory]
		,[CurrentSubstanceUse]
		,[CurrentSubstanceUseSuspected]
		,[RecomendedSubstanceUse]
		,[SubstanceUseDetails]
		,[FacilityProviderId]
		,[FacilitySiteId]
		,Staff1.LastName + '', '' + Staff1.FirstName as [NotifyStaffId1]        
		,Staff2.LastName + '', '' + Staff2.FirstName as[NotifyStaffId2]        
		,Staff3.LastName + '', '' + Staff3.FirstName as[NotifyStaffId3]        
		,Staff4.LastName + '', '' + Staff4.FirstName as [NotifyStaffId4]        
		,[NotificationMessage]
		,[NotificationSent]
FROM CustomScreenForServices CSFS
--Join Documents d on d.DocumentId = CSFS.DocumentID
Join DocumentVersions dv on dv.DocumentVersionId=CSFS.DocumentVersionID
Join Documents d on d.DocumentId = dv.DocumentId    --Modified by Anuj Dated 03-May-2010
Left join GlobalCodes gcEthnicity On CSFS.Ethnicity = gcEthnicity.GlobalCodeid
Left join GlobalCodes gcMaritalStatus On CSFS.MaritalStatus = gcMaritalStatus.GlobalCodeid
Left join GlobalCodes gcRelationWithClient On CSFS.RelationWithClient = gcRelationWithClient.GlobalCodeid
Left join Staff On CSFS.ScreeningCompletedBy = Staff.StaffId 
Left join GlobalCodes gcConsumerRequested On CSFS.ConsumerRequested = gcConsumerRequested.GlobalCodeID
Left Join GlobalCodes gcHospitalizationStatus On CSFS.HospitalizationStatus = gcHospitalizationStatus.GlobalCodeid
Left Join GlobalCodes gcRecommended on CSFS.Recommended = gcRecommended.GlobalCodeid
Left Join  Providers  On CSFS.FacilityProviderId = Providers.Providerid
Left Join Sites On CSFS.FacilitySiteId = Sites.Siteid
Left Join Staff Staff1 On CSFS.NotifyStaffId1 = Staff1.StaffId
Left Join Staff Staff2 On CSFS.NotifyStaffId2 = Staff2.StaffId
Left Join Staff Staff3 On CSFS.NotifyStaffId3 = Staff3.StaffId
Left Join Staff Staff4 On CSFS.NotifyStaffId4 = Staff4.StaffId
Left Join Counties County On CSFS.County = County.CountyFIPS
Left Join Counties ClientCounty On CSFS.ClientCounty = ClientCounty.CountyFIPS
where ISNull(CSFS.RecordDeleted,''N'') = ''N''
--and CSFS.Documentid = @DocumentId
--and CSFS.Version = @Version               
and CSFS.DocumentVersionId=  @DocumentVersionId    --Modified by Anuj Dated 03-May-2010         
   
                      
--Checking For Errors                      
If (@@error!=0)                      
	Begin                      
		RAISERROR  20006   ''csp_RDLCustomScreenForServices : An Error Occured''                       
		Return                      
	End
End
' 
END
GO
