IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetOrders]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetOrders]
GO

CREATE PROCEDURE [dbo].[ssp_GetOrders]  @OrderId INT
AS
/*********************************************************************/
/* Stored Procedure: [ssp_GetOrders] 2             */
/* Creation Date:  17/June/2013                                     */
/* Purpose: To get MedicationNames For orders            */
/* Output Parameters:   */
/*Returns The Table for Order Details  */
/* Called By:                                                       */
/* Data Modifications:                                              */
/*   Updates:                                                       */
/*   Date    Author   Purpose                       */
/*  17/June/2013  Vithobha  Created                       */
/*  21/Feb/2014   PPotnuru  Modified Added adhocorder column in orders */
/*  16/Mar/2015   Varun  Added Sensitive, Prescribed and Permissioned columns in Orders
						Added NeedsSignature and NeedsSignatureText in OrderAcknowledgments*/
/*  13/04/2015	Vaibhav Addeding HazardousMedication field in Order table */
/*  07/12/2015	Chethan N	What : Added table 'OrderLabs' and columns 'LaboratoryId' and 'QuestionCode' to OrderQuestions 
							Why : Streamline Administration task #153*/
/*	03/28/2016	Pradeep A	What : Added DrawFromServiceCenter column for Lab Orders
							Why : Streamline Administration task #153*/	
/*  07/12/2016	Chethan N	What : Changed Inner Join to Left Join for table 'GlobalCodes' to get OrderTemplateFrequencies.
							Why : Allegan - Support task #529*/
/*  02/26/2018	Chethan N	What : Added ClinicalLocation column for Lab Orders
							Why : Engineering Improvement Initiatives- NBL(I)  task #585*/
/* 08/May/2018  Shankha		What: Modified the logic to display distinct Labs */
/*	02/Jul/2018	Chethan N	What : Added new column 'LocationId' to Orders table.
							Why : Engineering Improvement Initiatives- NBL(I) task #667		*/	
/*	17/Jul/2018	Chethan N	What : Added new column 'CannotModifyName' to Orders table.
							Why : Engineering Improvement Initiatives- NBL(I) task #694		*/							
