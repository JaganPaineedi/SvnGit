/****** Object:  StoredProcedure [dbo].[ssp_CreateRxMappingClientOrder]    Script Date: 01/13/2016 18:14:11 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_CreateRxMappingClientOrder]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_CreateRxMappingClientOrder]
GO

/****** Object:  StoredProcedure [dbo].[ssp_CreateRxMappingClientOrder]    Script Date: 01/13/2016 18:14:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_CreateRxMappingClientOrder] @ClientMedicationId INT
	,@OrderTemplateFrequencyId INT
	,@ClientMedicationInstructionId INT = NULL
	,@RxClientOrderId INT OUTPUT
	/*********************************************************************/
	/* Function: dbo.ssp_CreateRxMappingClientOrder                                     */
	/* Creation Date:   12/12/2012	                                    */
	/*                                                                  */
	/* Purpose: To Create Rx Mapping Client Order for @ClientMedicationId.                       */
	/* Input Parameters:											    */
	/*	@ClientMedicationId int													*/
	/*                                                                  */
	/* Returns:															*/
	/*	varchar(500)  													*/
	/*                                                                  */
	/*                                                                  */
	/* Updates:                                                         */
	/*   Date			Author			Purpose                                   */
	/*  01/18/2016		Chethan N		Created												
		23/May/2017		Chethan N		What: Avoiding creation of Client Orders if the Medication has mapping orders.
										Why:  Renaissance - Dev Items task #5.1				
		11/04/2018		Chethan N	    What : Avoiding duplicate creation of mapping ClientOrders.
										Why : AHN Support GO live Task #195			
		05/Jun/2018		Chethan N	    What : Added parameter @OrderTemplateFrequencyId.
										Why : AHN Support GO live Task #271	
		09-25-2018		Chethan N		What : Added parameter @ClientMedicationInstructionId and Creating ClientOrders based on ClientMedicationInstructionId
										Why : CCC-Customizations task #74	
	    12-06-2018       Jyothi B       Why : Displaying StartDate and EndDate from ClientMedicationScritDrugs Table and added status columns as part of WestBridge - Support Go Live -#17	
		12-07-2018		Chethan N		What : Added ISNULL condition to Start and End date and changed Join to left join to ClientMedicationScriptDrugs   
										Why : WestBridge - Support Go Live Task #17*/
											
	/*********************************************************************/
AS
BEGIN
	BEGIN TRY
		DECLARE @OrderId INT

		SET @RxClientOrderId = NULL
		SET @OrderId = (
				SELECT TOP 1 R.IntegerCodeId
				FROM Recodes R
				JOIN RecodeCategories RC ON RC.CategoryName = 'RxOrder'
					AND RC.RecodeCategoryId = R.RecodeCategoryId
				WHERE ISNULL(R.RecordDeleted, 'N') = 'N'
				)
				
		SET @RxClientOrderId = (
				SELECT TOP 1 ClientOrderId 
				FROM ClientOrderMedicationReferences COMR  
				WHERE  COMR.ClientMedicationId = @ClientMedicationId
				ORDER BY COMR.CreatedDate DESC 
				) 
		
		IF @RxClientOrderId IS NULL AND @OrderId IS NOT NULL
			BEGIN
				IF NOT EXISTS (
						SELECT 1
						FROM MedAdminRecords
						WHERE ClientMedicationInstructionId = @ClientMedicationInstructionId
							AND ClientOrderId IS NOT NULL
							AND ISNULL(RecordDeleted, 'N') = 'N' 
						)
				BEGIN
					INSERT INTO ClientOrders (
						Active
						,ClientId
						,OrderId
						,OrderTemplateFrequencyId
						,OrderType
						,OrderedBy
						,OrderingPhysician
						,OrderFlag
						,OrderStartDateTime
						,OrderEndDateTime
						,OrderStatus
						,CreatedBy
						,ModifiedBy
						)
					SELECT 'Y'
						,CM.ClientId
						,@OrderId
						,@OrderTemplateFrequencyId
						,'Additional'
						,(SELECT ISNULL(S.StaffId, CM.PrescriberId) FROM Staff S WHERE S.UserCode = CM.CreatedBy) AS OrderedBy
						,CM.PrescriberId
						,'Y'
						--,CM.MedicationStartDate
						--,CM.MedicationEndDate
						,ISNULL(CMSD.StartDate, CM.MedicationStartDate)  AS MedicationStartDate
		                ,ISNULL(CMSD.EndDate, CM.MedicationEndDate) AS MedicationEndDate
		                ,6509 AS OrderStatus  --ACTIVE
						,CM.CreatedBy
						,CM.ModifiedBy
					FROM ClientMedicationInstructions CMI
					JOIN ClientMedications CM ON CM.ClientMedicationId = CMI.ClientMedicationId AND ISNULL(CM.RecordDeleted, 'N') = 'N'
					LEFT JOIN ClientMedicationScriptDrugs CMSD ON CMSD.ClientMedicationInstructionId=CMI.ClientMedicationInstructionId								   
					    AND ISNULL(CMSD.RecordDeleted, 'N') = 'N'
						AND isnull(CMI.Active, 'Y') = 'Y'						
					WHERE (CMI.ClientMedicationInstructionId = @ClientMedicationInstructionId
						AND ISNULL(CMI.RecordDeleted, 'N') = 'N')
					

					SET @RxClientOrderId = SCOPE_IDENTITY()
				END
				ELSE
					IF EXISTS (
							SELECT 1
							FROM MedAdminRecords
							WHERE ClientMedicationInstructionId = @ClientMedicationInstructionId
								AND ClientOrderId IS NOT NULL
								AND ISNULL(RecordDeleted, 'N') = 'N'
							)
					BEGIN
						SELECT TOP 1 @RxClientOrderId = ClientOrderId
						FROM MedAdminRecords
						WHERE ClientMedicationInstructionId = @ClientMedicationInstructionId
							AND ISNULL(RecordDeleted, 'N') = 'N'
						ORDER BY MedAdminRecordId DESC
					END
			END
			
		UPDATE MedAdminRecords
		SET ClientOrderId = @RxClientOrderId
		WHERE ClientMedicationInstructionId = @ClientMedicationInstructionId
			AND ISNULL(RecordDeleted, 'N') = 'N'
			AND ClientOrderId IS NULL
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = CONVERT(VARCHAR, Error_number()) + '*****' + CONVERT(VARCHAR(4000), Error_message()) + '*****' + Isnull(CONVERT(VARCHAR, Error_procedure()), 'ssp_CreateRxMappingClientOrder') + '*****' + CONVERT(VARCHAR, Error_line()) + '*****' + CONVERT(VARCHAR, Error_severity()) + '*****' + CONVERT(VARCHAR, Error_state())

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
