/****** Object:  StoredProcedure [dbo].[csp_GetClientDemographicsClientAddress]    Script Date: 07/18/2014 15:24:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetClientDemographicsClientAddress]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetClientDemographicsClientAddress]
GO


/****** Object:  StoredProcedure [dbo].[csp_GetClientDemographicsClientAddress]    Script Date: 07/18/2014 15:24:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROC [dbo].[csp_GetClientDemographicsClientAddress]     
@ClientID int               
AS                                      
                                      
/*********************************************************************/                                        
/* Stored Procedure: dbo.csp_GetClientDemographicsClientAddress					 */                                        
/* Copyright: 2014 Streamline Healthcare Solutions,  LLC             */                                        
/* Purpose:  Return Client Address.  */                                       
/* Input Parameters: @ClientID                                       */                                      
/* Output Parameters:   None                                         */                                        
/*                                                                   */                                        
/* Called By:  Custom Demographics Document                             */                                        
/* Calls:                                                            */                                        
/* Data Modifications:                                               */                                        
/* Updates:                                                          */                                        
/*  Date            Author          Purpose                          */                                                       
/* 24/NOV/2014      Akwinass         Create                           */ 
/*********************************************************************/                                             
BEGIN                         
BEGIN TRY   
    
SELECT GC.CodeName AS AddressType
	,CA.[Address]
	,CA.City
	,CA.[State]
	,CA.Zip
FROM ClientAddresses CA
JOIN GlobalCodes GC ON CA.AddressType = GC.GlobalCodeId AND GC.GlobalCodeId = 90
WHERE ClientId = @ClientID
	AND ISNULL(CA.RecordDeleted, 'N') = 'N'


              
END TRY              
BEGIN CATCH                        
DECLARE @Error varchar(8000)                                          
   SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                           
   + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'csp_GetClientDemographicsClientAddress ')                  
   + '*****' + Convert(varchar,ERROR_LINE()) + '*****' + Convert(varchar,ERROR_SEVERITY())                                            
   + '*****' + Convert(varchar,ERROR_STATE())                                          
                                        
   RAISERROR                                           
   (                                          
    @Error, -- Message text.                                          
    16, -- Severity.                                          
    1 -- State.                                          
   );                           
End CATCH                                                                 
                    
End    


GO