/********************************************************************/
BEGIN
	BEGIN TRY
		--Select Orders
		SELECT o.OrderId
			,o.CreatedBy
			,o.CreatedDate
			,o.ModifiedBy
			,o.ModifiedDate
			,o.RecordDeleted
			,o.DeletedDate
			,o.DeletedBy
			,OrderName
			,OrderType
			,CanBeCompleted
			,CanBePended
			,HasRationale
			,HasComments
			,o.Active
			,o.MedicationNameId
			,o.ProcedureCodeId
			,MedicationName
			,os.OrderStrengthId AS DefaultStrengthId
			,ofreq.OrderFrequencyId AS DefaultFrequencyId
			,ShowOnWhiteBoard
			,NeedsDiagnosis
			,OrderLevelRequired
			,LegalStatusRequired
			,LabId
			,DualSignRequired
			,IsSelfAdministered
			,HDT.TemplateName AS labname
			,OSch.OrderScheduleId AS DefaultSchedule
			,ORS.OrderRouteId AS DefaultRoute
			,ORP.OrderPriorityId AS DefaultPriority
			,PC.ProcedureCodeName
			,o.AlternateOrderName1
			,o.AlternateOrderName2
			,o.AdhocOrder
			,o.IsBillable
			,o.AdministrationTimeWindow
			,o.IsStockMedication
			,o.ConsentIsRequired
			,o.AddOrderToMAR
			,o.Prescription
			,o.Permissioned
			,o.Sensitive
			,o.HazardousMedication
			,ORL.OrderLabId AS DefaultLab
			,o.DrawFromServiceCenter
			,o.EMNoteOrder
			,OD.OrderDiagnosisId AS DefaultDiagnosis
			,o.ClinicalLocation
			,o.LocationId
			,o.CannotModifyName
		FROM orders o
		LEFT JOIN mdmedicationnames M ON O.MedicationNameId = M.MedicationNameId
		LEFT JOIN orderstrengths os ON o.OrderId = os.OrderId
			AND os.IsDefault = 'Y'
			AND Isnull(os.RecordDeleted, 'N') = 'N'
		LEFT JOIN OrderFrequencies ofreq ON o.OrderId = ofreq.OrderId
			AND ofreq.IsDefault = 'Y'
			AND Isnull(ofreq.RecordDeleted, 'N') = 'N'
		LEFT JOIN HealthDataTemplates HDT ON O.LabId = HDT.HealthDataTemplateId
			AND Isnull(HDT.RecordDeleted, 'N') = 'N'
		LEFT JOIN OrderSchedules OSch ON O.OrderId = OSch.OrderId
			AND Isnull(OSch.RecordDeleted, 'N') = 'N'
			AND OSch.IsDefault = 'Y'
		LEFT JOIN OrderRoutes ORS ON O.OrderId = ORS.OrderId
			AND Isnull(ORS.RecordDeleted, 'N') = 'N'
			AND ORS.IsDefault = 'Y'
		LEFT JOIN OrderPriorities ORP ON O.OrderId = ORP.OrderId
			AND Isnull(ORP.RecordDeleted, 'N') = 'N'
			AND ORP.IsDefault = 'Y'
		LEFT JOIN OrderLabs ORL ON O.OrderId = ORL.OrderId
			AND Isnull(ORL.RecordDeleted, 'N') = 'N'
			AND ORL.IsDefault = 'Y'
		LEFT JOIN OrderDiagnosis OD ON O.OrderId = OD.OrderId
			AND Isnull(OD.RecordDeleted, 'N') = 'N'
			AND OD.IsDefault = 'Y'
		LEFT JOIN ProcedureCodes PC ON isnull(o.ProcedureCodeId, 0) = PC.ProcedureCodeId
		WHERE o.OrderId = @OrderId
			AND Isnull(o.RecordDeleted, 'N') = 'N'

		--Select Frequencies
		SELECT OrderFrequencyId
			,o.CreatedBy
			,o.CreatedDate
			,o.ModifiedBy
			,o.ModifiedDate
			,o.RecordDeleted
			,o.DeletedDate
			,o.DeletedBy
			,o.OrderId
			,o.OrderTemplateFrequencyId
			,o.IsDefault
			,f.DispenseTime1
			,f.DispenseTime2
			,f.DispenseTime3
			,f.DispenseTime4
			,f.DispenseTime5
			,f.DispenseTime6
			,f.DispenseTime7
			,f.DispenseTime8
			,CASE 
				WHEN DispenseTime1 IS NOT NULL
					THEN CONVERT(VARCHAR(15), f.DispenseTime1, 100)
				ELSE ''
				END + CASE 
				WHEN DispenseTime2 IS NOT NULL
					THEN ', ' + CONVERT(VARCHAR(15), f.DispenseTime2, 100)
				ELSE ''
				END + CASE 
				WHEN DispenseTime3 IS NOT NULL
					THEN ', ' + CONVERT(VARCHAR(15), f.DispenseTime3, 100)
				ELSE ''
				END + CASE 
				WHEN DispenseTime4 IS NOT NULL
					THEN ', ' + CONVERT(VARCHAR(15), f.DispenseTime4, 100)
				ELSE ''
				END + CASE 
				WHEN DispenseTime5 IS NOT NULL
					THEN ', ' + CONVERT(VARCHAR(15), f.DispenseTime5, 100)
				ELSE ''
				END + CASE 
				WHEN DispenseTime6 IS NOT NULL
					THEN ', ' + CONVERT(VARCHAR(15), f.DispenseTime6, 100)
				ELSE ''
				END + CASE 
				WHEN DispenseTime7 IS NOT NULL
					THEN ', ' + CONVERT(VARCHAR(15), f.DispenseTime7, 100)
				ELSE ''
				END + CASE 
				WHEN DispenseTime8 IS NOT NULL
					THEN ', ' + CONVERT(VARCHAR(15), f.DispenseTime8, 100)
				ELSE ''
				END AS DispenseTimes
			,CASE 
				WHEN f.IsPRN = 'Y'
					THEN (GC.CodeName + ' - PRN')
				ELSE GC.CodeName 
				END AS FrequencyName
			,GC1.CodeName As RxFrequencyName
			,F.DisplayName	
		FROM OrderFrequencies O
			,OrderTemplateFrequencies F
		LEFT JOIN GlobalCodes GC ON F.FrequencyId = GC.GlobalCodeId
			AND Isnull(GC.RecordDeleted, 'N') = 'N'
		LEFT JOIN GlobalCodes GC1 ON F.RxFrequencyId = GC1.GlobalCodeId
			AND Isnull(GC1.RecordDeleted, 'N') = 'N'	
		WHERE O.OrderId = @OrderId
			AND f.OrderTemplateFrequencyId = o.OrderTemplateFrequencyId
			AND Isnull(O.RecordDeleted, 'N') = 'N'
			AND Isnull(F.RecordDeleted, 'N') = 'N'

		--Select Strengths
		SELECT O.OrderStrengthId
			,O.CreatedBy
			,O.CreatedDate
			,O.ModifiedBy
			,O.ModifiedDate
			,O.RecordDeleted
			,O.DeletedDate
			,O.DeletedBy
			,O.OrderId
			,ISNULL(MedictionOtherStrength, MD.StrengthDescription) AS 'DisplayName'
			,O.MedicationId
			,O.IsDefault
			,MedicationUnit
			,MedicationUnitText = (
				SELECT CodeName
				FROM GlobalCodes
				WHERE GlobalCodeId = O.MedicationUnit
				)
			,O.MedictionOtherStrength
			,REPLACE(O.PreferredNDC, '-', '') AS PreferredNDC
		FROM orderstrengths O
		LEFT JOIN MDMedications AS MD ON O.MedicationId = MD.MedicationId
			AND Isnull(MD.RecordDeleted, 'N') = 'N'
		WHERE O.OrderId = @OrderId
			AND Isnull(O.RecordDeleted, 'N') = 'N'

		--Select Acknowledgements
		SELECT o.OrderAcknowledgmentId
			,o.CreatedBy
			,o.CreatedDate
			,o.ModifiedBy
			,o.ModifiedDate
			,o.RecordDeleted
			,o.DeletedDate
			,o.DeletedBy
			,o.OrderId
			,o.RoleId
			,o.NeedsToAcknowledge
			,o.CanAcknowledge
			,o.CanPendingRelease
			,CASE 
				WHEN o.NeedsToAcknowledge = 'Y'
					THEN 'Yes'
				ELSE 'No'
				END AS needstoacknowledgetext
			,CASE 
				WHEN o.CanAcknowledge = 'Y'
					THEN 'Yes'
				ELSE 'No'
				END AS canacknowledgetext
			,CASE 
				WHEN o.CanPendingRelease = 'Y'
					THEN 'Yes'
				ELSE 'No'
				END AS canpendingreleasetext
			,gc.CodeName AS roleidtext
			,o.NeedsSignature
			,CASE 
				WHEN o.NeedsSignature = 'Y'
					THEN 'Yes'
				ELSE 'No'
				END AS NeedsSignatureText
		FROM globalcodes AS GC
		INNER JOIN OrderAcknowledgments O ON GC.GlobalCodeId = O.RoleId
		WHERE O.orderid = @OrderId
			AND Isnull(O.recorddeleted, 'N') = 'N'
			AND Isnull(GC.recorddeleted, 'N') = 'N'

		-- Select OrderQuestions
		SELECT QuestionId
			,CreatedBy
			,CreatedDate
			,ModifiedBy
			,ModifiedDate
			,RecordDeleted
			,DeletedDate
			,DeletedBy
			,Question
			,OrderId
			,AnswerType
			,AnswerRelatedCategory
			,IsRequired
			,ShowQuestionTimeOption
			,LaboratoryId
			,QuestionCode
		FROM OrderQuestions
		WHERE OrderId = @OrderId
			AND Isnull(recorddeleted, 'N') = 'N'

		-- Select OrderRoutes
		SELECT OrderRouteId
			,ORS.CreatedBy
			,ORS.CreatedDate
			,ORS.ModifiedBy
			,ORS.ModifiedDate
			,ORS.RecordDeleted
			,ORS.DeletedDate
			,ORS.DeletedBy
			,ORS.OrderId
			,ORS.RouteId
			,IsDefault
			,MDR.RouteAbbreviation AS RouteText
		FROM OrderRoutes AS ORS
		INNER JOIN MDRoutes AS MDR ON MDR.RouteId = ORS.RouteId
			AND (ISNULL(MDR.RecordDeleted, 'N') = 'N')
		WHERE (OrderId = @OrderId)
			AND (ISNULL(ORS.RecordDeleted, 'N') = 'N')

		-- Select OrderSchedules
		SELECT OS.OrderScheduleId
			,OS.CreatedBy
			,OS.CreatedDate
			,OS.ModifiedBy
			,OS.ModifiedDate
			,OS.RecordDeleted
			,OS.DeletedDate
			,OS.DeletedBy
			,OS.OrderId
			,OS.ScheduleId
			,OS.IsDefault
			,GC.CodeName AS ScheduleText
		FROM OrderSchedules AS OS
		INNER JOIN GlobalCodes AS GC ON GC.GlobalCodeId = OS.ScheduleId
			AND (ISNULL(GC.RecordDeleted, 'N') = 'N')
		WHERE (OrderId = @OrderId)
			AND (ISNULL(OS.RecordDeleted, 'N') = 'N')

		-- Select OrderPriorities
		SELECT OrderPriorityId
			,OP.CreatedBy
			,OP.CreatedDate
			,OP.ModifiedBy
			,OP.ModifiedDate
			,OP.RecordDeleted
			,OP.DeletedDate
			,OP.DeletedBy
			,OP.OrderId
			,OP.PriorityId
			,OP.IsDefault
			,GC.CodeName AS PriorityText
		FROM OrderPriorities AS OP
		INNER JOIN GlobalCodes AS GC ON GC.GlobalCodeId = OP.PriorityId
			AND (ISNULL(GC.RecordDeleted, 'N') = 'N')
		WHERE (OrderId = @OrderId)
			AND (ISNULL(OP.RecordDeleted, 'N') = 'N')
		
		-- Select OrderLabs
		SELECT DISTINCT OL.OrderLabId					
			,OL.CreatedBy					
			,OL.CreatedDate					
			,OL.ModifiedBy					
			,OL.ModifiedDate				
			,OL.RecordDeleted		
			,OL.DeletedBy					
			,OL.DeletedDate					
			,OL.OrderId						
			,OL.LaboratoryId				
			,OL.ExternalOrderId				
			,OL.IsDefault
			,L.LaboratoryName AS DisplayName
			,OL.CPT
			,OL.OrderCode
		FROM OrderLabs AS OL
		JOIN Laboratories AS L ON L.LaboratoryId = OL.LaboratoryId
			AND ISNULL(L.RecordDeleted, 'N') = 'N'
		WHERE OL.OrderId = @OrderId
			AND ISNULL(OL.RecordDeleted, 'N') = 'N'
			
			
			SELECT 
			 OD.OrderDiagnosisId
			,OD.CreatedBy
			,OD.CreatedDate
			,OD.ModifiedBy
			,OD.ModifiedDate
			,OD.RecordDeleted
			,OD.DeletedBy
			,OD.DeletedDate
			,OD.OrderId
			,OD.ICD10CodeId
			,OD.IsDefault
			,OD.ICDCode
			,OD.ICDDescription
		FROM OrderDiagnosis AS OD
		WHERE OD.OrderId = @OrderId
			AND ISNULL(OD.RecordDeleted, 'N') = 'N'
		
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_GetOrders') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

		RAISERROR (
				@Error
				,-- Message text.       
				16
				,-- Severity.       
				1 -- State.       
				);
	END CATCH

	RETURN
END
GO

