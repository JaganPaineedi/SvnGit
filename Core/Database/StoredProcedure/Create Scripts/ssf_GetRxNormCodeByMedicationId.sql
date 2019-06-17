/****** Object:  UserDefinedFunction [dbo].[ssf_GetRxNormCodeByMedicationId]    Script Date: 08/21/2017 14:35:58 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssf_GetRxNormCodeByMedicationId]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[ssf_GetRxNormCodeByMedicationId]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_GetRxNormCodeByMedicationId]    Script Date: 08/21/2017 14:35:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[ssf_GetRxNormCodeByMedicationId] (@MedicationId INT)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @RxNormCode VARCHAR(max)

	SELECT TOP 1 @RxNormCode = dsc.MDExternalVocabularyIdentifier
	FROM MDMedications AS mdm
	JOIN MDExternalVocabularyMappings AS lnk ON lnk.FirstDatabankVocabularyIdentifier = cast(mdm.ExternalMedicationId AS VARCHAR(20))
		AND lnk.MDVocabularyLinkType = 3
	JOIN MDExternalVocabularyDescriptions AS dsc ON dsc.MDExternalVocabularyIdentifier = lnk.MDExternalVocabularyIdentifier
		AND dsc.MDExternalVocabularyType = lnk.MDExternalVocabularyType
	WHERE mdm.MedicationId = @MedicationId

	--and lnk.EVD_EXT_VOCAB_TYPE_ID in (501, 502)
	RETURN ISNULL(@RxNormCode, '')
END
GO


