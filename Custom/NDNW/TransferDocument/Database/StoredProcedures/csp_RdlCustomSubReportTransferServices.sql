
/****** Object:  StoredProcedure [dbo].[csp_RdlCustomSubReportTransferServices]    Script Date: 11/18/2011 16:25:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomSubReportTransferServices]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlCustomSubReportTransferServices]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomSubReportTransferServices]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[csp_RdlCustomSubReportTransferServices]                            
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
                   
   SELECT TransferServiceId                              
      ,C.DocumentVersionId                              
      ,C.AuthorizationCodeId                             
      ,AuthorizationCodeName as  TransferServiceText                            
  FROM CustomTransferServices C                             
  inner join authorizationCodes A                            
  on C.AuthorizationCodeId=A.AuthorizationCodeId              
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
