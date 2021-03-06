/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentExperiences]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentExperiences]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentExperiences]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentExperiences]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

 
 
 
Create PROCEDURE [dbo].[csp_RdlSubReportCustomDocumentMapToEmploymentExperiences]                          
@DocumentVersionId  int                   
 AS                         
Begin             
               
/*********************************************************************/                                                                                                                                  
/* Stored Procedure: dbo.[csp_RdlSubReportCustomDocumentMapToEmploymentExperiences]                */                                                                                                                                  
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                  
/* Creation Date:  4 Aug,2011                                       */                                                                                                                                  
/* Created By: Damanpreet Kaur                                                                  */                                                                                                                                  
/* Purpose:  Get Data from CustomDocumentMapToEmploymentExperiences */                                                                                                                                
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
                 
 SELECT EmploymentExperienceId
       ,DocumentVersionId                              
       ,ExperienceComment                             
 FROM CustomDocumentMapToEmploymentExperiences E                        
 Where DocumentVersionId=@DocumentVersionId and IsNull(E.RecordDeleted,''N'')=''N''   
               
    --Checking For Errors                          
  If (@@error!=0)                          
  Begin                          
   RAISERROR  20006   ''csp_RdlSubReportCustomDocumentMapToEmploymentExperiences : An Error Occured''                           
   Return                          
   End                          
End


 ' 
END
GO
