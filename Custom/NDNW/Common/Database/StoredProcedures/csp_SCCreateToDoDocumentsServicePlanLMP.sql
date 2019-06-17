/****** Object:  StoredProcedure [dbo].[csp_SCCreateToDoDocumentsServicePlanLMP]    Script Date: 6/27/2018 9:55:54 AM ******/
if object_id('dbo.csp_SCCreateToDoDocumentsServicePlanLMP') is not null 
DROP PROCEDURE [dbo].[csp_SCCreateToDoDocumentsServicePlanLMP]
GO

/****** Object:  StoredProcedure [dbo].[csp_SCCreateToDoDocumentsServicePlanLMP]    Script Date: 6/27/2018 9:55:54 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[csp_SCCreateToDoDocumentsServicePlanLMP]

as
/*******************************************************************************
Date			Author			Purpose
-----------		---------------	--------------------------------------------
02/15/2016		praorane		Created - New Directions-Sup Go Live Task # 139
06/27/2018      BFagaly			changed Care Plan to Service Plan
********************************************************************************/
begin
 DECLARE @AlertType INT
       
          SET @AlertType =
         (
             SELECT GlobalCodeId
             FROM GlobalCodes 
             WHERE CodeName = 'Documents'
                   AND Category = 'AlertType'
         )

	declare @DocumentCodeId int =
	isnull ((select DocumentCodeId
	from DocumentCodes
	where DocumentName = 'SERVICE PLAN' and isnull(RecordDeleted, 'N') = 'N' ), 0)--change from Care Plan to SERVICE PLAN

	declare @NewDocuments table ( DocumentId int )
	declare @NewDocumentVersions table ( DocumentId        int
	,                                    DocumentVersionId int )

	-- Find All Clients Who Currently have Care Plan with Review due within 14 days
	--drop table #ClientsWithServicePlanDueIn14Days
	create table #ClientsWithServicePlanDueIn14Days ( ClientId           int
	,                                                 ServicePlanDate    datetime
	,                                                 ReviewDate         datetime
	,                                                 ReviewIntervalDays int
	,                                                 ReviewDueInDays    int
	,                                                 ReviewType         char(1)
	,                                                 DocumentId         int
	,                                                 DocumentVersionId  int )


	insert into #ClientsWithServicePlanDueIn14Days ( ClientId, ServicePlanDate, ReviewDate, ReviewIntervalDays, ReviewDueInDays, ReviewType, DocumentId, DocumentVersionId )
	select d.ClientId
	,      d.EffectiveDate
	,      case when p.ReviewEntireCareType = 'D' then ISNULL(p.ReviewEntireCarePlanDate, DATEADD(year,1, p.ReviewEntireCarePlanDate))
	                                              else null end
	,      case when p.ReviewEntireCareType = 'S' then cast(ltrim(replace(dbo.csf_GetGlobalCodeNameById(p.ReviewEntireCarePlan), 'days', '')) as int)
	                                              else null end
	,      null
	,      p.ReviewEntireCareType
	,      d.DocumentId
	,      d.CurrentDocumentVersionId
	from dbo.DocumentCarePlans p
	join Documents             d on p.DocumentVersionId = d.CurrentDocumentVersionId
			and isnull(d.RecordDeleted, 'N') = 'N'
	join Clients               c on d.ClientId = c.ClientId
			and isnull(c.RecordDeleted, 'N') = 'N'
	join DocumentSignatures ds on ds.signeddocumentversionid = d.CurrentDocumentVersionId
			AND ISNULL(ds.RecordDeleted, 'N') <> 'Y'
	where d.[status] = 22
		and ds.signatureorder>1
		and (p.estimateddischargedate - p.reviewentirecareplandate >=365)
		and isnull(p.RecordDeleted, 'N') = 'N'
		AND d.DocumentCodeId = @DocumentCodeId


	-- Step 2a: Compute ReviewDueInDays, ReviewDate as needed ...
	update #ClientsWithServicePlanDueIn14Days
	set ReviewDate = dateadd(day, ReviewIntervalDays, ServicePlanDate)
	where ReviewDate is null

	update #ClientsWithServicePlanDueIn14Days
	set ReviewDueInDays = datediff(day, getdate(), ReviewDate)
	where ReviewDueInDays is null
	
	-- Step 2b: Remove from the temp table unless Review Due Date is within 30 days...
	delete from #ClientsWithServicePlanDueIn14Days
	where ReviewDueInDays > 14 or ReviewDueInDays <= 0 or ReviewDueInDays is null




	-- New Documents ...
	insert into dbo.Documents ( ClientId, EffectiveDate, DueDate, DocumentCodeId, AuthorId, [Status], CurrentVersionStatus, DocumentShared, CreatedBy, ModifiedBy )
		output inserted.DocumentId
		into @NewDocuments ( DocumentId )
	select ClientId = r.ClientId
	,      EffectiveDate = r.ReviewDate
	,      DueDate = r.ReviewDate
	,      DocumentCodeId = @DocumentCodeId
	,      AuthorId = c.PrimaryClinicianId
	,      [Status] = 20 -- To Do
	,      CurrentVersionStatus = 20 -- To Do
	,      DocumentShared = 'Y'
	,      CreatedBy = 'SYSTEM'
	,      ModifiedBy = 'SYSTEM'
	from #ClientsWithServicePlanDueIn14Days as r
	join dbo.Clients                        as c on c.ClientId = r.ClientId
	where not exists (
		select *
		from Documents
		where ClientId = r.ClientId
			and DocumentCodeId = @DocumentCodeId
			  --   AND AuthorId = c.PrimaryClinicianId
                          AND EffectiveDate > = r.ReviewDate 
                          AND [Status] IN ( 20,21,22,25)
		--	and [Status] = 20
			and isnull(RecordDeleted, 'N') = 'N'
		)

	-- New Document Versions ...
	insert into dbo.DocumentVersions ( DocumentId, [Version], AuthorId, EffectiveDate, CreatedBy, ModifiedBy )
		output inserted.DocumentID
		,      inserted.DocumentVersionId
		into @NewDocumentVersions ( DocumentId
		,                           DocumentVersionId )
	select DocumentId = nd.DocumentId
	,      [Version] = 1
	,      AuthorId = d.AuthorId
	,      EffectiveDate = d.EffectiveDate
	,      CreatedBy = 'SYSTEM'
	,      ModifiedBy = 'SYSTEM'
	from @NewDocuments as nd
	join dbo.Documents as d  on nd.DocumentId = d.DocumentId

	-- Set Document Current and InProgress DocumentVersionIDs ...
	update doc
	set CurrentDocumentVersionId    = ndv.DocumentVersionId
	,   InProgressDocumentVersionId = ndv.DocumentVersionId
	from dbo.Documents        as doc
	join @NewDocumentVersions as ndv on doc.DocumentId = ndv.DocumentId

	-- New Custom Document table records	...
	insert into dbo.DocumentCarePlanReviews ( DocumentVersionId, CreatedBy, ModifiedBy )
	select DocumentVersionId = ndv.DocumentVersionId
	,      CreatedBy = 'SYSTEM'
	,      ModifiedBy = 'SYSTEM'
	from @NewDocumentVersions as ndv


            INSERT INTO alerts
         (ToStaffId,
          ClientId,
          AlertType,
          DocumentId,
          Unread,
          DateReceived,
          Subject,
          Message
         )
                SELECT D.AuthorId, --h.AlertToUser, --to Staff (service clinician)  
                       D.ClientId,
                       @AlertType, --Documents
                       D.DocumentId,
                       'Y',
                       GETDATE(),
                       'Care Plan Signed by LMP due in 14 Days', --Subject  
                       'Client, '+C.lastname+', '+C.Firstname+' Care Plan Signed by LMP is due on '+CONVERT( VARCHAR(20), DATEADD(yyyy, 1, D.EffectiveDate), 101)+'.'
                FROM @NewDocuments N
                     JOIN Documents D ON N.DocumentId = D.Documentid
                     JOIN clients C ON C.Clientid = D.Clientid
                     where d.authorid is not null



end




GO


