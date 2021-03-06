/****** Object:  StoredProcedure [dbo].[csp_RDLCustomMedicaidHealthHomeServicesNote]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicaidHealthHomeServicesNote]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomMedicaidHealthHomeServicesNote]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomMedicaidHealthHomeServicesNote]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE   [dbo].[csp_RDLCustomMedicaidHealthHomeServicesNote]         
(                               
@DocumentVersionId  int           
)                      
AS                      
                
Begin                
-- =============================================
-- Author:		Veena S Mani
-- Create date: 27/03/2013
-- Description:	To get data for Custom ServiceNote RDL.
-- =============================================


Declare @VersionDIAG as bigint
Declare @DocumentIDDIAG as bigint
Declare @MentalHealthDiagnoses varchar(max)
Declare @EffectiveDate Varchar(25)
declare @ClientId Int

	SET @ClientId = (
				SELECT ClientId
				FROM documents doc
				INNER JOIN DocumentVersions docv ON docv.DocumentId = doc.DocumentId
				WHERE DocumentVersionId = @DocumentVersionId
					AND ISNULL(docv.RecordDeleted, ''N'') <> ''Y''
				)

SELECT  top 1  @DocumentIDDIAG = a.DocumentId,@VersionDIAG = a.CurrentDocumentVersionId,@EffectiveDate = convert(varchar, a.EffectiveDate, 103) 
FROM         Documents AS a INNER JOIN
                      DocumentCodes AS Dc ON Dc.DocumentCodeId = a.DocumentCodeId INNER JOIN
                      DocumentDiagnosisCodes AS DDC ON a.CurrentDocumentVersionId = DDC.DocumentVersionId                                                     
where a.ClientId = @ClientId and a.EffectiveDate <= convert(datetime, convert(varchar, getDate(),101))                                                        
and a.Status = 22 and Dc.DiagnosisDocument=''Y'' and isNull(a.RecordDeleted,''N'')<>''Y'' and isNull(Dc.RecordDeleted,''N'')<>''Y''                                                                                       
order by a.EffectiveDate desc,a.ModifiedDate desc 


SET    @MentalHealthDiagnoses = '''';
set @MentalHealthDiagnoses=''Effective Date:''+ @EffectiveDate

+ CHAR(13) +''Type''+ char(9) + ''ICD 9''  + char(9) + ''ICD 10'' + char(9)+ ''DSM5'' + char(9) + ''Description'' + CHAR(13)        

--select @MentalHealthDiagnoses = @MentalHealthDiagnoses + ISNULL(cast(b.CodeName AS varchar),char(9)) + char(9)+ ISNULL(cast(a.ICD9Code as varchar),char(9)) +char(9) + ISNULL(cast(a.ICD10Code as varchar),char(9))+ char(9)+ case ISNULL(cast(ICD10.DSMVCode AS varchar),char(9)) when ''Y'' then ''Yes'' else ''No'' end + char(9) + ISNULL(cast(ICD10.ICDDescription as varchar),'''') + char(13)         
--from DocumentDiagnosisCodes a                              
-- INNER JOIN GlobalCodes b on a.DiagnosisType=b.GlobalCodeid  
-- INNER JOIN DiagnosisICD10Codes ICD10 ON ICD10.ICD10CodeId = a.DSMVCodeId          
--where DocumentDiagnosisCodeId in (select DocumentDiagnosisCodeId from dbo.DocumentDiagnosisCodes  where DocumentVersionId = @VersionDIAG and isNull(RecordDeleted,''N'')<>''Y'')                           
-- and isNull(a.RecordDeleted,''N'')<>''Y''  and billable =''Y'' order by DiagnosisOrder 
 
SELECT CDHHCP.DocumentVersionId,
       CDHHCP.CreatedBy,
       CDHHCP.CreatedDate,
       CDHHCP.ModifiedBy,
       CDHHCP.ModifiedDate,
       CDHHCP.RecordDeleted,
       CDHHCP.DeletedDate,
       CDHHCP.DeletedBy,
       CONVERT(VARCHAR(10), LastVisitDate, 101) AS LastVisitDate,
       @MentalHealthDiagnoses as CurrentMentalHealthDiagnoses,
       CurrentDDDiagnoses,
       IntegratedCarePlanGoalsAddressed,
       ReasonTodaysEncounter,
       ReasonTodaysEncounterDescription,
       LDLValue,
       CONVERT(VARCHAR(10), LDLDate, 101) AS LDLDate,
       LDLNA,
       ALCValue,
       CONVERT(VARCHAR(10), ALCDate, 101) AS ALCDate,
       ALCNA,
       HDVS,
       CONVERT(VARCHAR(10), HDVSDate, 101) AS HDVSDate,
       HDT,
       CONVERT(VARCHAR(10), HDTDate, 101) AS HDTDate,
       HDP,
       CONVERT(VARCHAR(10), HDPDate, 101) AS HDPDate,
       HDR,
       CONVERT(VARCHAR(10), HDRDate, 101) AS HDRDate,
       HDBPDiastolic,
       CONVERT(VARCHAR(10), HDBPDiastolicDate, 101) AS HDBPDiastolicDate,
       HDBPSystolic,
       CONVERT(VARCHAR(10), HDBPSystolicDate, 101) AS HDBPSystolicDate,
       HDHt,
       CONVERT(VARCHAR(10), HDHtDate, 101) AS HDHtDate,
       HDWt,
       CONVERT(VARCHAR(10), HDWtDate, 101) AS HDWtDate,
       HDWC,
       CONVERT(VARCHAR(10), HDWCDate, 101) AS HDWCDate,
       HDBMI,
       CONVERT(VARCHAR(10), HDBMIDate, 101) AS HDBMIDate,
       HDSaO2,
       CONVERT(VARCHAR(10), HDSaO2Date, 101) AS HDSaO2Date,
       MedAllergyListReviewed,
       MedAllergyListReviewedComment,
       ProblemListReviewed,
       ProblemListReviewedComment,
       RescueMentalHealthEncounter,
       CONVERT(VARCHAR(10), RescueMentalHealthEncounterDate, 101) AS RescueMentalHealthEncounterDate,
       CONVERT(VARCHAR(10), RescueMentalHealthFollowUpDate, 101) AS RescueMentalHealthFollowUpDate,
       RescueMentalHealthEducationProvided,
       RecentPsychHospitalDischarge,
       CONVERT(VARCHAR(10), RecentPsychHospitalDischargeDate, 101) AS RecentPsychHospitalDischargeDate,
       CONVERT(VARCHAR(10), RecentPsychHospitalFollowUpDate, 101) AS RecentPsychHospitalFollowUpDate,
       RecentPsychHospitalTransitionCompleted,
       RecentEmergencyDeptEncounter,
       CONVERT(VARCHAR(10), RecentEmergencyDeptEncounterDate, 101) AS RecentEmergencyDeptEncounterDate,
       CONVERT(VARCHAR(10), RecentEmergencyDeptFollowUpDate, 101) AS RecentEmergencyDeptFollowUpDate,
       RecentEmergencyDeptEducationProvided,
       RecentPhysicalHospitalDischarge,
       CONVERT(VARCHAR(10), RecentPhysicalHospitalDischargeDate, 101) AS RecentPhysicalHospitalDischargeDate,
       CONVERT(VARCHAR(10), RecentPhysicalHospitalFollowUpDate, 101) AS RecentPhysicalHospitalFollowUpDate,
       RecentPhysicalHospitalTransitionCompleted,
       PlannedTransitionsLongTermCareAOD,
       PlannedTransitionsLongTermCareAODComment,
       PlannedTransitionsLongTermCareAODTransitionCompleted,
       CCMIdentificationEligibility,
       CCMProvideServiceOrientation,
       CCMComprehensiveHealthAssessment,
       CCMDevelopUpdateCarePlan,
       CCMDevelopUpdateCommPlan,
       CCMDevelopUpdateCrisisPlan,
       CCImplementationCarePlan,
       CCAssistanceObtainingHealthcare,
       CCMedicationManagement,
       CCTrackTests,
       CCCoordinationProviders,
       CCDevelopmentCrisisPlan,
       CCCoordinationReferrals,
       CC90DayAssessment,
       CCPeriodicClinicalSummary,
       HPProvisionHealthEducation,
       HPAssistedSelfMonitoring,
       HPProvisionWellnessServices,
       HPEngagePlanMonitoring,
       HPReferralToSelfHelp,
       HPDevelopmentCrisisPlan,
       HPAppointmentServiceReminders,
       HPPromotionHealthLifestyle,
       CTCCoordinationProviders,
       CTCFacilitateDischarge,
       CTCDevelopComprehensiveDischargePlan,
       IFSSupportRelationships,
       IFSAdvocacyBenefits,
       IFSProvidedEducation,
       IFSAssistedObtainingMedications,
       IFSAssistanceOvercomeBarriers,
       IFSFacilitatedFamilyInvolvement,
       IFSReferralsCommunitySupports,
       IFSPromotionPersonalIndependence,
       IFSObtainedFeedback,
       IFSReviewedRecordWithPatient,
       RCSSReferralSelfHelp,
       RCSSReferralsCommunitySupports,
       RCSSCoordinationReferrals,
       TobaccoCurrentEveryDay,
       TobaccoCurrentSomeDay,
       TobaccoUsesSmokeless,
       TobaccoCurrentStatusUnknown,
       TobaccoFormerSmoker,
       TobaccoNeverSmoker,
       TobaccoUnknownEverSmoked,
       TobaccoReductionCessationCounselingProvided,
       PatientReportedInitationOfAODTreatment,
       PatientReportedAnnualDentalVisit,
       ServiceOrOtherTreatmentsProvided,
       PlanInstructions,
       RecommendChangesCarePlan,
       Clients.FirstName + '' '' + Clients.LastName AS ClientName,  
	   Clients.ClientId 
       FROM CustomDocumentHealthHomeServiceNotes AS CDHHCP 
		INNER JOIN  
			  DocumentVersions AS DV ON CDHHCP.DocumentVersionId = DV.DocumentVersionId  AND (CDHHCP.DocumentVersionId = @DocumentVersionId) 
		INNER JOIN  
			  Documents ON DV.DocumentId = Documents.DocumentId AND DV.DocumentVersionId = Documents.CurrentDocumentVersionId 
			  --AND   
			  --DV.DocumentVersionId = Documents.InProgressDocumentVersionId 
			  INNER JOIN  
			  Clients ON Documents.ClientId = Clients.ClientId  
       WHERE     (ISNULL(CDHHCP.RecordDeleted, ''N'') = ''N'') --AND (CDHHCP.DocumentVersionId = @DocumentVersionId)  
               
--Checking For Errors                            
If (@@error!=0)                                                        
 Begin                                                        
  RAISERROR  20006   ''[csp_RDLCustomMedicaidHealthHomeServicesNote] : An Error Occured''                                                         
  Return                                                        
 End                                                                 
End' 
END
GO
