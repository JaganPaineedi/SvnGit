/****** Object:  StoredProcedure [dbo].[ssp_SCPostUpdateMedicationReconciliation]    Script Date: 06-10-2018 12:03:03 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCPostUpdateMedicationReconciliation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCPostUpdateMedicationReconciliation]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCPostUpdateMedicationReconciliation]    Script Date: 06-10-2018 12:03:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCPostUpdateMedicationReconciliation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
BEGIN
	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[ssp_SCPostUpdateMedicationReconciliation] AS'
END
GO

ALTER PROCEDURE [dbo].[ssp_SCPostUpdateMedicationReconciliation] (
	@ScreenKeyId INT
	,@StaffId INT
	,@CurrentUser VARCHAR(30)
	,@CustomParameters XML
	)
AS
/*********************************************************************/
/* Stored Procedure: ssp_SCPostUpdateMedicationReconciliation  215   */
/* Creation Date:  21/August/2017                                    */
/* Author : Arjun K R                                                */
/* Purpose: To Get Medication Reconciliation                         */
/* Input Parameters: @DocumentVersionId                              */
/* Output Parameters:                                                */
/* Return:                                                           */
/* Data Modifications:                                               */
/* Updates:                                                          */
/* Date              Author                  Purpose                 */
/* May/11/2018       Anto             Modified the Code by adding Documentversionid in Not EXISTS Condition and Merging the changes from Meaniful USE database for RECONCILIATION HISTORY.         
            Aspen Point Build Cycle Tasks #81 */
