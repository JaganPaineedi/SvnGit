IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCGetQuickOrders]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCGetQuickOrders]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCGetQuickOrders] @DocumentVersionId INT
-- ============================================================================================================================   
-- Author      : Akwinass.D 
-- Date        : 15/MAY/2018
-- Purpose     : To get data for "Quick Orders"
-- Updates:
-- Date			Author		Purpose 
-- 15/MAY/2018  Akwinass	Created.(Task #650 in Engineering Improvement Initiatives- NBL(I)) 
/* 03/JUL/2018	Chethan N	What : Added new column LocationId to ClientOrders table.
							Why : Engineering Improvement Initiatives- NBL(I)  task #667*/
-- ============================================================================================================================
AS
BEGIN
	BEGIN TRY
		SELECT [ClientOrderId]
			,[CreatedBy]
			,[CreatedDate]
			,[ModifiedBy]
			,[ModifiedDate]
			,[RecordDeleted]
			,[DeletedDate]
			,[DeletedBy]
			,[ClientId]
			,[OrderDateTime]
			,[OrderType]
			,[OrderedBy]
			,[Status]
			,[AssignedTo]
			,[OrderFlag]
			,[HealthDataCategoryId]
			,[LaboratoryId]
			,[RadiologyType]
			,[OrderDescription]
			,[Indication]
			,[Urgency]
			,[Frequency]
			,[Fasting]
			,[FastingHours]
			,[TotalVolumeRequired]
			,[DateAndTimeOfLastDose]
			,[HoursAfterLastDose]
			,[ICDCode1]
			,[ICDCode2]
			,[ICDCode3]
			,[Comment]
			,[HealthDataId]
			,[DocumentId]
			,[LabCategory]
			,[CommonLab]
			,[Height]
			,[Weight]
			,[LabBodySite]
			,[LabInfoNa]
			,[LabInfoK]
			,[LabInfoCl]
			,[RadiologyCategory]
			,[RadiologyLocation]
			,[RadiologyAdditionalInstruction]
			,[RadiologyComment]
			,[RadiologyBodyLocation]
			,[RadiologyNeurologist]
			,[RadiologyRadiologist]
			,[RadiologyWithContrast]
			,[RadiologyWithoutContrast]
			,[LabLocation]
			,[LabType]
			,[OrderId]
			,[PreviousClientOrderId]
			,[MedicationOrderStrengthId]
			,[MedicationOrderRouteId]
			,[OrderPriorityId]
			,[OrderScheduleId]
			,[OrderTemplateFrequencyId]
			,[MedicationUseOtherUsage]
			,[MedicationOtherDosage]
			,[RationaleText]
			,[CommentsText]
			,[Active]
			,[OrderPended]
			,[OrderDiscontinued]
			,[DiscontinuedDateTime]
			,[OrderStartOther]
			,[OrderStartDateTime]
			,[OrderMode]
			,[OrderStatus]
			,[DocumentVersionId]
			,[ReleasedOn]
			,[ReleasedBy]
			,[OrderPendAcknowledge]
			,[OrderPendRequiredRoleAcknowledge]
			,[OrderingPhysician]
			,[OrderEndDateTime]
			,[MedicationUnits]
			,[MedicationDosage]
			,[Legal]
			,[Level]
			,[MedicationDaySupply]
			,[MedicationRefill]
			,[ReviewedFlag]
			,[ReviewedBy]
			,[ReviewedDateTime]
			,[ReviewedComments]
			,[FlowSheetDateTime]
			,[DispenseBrand]
			,[IsReadBackAndVerified]
			,[MayUseOwnSupply]
			,[MaySelfAdminister]
			,[ConsentIsRequired]
			,[IsPRN]
			,[MaxDispense]
			,[RationaleOtherText]
			,[ReviewInterpretationType]
			,[DaysOfWeek]
			,[DrawFromServiceCenter]
			,[DiscontinuedReason]
			,[PotencyUnit]
			,[ParentClientOrderId]
			,[ClinicalLocation]
			,[LocationId]
		FROM ClientOrders
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(RecordDeleted, 'N') = 'N'

		SELECT COD.[DiagnosisIIICodeId]
			,COD.[CreatedBy]
			,COD.[CreatedDate]
			,COD.[ModifiedBy]
			,COD.[ModifiedDate]
			,COD.[RecordDeleted]
			,COD.[DeletedBy]
			,COD.[DeletedDate]
			,COD.[ClientOrderId]
			,COD.[ICDCode]
			,COD.[Description]
			,COD.[ICD10CodeId]
		FROM ClientOrdersDiagnosisIIICodes COD
		JOIN ClientOrders CO ON COD.ClientOrderId = CO.ClientOrderId
		WHERE CO.DocumentVersionId = @DocumentVersionId
			AND ISNULL(COD.RecordDeleted, 'N') = 'N'
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'

		SELECT COA.[ClientAnswerId]
			,COA.[CreatedBy]
			,COA.[CreatedDate]
			,COA.[ModifiedBy]
			,COA.[ModifiedDate]
			,COA.[RecordDeleted]
			,COA.[DeletedBy]
			,COA.[DeletedDate]
			,COA.[QuestionId]
			,COA.[ClientOrderId]
			,COA.[AnswerType]
			,COA.[AnswerText]
			,COA.[AnswerValue]
			,COA.[AnswerDateTime]
			,COA.[HealthDataAttributeId]
		FROM ClientOrderQnAnswers COA
		JOIN ClientOrders CO ON COA.ClientOrderId = CO.ClientOrderId
		WHERE CO.DocumentVersionId = @DocumentVersionId
			AND ISNULL(COA.RecordDeleted, 'N') = 'N'
			AND ISNULL(CO.RecordDeleted, 'N') = 'N'
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'ssp_SCGetQuickOrders') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

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