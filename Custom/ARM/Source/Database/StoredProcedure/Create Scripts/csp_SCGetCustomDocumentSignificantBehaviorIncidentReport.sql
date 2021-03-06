/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentSignificantBehaviorIncidentReport]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentSignificantBehaviorIncidentReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentSignificantBehaviorIncidentReport]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentSignificantBehaviorIncidentReport]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE	PROCEDURE	 [dbo].[csp_SCGetCustomDocumentSignificantBehaviorIncidentReport]
		@DocumentVersionId int
AS

SELECT	[DocumentVersionId],
		[CreatedBy],
		[CreatedDate],
		[ModifiedBy],
		[ModifiedDate],
		[RecordDeleted],
		[DeletedBy],
		[DeletedDate],
		
		[DateOfIncident],
		[TimeOfIncident],
		[WeekDay],
		[Location],
		[OtherLocation],
		[Witnesses],
		[MedicalTreatment],
		[PhysicalInjury],
		[Violence],
		[Transportation],
		[Behavioral],
		[Elopement],
		[Weapon],
		[PropertyDamage],
		[Verbal],
		[IllicitSubstance],
		[Other],
		[OtherDescription],
		[ReasonForIntervention],
		[InClassRecovery],
		[InClassRecoveryDesc],
		[OutClassRecovery],
		[OutClassRecoveryDesc],
		[Contracting],
		[ContractingDesc],
		[InvolvementOfTeam],
		[InvolvementOfTeamDesc],
		[SocialSkillsRoom],
		[SocialSkillsRoomDesc],
		[Counseling],
		[CounselingDesc],
		[CalledTPD],
		[CalledTPDDesc],
		[OtherIntervention],
		[OtherInterventionDesc],
		[TherapeuticHold],
		[TherapeuticHoldMinutes],
		[PhysicalRestraint],
		[WhoInitiatedHold],
		[StaffNameInitiatedHold],
		[StaffParticipatingInHold],
		[ClientAge],
		[ClientSex],
		[ClientRace],
		[RestraintType],
		[ExplanationProvidedYN],
		[ExplanationProvided],
		[AssessmentOfNeedsYN],
		[AssessmentOfNeeds],
		[InjuriesSustainedYN],
		[InjuriesSustained],
		[ContraindicationsObservedYN],
		[ContraindicationsObserved],
		[EvalWithinOneHourYN],
		[Debriefing],
		[DebriefingScheduled],
		[ReturnedToClassroom],
		[SuspendedFromTransportation],
		[SuspendedFromTransportationDays],
		[SafeSchoolCharges],
		[Arrested],
		[ScheduledCaseConference],
		[RemovedForDay],
		[SuspendedFromSchool],
		[SuspendedFromSchoolDays],
		[ReferredToATSP],
		[ReferredToATSPDate],
		[OtherAction],
		[OtherActionDesc],
		[MedicationYN],
		[MedicationDesc],
		[TXTeamConsultedYN],
		[TXTeamConsultedDesc],
		[ParentNotifiedYN],
		[ParentNotifiedDesc]
	
FROM	CustomDocumentSignificantBehaviorIncidentReport
WHERE	(ISNULL(RecordDeleted, ''N'') = ''N'')
AND		([DocumentVersionId] = @DocumentVersionId)  


' 
END
GO
