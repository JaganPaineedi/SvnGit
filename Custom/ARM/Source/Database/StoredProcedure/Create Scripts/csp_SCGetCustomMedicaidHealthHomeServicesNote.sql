
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomMedicaidHealthHomeServicesNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomMedicaidHealthHomeServicesNote]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO                               

CREATE PROCEDURE  [dbo].[csp_SCGetCustomMedicaidHealthHomeServicesNote]
@DocumentVersionId INT
AS
                                                             
 /***********************************************************************************************************/                                                                
 /* Stored Procedure: [csp_SCGetCustomMedicaidHealthHomeServicesNote]									    */                                                     
 /*																											*/
 /*       Date              Author                  Purpose													*/                                                                
 /*       26/mar/2013		Bernardin				To Retrieve Data										*/
 /*		  o8.17.2o15		Kevin Salerno			Changed join on a.DSMVCodeId to							*/
 /*													use column ICD10CodeId instead due to 4.0 data change.	*/
 /*													See Ace ARM - Support #302								*/      
 /***********************************************************************************************************/   

BEGIN

BEGIN TRY
 Declare @VersionDIAG as bigint 
 Declare @ClientId int 
  Declare @EffectiveDate Varchar(25)
   Declare @DocumentIDDIAG as bigint 
 
  SET @ClientId = (
			SELECT ClientId
			FROM documents doc
			INNER JOIN DocumentVersions docv ON docv.DocumentId = doc.DocumentId
			WHERE DocumentVersionId = @DocumentVersionId
				AND ISNULL(docv.RecordDeleted, 'N') <> 'Y'
			)
 
 SELECT  top 1  @VersionDIAG = a.CurrentDocumentVersionId 
FROM    Documents AS a INNER JOIN
                      DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId INNER JOIN
                      DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = 

DDC.DocumentVersionId                                                     
where a.ClientId = @ClientId and a.EffectiveDate <= convert(datetime, convert(varchar, getDate

(),101))                                                        
and a.Status = 22 and Dc.DiagnosisDocument='Y' and isNull(a.RecordDeleted,'N')<>'Y' and isNull

(Dc.RecordDeleted,'N')<>'Y' 

order by a.EffectiveDate desc,a.ModifiedDate desc

SELECT  top 1  @DocumentIDDIAG = a.DocumentId,@VersionDIAG = a.CurrentDocumentVersionId,@EffectiveDate = convert(varchar, a.EffectiveDate, 103) 
FROM         Documents AS a INNER JOIN
                      DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId INNER JOIN
                      DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId                                                     
where a.ClientId = @ClientId and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                        
and a.Status = 22 and Dc.DiagnosisDocument='Y' and isNull(a.RecordDeleted,'N')<>'Y' and isNull(Dc.RecordDeleted,'N')<>'Y'                                                                                       
order by a.EffectiveDate desc,a.ModifiedDate desc 

declare @CurrentMentalHealthDiagnoses varchar(max)
  
