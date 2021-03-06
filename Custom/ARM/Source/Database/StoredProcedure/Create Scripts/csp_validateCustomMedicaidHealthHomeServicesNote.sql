/****** Object:  StoredProcedure [dbo].[csp_validateCustomMedicaidHealthHomeServicesNote]    Script Date: 06/19/2013 17:49:52 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMedicaidHealthHomeServicesNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_validateCustomMedicaidHealthHomeServicesNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_validateCustomMedicaidHealthHomeServicesNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_validateCustomMedicaidHealthHomeServicesNote]
@DocumentVersionId	Int
as

Create Table #validationReturnTable
(TableName varchar(300),
 ColumnName varchar(200),
 ErrorMessage varchar(500),
 PageIndex int
)


Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage,
PageIndex
)
--This validation returns three fields
--Field1 = TableName
--Field2 = ColumnName
--Field3 = ErrorMessage

Select ''CustomDocumentHealthHomeServiceNotes'',''RescueMentalHealthEncounterDate'',''Enter recent rescue mental health encounter date'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and RescueMentalHealthEncounter=''Y'' and isnull(RescueMentalHealthEncounterDate,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''RescueMentalHealthEncounterDate'',''Enter recent rescue mental health encounter date'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and RescueMentalHealthEncounter=''Y'' and RecentPsychHospitalFollowUpDate <> '''' and isnull(RescueMentalHealthEncounterDate,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''RescueMentalHealthEducationProvided'',''Select education regarding rescue mental health utilization provided'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and isnull(RescueMentalHealthEducationProvided,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''RecentPsychHospitalDischargeDate'',''Enter recent psychiatric hospital discharge date'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and RecentPsychHospitalDischarge = ''Y'' and isnull(RecentPsychHospitalDischargeDate,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''RecentPsychHospitalDischargeDate'',''Enter recent psychiatric hospital discharge date'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and RescueMentalHealthEncounter=''Y'' and RecentPsychHospitalFollowUpDate <> '''' and isnull(RecentPsychHospitalDischargeDate,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''RecentPsychHospitalTransitionCompleted'',''Select recent psychiatric hospital discharge transition plan completed'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and RecentPsychHospitalDischarge = ''Y'' and isnull(RecentPsychHospitalTransitionCompleted,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''RecentEmergencyDeptEncounterDate'',''Enter recent emergency department encounter date'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and RecentEmergencyDeptEncounter = ''Y'' and isnull(RecentEmergencyDeptEncounterDate,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''RecentEmergencyDeptEncounterDate'',''Enter recent emergency department encounter date'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and RescueMentalHealthEncounter=''Y'' and RecentEmergencyDeptFollowUpDate <> '''' and isnull(RecentEmergencyDeptEncounterDate,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''RecentEmergencyDeptEducationProvided'',''Select education regarding ED utilization provided'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and isnull(RecentEmergencyDeptEducationProvided,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''RecentPhysicalHospitalDischargeDate'',''Enter recent physical care hospital discharge date'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and RecentPhysicalHospitalDischarge = ''Y'' and isnull(RecentPhysicalHospitalDischargeDate,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''RecentPhysicalHospitalDischargeDate'',''Enter recent physical care hospital discharge date'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and RecentPhysicalHospitalDischarge=''Y'' and RecentPhysicalHospitalFollowUpDate <> '''' and isnull(RecentPhysicalHospitalDischargeDate,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''RecentPhysicalHospitalTransitionCompleted'',''Select recent physical care hospital discharge transition plan completed'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and RecentPhysicalHospitalDischarge = ''Y'' and isnull(RecentPhysicalHospitalTransitionCompleted,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''PlannedTransitionsLongTermCareAODComment'',''Describe Long term care or AOD rehabilitation including dates and location'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and PlannedTransitionsLongTermCareAOD = ''Y'' and isnull(PlannedTransitionsLongTermCareAODComment,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''PlannedTransitionsLongTermCareAODTransitionCompleted'',''Select long term care or AOD rehabilitation transition plan completed'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and PlannedTransitionsLongTermCareAOD = ''Y'' and isnull(PlannedTransitionsLongTermCareAODTransitionCompleted,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''CCMIdentificationEligibility'',''Atleast one value must be selected in Comprehensive Care Management'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and isnull(CCMIdentificationEligibility,'''')='''' and isnull(CCMProvideServiceOrientation,'''')='''' and isnull(CCMComprehensiveHealthAssessment,'''')='''' and isnull(CCMDevelopUpdateCarePlan,'''')='''' and isnull(CCMDevelopUpdateCommPlan,'''')='''' and isnull(CCMDevelopUpdateCrisisPlan,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''CCImplementationCarePlan'',''Atleast one value must be selected in Care Coordination'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and isnull(CCImplementationCarePlan,'''')='''' and isnull(CCAssistanceObtainingHealthcare,'''')='''' and isnull(CCMedicationManagement,'''')='''' and isnull(CCTrackTests,'''')='''' and isnull(CCCoordinationProviders,'''')='''' and isnull(CCDevelopmentCrisisPlan,'''')='''' and isnull(CCCoordinationReferrals,'''')='''' and isnull(CC90DayAssessment,'''')='''' and isnull(CCPeriodicClinicalSummary,'''')='''' and isnull(recordDeleted,''N'')=''N''     
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''HPProvisionHealthEducation'',''Atleast one value must be selected in Health Promotion'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and isnull(HPProvisionHealthEducation,'''')='''' and isnull(HPAssistedSelfMonitoring,'''')='''' and isnull(HPProvisionWellnessServices,'''')='''' and isnull(HPEngagePlanMonitoring,'''')='''' and isnull(HPReferralToSelfHelp,'''')='''' and isnull(HPDevelopmentCrisisPlan,'''')='''' and isnull(HPAppointmentServiceReminders,'''')='''' and isnull(HPPromotionHealthLifestyle,'''')='''' and isnull(recordDeleted,''N'')=''N''     
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''CTCCoordinationProviders'',''Atleast one value must be selected in Comprehensive Transitional Care'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and isnull(CTCCoordinationProviders,'''')='''' and isnull(CTCFacilitateDischarge,'''')='''' and isnull(CTCDevelopComprehensiveDischargePlan,'''')='''' and isnull(recordDeleted,''N'')=''N''     
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''IFSSupportRelationships'',''Atleast one value must be selected in Individual and Family Supports'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and isnull(IFSSupportRelationships,'''')='''' and isnull(IFSAdvocacyBenefits,'''')='''' and isnull(IFSProvidedEducation,'''')='''' and isnull(IFSAssistedObtainingMedications,'''')='''' and isnull(IFSAssistanceOvercomeBarriers,'''')='''' and isnull(IFSFacilitatedFamilyInvolvement,'''')='''' and isnull(IFSReferralsCommunitySupports,'''')='''' and isnull(IFSPromotionPersonalIndependence,'''')='''' and isnull(IFSObtainedFeedback,'''')=''''  and isnull(IFSReviewedRecordWithPatient,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''RCSSReferralSelfHelp'',''Atleast one value must be selected in Referral to Community and Social Support Services'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and isnull(RCSSReferralSelfHelp,'''')='''' and isnull(RCSSReferralsCommunitySupports,'''')='''' and isnull(RCSSCoordinationReferrals,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''TobaccoCurrentEveryDay'',''Atleast one value must be selected in Tobacco Use Assessment'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and isnull(TobaccoCurrentEveryDay,'''')='''' and isnull(TobaccoCurrentSomeDay,'''')='''' and isnull(TobaccoUsesSmokeless,'''')='''' and isnull(TobaccoCurrentStatusUnknown,'''')='''' and isnull(TobaccoFormerSmoker,'''')='''' and isnull(TobaccoNeverSmoker,'''')='''' and isnull(TobaccoUnknownEverSmoked,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''PatientReportedInitationOfAODTreatment'',''Atleast one value must be selected in Patient Notification'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and isnull(PatientReportedInitationOfAODTreatment,'''')='''' and isnull(PatientReportedAnnualDentalVisit,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''PlanInstructions'',''Enter Plan/Instructions'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and isnull(PlanInstructions,'''')='''' and isnull(recordDeleted,''N'')=''N''
Union
Select ''CustomDocumentHealthHomeServiceNotes'',''RecommendChangesCarePlan'',''Select recommended changes to the Care Plan'',1
       From CustomDocumentHealthHomeServiceNotes
       Where DocumentVersionId = @DocumentVersionId and isnull(RecommendChangesCarePlan,'''')='''' and isnull(recordDeleted,''N'')=''N''

--Check to make sure record exists in custom table for @DocumentCodeId

If not exists (Select 1 from CustomDocumentHealthHomeServiceNotes Where DocumentVersionId = @DocumentVersionId)
begin 

Insert into CustomBugTracking
(DocumentVersionId, Description, CreatedDate)
Values
(@DocumentVersionId, ''No record exists in custom table.'', GETDATE())

Insert into #validationReturnTable
(TableName,
ColumnName,
ErrorMessage
)

Select ''CustomDocumentHealthHomeServiceNotes'', ''DeletedBy'', ''Error occurred. Please contact your system administrator. No record exists in custom table.''
Where not exists  (Select 1 from CustomDocumentHealthHomeServiceNotes Where DocumentVersionId = @DocumentVersionId)
end
select * from #validationReturnTable
if @@error <> 0 goto error

return

error:
raiserror 50000 ''csp_validateCustomMedicaidHealthHomeServicesNote failed.  Contact your system administrator.''
' 
END
GO
