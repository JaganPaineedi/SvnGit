/****** Object:  StoredProcedure [dbo].[csp_RdlDiagnosisIIICodes]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlDiagnosisIIICodes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlDiagnosisIIICodes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlDiagnosisIIICodes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'            
CREATE PROCEDURE [dbo].[csp_RdlDiagnosisIIICodes]                          
@DocumentVersionId  int                   
 AS                         
Begin             
               
/*********************************************************************/                                                                                                                                  
/* Stored Procedure: dbo.[csp_RdlDiagnosisIIICodes]                */                                                                                                                                  
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                  
/* Creation Date:  26 July,2010                                       */                                                                                                                                  
/*                                                                   */                                                                                                                                  
/* Purpose:  Get Data for DiagnosisIII Pages */                                                                                                                                
/*                                                                   */                                                                                                                                
/* Input Parameters:  @DocumentVersionId             */                                                                                                                                
/*                                                                   */                                                                                                                                  
/* Output Parameters:   None                   */                                                                                                                                  
/*                                                                   */                                                                                                                                  
/* Return:  0=success, otherwise an error number                     */                                                                                                                                  
/*                                                                   */                                                                                                                                  
/* Called By:                                                        */                                                                                                                                  
/*                                                                   */                                                                                                                                  
/* Calls:                                                            */                   
/* */                                            
/* Data Modifications:                   */                                                  
/*      */                                                                                 
/* Updates:               */                                                                          
/*   Date     Author            Purpose                             */                                                     
/*   Jitender Kumar Kamboj  */                                                             
/*                                                                                    
*/                                                                                                       
/*********************************************************************/            
           
          
                 
  --DiagnosesIIICodes        
 SELECT DIIICod.DiagnosesIIICodeId,DIIICod.ICDCode,DICD.ICDDescription,DIIICod.Billable              
 FROM  DiagnosesIIICodes as DIIICod inner join DiagnosisICDCodes as DICD on DIIICod.ICDCode=DICD.ICDCode            
 WHERE (DIIICod.DocumentVersionId = @DocumentVersionId) AND (ISNULL(DIIICod.RecordDeleted, ''N'') = ''N'')             
                 
              
    --Checking For Errors                          
  If (@@error!=0)                          
  Begin                          
   RAISERROR  20006   ''csp_RdlDiagnosisIIICodes : An Error Occured''                           
   Return                          
   End                          
                   
                        
              
End
' 
END
GO
