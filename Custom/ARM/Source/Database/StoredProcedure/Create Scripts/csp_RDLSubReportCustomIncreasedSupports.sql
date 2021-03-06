/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportCustomIncreasedSupports]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomIncreasedSupports]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportCustomIncreasedSupports]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomIncreasedSupports]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   PROCEDURE   [dbo].[csp_RDLSubReportCustomIncreasedSupports]          
(  
--@DocumentId int,               
--@Version int              
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010  
)                  
AS                  
            
Begin            
/************************************************************************/                                                  
/* Stored Procedure: [csp_RDLSubReportCustomIncreasedSupports]   */                                                                               
/* Copyright: 2006 Streamline SmartCare         */                                                                                        
/* Creation Date:  Jul 07, 2008           */                                                  
/*                  */                                                  
/* Purpose: Gets Data from CustomNaturalSupports      */  
/*                  */                                                 
/*                  */                                                
/* Input Parameters: DocumentID,Version         */                                                
/* Output Parameters:             */                                                  
/* Purpose: Use For Rdl Report           */                                        
/* Calls:                */                                                  
/* Author: Rupali Patil             */                                                  
/***********************************************************************/                    
    
SELECT Support  
From CustomIncreasedSupports CIS  
Where ISNull(CIS.RecordDeleted,''N'') = ''N''   
--and CIS.Documentid = @DocumentId   
--and CIS.Version = @Version          
and CIS.DocumentVersionId = @DocumentVersionId   --Modified by Anuj Dated 03-May-2010  
      
--Checking For Errors                                                  
If (@@error!=0)                                                  
 Begin                                                  
  RAISERROR  20006   ''[csp_RDLSubReportCustomIncreasedSupports] : An Error Occured''                                                   
  Return                                                  
 End     
End
' 
END
GO
