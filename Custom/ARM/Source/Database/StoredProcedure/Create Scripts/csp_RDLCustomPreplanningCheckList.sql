/****** Object:  StoredProcedure [dbo].[csp_RDLCustomPreplanningCheckList]    Script Date: 06/19/2013 17:49:47 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPreplanningCheckList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RDLCustomPreplanningCheckList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RDLCustomPreplanningCheckList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create	PROCEDURE   [dbo].[csp_RDLCustomPreplanningCheckList] 
(
--@DocumentId int,             
--@Version int            
@DocumentVersionId  int --Modified by Anuj Dated 03-May-2010
)            
AS            
      
Begin      
/************************************************************************/                                            
/* Stored Procedure: [csp_RDLCustomPreplanningCheckList]				*/                                  
/* Copyright: 2006 Streamline SmartCare									*/                                            
/* Creation Date: May 20, 2008											*/                                            
/*																		*/                                            
/* Purpose: Gets Data from CustomPreplanningChecklist,					*/
/*			SystemConfigurations,Staff,Documents						*/                                           
/*																		*/                                          
/* Input Parameters: DocumentID,Version									*/                                          
/* Output Parameters:													*/                                            
/* Purpose: Use For Rdl Report											*/                                  
/* Calls:																*/                                            
/* Author: Rupali Patil													*/                                            
/************************************************************************/              
SELECT	SystemConfig.OrganizationName
		,C.LastName + '', '' + C.FirstName as ClientName
		,Documents.ClientID
		,Documents.EffectiveDate      
		,S.FirstName + '' '' + S.LastName + '',  '' + ISNull(GC.CodeName,'''') as ClinicianName  
		,[Residential]
		,[OccupationalCommunityParticpation]
		,[Safety]
		,[Legal]
		,[Health]
		,[NaturalSupports]
		,[Other]
		,[Participants]
		,[Facilitator]
		,[Assessments]
		,[TimeLocation]
		,[IssuesToAvoid]
		,[CommunicationAccomodations]
		,[WishToDiscuss]
		,[SourceOfPrePlanningInformation]
		,[SelfDetermination]
		,[FiscalIntermediary]
		,[PCPInformationPamphletGiven]
		,[PCPInformationDiscussed]
--FROM [CustomPrePlanningChecklists] CPC join Documents ON  CPC.DocumentId = Documents.DocumentId    
FROM [CustomPrePlanningChecklists] CPC 
join DocumentVersions dv on dv.DocumentVersionId=CPC.DocumentVersionId and isnull(dv.RecordDeleted,''N'')=''N''
join Documents ON  dv.DocumentId = Documents.DocumentId    --Modified by Anuj Dated 03-May-2010
and isnull(Documents.RecordDeleted,''N'')<>''Y''               
join Staff S on Documents.AuthorId= S.StaffId and isnull(S.RecordDeleted,''N'')<>''Y''      
join Clients C on Documents.ClientId= C.ClientId and isnull(C.RecordDeleted,''N'')<>''Y''  
Left Join GlobalCodes GC On GC.GlobalCodeId = S.Degree and isNull(GC.RecordDeleted,''N'')<>''Y''
Cross Join SystemConfigurations as SystemConfig  
--where CPC .DocumentId=@DocumentId  
--and CPC.Version=@Version      
where CPC .DocumentVersionId=  @DocumentVersionId   --Modified by Anuj Dated 03-May-2010 
    
--Checking For Errors                                            
If (@@error!=0)                                            
	Begin                                            
		RAISERROR  20006   ''[csp_RDLCustomPreplanningCheckList] : An Error Occured''                                             
		Return                                            
	End                                                     
End
' 
END
GO