/* July/13/2018      Kavya           Added  logic to update the DiscontinuedReasonCode and Discontinueddate columns in clientmedications table for those medications which are discountinued through Medication Reconciliation document.    
                                      AspenPoint SGL#81.1         
   Oct/04/2018       Gautam          What: Added code to fetch records from MedicationReconciliationOtherExternalMedications  
                                      why: Comprehensive-Customizations, #6120.1                                      
/*********************************************************************/  */
BEGIN
	DECLARE @ClientID INT
	DECLARE @DocumentVersionId INT
		,@ClientCCDId INT
		,@CCDDocumentVersionId INT
		,@AuthorId INT
		,@EffectiveDateTime DATETIME

	SELECT TOP 1 @ClientID = D.ClientId
		,@DocumentVersionId = DV.DocumentVersionId
		,@ClientCCDId = DMR.ClientCCDId
		,@EffectiveDateTime = d.EffectiveDate
		,@AuthorId = d.AuthorId
	FROM Documents D
	JOIN DocumentVersions DV ON DV.DocumentId = D.DocumentId
	INNER JOIN DocumentMedicationReconciliations DMR ON DV.DocumentVersionId = DMR.DocumentVersionId
	WHERE ISNULL(D.RecordDeleted, 'N') = 'N'
		AND ISNULL(DV.RecordDeleted, 'N') = 'N'
		AND ISNULL(DMR.RecordDeleted, 'N') = 'N'
		AND D.DocumentId = @ScreenKeyId

	BEGIN TRY
		-- FOR RECONCILIATION HISTORY    
		BEGIN
			SELECT TOP 1 @CCDDocumentVersionId = C.DocumentVersionId
			FROM ClientCCDs C
			WHERE C.ClientCCDId = @ClientCCDId

			INSERT INTO ClientMedicationReconciliations (
				DocumentVersionId
				,ClientId
				,StaffId
				,ReconciliationReasonId
				,ReconciliationDate
				,ReconciliationTypeId
				)
			VALUES (
				@CCDDocumentVersionId
				,@ClientID
				,@AuthorId
				,8792
				,@EffectiveDateTime
				,8793
				)
		END

		DECLARE @LastScriptIdTable TABLE (
			ClientMedicationInstructionId INT
			,ClientMedicationScriptId INT
			)

		INSERT INTO @LastScriptIdTable (
			ClientMedicationInstructionId
			,ClientMedicationScriptId
			)
		SELECT ClientMedicationInstructionId
			,ClientMedicationScriptId
		FROM (
			SELECT cmsd.ClientMedicationInstructionId
				,cmsd.ClientMedicationScriptId
				,cms.OrderDate
				,ROW_NUMBER() OVER (
					PARTITION BY cmsd.ClientMedicationInstructionId ORDER BY cms.OrderDate DESC
						,cmsd.ClientMedicationScriptId DESC
					) AS rownum
			FROM ClientMedicationScriptDrugs cmsd
			INNER JOIN ClientMedicationScripts cms ON (cmsd.ClientMedicationScriptId = cms.ClientMedicationScriptId)
			WHERE ClientMedicationInstructionId IN (
					SELECT ClientMedicationInstructionId
					FROM clientmedications a
					INNER JOIN dbo.ClientMedicationInstructions b ON (a.ClientMedicationId = b.ClientMedicationId)
					WHERE a.ClientId = @ClientID
						AND ISNULL(a.RecordDeleted, 'N') = 'N'
						AND ISNULL(b.Active, 'Y') = 'Y'
						AND ISNULL(b.RecordDeleted, 'N') = 'N'
					)
				AND ISNULL(cmsd.RecordDeleted, 'N') = 'N'
				AND ISNULL(cms.RecordDeleted, 'N') = 'N'
				AND ISNULL(cms.Voided, 'N') = 'N'
			) AS a
		WHERE rownum = 1

		CREATE TABLE #UPDATEDiscontinuedClientMedications (
			ClientMedicationInstructionId INT
			,ClientMedicationId INT
			)

		INSERT INTO #UPDATEDiscontinuedClientMedications (
			ClientMedicationInstructionId
			,ClientMedicationId
			)
		SELECT DISTINCT CMI.ClientMedicationInstructionId
			,CMI.ClientMedicationId
		FROM ClientMedicationInstructions CMI
		INNER JOIN ClientMedications CM ON CMI.ClientMedicationId = CM.ClientMedicationId
		LEFT JOIN ClientMedicationScriptDrugs CMSD ON (CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId)
		LEFT JOIN @LastScriptIdTable LSId ON (
				cmi.ClientMedicationInstructionId = LSId.ClientMedicationInstructionId
				AND cmsd.ClientMedicationScriptId = LSId.ClientMedicationScriptId
				)
		LEFT JOIN dbo.ClientMedicationScripts AS cms ON cms.ClientMedicationScriptId = LSId.ClientMedicationScriptId
		WHERE ISNULL(CMSD.RecordDeleted, 'N') <> 'Y'
			AND ISNULL(cm.RecordDeleted, 'N') <> 'Y'
			AND cm.ClientId = @ClientID
			AND cm.discontinuedate IS NULL
			AND Isnull(Discontinued, 'N') <> 'Y'
			AND (isnull(cm.MedicationStartDate, Getdate()) <= GetDate())
			AND ISNULL(cmi.Active, 'Y') = 'Y'
			AND ISNULL(cmi.RecordDeleted, 'N') <> 'Y'
			AND (
				CMSD.ClientMedicationScriptId IS NULL
				OR CMSD.ClientMedicationScriptId = LSId.ClientMedicationScriptId
				)
			AND NOT EXISTS (
				SELECT 1
				FROM MedicationReconciliationCurrentMedications MRCM
				WHERE MRCM.ClientMedicationInstructionId = CMI.ClientMedicationInstructionId
					AND ISNULL(MRCM.RecordDeleted, 'N') <> 'Y'
					AND MRCM.Documentversionid = @DocumentVersionId
				)

		DECLARE @DisReasonCode INT

		SET @DisReasonCode = (
				SELECT globalcodeid
				FROM globalcodes
				WHERE category = 'MEDDISCONTINUEREASON'
					AND codename = 'Medication Reconciliation'
				)

		UPDATE CM
		SET CM.Discontinued = 'Y'
			,CM.ModifiedBy = @CurrentUser
			,Cm.ModifiedDate = GETDATE()
			,Cm.DiscontinuedReason = 'This medication is discountinued from SC Medication Reconciliation document'
			,cm.DiscontinuedReasonCode = @DisReasonCode --added by kavya    
			,cm.DiscontinueDate = GETDATE()
		FROM ClientMedications CM
		JOIN #UPDATEDiscontinuedClientMedications U ON U.ClientMedicationId = Cm.ClientMedicationId
		JOIN ClientMedicationInstructions CMI ON CMI.ClientMedicationId = CM.ClientMedicationId
		WHERE ISNULL(cm.RecordDeleted, 'N') <> 'Y'
			--AND U.ClientMedicationId NOT IN(Select T.ClientMedicationId FROM MedicationReconciliationCurrentMedications M    
			--             JOIN ClientMedicationInstructions T ON M.ClientMedicationInstructionId=T.ClientMedicationInstructionId    
			--             WHERE   ISNULL(M.RecordDeleted, 'N') <> 'Y')    
			AND Isnull(Discontinued, 'N') <> 'Y'

		UPDATE CM
		SET CM.Discontinued = 'Y'
			,CM.ModifiedBy = @CurrentUser
			,Cm.ModifiedDate = GETDATE()
			,Cm.DiscontinuedReason = 'This medication is discountinued from SC Medication Reconciliation document'
			,cm.DiscontinuedReasonCode = @DisReasonCode --added by kavya    
			,cm.DiscontinueDate = GETDATE()
		FROM ClientMedications CM
		JOIN ClientMedicationInstructions CMI ON CMI.ClientMedicationId = CM.ClientMedicationId
		JOIN MedicationReconciliationCurrentMedications mrCur ON mrCur.ClientMedicationInstructionId = cmi.ClientMedicationInstructionId
		WHERE mrCur.DocumentVersionId = @DocumentVersionId
			AND Isnull(mrCur.DiscontinuedMedication, 'N') = 'Y'
			AND ISNULL(cm.RecordDeleted, 'N') = 'N'
			AND Isnull(Discontinued, 'N') <> 'Y'

		------------------------------------------------------------------------------------------           
		DECLARE @MedicationReconciliationCCDMedicationId INT
			,@MedicationNameId INT
			,@UserDefinedMedicationId INT
			,@MedicationStartDate DATETIME
			,@MedicationEndDate DATETIME
			,@RouteId INT
			,@StrengthId INT
			,@StrengthDescription VARCHAR(max)
			,@Quantity DECIMAL(18, 2)
			,@UnitId INT
			,@ScheduleId INT
			,@MedicationName VARCHAR(250)
		DECLARE @ClientMedicationId INT
			,@ClientMedicationInstructionId INT
		DECLARE @UserDefinedMedicationNamePrimaryId INT

		DECLARE MedicationReconciliation_cursor CURSOR
		FOR
		SELECT MedicationReconciliationCCDMedicationId
			,MedicationNameId
			,UserDefinedMedicationId
			,MedicationStartDate
			,MedicationEndDate
			,RouteId
			,StrengthId
			,Quantity
			,UnitId
		FROM MedicationReconciliationCCDMedications
		WHERE DocumentVersionId = @DocumentVersionId
		
		UNION
		
		SELECT MedicationReconciliationExternalMedicationId
			,MedicationNameId
			,UserDefinedMedicationId
			,MedicationStartDate
			,MedicationEndDate
			,RouteId
			,StrengthId
			,Quantity
			,UnitId
		FROM MedicationReconciliationExternalMedications
		WHERE DocumentVersionId = @DocumentVersionId
			AND ISNULL(DiscontinuedMedication, 'N') <> 'Y'

		OPEN MedicationReconciliation_cursor

		FETCH NEXT
		FROM MedicationReconciliation_cursor
		INTO @MedicationReconciliationCCDMedicationId
			,@MedicationNameId
			,@UserDefinedMedicationId
			,@MedicationStartDate
			,@MedicationEndDate
			,@RouteId
			,@StrengthId
			,@Quantity
			,@UnitId

		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @MedicationNameId IS NOT NULL
			BEGIN
				IF NOT EXISTS (
						SELECT 1
						FROM ClientMedications cm
						WHERE cm.MedicationNameId = @MedicationNameId
							AND ISNULL(cm.RecordDeleted, 'N') = 'N'
							AND isnull(Discontinued, 'N') = 'N'
							AND CM.ClientId = @ClientID
						)
				BEGIN
					SELECT @UserDefinedMedicationNamePrimaryId = UserDefinedMedicationNameId
					FROM UserDefinedMedications
					WHERE UserDefinedMedicationId = @UserDefinedMedicationId
						AND ISNULL(RecordDeleted, 'N') <> 'Y'

					IF @UnitId IS NOT NULL
					BEGIN
						INSERT INTO ClientMedications (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientId
							,MedicationNameId
							,UserDefinedMedicationNameId
							,MedicationStartDate
							,MedicationEndDate
							,Ordered
							)
						SELECT @CurrentUser
							,getdate()
							,@CurrentUser
							,getdate()
							,@ClientId
							,@MedicationNameId
							,@UserDefinedMedicationNamePrimaryId
							,@MedicationStartDate
							,@MedicationEndDate
							,'N'

						SELECT @ClientMedicationId = SCOPE_IDENTITY()

						INSERT INTO ClientMedicationInstructions (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientMedicationId
							,StrengthId
							,Quantity
							,Unit
							,Schedule
							,UserDefinedMedicationId
							)
						SELECT @CurrentUser
							,getdate()
							,@CurrentUser
							,getdate()
							,@ClientMedicationId
							,@StrengthId
							,@Quantity
							,@UnitId
							,@ScheduleId
							,@UserDefinedMedicationId

						SELECT @ClientMedicationInstructionId = SCOPE_IDENTITY()

						INSERT INTO ClientMedicationScriptDrugs (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientMedicationInstructionId
							,StartDate
							,Days
							,EndDate
							,Pharmacy
							)
						SELECT @CurrentUser
							,getdate()
							,@CurrentUser
							,getdate()
							,@ClientMedicationInstructionId
							,@MedicationStartDate
							,CASE 
								WHEN (
										@MedicationEndDate IS NOT NULL
										AND @MedicationStartDate <> @MedicationEndDate
										)
									THEN datediff(d, @MedicationStartDate, @MedicationEndDate)
								ELSE 1
								END
							,@MedicationEndDate
							,0.00
					END
				END
			END
			ELSE
				IF @UserDefinedMedicationId IS NOT NULL
				BEGIN
					IF NOT EXISTS (
							SELECT 1
							FROM ClientMedications CM
							WHERE cm.UserDefinedMedicationNameId = @UserDefinedMedicationId
								AND ISNULL(cm.RecordDeleted, 'N') = 'N'
								AND isnull(CM.Discontinued, 'N') = 'N'
								AND CM.ClientId = @ClientId
							)
					BEGIN
						SELECT @UserDefinedMedicationNamePrimaryId = UserDefinedMedicationNameId
						FROM UserDefinedMedications
						WHERE UserDefinedMedicationId = @UserDefinedMedicationId
							AND ISNULL(RecordDeleted, 'N') = 'N'

						INSERT INTO ClientMedications (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientId
							,MedicationNameId
							,UserDefinedMedicationNameId
							,MedicationStartDate
							,MedicationEndDate
							,Ordered
							)
						SELECT @CurrentUser
							,getdate()
							,@CurrentUser
							,getdate()
							,@ClientId
							,@MedicationNameId
							,@UserDefinedMedicationNamePrimaryId
							,@MedicationStartDate
							,@MedicationEndDate
							,'N'

						SELECT @ClientMedicationId = SCOPE_IDENTITY()

						INSERT INTO ClientMedicationInstructions (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientMedicationId
							,StrengthId
							,Quantity
							,Unit
							,Schedule
							,UserDefinedMedicationId
							)
						SELECT @CurrentUser
							,getdate()
							,@CurrentUser
							,getdate()
							,@ClientMedicationId
							,@StrengthId
							,@Quantity
							,@UnitId
							,@ScheduleId
							,@UserDefinedMedicationId

						SELECT @ClientMedicationInstructionId = SCOPE_IDENTITY()

						INSERT INTO ClientMedicationScriptDrugs (
							CreatedBy
							,CreatedDate
							,ModifiedBy
							,ModifiedDate
							,ClientMedicationInstructionId
							,StartDate
							,Days
							,EndDate
							,Pharmacy
							)
						SELECT @CurrentUser
							,getdate()
							,@CurrentUser
							,getdate()
							,@ClientMedicationInstructionId
							,@MedicationStartDate
							,CASE 
								WHEN (
										@MedicationEndDate IS NOT NULL
										AND @MedicationStartDate <> @MedicationEndDate
										)
									THEN datediff(d, @MedicationStartDate, @MedicationEndDate)
								ELSE 1
								END
							,@MedicationEndDate
							,0.00
					END
				END

			FETCH NEXT
			FROM MedicationReconciliation_cursor
			INTO @MedicationReconciliationCCDMedicationId
				,@MedicationNameId
				,@UserDefinedMedicationId
				,@MedicationStartDate
				,@MedicationEndDate
				,@RouteId
				,@StrengthId
				,@Quantity
				,@UnitId
		END

		CLOSE MedicationReconciliation_cursor

		DEALLOCATE MedicationReconciliation_cursor
	END TRY

	BEGIN CATCH
		IF (@@error != 0)
		BEGIN
			RAISERROR (
					'ssp_SCPostUpdateMedicationReconciliation: An Error Occured'
					,16
					,1
					)

			RETURN
		END
	END CATCH
END
