/****** Object:  StoredProcedure [dbo].[ssp_UpdateMDAllergenConcepts]    Script Date: 05/19/2016 14:54:01 ******/
IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_UpdateMDAllergenConcepts]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_UpdateMDAllergenConcepts]
GO

/****** Object:  StoredProcedure [dbo].[ssp_UpdateMDAllergenConcepts]    Script Date: 05/19/2016 14:54:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
      
          
 CREATE PROCEDURE [dbo].[ssp_UpdateMDAllergenConcepts] @AllergyConceptId AS Int                
 ,@AllergyDesc AS VARCHAR(Max)
 ,@LoggedInUser AS VARCHAR(30)               
AS /*********************************************************************/                
/* Stored Procedure: dbo.ssp_UpdateMDAllergenConcepts            */                
/* Creation Date:    11/Oct/2017                 */                
/* Purpose:  To Update Allergy from XML data                */                
/*    Exec ssp_UpdateMDAllergenConcepts                                              */                
/* Input Parameters:                           */                
/* Date    Author   Purpose              */              
/* 11/Oct/2017  Alok   Created  Ref: task #26.2 Meaningful Use - Stage 3   */               
/*********************************************************************/                
BEGIN                
 BEGIN TRY                
  
  IF Exists( Select 1 From MDAllergenConcepts Where AllergenConceptId=@AllergyConceptId And
				 ( ISNULL(RecordDeleted, 'N') = 'Y' OR ConceptDescription <> @AllergyDesc ) )
	BEGIN
		
		Update MDAllergenConcepts 
			Set	ConceptDescription = @AllergyDesc
				,RecordDeleted = NULL
				,DeletedDate = NULL
				,DeletedBy = NULL
				,ModifiedDate = GETDATE()
				,ModifiedBy = @LoggedInUser
			Where AllergenConceptId=@AllergyConceptId
	
	END
             
 END TRY                
                
 BEGIN CATCH                
  DECLARE @Error VARCHAR(max)                
                
  SET @Error = convert(VARCHAR, error_number()) + '*****' + convert(VARCHAR(4000), error_message()) + '*****'              
   + isnull(convert(VARCHAR, error_procedure()), 'ssp_UpdateMDAllergenConcepts') + '*****' +               
   convert(VARCHAR, error_line()) + '*****' + convert(VARCHAR, error_severity()) + '*****' + convert(VARCHAR, error_state())                
                
  RAISERROR (                
    @Error                
    ,                
    -- Message text.                                                      
    16                
    ,                
    -- Severity.                                                                                                           
    1                
    -- State.                                                                                                           
    );                
 END CATCH                
END 