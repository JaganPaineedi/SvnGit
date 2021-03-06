/****** Object:  StoredProcedure [dbo].[csp_RdlCustomConnectionsNotes]    Script Date: 06/19/2013 17:49:46 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomConnectionsNotes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RdlCustomConnectionsNotes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RdlCustomConnectionsNotes]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create PROCEDURE  [dbo].[csp_RdlCustomConnectionsNotes]         
(            
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010  
)            
As            
                    
Begin                    
/************************************************************************/                      
/* Stored Procedure: csp_RdlCustomConnectionsNotes						*/             
/* Copyright: 2006 Streamline SmartCare									*/                      
/* Creation Date:  Oct 26th ,2007										*/                      
/*																		*/                      
/* Purpose: Gets Data for CustomConnectionsNotes						*/                     
/*																		*/                      
/* Input Parameters: DocumentID,Version									*/                    
/* Output Parameters:													*/                      
/* Purpose: Use For Rdl Report											*/            
/* Calls:																*/                      
/* Author: Ranjeetb                                                     */                      
/* Modified by: Rupali Patil											*/
/* Modified date: 6/6/2008												*/
/* Modified: Added ClientID to the select list							*/
/************************************************************************/                       
                  
SELECT	d.ClientID
		,[Purpose]
		,[Location]
		,[EmploymentStatus]
		,[HoursWorked]
		,[Narrative]
		,[OnTime]
		,[Appearance]
		,[ProductiveWork]
		,[AppropriatePlacement]
		,[InteractSupervisor]
		,[InteractCoWorker]
		,[Hygiene]
		,[SatisfactoryWork]
		,[ProductiveSession]
FROM [CustomConnectionsNotes] CCN
join DocumentVersions as dv on dv.DocumentVersionId = CCN.DocumentVersionId
JOIN Documents d on d.DocumentId = dv.DocumentId
where ISNull(CCN.RecordDeleted,''N'') = ''N'' 
--and CCN.Documentid = @DocumentId 
--and CCN.Version = @Version
and CCN.DocumentVersionId = @DocumentVersionId     
            
--Checking For Errors            
If (@@error!=0)            
	Begin            
		RAISERROR  20006   ''csp_RdlCustomConnectionsNotes : An Error Occured''             
		Return            
	End
End
' 
END
GO