set @CurrentMentalHealthDiagnoses ='Effective Date:'+ @EffectiveDate 
  
 SELECT     DocumentVersionId, CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy, LastVisitDate, @CurrentMentalHealthDiagnoses as CurrentMentalHealthDiagnoses, 
                      CurrentDDDiagnoses, IntegratedCarePlanGoalsAddressed, ReasonTodaysEncounter, ReasonTodaysEncounterDescription, LDLValue, LDLDate, LDLNA, ALCValue, 
                      ALCDate, ALCNA, HDVS, HDVSDate, HDT, HDTDate, HDP, HDPDate, HDR, HDRDate, HDBPDiastolic, HDBPDiastolicDate, HDBPSystolic, HDBPSystolicDate, HDHt, 
                      HDHtDate, HDWt, HDWtDate, HDWC, HDWCDate, HDBMI, HDBMIDate, HDSaO2, HDSaO2Date, MedAllergyListReviewed, MedAllergyListReviewedComment, 
                      ProblemListReviewed, ProblemListReviewedComment, RescueMentalHealthEncounter, RescueMentalHealthEncounterDate, RescueMentalHealthFollowUpDate, 
                      RescueMentalHealthEducationProvided, RecentPsychHospitalDischarge, RecentPsychHospitalDischargeDate, RecentPsychHospitalFollowUpDate, 
                      RecentPsychHospitalTransitionCompleted, RecentEmergencyDeptEncounter, RecentEmergencyDeptEncounterDate, RecentEmergencyDeptFollowUpDate, 
                      RecentEmergencyDeptEducationProvided, RecentPhysicalHospitalDischarge, RecentPhysicalHospitalDischargeDate, RecentPhysicalHospitalFollowUpDate, 
                      RecentPhysicalHospitalTransitionCompleted, PlannedTransitionsLongTermCareAOD, PlannedTransitionsLongTermCareAODComment, 
                      PlannedTransitionsLongTermCareAODTransitionCompleted, CCMIdentificationEligibility, CCMProvideServiceOrientation, CCMComprehensiveHealthAssessment, 
                      CCMDevelopUpdateCarePlan, CCMDevelopUpdateCommPlan, CCMDevelopUpdateCrisisPlan, CCImplementationCarePlan, CCAssistanceObtainingHealthcare, 
                      CCMedicationManagement, CCTrackTests, CCCoordinationProviders, CCDevelopmentCrisisPlan, CCCoordinationReferrals, CC90DayAssessment, 
                      CCPeriodicClinicalSummary, HPProvisionHealthEducation, HPAssistedSelfMonitoring, HPProvisionWellnessServices, HPEngagePlanMonitoring, 
                      HPReferralToSelfHelp, HPDevelopmentCrisisPlan, HPAppointmentServiceReminders, HPPromotionHealthLifestyle, CTCCoordinationProviders, 
                      CTCFacilitateDischarge, CTCDevelopComprehensiveDischargePlan, IFSSupportRelationships, IFSAdvocacyBenefits, IFSProvidedEducation, 
                      IFSAssistedObtainingMedications, IFSAssistanceOvercomeBarriers, IFSFacilitatedFamilyInvolvement, IFSReferralsCommunitySupports, 
                      IFSPromotionPersonalIndependence, IFSObtainedFeedback, IFSReviewedRecordWithPatient, RCSSReferralSelfHelp, RCSSReferralsCommunitySupports, 
                      RCSSCoordinationReferrals, TobaccoCurrentEveryDay, TobaccoCurrentSomeDay, TobaccoUsesSmokeless, TobaccoCurrentStatusUnknown, TobaccoFormerSmoker, 
                      TobaccoNeverSmoker, TobaccoUnknownEverSmoked, TobaccoReductionCessationCounselingProvided, PatientReportedInitationOfAODTreatment, 
                      PatientReportedAnnualDentalVisit, ServiceOrOtherTreatmentsProvided, PlanInstructions, RecommendChangesCarePlan
FROM         CustomDocumentHealthHomeServiceNotes
WHERE     (ISNULL(RecordDeleted, 'N') = 'N') AND ([DocumentVersionId] = @DocumentVersionId)
 
 SELECT  CustomDocumentHealthHomeCarePlanDiagnosisId,CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedBy, DeletedDate,DocumentVersionId,
        SequenceNumber, ReportedDiagnosis, DiagnosisSource, TreatmentProvider                     
        FROM              CustomDocumentHealthHomeCarePlanDiagnoses
WHERE     (ISNULL(RecordDeleted, 'N') = 'N') AND ([DocumentVersionId] = @DocumentVersionId)

		
		
 select 'CurrentDiagnoses' as TableName
 ,(CAST(ROW_NUMBER() over (order by ICD10.ICDDescription) as int) * -1) as CurrentDiagnosesId
 ,CodeName , a.ICD9Code,a.ICD10Code
 ,case ISNULL(ICD10.DSMVCode,'') when 'Y' then 'Yes' else 'No' end as DSMVCode
 
 ,ICD10.ICDDescription 
 ,a.CreatedBy,
		a.CreatedDate,
		a.ModifiedBy,
		a.ModifiedDate,
		a.RecordDeleted,
		a.DeletedBy,
		a.DeletedDate      
from DocumentDiagnosisCodes a                              
 INNER JOIN GlobalCodes b on a.DiagnosisType=b.GlobalCodeid  
 -- INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = a.DSMVCodeId
 -- Changed join due to a data structure change in 4.0. See Ace ARM - Support #302 - Kevin Salerno          
 INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = a.ICD10CodeId
where DocumentDiagnosisCodeId in (select DocumentDiagnosisCodeId from dbo.DocumentDiagnosisCodes 

 where DocumentVersionId = @VersionDIAG and isNull(RecordDeleted,'N')<>'Y')                      

     
 and isNull(a.RecordDeleted,'N')<>'Y'  and billable ='Y' order by DiagnosisOrder        

END TRY

BEGIN CATCH
 DECLARE @Error VARCHAR(8000)
		SET @Error= CONVERT(VARCHAR,ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000),ERROR_MESSAGE())
			+ '*****' + ISNULL(CONVERT(VARCHAR,ERROR_PROCEDURE()),'csp_SCGetCustomMedicaidHealthHomeServicesNote')
			+ '*****' + CONVERT(VARCHAR,ERROR_LINE()) + '*****' + CONVERT(VARCHAR,ERROR_SEVERITY())
			+ '*****' + CONVERT(VARCHAR,ERROR_STATE())
		RAISERROR
		(
			@Error, -- Message text.
			16,		-- Severity.
			1		-- State.
		);
END CATCH
END
