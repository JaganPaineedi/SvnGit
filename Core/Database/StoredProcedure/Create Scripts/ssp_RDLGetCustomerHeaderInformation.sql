IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLGetCustomerHeaderInformation]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_RDLGetCustomerHeaderInformation]
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_RDLGetCustomerHeaderInformation] 
AS
/*************************************************************************/                
/* Stored Procedure: dbo.ssp_RDLGetCustomerHeaderInformation              */                
/* Copyright: DisclosureTo Details					 */                                
/*                                                                       */                
/* Purpose: retuns the details of NamAddress               */               
/*                                                                       */                          
/*																		 */                
/* Output Parameters:													 */                
/*                                                                       */                
/* Return:                                                               */                
/*                                                                       */                
/* Called By:                                                            */                
/*                                                                       */                
/* Calls:                                                                */                
/*                                                                       */                
/* Data Modifications:                                                   */                
/*                                                                       */                
/* Updates:                                                              */                
/*  Date            Author				Purpose                          */  
/*************************************************************************/ 
BEGIN TRY
   BEGIN
					
		SELECT TOP 1 AbbreviatedAgencyName
					,AddressDisplay
					,MainPhone
		FROM Agency
		
     END
   
END TRY
 BEGIN CATCH                                 
        DECLARE @Error VARCHAR(8000)                                  
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
            + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                     '[ssp_RDLGetCustomerHeaderInformation]') + '*****'
            + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
            + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
            + CONVERT(VARCHAR, ERROR_STATE())                                  
                                                                        
                              
        RAISERROR(@Error,16,1);                                  
                                  
    END CATCH    
GO

