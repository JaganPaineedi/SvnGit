IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportPsychitricNoteMDM]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[csp_RdlSubReportPsychitricNoteMDM]
GO

/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportPsychitricNoteMDM]    Script Date: 13/07/2015 09:06:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[csp_RdlSubReportPsychitricNoteMDM] @DocumentVersionId INT
AS
/*********************************************************************/
/* Stored Procedure: [csp_RdlSubReportPsychitricNoteMDM] 734787   */
/*       Date              Author                  Purpose                   */
/*      10-07-2015        Lakshmi Kanth            To Retrieve Data  for RDL   */
/*********************************************************************/
BEGIN
	BEGIN TRY
		 SELECT DocumentVersionId
		,CD.CreatedBy
		,CD.CreatedDate
		,CD.ModifiedBy
		,CD.ModifiedDate
		,CD.RecordDeleted
		,CD.DeletedBy
		,CD.DeletedDate
		,CD.MedicalRecords
		,DiagnosticTest
		,CollaborationOfCare
		,Labs
		,Other
		,LabsSelected
		,MedicalRecordsComments
		,OrderedMedications
		,MedicationsReviewed
		,RisksBenefits
		,NewlyEmergentSideEffects
		,LabOrder
		,EKG
		,RadiologyOrder
		,Consultations
		,OrdersComments
		,LabsLastOrder
		,PlanLastVisitMDM
		,[PlanComment]
		,NextPhysicianVisit
		,PatientConsent
		,MoreThanFifty
		,InformationAndEducation
		,NurseMonitorPillBox
		,g4.codename as NurseMonitorFrequency
		,NurseMonitorComment
		,DecisionMakingSchizophrenia
		, g.codename as DecisionMakingSchizophreniaStatus
		,DecisionMakingAnxiety
		,g1.codename as DecisionMakingAnxietyStatus
		,DecisionMakingWeightLoss
		,g2.codename as DecisionMakingWeightLossStatus
		,DecisionMakingInsomnia
		,g3.codename as DecisionMakingInsomniaStatus
		,RisksBenefitscomment
		,MedicationsDiscontinued
		,NurseMonitorFrequencyOther
		,MedicalRecordsRelevantResults
		,MedicalRecordsPreviousResults
		,MedicalRecordsLabsOrderedLastvisit
		,ReviewClinicalLabs
		,ReviewRadiologyTest
		,ReviewOtherTest
		,DiscussionOfTestResults
		,DecisionToObtainByOthers
		,ReviewSummarizedOldRecords
		,IndependentVisualization
		 ,CASE LevelOfRisk  
         WHEN 'M' THEN 'Minimal'   
         WHEN 'L' THEN 'Low'    
         WHEN 'O' THEN 'Moderate'  
         WHEN 'H' THEN 'High'  
         ELSE '' END AS LevelOfRisk 
         ,MedicationReconciliation 
  FROM CustomDocumentPsychiatricNoteMDMs CD   
  left join GlobalCodes G ON CD.DecisionMakingSchizophreniaStatus = G.GlobalCodeId 
    left join GlobalCodes G1 ON CD.DecisionMakingAnxietyStatus = G1.GlobalCodeId 
    left join GlobalCodes G2 ON CD.DecisionMakingWeightLossStatus = G2.GlobalCodeId 
    left join GlobalCodes G3 ON CD.DecisionMakingInsomniaStatus = G3.GlobalCodeId 
    left join GlobalCodes G4 ON CD.NurseMonitorFrequency = G4.GlobalCodeId 
  WHERE       
  CD.DocumentVersionId = @DocumentVersionId  
		
	
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_RdlSubReportMedicalNoteMDM') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,-- Message text.
				16
				,-- Severity.
				1 -- State.
				);
	END CATCH
END

GO

