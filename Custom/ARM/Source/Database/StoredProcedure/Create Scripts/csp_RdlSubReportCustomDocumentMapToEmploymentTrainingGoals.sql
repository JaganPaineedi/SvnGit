/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentTrainingGoals]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentTrainingGoals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentTrainingGoals]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentTrainingGoals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentTrainingGoals]                            
@DocumentVersionId  int                     
 AS                           
Begin               
                 
/*********************************************************************/                                                                                                                                    
/* Stored Procedure: dbo.[csp_RdlSubReportCustomDocumentMapToEmploymentTrainingGoals]                */                                                                                                                                    
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                    
/* Creation Date:  04 Aug,2011                                       */                                                                                                                                    
/* Created By: Jagdeep Hundal                                                                  */                                                                                                                                    
/* Purpose:  Get Data from MapToEmploymentTrainingGoals */                                                                                                                                  
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
/*********************************************************************/              
                   
   SELECT  CDMTETG.[EmploymentTrainingGoalId]
          ,CDMTETG.[DocumentVersionId]
          ,CDMTETG.[TrainingGoal]                     
  FROM CustomDocumentMapToEmploymentTrainingGoals   CDMTETG                       
  where CDMTETG.DocumentVersionId=@DocumentVersionId and IsNull(CDMTETG.RecordDeleted,''N'')=''N''         
                
    --Checking For Errors                            
  If (@@error!=0)                            
  Begin                            
   RAISERROR  20006   ''csp_RdlSubReportCustomDocumentMapToEmploymentTrainingGoals : An Error Occured''                             
   Return                            
   End                            
                     
                          
                
End  
  
  ' 
END
GO
