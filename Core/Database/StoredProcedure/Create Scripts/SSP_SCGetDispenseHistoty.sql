
/****** Object:  StoredProcedure [dbo].[SSP_SCGetDispenseHistoty]   ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SSP_SCGetDispenseHistoty]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[SSP_SCGetDispenseHistoty]
GO



/****** Object:  StoredProcedure [dbo].[SSP_SCGetDispenseHistoty]    Script Date: 11/13/2013 17:13:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO    
                          
CREATE PROCEDURE [dbo].[SSP_SCGetDispenseHistoty] 
(                                     
  @ClientOrderID int                                                                                                                                         
)                                                                                                                                              
As                          
/*********************************************************************/                                                                                                                                
/* Stored Procedure: SSP_SCGetDispenseHistoty          */                                                                                                                                
/* Purpose:   To get Dispense History*/                                                                                                                                
        
/*  Date			Author             Purpose                                    */                     
/*  
																*/         
/**************************************************************/                                      
                                                                                           
                                                                                 
BEGIN                                                                         
       	BEGIN TRY  
			SELECT IBM.DispensedDateTime
				,IBM.EnteredBy
				,IBM.VerifiedBy
				,IBM.DrugNDCCode
				,IBM.DrugNDCDescription
				,IBM.ProviderPharmacyInstructions
			FROM InboundMedications IBM
			WHERE ClientOrderId = @ClientOrderID
			ORDER BY IBM.InboundMedicationId DESC
				
   END TRY

	BEGIN CATCH
		DECLARE @Error VARCHAR(8000)

		SET @Error = Convert(VARCHAR, ERROR_NUMBER()) + '*****' + Convert(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + isnull(Convert(VARCHAR, ERROR_PROCEDURE()), 'SSP_SCGetDispenseHistoty') + '*****' + Convert(VARCHAR, ERROR_LINE()) + '*****' + Convert(VARCHAR, ERROR_SEVERITY()) + '*****' + Convert(VARCHAR, ERROR_STATE())

		RAISERROR (
				@Error
				,/* Message text.*/ 16
				,/* Severity.*/ 1 /*State.*/
				);
	END CATCH
                                              
END        
  
  
  
  