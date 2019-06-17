/****** Object:  UserDefinedFunction [dbo].[smsf_GetCurrentMedications]    Script Date: 09/30/2016 18:06:04 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[smsf_GetCurrentMedications]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[smsf_GetCurrentMedications]
GO

/****** Object:  UserDefinedFunction [dbo].[smsf_GetCurrentMedications]    Script Date: 09/30/2016 18:06:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[smsf_GetCurrentMedications] (@ClientId INT)
RETURNS VARCHAR(MAX)
AS
BEGIN
	DECLARE @JsonResult VARCHAR(MAX)

	SELECT @JsonResult = dbo.smsf_FlattenedJSON((
				SELECT ISNULL(M.MedicationName, '') AS MedicationName
					,ISNULL(dbo.csf_GetMedicationInstruction(cmi.ClientMedicationInstructionId), '') AS MedicationInstruction
				FROM MDMedicationNames M
				INNER JOIN ClientMedications CM ON CM.MedicationNameId = m.MedicationNameId
					AND CM.ClientId = @ClientId
					AND CM.Discontinued IS NULL
					AND ISNULL(CM.RecordDeleted, 'N') = 'N'
					AND ISNULL(M.RecordDeleted, 'N') = 'N'
					AND CAST(CM.MedicationStartDate AS DATE) < CAST(GETDATE() AS DATE)
					AND (ISNULL(CM.MedicationEndDate, DATEADD(dd, 1, GETDATE())) > GETDATE())
					AND ISNULL(CM.RecordDeleted, 'N') = 'N'
				LEFT OUTER JOIN dbo.ClientMedicationInstructions AS cmi ON cmi.ClientMedicationId = cm.ClientMedicationId
				WHERE ISNULL(cmi.RecordDeleted, 'N') = 'N'
					AND cmi.Active = 'Y'
				ORDER BY M.MedicationName
				FOR XML path
					,root
				))

	RETURN REPLACE(@JsonResult, '"', '''')
END
GO


