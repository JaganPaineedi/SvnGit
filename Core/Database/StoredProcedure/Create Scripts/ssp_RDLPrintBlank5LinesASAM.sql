 IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_RDLPrintBlank5LinesASAM]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ssp_RDLPrintBlank5LinesASAM]
GO
    

CREATE PROCEDURE   [dbo].[ssp_RDLPrintBlank5LinesASAM]    
   
AS    
  
/*********************************************************************/                    
/* Stored Procedure: [ssp_RDLPrintBlank5LinesASAM]      */        
                  
/* Purpose:    To Display 5 set of Blank lines          */                    
/*                                                                   */                    
/* Input Parameters: None */                    
/*                                                                   */                    
/* Output Parameters:   None                                         */                    
/*                                                                   */                    
/*                                                                   */                    
/*                                                                   */                    
/* Calls:                                                            */                    
/*                                                                   */                    
/* Data Modifications:                                               */                    
/*                                                                   */                    
/* Updates:                                                          */                    
/* Date         Author        Purpose                                    */                    
/* 12/14/2012   Bernsrdin     To Display 5 set of Blank lines */  
                   
/*********************************************************************/   
  
  
/* This is a dummy sp to display Blank lines in Signature RDL . To format the records using tablix control in Blank5Lines RDL we required dataset.*/  
Begin  
Select '' AS SignerName  
End  
  
  
  