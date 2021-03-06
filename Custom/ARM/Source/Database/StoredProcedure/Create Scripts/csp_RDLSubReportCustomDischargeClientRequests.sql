/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportCustomDischargeClientRequests]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomDischargeClientRequests]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportCustomDischargeClientRequests]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomDischargeClientRequests]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   PROCEDURE   [dbo].[csp_RDLSubReportCustomDischargeClientRequests]              
(                               
@DocumentVersionId  int                              
)                              
AS                              
                        
              
/************************************************************************/                                                              
/* Stored Procedure: [csp_RDLSubReportCustomDischargeClientRequests]  */                                                                                           
/* Copyright: 2008 Streamline SmartCare         */                                                                                                    
/* Creation Date:  27 July 2010           */                                                              
/*                  */                                                              
/* Purpose: CustomDischarge sub report for Medication  page  */                                                  
/*                  */                                                            
/* Input Parameters: @DocumentVersionId         */                                                            
/* Output Parameters:             */                                                              
/* Purpose: Use For Rdl Report           */                                                    
/* Calls:                */                                                              
/* Author: Jitender Kumar Kamboj                    
Updated by:     Date    Description          
          
          
              */                                                              
/************************************************************************/                                
                     
           
           
--CustomDischargeClientRequests                              
SELECT [DischargeClientRequestId]                                                      
      ,[DocumentVersionId]                              
      ,[ClientRequest]                       
      ,CodeName                             
FROM [CustomDischargeClientRequests] DCR join GlobalCodes on [ClientRequest]= GlobalCodes.globalcodeid                       
WHERE DocumentVersionId=@DocumentVersionId AND ISNULL(DCR.[RecordDeleted] ,''N'')=''N''         
AND ISNULL(GlobalCodes.RecordDeleted,''N'')=''N''              
           
              
--Checking For Errors                                                              
If (@@error!=0)                                                              
 Begin                                                              
  RAISERROR  20006   ''[csp_RDLSubReportCustomDischargeClientRequests] : An Error Occured''                                                               
  Return                                                              
 End
' 
END
GO
