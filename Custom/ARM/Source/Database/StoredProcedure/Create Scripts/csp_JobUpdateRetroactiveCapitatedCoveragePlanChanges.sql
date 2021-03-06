/****** Object:  StoredProcedure [dbo].[csp_JobUpdateRetroactiveCapitatedCoveragePlanChanges]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobUpdateRetroactiveCapitatedCoveragePlanChanges]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_JobUpdateRetroactiveCapitatedCoveragePlanChanges]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_JobUpdateRetroactiveCapitatedCoveragePlanChanges]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_JobUpdateRetroactiveCapitatedCoveragePlanChanges] as
/************************************************************************/
/* SUMMIT POINTE Customization											*/
/* This procedure updates authorization documents with					*/
/* a capitated coverage	plan id to be sent to the UM					*/
/* 																		*/
/* 																		*/
/* This should be run nightly by the SQL job scheduler.					*/
/* CreatedDate: 8/1/2007	CreatedBy: avoss							*/
/* ModifiedDate: 03/21/2008 ModifiedBy: Ryan Noble						*/
/* Changed Retro cursor select to include authorization requests if the */
/* a capitated coverage covers any period of the authorization request  */
/************************************************************************/
    declare @AuthDocumentId			int,
	    	@ClientCoveragePlanId	int
    
	declare Retro cursor for
	select 
		ad.authorizationdocumentid,
		ccp.ClientCoveragePlanId
	from documents d 
		join tpprocedures tp on tp.documentVersionId = d.CurrentDocumentVersionId and isnull(tp.Recorddeleted, ''N'')=''N''
		join clients c on c.clientId = d.clientId and isnull(c.Recorddeleted, ''N'')=''N''
		Join clientCoveragePlans ccp on ccp.clientid = c.clientId and isnull(ccp.Recorddeleted, ''N'')=''N''
		join coverageplans cp on cp.coverageplanid = ccp.coverageplanid and isnull(cp.Recorddeleted, ''N'')=''N''
		join clientCoverageHistory cch on cch.ClientCoveragePlanId = ccp.ClientCoveragePlanId and isnull(cch.Recorddeleted, ''N'')=''N''
		Join authorizations a on a.authorizationId = tp.authorizationId and isnull(a.Recorddeleted, ''N'')=''N''	
		join authorizationdocuments ad on ad.documentId = d.documentid and isnull(ad.Recorddeleted, ''N'')=''N''
	where ad.ClientCoveragePlanId is null
	and cp.capitated = ''Y''
	and cp.active=''Y''
	and d.status = 22
	and cch.StartDate <= a.EndDateRequested
	and (cch.EndDate is null or dateadd(dd,1,cch.EndDate) > a.StartDateRequested)
	and d.effectiveDate >= dateadd(dd, -90, getdate())
	and isnull(d.Recorddeleted, ''N'')=''N''
group by ad.AuthorizationDocumentId, ccp.ClientCoveragePlanId
		
open Retro 


Fetch next from Retro into @AuthDocumentId, @ClientCoveragePlanId    
while (@@fetch_status = 0)
Begin  

	Update AuthorizationDocuments 
	set ClientCoveragePlanId = @ClientCoveragePlanId,
		ModifiedBy = ''AuthRetro'',
		ModifiedDate = getdate()
	Where AuthorizationDocumentId = @AuthDocumentId
    
Fetch next from Retro into @AuthDocumentId, @ClientCoveragePlanId    
End
   
Close Retro 
Deallocate Retro 


Return
' 
END
GO
