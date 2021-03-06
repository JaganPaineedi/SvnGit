/****** Object:  StoredProcedure [dbo].[ssp_RxNormLookupByAllergenConceptId2]    Script Date: 8/20/2017 1:31:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF object_id('ssp_RxNormLookupByAllergenConceptId2', 'P') IS NOT NULL
	DROP PROCEDURE ssp_RxNormLookupByAllergenConceptId2
GO

CREATE PROCEDURE [dbo].[ssp_RxNormLookupByAllergenConceptId2]
	-- MU Stage 3
	-- RXNorm Lookup for Medication based on AllergenConceptId
	@AllergenConceptId INT
AS
DECLARE @ConceptIdtype INT

SELECT @ConceptIdType = ConceptIdType
FROM MDAllergenConcepts
WHERE AllergenConceptId = @AllergenConceptId

IF @ConceptIdType = 1
BEGIN
	SELECT TOP 1 l.RXNormCode AS RXNormCode
		,l.MDExternalVocabularyDescription AS RXNormDescription
	FROM MDAllergenConcepts AS ac
	JOIN MDAllergenGroups AS ag ON ag.AllergenGroupId = ac.AllergenGroupId
	JOIN MDExternalConceptMappings AS l ON l.FirstDatabankVocabularyType = 110
		AND l.FirstDatabankVocabularyIdentifier = ag.ExternalAllergenGroupId
	WHERE ac.AllergenConceptId = @AllergenConceptId
	ORDER BY CASE 
			WHEN l.MappingInactiveDate IS NULL
				THEN 1000
			ELSE datediff(day, getdate(), l.MappingInactiveDate)
			END DESC
		,MappingAddDate DESC
END
ELSE IF @ConceptIdType = 2
BEGIN
	SELECT TOP 1 l.RXNormCode AS RXNormCode
		,l.MDExternalVocabularyDescription AS RXNormDescription
	FROM MDAllergenConcepts AS ac
	JOIN MDMedicationNames AS mn ON mn.MedicationNameId = ac.MedicationNameId
	JOIN MDExternalConceptMappings AS l ON l.FirstDatabankVocabularyType = 1
		AND l.FirstDatabankVocabularyIdentifier = mn.ExternalMedicationNameId
	WHERE ac.AllergenConceptId = @AllergenConceptId
	ORDER BY CASE 
			WHEN l.MappingInactiveDate IS NULL
				THEN 1000
			ELSE datediff(day, getdate(), l.MappingInactiveDate)
			END DESC
		,MappingAddDate DESC
END
ELSE IF @ConceptIdType = 6
BEGIN
	SELECT TOP 1 l.RXNormCode AS RXNormCode
		,l.MDExternalVocabularyDescription AS RXNormDescription
	FROM MDAllergenConcepts AS ac
	JOIN MDHierarchicalIngredientCodes AS hic ON hic.HierarchicalIngredientCodeId = ac.HierarchicalIngredientCodeId
	JOIN MDExternalConceptMappings AS l ON l.FirstDatabankVocabularyType = 104
		AND l.FirstDatabankVocabularyIdentifier = hic.ExternalHierarchicalIngredientCodeId
	WHERE ac.AllergenConceptId = @AllergenConceptId
	ORDER BY CASE 
			WHEN l.MappingInactiveDate IS NULL
				THEN 1000
			ELSE datediff(day, getdate(), l.MappingInactiveDate)
			END DESC
		,MappingAddDate DESC
END
GO


