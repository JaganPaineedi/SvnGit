/****** Object:  StoredProcedure [dbo].[csp_ViewModeCustomAuthorizationDocument]    Script Date: 06/19/2013 17:49:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ViewModeCustomAuthorizationDocument]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ViewModeCustomAuthorizationDocument]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ViewModeCustomAuthorizationDocument]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE	PROCEDURE  [dbo].[csp_ViewModeCustomAuthorizationDocument]  
(  
--@DocumentId as int,  
--@Version as int  
@DocumentVersionId int
)  
As  
          
Begin          
/************************************************************************/            
/* Stored Procedure: dbo.csp_ViewModeCustomAuthorizationDocument		*/   
/* Copyright: 2006 Streamline SmartCare									*/            
/* Creation Date: June 19, 2008											*/
/*																		*/            
/* Purpose: Populates data for Custom Authorization Documents RDL		*/           
/* Input Parameters: DocumentID,Version									*/          
/* Output Parameters:													*/            
/* Return:																*/            
/* Calls:																*/
/* Author: Rupali Patil													*/
/************************************************************************/             
        
Select	(select OrganizationName from SystemConfigurations) as OrganizationName
		,d.ClientId
		,d.EffectiveDate
		,C.LastName + '', '' + C.FirstName as FullName
		,S.LastName + '', '' + S.FirstName as RequestorName
		,GCProg.CodeName as ''Program''	
		,CAD.AuthorizationRequestorComment
from Documents d 
join DocumentVersions dv on dv.DocumentId  = d.DocumentId
Join Clients C on C.ClientId = D.ClientId
Join Staff S on S.StaffId = D.AuthorId
left Join CustomAuthorizationDocuments CAD on CAD.DocumentVersionId = dv.DocumentVersionId
left join GlobalCodes GCProg on GCProg.GlobalCodeId = CAD.Assigned
where Dv.DocumentVersionId = @DocumentVersionId 

   
/*
Select	(select OrganizationName from SystemConfigurations) as OrganizationName
		,d.ClientId
		,d.EffectiveDate
		,C.LastName + '', '' + C.FirstName as FullName
		,S.LastName + '', '' + S.FirstName as RequestorName
		,GCProg.CodeName as ''Program''	
		,CAD.AuthorizationRequestorComment
from Documents D
Join Clients C on C.ClientId = D.ClientId
Join Staff S on S.StaffId = D.AuthorId
Join CustomAuthorizationDocuments CAD on CAD.DocumentID = D.DocumentID
left join GlobalCodes GCProg on GCProg.GlobalCodeId = CAD.Assigned
where CAD.DocumentID = @DocumentId 
and CAD.Version = @Version
*/

  

--Checking For Errors  
If (@@error!=0)  
	Begin  
		RAISERROR  20006   ''csp_ViewModeCustomAuthorizationDocument: An Error Occured''   
		Return  
	End  
End
' 
END
GO
