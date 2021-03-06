/****** Object:  StoredProcedure [dbo].[csp_RDLCustomHospitalizationPrescreens]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomHospitalizationPrescreens]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomHospitalizationPrescreens]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomHospitalizationPrescreens]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE  [dbo].[csp_RDLCustomHospitalizationPrescreens]
(
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)
As

Begin
/************************************************************************/
/* Stored Procedure: csp_RDLCustomHospitalizationPrescreens				*/
/* Copyright: 2006 Streamline SmartCare									*/
/* Creation Date:  Oct 09, 2007											*/
/*																		*/
/* Purpose: Gets Data for HospitalizationPreScreens						*/
/*																		*/
/* Input Parameters: DocumentID,Version									*/
/* Output Parameters:													*/
/* Purpose: Use For Rdl Report											*/
/* Calls:																*/
/* Author: Ranjeetb														*/
/*********************************************************************/

SELECT	d.ClientID
		,[DateOfPrescreen]
		,InitialCallTime as [InitialCallTime]
		,[ElapsedTimeOfScreen]
--		,[CHMStatus]
		,gcCHMStatus.CodeName as [CHMStatus]
		,EventStartTime as [EventStartTime]
		,[TravelTime]
--		,[ScreenContactType]
		,gcScreenContactType.CodeName as [ScreenContactType]
		,DispositionTime as [DispositionTime]
		,ReferralToProviderTime as [ReferralToProviderTime]
		,EventStopTime as [EventStopTime]
		,ProviderResponseTime  as [ProviderResponseTime]
		,Staff.FirstName + '', '' + Staff.LastName as [ScreeningCompletedBy]
		,County.CountyName as  [County]
		,[OtherCounty]
--		,[Ethnicity]
		,gcEthnicity.CodeName as [Ethnicity]
--		,[MaritalStatus]
		,gcMaritalStatus.CodeName as MaritalStatus
		,CHP.[Sex] as [Sex]
		,[ClientName]
		,[CMHCaseNumber]
		,CHP.[SSN] as [SSN]
		,[DateOfBirth]
		,[ClientAddress]
		,[ClientCity]
		,[ClientState]
		,[ClientZip]
		,ClientCounty.CountyName as  [ClientCounty]
		,[ClientHomePhone]
		,[EmergencyContact]
--		,[RelationWithClient]
		,gcRelationWithClient.CodeName as [RelationWithClient]
		,[EmergencyPhone]
		,[GuardianName]
		,[GuardianPhone]
		,[Indigent]
		,[Private]
		,[PrivateDetail]
		,[EmployerName]
		,[EmployerNumber]
		,[Medicare]
		,[MedicareType]
		,[MedicareNumber]
		,[Medicaid]
		,[MedicaidType]
		,[MedicaidNumber]
		,[Verified]
		,[VA]
		,[OtherReportedPaymentSource]
		,[OtherReportedPaymentSourceDetail]
		,gcReferralSourceType.CodeName as [ReferralSourceType]
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
		,[CurrentSelfHarmfulBehaviour]
		,[CurrentSelfHarmfulBehaviourDetail]
		,[CurrentSelfHarmfulBehaviourOutcomeDetail]
		,[PreviousSelfHarmfulBehaviour]
        ,[PreviousSelfHarmfulBehaviourDetail]
        ,[PreviousSelfHarmfulBehaviourOutcome]
		,[FamilyHistory]
		,[FamilyHistoryDetail]
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
		,[PreviosHealthConcerns]
		,[PsychiatricSymptoms]
		,[PossibleHarmToSelf]
		,[PossibleHarmToOther]
		,[DrugComplication]
		,[Disruption]
		,[ImpairedAdjustment]
		,[IntensityOfService]
--		,[ConsumerRequested]
		,gcConsumerRequested.CodeName as [ConsumerRequested]
		,[OtherRequested]
--		,[Recommended]
		,gcRecommended.CodeName as [Recommended]
		,[OtherRecommended]
		,[RequestNotAuthorized]
		,gcHospitalizationStatus.CodeName as [HospitalizationStatus]
