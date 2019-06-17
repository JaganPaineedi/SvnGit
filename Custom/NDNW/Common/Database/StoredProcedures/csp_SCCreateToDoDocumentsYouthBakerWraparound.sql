/****** Object:  StoredProcedure [dbo].[csp_SCCreateToDoDocumentsYouthBakerWraparound]    Script Date: 03/04/2016 11:25:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_SCCreateToDoDocumentsYouthBakerWraparound]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_SCCreateToDoDocumentsYouthBakerWraparound]
GO


/****** Object:  StoredProcedure [dbo].[csp_SCCreateToDoDocumentsYouthBakerWraparound]    Script Date: 03/04/2016 11:25:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE procedure [dbo].[csp_SCCreateToDoDocumentsYouthBakerWraparound]

as
/*******************************************************************************
Date			Author			Purpose
-----------		---------------	--------------------------------------------
02/15/2016		praorane		Created - New Directions-Sup Go Live Task # 139
********************************************************************************/
begin


	declare @DocumentCodeId int =
	isnull ((select DocumentCodeId
	from DocumentCodes
	where DocumentName = 'Child and Adolescent Needs and Strengths (CANS)' and isnull(RecordDeleted, 'N') = 'N' ), 0)

	declare @NewDocuments table ( DocumentId int )
	declare @NewDocumentVersions table ( DocumentId        int
	,                                    DocumentVersionId int )
	--drop table #ClientsWithCANSDueIn14Days1
	create table #ClientsWithCANSDueIn14Days1 ( ClientId          int
	,                                           CANSDate          datetime
	,                                           UpdateDate        datetime
	,                                           UpdateDueInDays   int
	,                                           CANSType          int
	,                                           DocumentId        int
	,                                           DocumentVersionId int )
	insert into #ClientsWithCANSDueIn14Days1 ( ClientId, CANSDate, UpdateDate, CANSType, DocumentId, DocumentVersionId )
	select ClientId = d.ClientId
	,      d.effectivedate                  
	,      DATEADD(DAY, 90, d.EffectiveDate)
	,      cans.DocumentType                
	,      DocumentId = d.DocumentId
	,      DocumentVersionId = d.CurrentDocumentVersionId
	from            dbo.CustomDocumentCANSGenerals cans
	join            Documents                      d    on cans.DocumentVersionId = d.CurrentDocumentVersionId
			and isnull(d.RecordDeleted, 'N') = 'N'
	join            Clients                        c    on d.ClientId = c.ClientId
			and isnull(c.RecordDeleted, 'N') = 'N'
	LEFT OUTER JOIN ClientPrograms                 cp   ON cp.ClientId = d.ClientId
			AND cp.Status = 4
			AND cp.EnrolledDate <= GETDATE()
			AND (cp.DischargedDate IS NULL
			OR cp.DeletedDate >= GETDATE())
			AND cp.ProgramId = 105 -- NDBHW - Baker County Wrap
	where d.[status] = 22 
		and cans.DocumentType IN (39576, 39577) -- Initial, Reassessment
		and isnull(cans.RecordDeleted, 'N') = 'N'

	--select * from #ClientsWithCANSDueIn14Days1

	-- Step 2a: Compute UpdateDueInDays, UpdateDate as needed ...

	update #ClientsWithCANSDueIn14Days1
	set UpdateDueInDays = datediff(day, getdate(), UpdateDate)
	where UpdateDueInDays is NULL
	
	--select * from #ClientsWithCANSDueIn14Days1
	-- Step 2b: Remove from the temp table unless Review Due Date is within 30 days...
	delete from #ClientsWithCANSDueIn14Days1
	where UpdateDueInDays > 14 or UpdateDueInDays <= 0 or UpdateDueInDays is null

	--select * from #ClientsWithCANSDueIn14Days1


	-- New Documents ...
	insert into dbo.Documents ( ClientId, EffectiveDate, DueDate, DocumentCodeId, AuthorId, [Status], CurrentVersionStatus, DocumentShared, CreatedBy, ModifiedBy )
		output inserted.DocumentId
		into @NewDocuments ( DocumentId )
	select r.ClientId
	,      r.UpdateDate
	,      r.UpdateDate
	,      @DocumentCodeId
	,      c.PrimaryClinicianId
	,      20 -- To Do
	,      20 -- To Do
	,      'Y'
	,      'SYSTEM'
	,      'SYSTEM'
	from #ClientsWithCANSDueIn14Days1 as r
	join dbo.Clients                              as c on c.ClientId = r.ClientId
	where not exists (
		select *
		from Documents
		where ClientId = r.ClientId
			and DocumentCodeId = @DocumentCodeId
			and AuthorId = c.PrimaryClinicianId
			and [Status] = 20
			and isnull(RecordDeleted, 'N') = 'N'
		)

	-- New Document Versions ...
	insert into dbo.DocumentVersions ( DocumentId, [Version], AuthorId, EffectiveDate, CreatedBy, ModifiedBy )
		output inserted.DocumentID
		,      inserted.DocumentVersionId
		into @NewDocumentVersions ( DocumentId
		,                           DocumentVersionId )
	select nd.DocumentId
	,      1
	,      d.AuthorId
	,      d.EffectiveDate
	,      'SYSTEM'
	,      'SYSTEM'
	from @NewDocuments as nd
	join dbo.Documents as d  on nd.DocumentId = d.DocumentId

	-- Set Document Current and InProgress DocumentVersionIDs ...
	update doc
	set CurrentDocumentVersionId    = ndv.DocumentVersionId
	,   InProgressDocumentVersionId = ndv.DocumentVersionId
	from dbo.Documents        as doc
	join @NewDocumentVersions as ndv on doc.DocumentId = ndv.DocumentId
end

GO


