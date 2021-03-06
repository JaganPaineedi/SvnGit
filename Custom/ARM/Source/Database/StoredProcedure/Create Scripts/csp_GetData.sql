/****** Object:  StoredProcedure [dbo].[csp_GetData]    Script Date: 06/19/2013 17:49:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetData]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_GetData]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_GetData]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_GetData]             
(                
@documentCodeId as int    
)                
As                
                        
Begin                        
/*********************************************************************/                          
/* Stored Procedure: dbo.csp_GetData             */                 
                
/* Copyright: 2006 Streamline SmartCare*/                          
                
/* Creation Date:  07/23/2007                                   */                          
/*                                                                   */                          
/* Purpose: Gets SP name and TableList from Documentcodes table */                         
/*                                                                   */                        
/* Input Parameters: DocumentID */                        
/*                                                                   */                           
/* Output Parameters:                      */                          
/*                                                                   */                          
/* Return:   SP name and TableList corresponding to DocumentCodesId  */                          
/*                                                                   */                          
/* Called By: FillDocumentsWithStoredProcedure()     */                
/*      */                
                
/*                                                                   */                          
/* Calls:                                                            */                          
/*                                                                   */                          
/* Data Modifications:                                               */                          
/*                                                                   */                          
/*   Updates:                                                          */                          
                
/*       Date              Author                  Purpose                                    */                          
/*  7/23/2007   Preeti     To Retrieve SP name and TableList                                 */                          
/*********************************************************************/                           
                      
  Select StoredProcedure,TableList,DocumentType,ViewStoredProcedure  
	from DocumentCodes 
	where DocumentcodeId=@DocumentcodeId                 
                
   --Checking For Errors                
  If (@@error!=0)                
  Begin                
   RAISERROR  20006   ''csp_GetData : An Error Occured''                 
   Return                
   End     
  
End
' 
END
GO
