/****** Object:  StoredProcedure [dbo].[ssp_GetMARDetails]    Script Date: 25/07/2013 11:48:52 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_UpdateAdministeredDateTime]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_UpdateAdministeredDateTime]
GO

/****** Object:  StoredProcedure [dbo].[ssp_UpdateAdministeredDateTime]    Script Date: 25/07/2013 11:48:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

/********************************************************************/
/* Stored Procedure: dbo.ssp_UpdateAdministeredDateTime				*/
/* Creation Date: 05/08/2013                                        */
/*                                                                  */
/* Purpose: Updates the Administered Date and Time                  */
/*  Date                  Author                 Purpose            */
/* 25th July 2013         Ppotnuru				 Created             */
/* 29th May 2015          Chethan N				 What: Updating Administered Dose 
												 Why : Philhaven Development task # 258         */
/* 26th Nov 2015          Chethan N				 What: Considering MedAdminRecord entries from Rx as Medications and Updating 'Given' status for medications from Rx.
												 Why : Key Point - Environment Issues Tracking task # 150         
   31st Mar 2017		  Chethan N				 What: 1. Updating 'NoOfDosageForm' based the Medication Strength. 
													2. Converted Custom 'XMarStatus' to Core 'MarStatus'.
												 Why:  Renaissance - Dev Items task #5.1				
	22/Jun/2018			Chethan N				What : Changed ClientMedication join to ClientMedicationInstructions table to get Dose.
												Why : Porter Starke-Customizations Task #11			
	02/Jan/2019			Chethan N				What : Replacing ',' with '' before multiplication as INT containing ',' is considered as varchar and multiplying with INT gives conversion error.
												Why : AHN-Support Go Live Task #478*/
/********************************************************************/
CREATE PROCEDURE [dbo].[ssp_UpdateAdministeredDateTime] @MedAdminRecordId INT
	,@AdministeredDate DATE
	,@AdministeredTime TIME
	,@AdministeredBy INT
	,@ModifiedBy VARCHAR(30)
	,@ModifiedDate DATETIME
	,@IsSelfAdministered BIT
