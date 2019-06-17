/****** Object:  StoredProcedure [dbo].[ssp_SCParseCCDCCR]    Script Date: 05/19/2016 14:54:01 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCParseCCDCCR]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_SCParseCCDCCR]
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCParseCCDCCR]    Script Date: 05/19/2016 14:54:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_SCParseCCDCCR] @ClientCCDID AS INT
	,@ParseType AS VARCHAR(50)
AS /*********************************************************************/
/* Stored Procedure: dbo.ssp_SCParseCCDCCR            */
/* Creation Date:    28/Jan/2015                  */
/* Purpose:  To parse  XML data based on @ClientCCDID and @ParseType('Diagnosis', 'Allergies')            */
/*    Exec ssp_SCParseCCDCCR                                              */
/* Input Parameters:                           */
/* Date   Author   Purpose              */
/* 28/Jan/2015  Gautam   Created           Certification 2014   
   18/Feb/2016  Gautam   Added join with table HL7DocumentInboundMessageMappingsDeatils ,
						Woods - CustomizationsPharmacy Interfacing - 1.4.8.3 (Elywn Pharmacy)  , #842             */
/* 28/Sep/2017	Gautam/Alok		Created and calling diff SP for Diagnosis(i.e. ssp_SCParseCCDCCRForDiagnosisReconciliation)
								for Allergies(i.e. ssp_SCParseCCDCCRForAllergiesReconciliation)
								Ref: task #26.2/#26.3 Meaningful Use - Stage 3	

********************************************************************/
BEGIN
	BEGIN TRY
		DECLARE @XMLData AS XML
		DECLARE @FileName AS VARCHAR(250)

		SELECT @XMLData = cast(xmlData AS XML)
			,@FileName = [FileName]
		FROM ClientCCDs
		WHERE ClientCCDId = @ClientCCDID

		IF @ParseType = 'Allergies'
		BEGIN
			EXEC ssp_SCParseCCDCCRForAllergiesReconciliation @XMLData
				,@FileName
		END
		ELSE IF @ParseType = 'Diagnosis'
		BEGIN
			EXEC ssp_SCParseCCDCCRForDiagnosisReconciliation @XMLData
				,@FileName
		END
		ELSE IF @ParseType = 'Medications'
		BEGIN
			IF NOT EXISTS (
					SELECT 1
					FROM ClientCCDs
					WHERE ClientCCDId = @ClientCCDID
						AND FileType = 8807
					)
			BEGIN
				EXEC ssp_SCParseCCDCCRForMedications @XMLData
					,@FileName
			END
			ELSE
			BEGIN
				SELECT HL7I.HL7CPQueueMessageID AS RowNumber
					,HL7I.RxNormCode
					,HL7I.MedicationName
					,HL7I.MedicationNameId
					,HL7I.Quantity
					,HL7I.Unit
					,HL7I.UnitId
					,HL7I.StrengthDescription
					,HL7I.StrengthId
					,HL7I.[Route]
					,HL7I.RouteId
					,MD.Schedule
					,MD.ScheduleId
					,convert(VARCHAR(10), MD.MedicationStartDate, 101) AS MedicationStartDate
					,convert(VARCHAR(10), MD.MedicationEndDate, 101) AS MedicationEndDate
					,MD.TextInstruction AS AdditionalInformation
					,GC.CodeName AS 'Status'
					,IsNull(MD.TextInstruction, '') + ' ' + IsNull(HL7I.Comment, '') AS Comment
				FROM [HL7DocumentInboundMessageMappings] HL7I
				INNER JOIN HL7DocumentInboundMessageMappingsDeatils MD ON MD.DocumentVersionId = HL7I.DocumentVersionId
				INNER JOIN ClientCCDs CCD ON CCD.DocumentVersionId = HL7I.DocumentVersionId
				INNER JOIN GlobalCodes GC ON HL7I.STATUS = GC.GlobalCodeId
				WHERE CCD.ClientCCDId = @ClientCCDID
					AND CCD.FileType = 8807
					AND ISNULL(CCD.RecordDeleted, 'N') = 'N'
					AND ISNULL(HL7I.RecordDeleted, 'N') = 'N'
					AND ISNULL(MD.RecordDeleted, 'N') = 'N'
			END
		END
	END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(max)

		SET @Error = convert(VARCHAR, error_number()) + '*****' + convert(VARCHAR(4000), error_message()) + '*****' + isnull(convert(VARCHAR, error_procedure()), 'ssp_SCParseCCDCCR') + '*****' + convert(VARCHAR, error_line()) + '*****' + convert(VARCHAR, error_severity()) + '*****' + convert(VARCHAR, error_state())

		RAISERROR (
				@Error
				,
				-- Message text.                                                                                           
				16
				,
				-- Severity.                                                                                           
				1
				-- State.                                                                                           
				);
	END CATCH
END
GO


