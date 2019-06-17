IF EXISTS (
		SELECT *
		FROM sysobjects
		WHERE type = 'P'
			AND name = 'ssp_InitDocumentDasts'
		)
BEGIN
	DROP PROCEDURE ssp_InitDocumentDasts
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_InitDocumentDasts] 
(                                                                                                                                              
  @ClientID int,                      
  @StaffID int,                    
  @CustomParameters xml                                                                                                                                           
)   
AS
/*   Date			Author						Description	 		       */
/*---------------------------------------------------------------------------------*/
/*   04-05-2018		Prabina Kumar Pradhan		Westbridge-Customizations-#4650*/
/***********************************************************************************/
BEGIN
	BEGIN TRY
		SELECT TOP 1 'DocumentDASTs' AS TableName
			,ISNULL(D.DocumentVersionId, - 1) AS 'DocumentVersionId'
			,'' AS CreatedBy
			,getdate() AS CreatedDate
			,'' AS ModifiedBy
			,getdate() AS ModifiedDate
			,D.RecordDeleted
			,D.DeletedDate
			,D.DeletedBy
			,D.MedicalReason
			,D.PrescriptionDrugs
			,D.OneDrugAtaTime
			,D.WeekWithoutDrugs
			,D.StopDrug
			,D.ContinuousDrugs
			,D.LimitDrugsSituations
			,D.FlashBack
			,D.DrugAbuse
			,D.InvolvementWithDrug
			,D.SuspectDrugs
			,D.ProblemCreatedSpouse
			,D.ShoughtHelp
			,D.LostFriends
			,D.NeglectedDrug
			,D.TroubleWork
			,D.LostJob
			,D.GottenIntoFights
			,D.ArrestedDrugs
			,D.ArrestedDrivingDrugs
			,D.ObtainDrug
			,D.PossessionIligalDrugs
			,D.HeavyDrugIntake
			,D.MedicalProblem
			,D.GoneAnyoneHelp
			,D.HospitalisedDrug
			,D.TreatmentProgram
			,D.TreatedAsOutpatient
			,D.Score
		FROM systemconfigurations s
		LEFT JOIN DocumentDASTs D ON D.DocumentVersionId = -1
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_InitDocumentDasts') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,16
				,- 1
				);
	END CATCH
END