AS
BEGIN
	BEGIN TRY
		DECLARE @Status VARCHAR(15)
		DECLARE @AdministeredDose VARCHAR(25)
		DECLARE @IsNonMedicationOrder BIT
		DECLARE @NoOfDosageForm VARCHAR(25)
		
		DECLARE @OrderFromRX BIT
		-- Chethan N chnages -- Key Point - Environment Issues Tracking task # 150
		SET @OrderFromRX = CASE 
				WHEN (
						SELECT MR.ClientMedicationId
						FROM MedAdminRecords MR
						JOIN ClientMedications CM ON CM.ClientMedicationId =  MR.ClientMedicationId
							AND ISNULL(CM.RecordDeleted, 'N') = 'N'
							AND ISNULL(CM.SmartCareOrderEntry, 'N') = 'N'
						WHERE MR.MedAdminRecordId = @MedAdminRecordId
							AND ISNULL(MR.RecordDeleted, 'N') = 'N'
						) IS NOT NULL
					THEN 1
				ELSE 0
				END
							

		SET @IsNonMedicationOrder = CASE -- Chethan N changes -- Key Point - Environment Issues Tracking task # 150
										WHEN @OrderFromRX = 1
											THEN 0
								ELSE CASE 
										WHEN 'Medication' = (
												SELECT CO.OrderType
												FROM MedAdminRecords MR
												INNER JOIN ClientOrders CO ON MR.ClientOrderId = CO.ClientOrderId
													AND ISNULL(CO.RecordDeleted, 'N') <> 'Y' 
												WHERE MR.MedAdminRecordId = @MedAdminRecordId
													AND ISNULL(MR.RecordDeleted, 'N') <> 'Y'
												)
											THEN 0
										ELSE 1
										END
								END
		SET @Status = CASE 
				WHEN @IsNonMedicationOrder = 1
					THEN (
							SELECT Globalcodeid
							FROM GlobalCodes
							WHERE CodeName = 'Completed'
								AND Category = 'MARStatus'
								AND ISNULL(RecordDeleted, 'N') <> 'Y'
							)
				ELSE CASE 
						WHEN @IsSelfAdministered = 0
							THEN (
									SELECT Globalcodeid
									FROM GlobalCodes
									WHERE CodeName = 'Given'
										AND Category = 'MARStatus'
										AND ISNULL(RecordDeleted, 'N') <> 'Y'
									)
						ELSE (
								SELECT Globalcodeid
								FROM GlobalCodes
								WHERE CodeName = 'Self-Administered'
									AND Category = 'MARStatus'
									AND ISNULL(RecordDeleted, 'N') <> 'Y'
								)
						END
				END
		SET @AdministeredDose = CASE @OrderFromRX 
									WHEN 1 
										THEN (
											SELECT CMI.Quantity
											FROM MedAdminRecords AS MA  
										   INNER JOIN ClientMedicationInstructions AS CMI ON CMI.ClientMedicationInstructionId = MA.ClientMedicationInstructionId  
											AND ISNULL(CMI.RecordDeleted, 'N') = 'N' AND ISNULL(CMI.Active,'Y') ='Y' 
											WHERE MA.MedAdminRecordId = @MedAdminRecordId 
											AND (ISNULL(MA.RecordDeleted, 'N') = 'N') 
												)
										ELSE (
											SELECT (
													CASE ISNUMERIC(MM.Strength) 
													WHEN 1 
													THEN (
															( CASE 
																WHEN IM.ClientOrderId IS NULL
																	THEN CAST(convert(VARCHAR(15), CO.MedicationDosage) AS FLOAT)
																ELSE IM.Dose
																END ) * REPLACE(MM.Strength, ',', '')
															) 
														ELSE 
															(CASE 
																WHEN IM.ClientOrderId IS NULL
																	THEN convert(VARCHAR(15), CO.MedicationDosage)
																ELSE IM.Dose
																END )
														END
													)
											FROM MedAdminRecords AS MA
											INNER JOIN ClientOrders AS CO ON MA.ClientOrderId = CO.ClientOrderId
												AND ISNULL(CO.RecordDeleted, 'N') = 'N'
												AND (ISNULL(MA.RecordDeleted, 'N') = 'N')
											LEFT JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId
												AND ISNULL(OS.RecordDeleted, 'N') = 'N' 
											LEFT JOIN MdMedications MM ON MM.medicationId = OS.medicationId  
												AND ISNULL(MM.RecordDeleted, 'N') = 'N' 
											LEFT JOIN InboundMedications AS IM ON IM.ClientOrderId = CO.ClientOrderId
												AND ISNULL(IM.RecordDeleted, 'N') = 'N'
											LEFT JOIN GlobalCodes AS GC3 ON GC3.GlobalCodeId = OS.MedicationUnit
												AND ISNULL(GC3.RecordDeleted, 'N') = 'N'
											WHERE MA.MedAdminRecordId = @MedAdminRecordId
												) END

		SET @NoOfDosageForm = CASE @OrderFromRX 
									WHEN 1 
										THEN @AdministeredDose
										ELSE (
											SELECT (
													CASE ISNUMERIC(MM.Strength) 
													WHEN 0 
													THEN (
															NULL
															) 
														ELSE 
															(CASE 
																WHEN IM.ClientOrderId IS NULL
																	THEN convert(VARCHAR(15), CO.MedicationDosage)
																ELSE IM.Dose
																END )
														END
													)
											FROM MedAdminRecords AS MA
											INNER JOIN ClientOrders AS CO ON MA.ClientOrderId = CO.ClientOrderId
												AND ISNULL(CO.RecordDeleted, 'N') = 'N'
												AND (ISNULL(MA.RecordDeleted, 'N') = 'N')
											LEFT JOIN OrderStrengths AS OS ON CO.MedicationOrderStrengthId = OS.OrderStrengthId
												AND ISNULL(OS.RecordDeleted, 'N') = 'N' 
											LEFT JOIN MdMedications MM ON MM.medicationId = OS.medicationId  
												AND ISNULL(MM.RecordDeleted, 'N') = 'N' 
											LEFT JOIN InboundMedications AS IM ON IM.ClientOrderId = CO.ClientOrderId
												AND ISNULL(IM.RecordDeleted, 'N') = 'N'
											LEFT JOIN GlobalCodes AS GC3 ON GC3.GlobalCodeId = OS.MedicationUnit
												AND ISNULL(GC3.RecordDeleted, 'N') = 'N'
											WHERE MA.MedAdminRecordId = @MedAdminRecordId
												) END


		UPDATE MedAdminRecords
		SET AdministeredDate = @AdministeredDate
			,AdministeredTime = @AdministeredTime
			,AdministeredBy = @AdministeredBy
			,ModifiedBy = @ModifiedBy
			,ModifiedDate = @ModifiedDate
			,AdministeredDose = @AdministeredDose
			,STATUS = @Status
			,NoOfDosageForm = @NoOfDosageForm
		WHERE MedAdminRecordId = @MedAdminRecordId
	END TRY

	BEGIN CATCH
		 DECLARE @Error VARCHAR(max) 
          SET @Error= CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' 
                      + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) 
                      + '*****' 
                      + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 
                      'ssp_SCUpdateMultiClientMARStatus' 
                      ) 
                      + '*****' + CONVERT(VARCHAR, ERROR_LINE()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) 
                      + '*****' + CONVERT(VARCHAR, ERROR_STATE()) 

          RAISERROR ( @Error, 
                      -- Message text.                                                                                 
                      16, 
                      -- Severity.                                                                                 
                      1 
          -- State.                                                                                 
          ); 
	END CATCH
END
GO

