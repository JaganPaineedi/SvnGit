/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetGlobalCodes]    Script Date: 04/30/2015 18:27:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_SCWebGetGlobalCodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_SCWebGetGlobalCodes]
GO


/****** Object:  StoredProcedure [dbo].[ssp_SCWebGetGlobalCodes]    Script Date: 04/30/2015 18:27:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE  PROCEDURE  [dbo].[ssp_SCWebGetGlobalCodes]      
@Category NVARCHAR(100)      
As      
              
Begin              
/*********************************************************************/                
/* Stored Procedure: dbo.ssp_SCWebGetGlobalCodes      */       
      
/* Copyright: 2006 Streamline Healthcare Solutions     */                
      
/* Creation Date:  25th May 2011                                    */                
/*                                                                  */                
/* Purpose: Gets GlobalCodes based on Category      */               
/*                                                                  */              
/* Input Parameters: Category          */              
/*                                                                  */                 
/* Output Parameters:            */                
/*                                                                  */                
/* Return:               */                
/*                                                                  */                
/* Called By: GetGlobalCodes Method in AuhtorizationDetails Class Of DataService  in "SCWeb"    */                
      
/*                                                                   */                
/* Calls:                                                            */                
/*                                                                   */                
/* Data Modifications:                                               */                
/*                                                                   */                
/*   Updates:                                                        */                
      
/*       Date                  Author                  Purpose       */                
/*  25th May 2011   Maninder Singh     Created        */          
/*  4-May-2015		Ponnin			   Returing new column SortOrder. For task #96 of CEI - Environment Issues Tracking */     
/*********************************************************************/                 
    BEGIN TRY            
       
  SELECT GlobalCodes.GlobalCodeId, GlobalCodes.CodeName, GlobalCodes.SortOrder  from GlobalCodes       
  WHERE  GlobalCodes.Category=@Category and GlobalCodes.Active='Y' and ISNULL(GlobalCodes.RecordDeleted,'N')<>'Y'    
      
 END TRY        
 BEGIN CATCH                                                                    
                                             
 DECLARE @Error varchar(8000)                                                               
                                              
 SET @Error= Convert(varchar,ERROR_NUMBER()) + '*****' + Convert(varchar(4000),ERROR_MESSAGE())                                                                                      
 + '*****' + isnull(Convert(varchar,ERROR_PROCEDURE()),'[ssp_SCWebGetGlobalCodes]')                                                                                                       
 + '*****' + Convert(varchar,ERROR_LINE()) + '*****ERROR_SEVERITY=' + Convert(varchar,ERROR_SEVERITY())                                                             
 + '*****ERROR_STATE=' + Convert(varchar,ERROR_STATE())                                                                                                      
                                              
 RAISERROR ( @Error, /* Message text.*/16, /* Severity.*/ 1 /*State.*/ );                                                                                              
                                                                   
 END CATCH                           
        
      
End  
GO


