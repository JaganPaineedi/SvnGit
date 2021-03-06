/****** Object:  StoredProcedure [dbo].[csp_SCGetDocumentCodeForPatientConsent]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetDocumentCodeForPatientConsent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetDocumentCodeForPatientConsent]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetDocumentCodeForPatientConsent]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_SCGetDocumentCodeForPatientConsent]   
   
AS  
BEGIN  
 /*********************************************************************/                        
/* Stored Procedure: dbo.csp_SCGetDocumentCodeForPatientConsent              */               
              
/* Copyright: 2006 Streamline SmartCare*/                        
              
/* Creation Date: 12-4-2009                             */                        
/*                                                                   */                        
/* Purpose:  */                       
/*                                                                   */                      
/* Input Parameters:  */                   
/*                                                                   */                         
/* Output Parameters:                                */                        
/*                                                                   */                        
/* Return:   */                        
/*                                                                   */                        
/* Called By:   */              
/*      */              
              
/*                                                                   */                        
/* Calls:                                                            */                        
/*                                                                   */                        
/* Data Modifications:                                               */                        
/*                                                                   */                        
/*   Updates:                                                          */                        
              
/*       Date              Author                  Purpose                                    */                        
/*       12-4-2009         Mohit Madaan            To Retrieve Data                                    */                        
/*********************************************************************/     
Select DocumentCodeId,DocumentName,ViewDocumentURL from DocumentCodes Where  
  Active =''Y''   
    and PatientConsent=''Y''   
    and ISNULL(RecordDeleted,''N''  )<>''Y''
      
     --Checking For Errors              
  If (@@error!=0)              
  Begin              
   RAISERROR  20006   ''csp_SCGetDocumentCodeForPatientConsent : An Error Occured''               
   Return              
   End      
  
END
' 
END
GO
