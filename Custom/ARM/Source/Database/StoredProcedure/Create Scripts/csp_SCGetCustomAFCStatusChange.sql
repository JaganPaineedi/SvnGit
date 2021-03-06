/****** Object:  StoredProcedure [dbo].[csp_SCGetCustomAFCStatusChange]    Script Date: 06/19/2013 17:49:51 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomAFCStatusChange]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCGetCustomAFCStatusChange]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCGetCustomAFCStatusChange]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE  [dbo].[csp_SCGetCustomAFCStatusChange]         
(            
  @DocumentVersionId INT           
)            
As            
                    
Begin                    
/*********************************************************************/                      
/* Stored Procedure: dbo.[csp_SCGetCustomAFCStatusChange]               */             
            
/* Copyright: 2006 Streamline SmartCare*/                      
            
/* Creation Date:  06/07/2007                                   */                      
/*                                                                   */                      
/* Purpose: Gets Data for [csp_SCGetCustomAFCStatusChange] */                     
/*                                                                   */                    
/* Input Parameters: DocumentID,Version */                    
/*                                                                   */                       
/* Output Parameters:                                */                      
/*                                                                   */                      
/* Return:   */                      

/* Called By: FillDocumentsWithStoredProcedure() Method in Document Class Of DataService    */                                                                                      
      
            
/*                                                                   */                      
/* Calls:                                                            */                      
/*                                                                   */                      
/* Data Modifications:                                               */                      
/*                                                                   */                      
/*   Updates:                                                          */                      
            
/*       Date              Author                  Purpose                                    */                                  
 /*      06/07/2007       Vishal               To Retrieve Data      */                                  
 /*********************************************************************/           
                  
 -- before modify  Select * from Documents where ISNull(RecordDeleted,''N'')=''N'' and DocumentId = @DocumentId             
  -- Select * from Documents where ISNull(RecordDeleted,''N'')=''N'' and DocumentVersionId = @DocumentVersionId             
            
  --Checking For Errors            
  If (@@error!=0)            
  Begin            
   RAISERROR  20006   ''csp_SCGetCustomAFCStatusChange: An Error Occured''             
   Return            
   End                     
            
            
  -- Before update Select * from DocumentVersions where ISNull(RecordDeleted,''N'')=''N'' and DocumentId=@DocumentId and Version=@Version             
  
 -- commented on 24 April,2010 Select * from DocumentVersions where ISNull(RecordDeleted,''N'')=''N'' and DocumentVersionId = @DocumentVersionId
            
  --Checking For Errors            
  If (@@error!=0)            
  Begin            
   RAISERROR  20006   ''csp_SCGetCustomAFCStatusChange: An Error Occured''              
   Return            
   End       
    
  /*               QUERY BEFORE MODIFIED         
  Select * from CustomAFCStatusChange  where ISNull(RecordDeleted,''N'')=''N'' and DocumentId=@DocumentId and Version=@Version             
  */
  Select * from CustomAFCStatusChange  where ISNull(RecordDeleted,''N'')=''N'' and DocumentVersionId  = @DocumentVersionId             
            
  --Checking For Errors            
  If (@@error!=0)            
  Begin            
   RAISERROR  20006   ''csp_SCGetCustomAFCStatusChange: An Error Occured''              
   Return            
   End     
                            
            
End
' 
END
GO
