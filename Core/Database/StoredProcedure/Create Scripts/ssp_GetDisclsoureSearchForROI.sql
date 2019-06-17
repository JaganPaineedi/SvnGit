IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'[dbo].[ssp_GetDisclsoureSearchForROI]')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE [dbo].[ssp_GetDisclsoureSearchForROI]
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ssp_GetDisclsoureSearchForROI] @DisclosureNameSearch VARCHAR(MAX)
,@DiscloserType char(1)
,@ClientId INT=NULL 
AS
/*************************************************************************/                
/* Stored Procedure: dbo.ssp_GetDisclsoureSearchForROI              */                
/* Copyright: DisclosureTo Details					 */                
/* Creation Date:  25/03/2016											 */                
/*                                                                       */                
/* Purpose: retuns the details of NamAddress               */               
/*                                                                       */              
/* Input Parameters: @ClientId,@DisclosureNameSearch                                       */              
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
 
	
     DECLARE @DisclosureName VARCHAR(50)  
     SET @DisclosureName = '%' + @DisclosureNameSearch + '%' 
      
     IF @DiscloserType='O'
	    BEGIN       
		 SELECT DISTINCT DisclosedToDetailId   
						,DT.NAME  
		 FROM DisclosedToDetails  DT  
		 WHERE ISNULL(RecordDeleted, 'N') = 'N'  
		 AND (DT.FirstName LIKE @DisclosureName  
			   OR DT.LastName LIKE @DisclosureName  
			   OR DT.NAME LIKE @DisclosureName 		   
		 )  
       END
      ELSE IF @DiscloserType='C'
		BEGIN
			SELECT DISTINCT CC.ClientContactId AS DisclosedToDetailId    
			   ,(CC.LastName + ', ' + CC.FirstName ) AS NAME  
			  FROM ClientContacts AS CC  
			  WHERE CC.ClientId = @ClientId  
			   AND (  
				CC.FirstName LIKE @DisclosureName  
				OR CC.LastName LIKE @DisclosureName  
				OR CC.ListAs LIKE @DisclosureName  
				)  
			   AND ISNULL(CC.RecordDeleted, 'N') = 'N'  
               AND Active = 'Y' 		
		END
		
END
END TRY
 BEGIN CATCH                                 
        DECLARE @Error VARCHAR(8000)                                  
        SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****'
            + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****'
            + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()),
                     '[ssp_GetDisclsoureSearchForROI]') + '*****'
            + CONVERT(VARCHAR, ERROR_LINE()) + '*****'
            + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****'
            + CONVERT(VARCHAR, ERROR_STATE())                                  
                                                                        
                              
        RAISERROR(@Error,16,1);                                  
                                  
    END CATCH    
GO

