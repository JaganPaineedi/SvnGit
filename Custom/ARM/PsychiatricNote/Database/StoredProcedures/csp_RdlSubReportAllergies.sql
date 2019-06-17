/****** Object:  StoredProcedure [dbo].[csp_RDLPIECurrentAllergylist]    Script Date: 07/01/2013 19:25:54 ******/
IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportAllergies]')
					AND type IN ( N'P', N'PC' ) ) 
	DROP PROCEDURE [dbo].csp_RdlSubReportAllergies
 --18,1,null
GO

/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportAllergies]    Script Date: 07/01/2013 19:25:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[csp_RdlSubReportAllergies]  
	(
	  @DocumentVersionId INT             
	)
AS 
	BEGIN                   
/**************************************************************    
Created By   : Veena S Mani   
Created Date : 11th-DEC-2013    
Description  : Used to Get Current Allergy list data for Medication tab in PIE RDL  
 
**************************************************************/    
                     
		BEGIN TRY  
		DECLARE @ClientId int
		SELECT @ClientId = d.ClientId    
		FROM Documents d    
        WHERE d.InProgressDocumentVersionId = @DocumentVersionId    
		DECLARE @Allergies VARCHAR(MAX)   
			DECLARE	@AllergyCount INT = NULL;
			DECLARE	@ClientAllergies AS TABLE
				(
				  AllergenConceptId INT
				, Comment type_Comment2
				)

			INSERT	@ClientAllergies
					SELECT	AllergenConceptId
						  , Comment
					FROM	ClientAllergies
					WHERE	ClientId = @ClientId
							AND ISNULL(RecordDeleted, 'N') = 'N'
							AND ISNULL(Active, 'Y') = 'Y'

			SELECT	@AllergyCount = @@ROWCOUNT

			IF ( ( SELECT	NoKnownAllergies
				   FROM		Clients
				   WHERE	ClientId = @ClientId
				 ) = 'Y' ) 
				BEGIN
					SELECT	'No Known Allergies' AS Allergies
						 
				END
			ELSE 
				BEGIN
					IF ( @AllergyCount = 0 ) 
						BEGIN
							SELECT	'None Reported' AS Allergies
								
						END
					ELSE 
						BEGIN                      
							SELECT @Allergies = COALESCE(@Allergies +',' + CHAR(13) + CHAR(10), '') + MDA.ConceptDescription
								 
							FROM	MDAllergenConcepts MDA
									INNER JOIN @ClientAllergies CA ON CA.AllergenConceptId = MDA.AllergenConceptId
															  AND ISNULL(MDA.RecordDeleted,
															  'N') = 'N'
							ORDER BY MDA.ConceptDescription  
						END
				END   
                       
                     select @Allergies As Allergies
		END TRY                                                                          
		BEGIN CATCH                              
			DECLARE	@Error VARCHAR(8000)                                                                           
			SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
				+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
				+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
						 'csp_SCGetCurrentAllergylist') + '*****'
				+ CONVERT(VARCHAR, ERROR_LINE()) + '*****'
				+ CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
				+ CONVERT(VARCHAR, ERROR_STATE())                                                      
			RAISERROR                                                                                                         
 (                                                                           
  @Error, -- Message text.                                                                                                        
  16, -- Severity.                                                                                                        
  1 -- State.                                                                                                        
 );                                                                                                      
		END CATCH                                                     
	END                                                           
  
  
  