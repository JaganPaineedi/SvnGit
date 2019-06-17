/****** Object:  StoredProcedure [dbo].[ssp_UpdateReviewedComments]    Script Date: 09/08/2015 14:27:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_UpdateReviewedComments]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_UpdateReviewedComments]
GO

/****** Object:  StoredProcedure [dbo].[ssp_UpdateReviewedComments]    Script Date: 09/08/2015 14:27:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

 /*********************************************************************/                          
/* Stored Procedure: dbo.ssp_UpdateReviewedComments     */           
/*	exec ssp_UpdateReviewedComments 17, -1					*/               
/* Creation Date:  09/26/2018                                        */                          
/* Author: Chethan N                                                                  */                          
/* Purpose: To save ReviewedComments for the Client Orders from Lab Result Review screen
                  */                         
/*                                                                   */                        
/* Input Parameters:             */                        
/*                                                                   */                          
/* Output Parameters:             */                          
/*                                                                   */  
/*  Date			Author			Purpose							*/
/*	10-09-2018		Chethan N		Created - CCC-Customizations task #83	*/                  
/*********************************************************************/     
CREATE Procedure [dbo].[ssp_UpdateReviewedComments]
 @ClientId INT
,@ClientOrderId VARCHAR(MAX) 
,@EffectiveDate DATETIME = NULL
,@ReviewedComments VARCHAR(MAX)
,@UserCode type_CurrentUser
AS    
BEGIN    
BEGIN TRY 

	UPDATE ClientOrders
	SET ReviewedComments = @ReviewedComments,
		ModifiedBy = @UserCode,
		ModifiedDate = GETDATE()
	WHERE ClientOrderId = @ClientOrderId
		
	EXEC ssp_GETClientOrderObservations @ClientId=@ClientId, @EffectiveDate=@EffectiveDate

END TRY                  
 BEGIN CATCH                
  DECLARE @Error VARCHAR(8000) 

        SET @Error= CONVERT(VARCHAR, Error_number()) + '*****' 
                    + CONVERT(VARCHAR(4000), Error_message()) 
                    + '*****' 
                    + Isnull(CONVERT(VARCHAR, Error_procedure()), 
                    'ssp_UpdateReviewedComments') 
                    + '*****' + CONVERT(VARCHAR, Error_line()) 
                    + '*****' + CONVERT(VARCHAR, Error_severity()) 
                    + '*****' + CONVERT(VARCHAR, Error_state()) 

        RAISERROR ( @Error,-- Message text.             
                    16,-- Severity.             
                    1 -- State.             
        );                   
 END CATCH     
    
END    
GO


