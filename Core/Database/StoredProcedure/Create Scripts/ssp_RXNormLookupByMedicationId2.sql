/****** Object:  StoredProcedure [dbo].[ssp_RXNormLookupByMedicationId2]    Script Date: 8/20/2017 1:32:27 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID('ssp_RXNormLookupByMedicationId2', 'P') IS NOT NULL
	DROP PROCEDURE ssp_RXNormLookupByMedicationId2
GO

CREATE PROCEDURE [dbo].[ssp_RXNormLookupByMedicationId2]
	-- MU Stage 3
	-- RXNorm Lookup for Medication based on MedicationId
	@MedicationId INT
AS
SELECT dsc.MDExternalVocabularyIdentifier AS RXNormCode
	,dsc.MDExternalVocabularyDescription AS RxNormCodeDescription
	,CASE lnk.MDExternalVocabularyType
		WHEN 501
			THEN 'Generically Named'
		WHEN 503
			THEN 'Generically Named'
		WHEN 502
			THEN 'Brand-Specific'
		WHEN 504
			THEN 'Brand-Specific'
		END AS RXCUIType
FROM MDMedications AS mdm
JOIN MDExternalVocabularyMappings AS lnk ON lnk.FirstDatabankVocabularyIdentifier = cast(mdm.ExternalMedicationId AS VARCHAR(20))
	AND lnk.MDVocabularyLinkType = 3
JOIN MDExternalVocabularyDescriptions AS dsc ON dsc.MDExternalVocabularyIdentifier = lnk.MDExternalVocabularyIdentifier
	AND dsc.MDExternalVocabularyType = lnk.MDExternalVocabularyType
WHERE mdm.MedicationId = @MedicationId
	--and lnk.EVD_EXT_VOCAB_TYPE_ID in (501, 502)
GO


