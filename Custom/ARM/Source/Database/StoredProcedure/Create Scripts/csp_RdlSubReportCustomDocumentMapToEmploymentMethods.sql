/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentMethods]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentMethods]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentMethods]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentMethods]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
 
 
Create PROCEDURE [dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentMethods]                          
@DocumentVersionId  int                   
 AS                         
Begin             
               
/*********************************************************************/                                                                                                                                  
/* Stored Procedure: dbo.[csp_RdlSubReportCustomDocumentMapToEmploymentMethods]                */                                                                                                                                  
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                  
/* Creation Date:  4 Aug,2011                                       */                                                                                                                                  
/* Created By: Damanpreet Kaur                                                                  */                                                                                                                                  
/* Purpose:  Get Data from CustomDocumentMapToEmploymentMethods */                                                                                                                                
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
                 
  SELECT EmploymentMethodId
       ,DocumentVersionId                              
       ,MethodsTechniques
       ,GC.CodeName as ProvidedByText                             
 FROM CustomDocumentMapToEmploymentMethods M      
 Inner Join GlobalCodes GC on GC.GlobalCodeId = M.ProvidedBy                  
 Where DocumentVersionId=@DocumentVersionId and IsNull(M.RecordDeleted,''N'')=''N''
 and M.MethodType=''D'' 
 
     
    --Checking For Errors                          
  If (@@error!=0)                          
  Begin                          
   RAISERROR  20006   ''csp_RdlSubReportCustomDocumentMapToEmploymentMethods : An Error Occured''                           
   Return                          
   End                          
End


   ' 
END
GO
