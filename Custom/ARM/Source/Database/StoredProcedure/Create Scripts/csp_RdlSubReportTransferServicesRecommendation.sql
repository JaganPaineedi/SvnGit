/****** Object:  StoredProcedure [dbo].[csp_RdlSubReportTransferServicesRecommendation]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportTransferServicesRecommendation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlSubReportTransferServicesRecommendation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlSubReportTransferServicesRecommendation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlSubReportTransferServicesRecommendation]                            
@DocumentVersionId  int                     
 AS                           
Begin               
                 
/*********************************************************************/                                                                                                                                    
/* Stored Procedure: dbo.[csp_RdlSubReportTransferServicesRecommendation]                */                                                                                                                                    
/* Copyright: 2008 Streamline Healthcare Solutions,  LLC             */                                                                                                                                    
/* Creation Date:  13 July,2011                                       */                                                                                                                                    
/* Created By: Jagdeep Hundal                                                                  */                                                                                                                                    
/* Purpose:  Get Data from CustomDocumentAssessmentTransferServices */                                                                                                                                  
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
                   
   SELECT AssessmentTransferServiceId                              
      ,C.DocumentVersionId                              
      ,C.TransferService                             
      ,AuthorizationCodeName as  TransferServiceText                            
  FROM CustomDocumentAssessmentTransferServices C                             
  inner join authorizationCodes A                            
  on C.TransferService=A.AuthorizationCodeId              
  WHERE  DocumentVersionId=@DocumentVersionId                             
  AND    ISNULL(C.RecordDeleted,''N'')=''N''               
                
    --Checking For Errors                            
  If (@@error!=0)                            
  Begin                            
   RAISERROR  20006   ''csp_RdlSubReportTransferServicesRecommendation : An Error Occured''                             
   Return                            
   End                            
                     
                          
                
End  
  
  ' 
END
GO
