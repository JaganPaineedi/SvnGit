/****** Object:  StoredProcedure [dbo].[scsp_SCGetCustomASAMLevelOfCares]    Script Date: 01/21/2015 16:44:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[scsp_SCGetCustomASAMLevelOfCares]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[scsp_SCGetCustomASAMLevelOfCares]
GO


/****** Object:  StoredProcedure [dbo].[scsp_SCGetCustomASAMLevelOfCares]    Script Date: 01/21/2015 16:44:49 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
  
CREATE  PROCEDURE  [dbo].[scsp_SCGetCustomASAMLevelOfCares]                       
As                                 
Begin                                
/*********************************************************************/                                  
/* Stored Procedure: dbo.csp_SCGetCustomASAMLevelOfCares                */                         
                        
/* Copyright: 2005 SmartCare Always online             */                                  
                        
/* Creation Date:  23/02/2010                                    */                                  
/*                                                                   */                                  
/* Purpose: Get data from CustomASAMLevelOfCares          */                                 
/*                                                                   */                                
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
/*   Updates:                                                          */                                  
                        
/*       Date              Author- Jitender                  Purpose -                                   */                                  
    --21 Jan 2015        Vithobha				Added select statement for CustomASAMLevelOfCares
/********************************************************************* */                                   
                              
 SELECT ASAMLevelOfCareId, LevelOfCareName, Dimension1Description, Dimension2Description, Dimension3Description, Dimension4Description,               
        Dimension5Description, Dimension6Description  FROM  CustomASAMLevelOfCares where ISNULL(RecordDeleted,'N')='N'      
                      
                      
    --Checking For Errors                        
    If (@@error!=0)                        
     Begin                        
      RAISERROR  20006   'scsp_SCGetCustomASAMLevelOfCares: An Error Occured'                         
     Return                        
     End                             
                           
                           
                        
End  
  
GO