--		,[FacilityName]
		,Providers.ProviderName + ''- '' + Sites.SiteName as  [FacilityName]
		,[OtherFacilityName]
		,[SecondOpinionNotification]
		,[AlternativeServices]
		,[AlternativeServicesDetail]
		,[AdequateNoticeGiven]
		,[AdequateNoticeGivenDetail]
		,[ProviderDetail]
		,[FamilyNotification]
		,[FamilyMemeberName]
		,[ConsumerRefusedTreatment]
		,[CrisisResolved]
		,[Summary]
		,[SignedByConsumer]
		,[UnableToObtainConsumerSignature]
		,[ProvideRationale]
		,[NoSubstanceUseSuspected]
		,[FamilySUHistory]
		,[ClientSUHistory]
		,[CurrentSubstanceUse]
		,[CurrentSubstanceUseSuspected]
		,[RecomendedSubstanceUse]
		,[SubstanceUseDetails]
		,Staff1.LastName + '', '' + Staff1.FirstName as [NotifyStaffId1]
		,Staff2.LastName + '', '' + Staff2.FirstName as[NotifyStaffId2]
		,Staff3.LastName + '', '' + Staff3.FirstName as[NotifyStaffId3]
		,Staff4.LastName + '', '' + Staff4.FirstName as [NotifyStaffId4]
		,[NotificationMessage]
		,[IPHospitalizationUnknown]
		,[OPTreatmentUnknown]
		,[PreviousTreatment]
		,[FacilityProviderId]
		,[FacilitySiteId]
		,[AlternativeServicesAgreed]
FROM [CustomHospitalizationPrescreens] CHP
join DocumentVersions as dv on dv.DocumentVersionId = CHP.DocumentVersionId
Join Documents d On d.DocumentId = dv.DocumentId
Left Join GlobalCodes gcCHMStatus On CHP.CHMStatus = gcCHMStatus.GlobalCodeid
Left join GlobalCodes gcScreenContactType On CHP.ScreenContactType = gcScreenContactType.GlobalCodeid
Left join GlobalCodes gcEthnicity On CHP.Ethnicity = gcEthnicity.GlobalCodeid
Left join GlobalCodes gcMaritalStatus On CHP.MaritalStatus = gcMaritalStatus.GlobalCodeid
Left join GlobalCodes gcRelationWithClient On CHP.RelationWithClient = gcRelationWithClient.GlobalCodeid
Left join Staff On CHP.ScreeningCompletedBy = Staff.StaffId
Left join GlobalCodes gcConsumerRequested On CHP.ConsumerRequested = gcConsumerRequested.GlobalCodeID
Left Join GlobalCodes gcHospitalizationStatus On CHP.HospitalizationStatus = gcHospitalizationStatus.GlobalCodeid
Left Join GlobalCodes gcRecommended on CHP.Recommended = gcRecommended.GlobalCodeid
Left Join GlobalCodes gcReferralSourceType on CHP.ReferralSourceType = gcReferralSourceType.GlobalCodeid
Left Join  Providers On CHP.FacilityProviderId = Providers.Providerid
Left Join Sites On CHP.FacilitySiteId = Sites.Siteid
Left Join Staff Staff1 On CHP.NotifyStaffId1 = Staff1.StaffId
Left Join Staff Staff2 On CHP.NotifyStaffId2 = Staff2.StaffId
Left Join Staff Staff3 On CHP.NotifyStaffId3 = Staff3.StaffId
Left Join Staff Staff4 On CHP.NotifyStaffId4 = Staff4.StaffId
Left Join Counties County On CHP.County = County.CountyFIPS
Left Join Counties ClientCounty On CHP.ClientCounty = ClientCounty.CountyFIPS
where ISNull(CHP.RecordDeleted,''N'') = ''N''
and CHP.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010

--Checking For Errors
If (@@error!=0)
	Begin
		RAISERROR  20006   ''csp_RDLCustomHospitalizationPrescreens : An Error Occured''
		Return
	End
End
' 
END
GO
