/****** Object:  UserDefinedFunction [dbo].[ssf_GetRxNormCodeByAllergenConceptId]    Script Date: 08/21/2017 14:35:33 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssf_GetRxNormCodeByAllergenConceptId]')
			AND type IN (
				N'FN'
				,N'IF'
				,N'TF'
				,N'FS'
				,N'FT'
				)
		)
	DROP FUNCTION [dbo].[ssf_GetRxNormCodeByAllergenConceptId]
GO

/****** Object:  UserDefinedFunction [dbo].[ssf_GetRxNormCodeByAllergenConceptId]    Script Date: 08/21/2017 14:35:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  <Revathi>    
-- Create date: <24/Jan/2014>    
-- Description: <To get all available dates for appointment search>  
-- 13-FEB-2014 Akwinass Included Drop Script    
-- =============================================  
CREATE FUNCTION [dbo].[ssf_GetRxNormCodeByAllergenConceptId] (@AllergenConceptId INT)
RETURNS VARCHAR(20)
AS
BEGIN
	DECLARE @ConceptIdtype INT
	DECLARE @RxNormCode VARCHAR(max)

	SELECT @ConceptIdType = ConceptIdType
	FROM MDAllergenConcepts
	WHERE AllergenConceptId = @AllergenConceptId

	IF @ConceptIdType = 1
	BEGIN
		SELECT TOP 1 @RxNormCode = l.RXNormCode
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
		SELECT TOP 1 @RxNormCode = l.RXNormCode
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
		SELECT TOP 1 @RxNormCode = l.RXNormCode
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

	RETURN ISNULL(@RxNormCode, '')
END
GO


