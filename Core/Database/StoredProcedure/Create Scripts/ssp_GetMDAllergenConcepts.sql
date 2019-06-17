/****** Object:  StoredProcedure [dbo].[ssp_GetMDAllergenConcepts]    Script Date: 11/19/2013 10:50:26 AM ******/
IF EXISTS ( SELECT	1
			FROM	INFORMATION_SCHEMA.ROUTINES
			WHERE	SPECIFIC_SCHEMA = 'dbo'
					AND SPECIFIC_NAME = 'ssp_GetMDAllergenConcepts' ) 
	DROP PROCEDURE [dbo].[ssp_GetMDAllergenConcepts]
GO

/****** Object:  StoredProcedure [dbo].[ssp_GetMDAllergenConcepts]    Script Date: 11/19/2013 10:50:26 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetMDAllergenConcepts]
	(
	  @FilterCriteria VARCHAR(200)
	)
/*******************************************************************************  
**  Change History  
*******************************************************************************  
**  Date:        Author:		Description:  
**  07/16/2015   Chethan N		What : Added RecordDeleted check
								Why : Valley Client Acceptance Testing Issues task#310
*******************************************************************************/
AS 
	DECLARE	@SoundExOfSearchCriteria NVARCHAR(100)   
  
	SET @SoundExOfSearchCriteria = SOUNDEX(@FilterCriteria)   
  
	BEGIN   
		BEGIN TRY   
			SELECT --'MDAllergenConcepts'      AS TableName,    
					AllergenConceptId
				  , ConceptDescription
				  , CAST(CASE WHEN @FilterCriteria = ConceptDescription THEN 1
							  ELSE 0
						 END AS INT) AS Checked
			FROM	MDAllergenConcepts
			WHERE	(ConceptDescription LIKE '' + @FilterCriteria + '%'
					OR ConceptDescriptionSoundex LIKE ( @SoundExOfSearchCriteria
														+ '%' ))
					AND ISNULL(RecordDeleted, 'N') <> 'Y'
			ORDER BY ConceptDescription   
		END TRY   
  
		BEGIN CATCH   
			DECLARE	@Error VARCHAR(8000)   
  
			SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
				+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
				+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
						 'ssp_GetMDAllergenConcepts') + '*****'
				+ CONVERT(VARCHAR, ERROR_LINE()) + '*****'
				+ CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
				+ CONVERT(VARCHAR, ERROR_STATE())   
  
			RAISERROR ( @Error,   
                      -- Message text.                                                                                                                                                   
                      16,   
                      -- Severity.                                                                                                                                                                                                                             
           
                      1 -- State.                                                  
          );   
		END CATCH   
	END  
GO


