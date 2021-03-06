/****** Object:  StoredProcedure [dbo].[csp_RdlCustomDocumentMapToEmploymentResponsibilitiesCoaching]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomDocumentMapToEmploymentResponsibilitiesCoaching]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlCustomDocumentMapToEmploymentResponsibilitiesCoaching]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomDocumentMapToEmploymentResponsibilitiesCoaching]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlCustomDocumentMapToEmploymentResponsibilitiesCoaching]                            
@DocumentVersionId  int                     
 AS                           
Begin               
                 
/*********************************************************************/                                                                                                                                    
/* Stored Procedure: dbo.[csp_RdlCustomDocumentMapToEmploymentResponsibilitiesCoaching]                */                                                                                                                                    
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                    
/* Creation Date:  04 Aug,2011                                       */                                                                                                                                    
/* Created By: Jagdeep Hundal                                                                  */                                                                                                                                    
/* Purpose:  Get Data from MapToEmploymentResponsibilities */                                                                                                                                  
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
                   
   SELECT  CDMTER.[EmploymentResponsibilityId]
          ,CDMTER.[DocumentVersionId]
          ,CDMTER.[ResponsibilityComment]                  
  FROM CustomDocumentMapToEmploymentResponsibilities   CDMTER                      
  where CDMTER.DocumentVersionId=@DocumentVersionId and IsNull(CDMTER.RecordDeleted,''N'')=''N''         
  and CDMTER.ResponsibilityType=''C''               
    --Checking For Errors                            
  If (@@error!=0)                            
  Begin                            
   RAISERROR  20006   ''csp_RdlCustomDocumentMapToEmploymentResponsibilitiesCoaching : An Error Occured''                             
   Return                            
   End                            
End  
  
  ' 
END
GO
