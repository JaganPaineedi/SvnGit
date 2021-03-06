IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csf_GetMedicationInstruction]'))
DROP FUNCTION [dbo].[csf_GetMedicationInstruction]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[csf_GetMedicationInstruction]
	(
	  @ClientMedicationInstructionId INT
	)
RETURNS VARCHAR(1000)

AS 
	BEGIN
		DECLARE	@MedicationInstruction VARCHAR(MAX)
		SELECT DISTINCT
				@MedicationInstruction = COALESCE(@MedicationInstruction
												  + ', ', '')
				+ ( MD.StrengthDescription + ' '
					+ CONVERT(VARCHAR, CMI.Quantity) + ' '
					+ CONVERT(VARCHAR, GC.CodeName) + ' '
					+ CONVERT(VARCHAR, GC1.CodeName) )
		FROM	ClientMedicationInstructions CMI
				LEFT JOIN GlobalCodes GC ON ( GC.GlobalCodeID = CMI.Unit )
											AND ISNULL(gc.RecordDeleted, 'N') <> 'Y'
				LEFT JOIN GlobalCodes GC1 ON ( GC1.GlobalCodeId = CMI.Schedule )
											 AND ISNULL(gc1.RecordDeleted, 'N') <> 'Y'
				JOIN MDMedications MD ON ( MD.MedicationID = CMI.StrengthId )
				JOIN ClientMedicationScriptDrugs CMSD ON CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
														 AND ISNULL(CMSD.RecordDeleted,
															  'N') <> 'Y'
		WHERE	CMI.ClientMedicationInstructionId = @ClientMedicationInstructionId
				AND ISNULL(CMI.Active, 'Y') = 'Y' 

		RETURN @MedicationInstruction;
	END   

