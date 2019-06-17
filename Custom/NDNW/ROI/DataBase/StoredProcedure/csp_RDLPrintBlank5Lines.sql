IF EXISTS (SELECT * 
           FROM   SYS.objects 
           WHERE  object_id = OBJECT_ID(N'[dbo].[csp_RDLPrintBlank5Lines]') 
                  AND type IN ( N'P', N'PC' )) 
  BEGIN 
      DROP PROCEDURE [dbo].[csp_RDLPrintBlank5Lines] 
  END 

GO 
   
CREATE PROCEDURE   [dbo].[csp_RDLPrintBlank5Lines]      
     
AS      
    
/*********************************************************************/                      
/* Stored Procedure: [csp_RDLPrintBlank5Lines]      */          
                    
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