IF EXISTS (
		SELECT *
		FROM sysobjects
		WHERE type = 'P'
			AND name = 'ssp_GetDocumentDasts'
		)
BEGIN
	DROP PROCEDURE ssp_GetDocumentDasts
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetDocumentDasts] (@DocumentVersionId INT)
AS
/*****************************************************************************/
/*  Created By               Created Date		Description                       */
/*  Prabina Kumar Pradhan    04-05-2018			Westbridge-Customizations-#4650 */
/*****************************************************************************/
BEGIN
	BEGIN TRY
		SELECT DocumentVersionId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,MedicalReason
			,PrescriptionDrugs
			,OneDrugAtaTime
			,WeekWithoutDrugs
			,StopDrug
			,ContinuousDrugs
			,LimitDrugsSituations
			,FlashBack
			,DrugAbuse
			,InvolvementWithDrug
			,SuspectDrugs
			,ProblemCreatedSpouse
			,ShoughtHelp
			,LostFriends
			,NeglectedDrug
			,TroubleWork
			,LostJob
			,GottenIntoFights
			,ArrestedDrugs
			,ArrestedDrivingDrugs
			,ObtainDrug
			,PossessionIligalDrugs
			,HeavyDrugIntake
			,MedicalProblem
			,GoneAnyoneHelp
			,HospitalisedDrug
			,TreatmentProgram
			,TreatedAsOutpatient
			,Score  
		FROM DocumentDASTs
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted, 'N') <> 'Y'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_GetDocumentDasts') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END