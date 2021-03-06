/****** Object:  StoredProcedure [dbo].[csp_RDLCustomCrisisInterventions]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomCrisisInterventions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomCrisisInterventions]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomCrisisInterventions]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE  [dbo].[csp_RDLCustomCrisisInterventions]
(
--@DocumentId int,
--@Version int
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)
As

Begin
/************************************************************************/
/* Stored Procedure: csp_RDLCustomCrisisInterventions					*/
/* Copyright: 2006 Streamline SmartCare									*/
/* Creation Date:  Oct 11 ,2007											*/
/*																		*/
/* Purpose: Gets Data for CrisisInterventions							*/
/*																		*/
/* Input Parameters: DocumentID,Version									*/
/* Output Parameters:													*/
/* Purpose Use For Rdl Report											*/
/* Calls:																*/
/*																		*/
/* Author: Rishu Chopra													*/
/* Modified by: Rupali Patil											*/
/* Modified date: 6/5/2008												*/
/* Modified: Added ClientID to the select list							*/
/************************************************************************/
SELECT	D.ClientID
		,CCM.DateOfCrisisIntervention
		,S5.LastName+'', ''+ S5.FirstName as ScreeningCompletedBy
		,Convert(varchar,CU.countyName) as County
		,CCM.OtherCounty
		,Convert(varchar,GC1.CodeName) as Ethnicity
		,Convert(varchar,GC.CodeName) as MaritalStatus
		,case CCM.Sex When ''M'' Then ''Male'' When ''F'' Then ''Female'' Else '''' End as Sex
		,CCM.ClientName
		,CCM.CMHCaseNumber
		,CCM.SSN
		,Convert(varchar(10),CCM.DateOfBirth,101) as DateOfBirth
		,CCM.ClientAddress
		,CCM.ClientCity
		,CCM.ClientState
		,CCM.ClientZip
		,Convert(varchar,CU1.countyName) as ClientCounty
		,CCM.ClientHomePhone
		,CCM.EmergencyContact
		,Convert(varchar,GC2.CodeName) as RelationWithClient
		,CCM.EmergencyPhone
		,CCM.GuardianName
		,CCM.GuardianPhone
		,CCM.JustificationForReferral
		,CCM.Aggressive
		,CCM.AWOLRisk
		,CCM.AWOLRiskDetail
		,CCM.Physical
		,CCM.PhysicalDetail
		,CCM.Ideation
		,CCM.IdeationDetail
		,CCM.SexualActingOut
		,CCM.SexualActingOutDetail
		,CCM.Verbal
		,CCM.VerbalDetail
		,CCM.DestructionOfProperty
		,CCM.DestructionOfPropertyDetail
		,CCM.History
		,CCM.ChargesPending
		,CCM.ChargesPendingDetail
		,CCM.JailHold
		,CCM.CurrentSuicidalIdeation
		,CCM.ActiveSuicidal
		,CCM.PassiveSuicidal
		,CCM.SuicidalIdeationWithin48
		,CCM.SuicidalIdeationWithin14
		,CCM.SuicidalEgoSyntonic
		,CCM.SuicidalEgoDystonic
		,CCM.EgoExplanation
		,CCM.HasPlan
		,CCM.HasPlanDetail
		,CCM.AccessToMeans
		,CCM.AccessToMeansDetail
		,CCM.HistorySuicidalAttempts
		,CCM.HistoryFamily
		,CCM.Diagnosis
		,CCM.PreviousRescue
		,CCM.FamilySupport
		,CCM.FamilyUnwillingToHelp
		,CCM.Dependence
		,CCM.ConstrictedThinking
		,CCM.EgosyntonicAttitude
		,CCM.Helplessness
		,CCM.Hopelessness
		,CCM.MakingPreparations
		,CCM.NoAmbivalence
		,CCM.SelfHarmfulBehaviour
		,CCM.SelfHarmfulBehaviourDetail
		,CCM.OutcomeDetail
		,CCM.NumberOfHospitalizations
		,CCM.CurrentTherapist
		,Convert(varchar,GC3.CodeName) as ConsumerRequested
		,Convert(varchar,GC4.CodeName) as OtherRequested
		,Convert(varchar,GC6.CodeName) as Recommended
		,CCM.OtherRecommended
		,Convert(varchar,GC7.CodeName)as RequestNotAuthorized
		,Convert(varchar,GC5.CodeName) as HospitalizationStatus
		,PR.providerName +''-'' + ST.SiteName as FacilityName
		,CCM.OtherFacilityName
		,CCM.Summary
		,CCM.FacilityProviderId
		,CCM.FacilitySiteId
		,S1.LastName + '', '' + S1.FirstName as NotifyStaffId1
		,S2.LastName + '', '' + S2.FirstName as NotifyStaffId2
		,S3.LastName + '', '' + S3.FirstName as NotifyStaffId3
		,S4.LastName + '', '' + S4.FirstName as NotifyStaffId4
		,CCM.NotificationMessage
		,CCM.NotificationSent
		,CCM.Modality
		,CSU.NoSubstanceAbuseSuspected
		,CSU.FamilySAHistory
		,CSU.ClientSAHistory
		,CSU.CurrentSubstanceAbuse
		,CSU.SuspectedSubstanceAbuse
		,CSU.SubstanceAbuseTxPlan
FROM CustomCrisisInterventions CCM
join DocumentVersions as dv on dv.DocumentVersionId = CCM.DocumentVersionId
JOIn Documents D on D.DocumentId = dv.DocumentId
left JOIN GlobalCodes GC on (GC.GlobalCodeID = CCM.MaritalStatus)
left JOIN GlobalCodes GC1 on (GC1.GlobalCodeID = CCM.Ethnicity)
left JOIN GlobalCodes GC2 on (GC2.GlobalCodeID = CCM.RelationWithClient)
left JOIN GlobalCodes GC3 on (GC3.GlobalCodeID = CCM.consumerRequested)
left JOIN GlobalCodes GC4 on (GC4.GlobalCodeID = CCM.otherrequested)
left JOIN GlobalCodes GC5 on (GC5.GlobalCodeID = CCM.Hospitalizationstatus)
left JOIN GlobalCodes GC6 on (GC6.GlobalCodeID = CCM.Recommended)
left JOIN GlobalCodes GC7 on (GC7.GlobalCodeID = CCM.RequestNotAuthorized)
left JOIN staff S1 on (S1.StaffId = CCM.NotifyStaffId1)
left JOIN staff S2 on (S2.StaffId = CCM.NotifyStaffId2)
left JOIN staff S3 on (S3.StaffId = CCM.NotifyStaffId3)
left JOIN staff S4 on (S4.StaffId = CCM.NotifyStaffId4)
left JOIN staff S5 on (S5.StaffId = CCM.ScreeningComletedBy)
left JOIN providers PR on (PR.ProviderId = CCM.FacilityProviderId)
left JOIN sites ST on (ST.SiteId = CCM.FacilityName)
left JOIN counties CU on (CU.countyFIPS = CCM.County)
left JOIN counties CU1 on (CU1.countyFIPS = CCM.ClientCounty)
left JOIN customsubstanceuseassessments CSU on (CSU.DocumentVersionId=CCM.DocumentVersionId)  --Modified by Anuj Dated 03-May-2010
where ISNull(CCM.RecordDeleted,''N'') = ''N''
and CCM.DocumentVersionId=@DocumentVersionId  --Modified by Anuj Dated 03-May-2010

--Checking For Errors
If (@@error!=0)
	Begin
		RAISERROR  20006   ''csp_RDLCustomCrisisInterventions : An Error Occured''
		Return
	End
End
' 
END
GO
