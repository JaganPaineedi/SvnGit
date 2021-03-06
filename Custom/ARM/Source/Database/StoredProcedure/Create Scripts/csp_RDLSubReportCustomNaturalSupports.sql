/****** Object:  StoredProcedure [dbo].[csp_RDLSubReportCustomNaturalSupports]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomNaturalSupports]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLSubReportCustomNaturalSupports]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLSubReportCustomNaturalSupports]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE   PROCEDURE   [dbo].[csp_RDLSubReportCustomNaturalSupports]        
(
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)                
AS                
          
Begin          
/************************************************************************/                                                
/* Stored Procedure: [csp_RDLSubReportCustomNaturalSupports]			*/                                                                             
/* Copyright: 2006 Streamline SmartCare									*/                                                                                      
/* Creation Date:  Jul 07, 2008											*/                                                
/*																		*/                                                
/* Purpose: Gets Data from CustomNaturalSupports						*/
/*																		*/                                               
/*																		*/                                              
/* Input Parameters: DocumentID,Version									*/                                              
/* Output Parameters:													*/                                                
/* Purpose: Use For Rdl Report											*/                                      
/* Calls:																*/                                                
/* Author: Rupali Patil													*/                                                
/***********************************************************************/                  
  
SELECT	Support
From CustomNaturalSupports CNS
Where ISNull(CNS.RecordDeleted,''N'') = ''N'' 
--and CNS.Documentid = @DocumentId 
--and CNS.Version = @Version        
and CNS.DocumentVersionId = @DocumentVersionId  --Modified by Anuj Dated 03-May-2010
--Checking For Errors                                                
If (@@error!=0)                                                
	Begin                                                
		RAISERROR  20006   ''[csp_RDLSubReportCustomNaturalSupports] : An Error Occured''                                                 
		Return                                                
	End   
End
' 
END
GO
