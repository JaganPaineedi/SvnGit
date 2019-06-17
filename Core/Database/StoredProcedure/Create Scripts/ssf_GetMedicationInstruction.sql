IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssf_GetMedicationInstruction]')
			AND type IN (N'FN')
		)
	DROP FUNCTION [dbo].[ssf_GetMedicationInstruction]
GO

CREATE FUNCTION [dbo].[ssf_GetMedicationInstruction] (
@ClientMedicationInstructionId INT
)
RETURNS VARCHAR(1000)
	/*********************************************************************************/
	/* FUNCTION: ssf_GetMedicationInstruction										*/
	/* Copyright: Streamline Healthcare Solutions									*/
	/* Date				Author        Purpose										*/
	/* 02-sep-2014     Revathi       What:  Get MedicationInstructions 
									  Why: #36 MeaningfulUse						*/
	/*********************************************************************************/
AS
BEGIN

	DECLARE @MedicationInstruction VARCHAR(MAX)

	SELECT DISTINCT @MedicationInstruction = COALESCE(@MedicationInstruction + ', ', '') + (MD.StrengthDescription + ' ' + CONVERT(VARCHAR, CMI.Quantity) + ' ' + CONVERT(VARCHAR, GC.CodeName) + ' ' + CONVERT(VARCHAR, GC1.CodeName))
	FROM ClientMedicationInstructions CMI
	LEFT JOIN GlobalCodes GC ON (GC.GlobalCodeID = CMI.Unit)
		AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
	LEFT JOIN GlobalCodes GC1 ON (GC1.GlobalCodeId = CMI.Schedule)
		AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'
	INNER JOIN MDMedications MD ON (MD.MedicationID = CMI.StrengthId)
	INNER JOIN ClientMedicationScriptDrugs CMSD ON CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
		AND ISNULL(CMSD.RecordDeleted, 'N') <> 'Y'
	WHERE CMI.ClientMedicationInstructionId = @ClientMedicationInstructionId
		AND ISNULL(CMI.Active, 'Y') = 'Y'

	RETURN @MedicationInstruction
	
END