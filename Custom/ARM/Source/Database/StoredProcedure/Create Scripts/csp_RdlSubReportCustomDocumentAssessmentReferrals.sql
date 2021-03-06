/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportCustomDocumentAssessmentReferrals]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportCustomDocumentAssessmentReferrals]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportCustomDocumentAssessmentReferrals]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportCustomDocumentAssessmentReferrals]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlSubReportCustomDocumentAssessmentReferrals]                            
@DocumentVersionId  int                     
 AS                           
Begin               
                 
/*********************************************************************/                                                                                                                                    
/* Stored Procedure: dbo.[csp_RdlSubReportCustomDocumentAssessmentReferrals]                */                                                                                                                                    
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                    
/* Creation Date:  13 July,2011                                       */                                                                                                                                    
/* Created By: Jagdeep Hundal                                                                  */                                                                                                                                    
/* Purpose:  Get Data from CustomDocumentAssessmentReferrals */                                                                                                                                  
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
                   
   SELECT ReferralServiceId                             
      ,C.DocumentVersionId                              
      ,C.AuthorizationCodeId                             
      ,AuthorizationCodeName as  ReferralServiceText                            
  FROM CustomDocumentReferralServices C                             
  inner join authorizationCodes A                            
  on C.AuthorizationCodeId=A.AuthorizationCodeId              
  WHERE  DocumentVersionId=@DocumentVersionId                             
  AND    ISNULL(C.RecordDeleted,''N'')=''N''               
               
    --Checking For Errors                            
  If (@@error!=0)                            
  Begin                            
   RAISERROR  20006   ''csp_RdlSubReportCustomDocumentAssessmentReferrals : An Error Occured''                             
   Return                            
   End                            
                     
                          
                
End  
  
  
' 
END
GO
