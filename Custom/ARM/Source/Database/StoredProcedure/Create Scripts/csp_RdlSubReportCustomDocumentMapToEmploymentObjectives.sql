/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentObjectives]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentObjectives]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentObjectives]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentObjectives]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N' 
 
 
Create PROCEDURE [dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentObjectives]                          
@DocumentVersionId  int                   
 AS                         
Begin             
               
/*********************************************************************/                                                                                                                                  
/* Stored Procedure: dbo.[csp_RdlSubReportCustomDocumentMapToEmploymentObjectives]                */                                                                                                                                  
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                  
/* Creation Date:  4 Aug,2011                                       */                                                                                                                                  
/* Created By: Damanpreet Kaur                                                                  */                                                                                                                                  
/* Purpose:  Get Data from CustomDocumentMapToEmploymentObjectives */                                                                                                                                
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
                 
  SELECT EmploymentObjectiveId
      ,DocumentVersionId                              
      ,[ObjectiveType]
      ,[ObjectiveText]
      ,CONVERT(varchar,[ObjectiveTargetDate],101) as TargetDate                             
  FROM CustomDocumentMapToEmploymentObjectives O                        
  Where DocumentVersionId=@DocumentVersionId 
  and O.ObjectiveType = ''D''
  and IsNull(O.RecordDeleted,''N'')=''N''     
              
    --Checking For Errors                          
  If (@@error!=0)                          
  Begin                          
   RAISERROR  20006   ''csp_RdlSubReportCustomDocumentMapToEmploymentObjectives : An Error Occured''                           
   Return                          
   End                          
End


' 
END
GO
