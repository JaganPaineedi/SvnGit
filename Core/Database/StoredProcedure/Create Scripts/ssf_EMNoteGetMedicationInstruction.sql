/****** Object:  UserDefinedFunction [dbo].[ssf_EMNoteGetMedicationInstruction]    Script Date: 16-10-2018 15:06:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_EMNoteGetMedicationInstruction]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[ssf_EMNoteGetMedicationInstruction]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_EMNoteGetMedicationInstruction]    Script Date: 16-10-2018 15:06:11 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssf_EMNoteGetMedicationInstruction]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
BEGIN
execute dbo.sp_executesql @statement = N'
CREATE FUNCTION [dbo].[ssf_EMNoteGetMedicationInstruction]
	(
	  @ClientMedicationInstructionId INT
	)
RETURNS VARCHAR(1000)

AS 
	BEGIN
		DECLARE	@MedicationInstruction VARCHAR(MAX)
		SELECT DISTINCT
				@MedicationInstruction = COALESCE(@MedicationInstruction
												  + '', '', '''')
				+ ( MD.StrengthDescription + '' ''
					+ CONVERT(VARCHAR, CMI.Quantity) + '' ''
					+ CONVERT(VARCHAR, GC.CodeName) + '' ''
					+ CONVERT(VARCHAR, GC1.CodeName) + '' '')
		FROM	ClientMedicationInstructions CMI
				LEFT JOIN GlobalCodes GC ON ( GC.GlobalCodeID = CMI.Unit )
											AND ISNULL(gc.RecordDeleted, ''N'') <> ''Y''
				LEFT JOIN GlobalCodes GC1 ON ( GC1.GlobalCodeId = CMI.Schedule )
											 AND ISNULL(gc1.RecordDeleted, ''N'') <> ''Y''
				JOIN MDMedications MD ON ( MD.MedicationID = CMI.StrengthId )
				JOIN ClientMedicationScriptDrugs CMSD ON CMI.ClientMedicationInstructionId = CMSD.ClientMedicationInstructionId
														 AND ISNULL(CMSD.RecordDeleted,
															  ''N'') <> ''Y''
		WHERE	CMI.ClientMedicationInstructionId = @ClientMedicationInstructionId
				AND ISNULL(CMI.Active, ''Y'') = ''Y'' 

		RETURN @MedicationInstruction;
	END   

' 
END
GO

