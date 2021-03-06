/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomDocumentIntakeInterview]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentIntakeInterview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomDocumentIntakeInterview]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomDocumentIntakeInterview]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE	PROCEDURE	 [dbo].[csp_SCGetCustomDocumentIntakeInterview]
		@DocumentVersionId int
AS

SELECT		[DocumentVersionId],
	[CreatedBy],
	[CreatedDate],
	[ModifiedBy],
	[ModifiedDate],
	[RecordDeleted],
	[DeletedBy],
	[DeletedDate],

	[ReferralDate],
	[InitialInterviewDate],

	[LastName],
	[FirstName],
	[Address],
	[City],
	[State],
	[Zip],
	[County],

	[HomePhoneNumber],
	[AlternatePhoneNumber],
	[Email],
	[SSN],
	[DOB],
	[Sex],
	[AliasLastName],
	[AliasFirstName],
	[USCitizenYN],
	[MaritalStatus],
	[EthnicityIndian],
	[EthnicityAlaskan],
	[EthnicityAsian],
	[EthnicityBlack],
	[EthnicityHawaiian],
	[EthnicityCaucasian],
	[EthnicityMultiRacial],
	[EthnicityOther],
	[EthnicityOtherComment],
	[EthnicityUnknown],

	[ReferringLastName],
	[ReferringFirstName],
	[ReferringOrganization],
	[ReferringPhoneNumber],
	
	[GuardianLastName],
	[GuardianFirstName],
	[GuardianPhoneNumber],
	
	[EmergencyContactLastName],
	[EmergencyContactFirstName],
	[EmergencyContactPhoneNumber],

	[LivingSituation],
	[LivingSituationComment],
	[SubsidizedHousing],

	[HouseholdOccupants],
	[HouseholdOccupantsComment],
	[ChildCareArrangements],

	[TransportationCar],
	[TransportationBike],
	[TransportationFamily],
	[TransportationTARTA],
	[TransportationTaxi],
	[TransportationTARPS],
	[TransportationOther],
	[TransportationOtherComment],
	[TransportationBenefitFromTravelTrainingYN],
	[TransportationLivesOnBusLine],
	[TransportationIssues],
	[TransportationIssuesComment],

	[FormsOfIDDriversLicence],
	[FormsOfIDBirthCertificate],
	[FormsOfIDSocialSecurityCard],
	[FormsOfIDStateID],
	[FormsOfIDOther],
	[FormsOfIDOtherComment],

	[MedicationCosts],
	[HowMedicationPaidFor],
	[MedicalCoverageMedicaid],
	[MedicalCoverageMedicare],
	[MedicalCoveragePrivateInsurance],
	[MedicalCoverageOther],
	[MedicalCoverageNone],
	[MedicalCoverageOtherComment],

	[FinancialSSI],
	[FinancialSSDI],
	[FinancialFamily],
	[FinancialChildSupport],
	[FinancialTrustFund],
	[FinancialOther],
	[FinancialNone],
	[FinancialSSIComment],
	[FinancialSSDIComment],
	[FinancialFamilyComment],
	[FinancialChildSupportComment],
	[FinancialTrustFundComment],
	[FinancialOtherComment],
	[FinancialNeedsBenefitConsult],
	[FinancialNeedsBudgetingAssistance],
	[FinancialNeedsInfoFinancialAssistance],

	[LegalNoPriors],
	[LegalMisdemeanor],
	[LegalFelony],
	[LegalOweChildSupport],
	[LegalBWC],
	[LegalBankruptcy],

	[LegalInvolvement],
	[LegalCourtOrderedWork],
	[LegalBarriersNA],
	[LegalBarriersComment],
	[LegalBackgroundReport],
	[LegalAssistanceNeeded],

	[FamilyOrigin],
	[FamilyNA],
	[FamilyConcerns],
	[FamilyResources],
	[FamilyServicePriorities],
	[FamilyExpectations],
	[FamilyBeneficialActivities],
	[FamilyStrengths],
	[FamilyControlDesired],
	[FamilyReferralNeeds],
	[FamilyCulturalIssues],
	[FamilySupporters],
	[FamilyLivingSituation],

	[SocialExercise],
	[SocialSmokeOrDrinkCaffeine],
	[SocialActivities],
	[SocialActivitiesFrequency],
	[SocialPersonalQualities],
	[SocialRelationships],
	[SocialVolunteerExperience],

	[EducationObtained],
	[EducationWhere],
	[EducationGrades],
	[EducationFavoriteClass],
	[EducationLeastFavoriteClass],
	[EducationExtracurricular],
	[EducationOtherTraining],

	[MilitaryVeteranYN],
	[MilitaryBranch],
	[MilitaryTraining],
	[MilitaryServiceDates],
	[MilitaryTypeOfDischarge],

	[VocHistoryNA],

	[VocHistoryEmployer1],
	[VocHistorySupervisor1],
	[VocHistoryPosition1],
	[VocHistoryPay1],
	[VocHistoryDates1],
	[VocHistoryDuties1],
	[VocHistoryLiked1],
	[VocHistoryReasonForLeaving1],

	[VocHistoryEmployer2],
	[VocHistorySupervisor2],
	[VocHistoryPosition2],
	[VocHistoryPay2],
	[VocHistoryDates2],
	[VocHistoryDuties2],
	[VocHistoryLiked2],
	[VocHistoryReasonForLeaving2],
	
	[VocHistoryEmployer3],
	[VocHistorySupervisor3],
	[VocHistoryPosition3],
	[VocHistoryPay3],
	[VocHistoryDates3],
	[VocHistoryDuties3],
	[VocHistoryLiked3],
	[VocHistoryReasonForLeaving3],

	[VocHistoryEmployer4],
	[VocHistorySupervisor4],
	[VocHistoryPosition4],
	[VocHistoryPay4],
	[VocHistoryDates4],
	[VocHistoryDuties4],
	[VocHistoryLiked4],
	[VocHistoryReasonForLeaving4],

	[VocHistoryAdditionalInfo],
	[VocHistoryTimeSincePrevious],
	[VocHistoryTimeSpentAtPrevious],
	[VocHistoryShiftPreference],
	[VocHistoryHoursPreference],
	[VocHistoryDayPreference],
	[VocHistoryTravelDistancePreference],
	[VocHistoryPayDesired],
	[VocHistoryBenefitsHealth],
	[VocHistoryBenefitsVision],
	[VocHistoryBenefitsLife],
	[VocHistoryBenefitsHolidays],
	[VocHistoryBenefitsDental],
	[VocHistoryBenefitsVacation],
	[VocHistoryBenefitsSick],
	[VocHistoryBenefitsOther],
	[VocHistoryBenefitsOtherComment],

	[VocHistoryInterest],
	[VocHistoryStrengths],
	[VocHistoryOtherNeeds],
	[VocHistoryHowLookForWork],
	[VocHistoryHowLookForWorkNA],
	[VocHistoryHowLongLooking],
	[VocHistoryHowLongLookingNA],

	[VocHistoryResume],
	[VocHistoryApplicationsExp],
	[VocHistoryInterviewExp],

	[Skill1],
	[SkillRating1],
	[Skill2],
	[SkillRating2],
	[Skill3],
	[SkillRating3],

	[DDDiagnosis],
	[DDBrainInjury],
	[DDDevelopmental],
	[DDDeaf],
	[DDBlind],
	[DDMentalOrEmotional],
	[DDAddictions],
	[DDPhysical],
	[DDLearning],

	[DDHarborClientYN],

	[DDPreviousCaseOutcome],
	[DDSupportNeeded],
	[DDLearningStyle],
	[DDAccomodationsNeeded],
	[DDAccomodationsNeededNone],
	[DDRisks],
	[DDRisksNone],
	[DDWillingToDisclose],
	[DDSupports],
	[DDOtherAgency],

	[Plan]
		
FROM	CustomDocumentIntakeInterview
WHERE	(ISNULL(RecordDeleted, ''N'') = ''N'')
AND		([DocumentVersionId] = @DocumentVersionId)  


' 
END
GO
