IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_getImage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_getImage]
GO
/****** Object:  StoredProcedure [dbo].[ssp_getImage]    Script Date: 03/12/2012 15:46:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE  [dbo].[ssp_getImage]      
 
 @ClientId  INT               
/*********************************************************************/                                                      
/* Stored Procedure: dbo.ssp_getImage                */                                             
                                            
                                            
/* Creation Date:  05/12/2012                                  */                                                      
/*                                                                   */                                                      
/* Purpose: Get Images by Id           */                                                     
/*                                                                          */                                             
/* Input Parameters:      */                                                    
/*                                                                   */                                                       
/* Output Parameters:                                    */                                                      
/*                                                                   */                                                      
/* Return:   */                                                      
/*                                                                   */                                                      
/* Called By:         */                                          
/*                                                                   */                                                      
/* Calls:                                                            */                                                      
/*                                                                   */                                                      
/* Data Modifications:                                               */                                                      
/*                                                                   */                                                      
/* Updates:                                                          */                                                      
                                            
/* Author Vaibhav  khare */                    
/*          */     
/* Updates:                                                          */                    
/*   Date        Author           Purpose                                    */                    
/* 02/08/2018    Kaushal          Added CreatedDate in select query. Why: Created date was missing. task #123, Boundless - Support  */    
                                                               
/*********************************************************************/                                                       
AS                
                 
BEGIN
	BEGIN TRY                       
      Select ClientScanId,ScanImage,convert(varchar(10), CreatedDate, 101)  AS CreatedDate --02/08/2018    Kaushal  
     from ClientScans where ClientId =@ClientId   And ISNULL( RecordDeleted,'N' )!='Y'
    END TRY
     BEGIN CATCH

			DECLARE @ErrorMessage NVARCHAR(4000);
			DECLARE @ErrorSeverity INT;
			DECLARE @ErrorState INT;
			
			SELECT @ErrorMessage = ERROR_MESSAGE(), @ErrorSeverity = ERROR_SEVERITY(), @ErrorState = ERROR_STATE();
			-- Use RAISERROR inside the CATCH block to return 
			-- error information about the original error that 
			-- caused execution to jump to the CATCH block.
			RAISERROR (@ErrorMessage, -- Message text.
					   @ErrorSeverity, -- Severity.
					   @ErrorState -- State.
					   ); 
		END CATCH 
END
      
     
                          
