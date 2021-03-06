/****** Object:  StoredProcedure [dbo].[csp_RdlCustomDocumentMapToEmploymentMethodsCoaching]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomDocumentMapToEmploymentMethodsCoaching]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlCustomDocumentMapToEmploymentMethodsCoaching]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomDocumentMapToEmploymentMethodsCoaching]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlCustomDocumentMapToEmploymentMethodsCoaching]                            
@DocumentVersionId  int                     
 AS                           
Begin               
                 
/*********************************************************************/                                                                                                                                    
/* Stored Procedure: dbo.[csp_RdlCustomDocumentMapToEmploymentMethodsCoaching]                */                                                                                                                                    
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                    
/* Creation Date:  04 Aug,2011                                       */                                                                                                                                    
/* Created By: Jagdeep Hundal                                                                  */                                                                                                                                    
/* Purpose:  Get Data from MapToEmploymentMethods */                                                                                                                                  
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
                   
   SELECT  CDMTEM.[EmploymentMethodId]
          ,CDMTEM.[DocumentVersionId]
          ,CDMTEM.[MethodsTechniques]                  
  FROM CustomDocumentMapToEmploymentMethods   CDMTEM                    
  where CDMTEM.DocumentVersionId=@DocumentVersionId and IsNull(CDMTEM.RecordDeleted,''N'')=''N''         
  and CDMTEM.MethodType=''C''               
    --Checking For Errors                            
  If (@@error!=0)                            
  Begin                            
   RAISERROR  20006   ''csp_RdlCustomDocumentMapToEmploymentMethodsCoaching : An Error Occured''                             
   Return                            
   End                            
End  
  
  ' 
END
GO
