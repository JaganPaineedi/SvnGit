/****** Object:  StoredProcedure [dbo].[csp_RDLPIECurrentAllergylist]    Script Date: 07/01/2013 19:25:54 ******/
IF EXISTS ( SELECT	*
			FROM	sys.objects
			WHERE	object_id = OBJECT_ID(N'[dbo].[ssp_SCGetAllergies]')
					AND type IN ( N'P', N'PC' ) ) 
	DROP PROCEDURE [dbo].ssp_SCGetAllergies
 --18,1,null
GO

/****** Object:  StoredProcedure [dbo].[ssp_SCGetAllergies]    Script Date: 07/01/2013 19:25:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ssp_SCGetAllergies]
	(
	  @ClientId INT, 
	  @EffectiveDate Datetime            
	)
AS 
	BEGIN                   
/*********************************************************************/
/* Stored Procedure Name:[ssp_SCGetAllergies] 23,'08/27/2018' */ 
/* Copyright: Streamline Healthcare Solutions							         */          
/* Creation Date:  18-July-2018											         */   
/* Created By   :  Pabitra Kumar 											     */          
/* Purpose: Used by PsychiatricNote										       	 */         
/* Input Parameters: @DocumentVersionId									     */        
/* Output Parameters:															 */
/* Return:																	     */          
/* Called By: 																	 */          
/* Calls:																		 */          
/* Data Modifications:															 */          
/* Updates:																		 */          
/* Date				Author        Purpose						                 */ 
/* 08/28/2018      Pabitra        Added Comments field in Allergies Section      */              
/*********************************************************************/   
                     
		BEGIN TRY  
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
						
	SELECT 
		 MDA.ConceptDescription  AS Allergy
		,Comment AS AllergyComment
	FROM MDAllergenConcepts MDA
	INNER JOIN @ClientAllergies CA ON CA.AllergenConceptId = MDA.AllergenConceptId
	AND ISNULL(MDA.RecordDeleted,'N') = 'N' ORDER BY MDA.ConceptDescription                    					
						END
				END   
                                        
		END TRY                                                                          
		BEGIN CATCH                              
			DECLARE	@Error VARCHAR(8000)                                                                           
			SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
				+ CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
				+ ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
						 'ssp_SCGetAllergies') + '*****'
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
  
  
  