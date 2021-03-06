/****** Object:  StoredProcedure [dbo].[csp_InitializeRecordReviewItemDetails]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeRecordReviewItemDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_InitializeRecordReviewItemDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_InitializeRecordReviewItemDetails]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE proc  [dbo].[csp_InitializeRecordReviewItemDetails]  --92,1,''<Root><Parameters RecordReviewTemplateId="77" RecordReviewId="342" clientId="100" ReviewedByStaffId="92" ReviewedStaffId="86" AssignedDate=""   ></Parameters></Root>''


 @StaffId int,
 @ClientID int,
 @CustomParameters xml

AS

/*********************************************************************/
/* Stored Procedure: dbo.csp_InitializeRecordReviewItemDetails                */
/* Copyright: 2005 Streamline Healthcare Solutions,  LLC             */
/* Creation Date:    03/June/2011                                         */
/*                                                                   */
/* Purpose:  Used to display records for any RecordReviewTemplate in order to insert new review  */
/*                                                                   */
/* Input Parameters:   @@StaffId , @@ClientID , @CustomParameters     */
/*                                                                   */
/* Output Parameters:   None                */
/*                                                                   */
/* Return:  0=success, otherwise an error number                     */
/*                                                                   */
/* Called By:                                                        */
/*                                                                   */
/* Calls:                                                            */
/*                                                                   */
/* Data Modifications:                                               */
/*                                                                   */
/* Updates:                                                          */
/*  Date         Author          Purpose                             */
/* 03/june/2011   Karan Garg      Created                             */
/* 2011.08.28	T. Remisosi		Corrected and revised.				*/

/*********************************************************************/
BEGIN
BEGIN TRY
begin tran

SET ARITHABORT ON
 declare @RecordReviewTemplateId int
 declare @RecordReviewId int
 declare @documentclientId int = null
 declare @ReviewedByStaffId int = null
 declare @ReviewedStaffId int = null
 declare @AssignedDate datetime = null
 declare @StringAnswer varchar(max)
 declare @StringDocumentVersionId varchar(max)
 declare @Answer varchar(3)
 declare @DocumentVersionId varchar(max)
 declare @totalRows int

 
declare @tabDocumentVersions table (
	DocumentVersionId int
)

 
 SET @RecordReviewId = @CustomParameters.value(''(/Root/Parameters/@RecordReviewId)[1]'', ''int'' )

 select @RecordReviewTemplateId = RecordReviewTemplateId, @documentclientId = ClientId, @ReviewedByStaffId = ReviewingStaff,
	@ReviewedStaffId = ClinicianReviewed, @AssignedDate = AssignedDate
from CustomRecordReviews
where RecordReviewId = @RecordReviewId

-- this is no longer needed
    /*********************    Table CustomRecordReviews ********************/
--   SELECT ''CustomRecordReviews'' as TableName,
--   [RecordReviewId]
--    ,CustomRecordReviews.[CreatedBy]
--    ,CustomRecordReviews.[CreatedDate]
--,CustomRecordReviews.[ModifiedBy]
--    ,CustomRecordReviews.[ModifiedDate]
--    ,CustomRecordReviews.[RecordDeleted]
--    ,CustomRecordReviews.[DeletedDate]
--    ,CustomRecordReviews.[DeletedBy]
--    ,CustomRecordReviews.[RecordReviewTemplateId]
--    ,[ReviewingStaff]
--    ,[ClinicianReviewed]
--    ,CustomRecordReviews.[ClientId]
--    ,[Status]
--    ,[AssignedDate]
--    ,[CompletedDate]
--    ,[ReviewComments]
--    ,[Results]
--    ,[RequestQIReview]  ,

--    Clients.LastName+'', ''+Clients.FirstName as ClientName,
--    CustomRecordReviewTemplates.RecordReviewTemplateName as TemplateName,
--    s1.LastName+'' ''+s1.FirstName as ReviewingStaffName,
--    s2.LastName+'' ''+s2.FirstName as ClinicianReviewedName


--    from CustomRecordReviews inner join
--    CustomRecordReviewTemplates on
--  CustomRecordReviews.RecordReviewTemplateId = CustomRecordReviewTemplates.RecordReviewTemplateId
--  inner join Staff s1 on CustomRecordReviews.ReviewingStaff = s1.StaffId
--  inner join Staff s2 on CustomRecordReviews.ClinicianReviewed = s2.StaffId
--  inner join Clients on Clients.ClientId = CustomRecordReviews.ClientId

--     where RecordReviewId = @RecordReviewId

   /********************** Table CustomRecordReviewItems ********************/

declare @tabRecordReviewItemIdentifiers table (
	newRecordReviewItemId int
)

declare @tabEvaluationResults table (
	EvalResult char(1)
)

--select * from CustomRecordReviewTemplateItems
declare 
	@RecordReviewTemplateItemId int,
	@Section varchar(100),
	@ItemNumber int,
	@Prompt type_Comment2,
	@HelpText type_Comment2,
	@SQLToEvaluateItem type_Comment2,
	@SQLToFindReferences type_Comment2,
	@NAResponseAllowed type_YOrN,
	@NotifyQAIfAnswerIsNo type_YOrN,
	@ReviewStatusUnacceptableIfAnswerNo type_YOrN

declare @RecordReviewItemId int

declare @cRecordReviewTemplateItems cursor 

set @cRecordReviewTemplateItems = cursor for
select
	RecordReviewTemplateItemId,
	Section,
	ItemNumber,
	Prompt,
	HelpText,
	SQLToEvaluateItem,
	SQLToFindReferences,
	NAResponseAllowed,
	NotifyQAIfAnswerIsNo,
	ReviewStatusUnacceptableIfAnswerNo
from CustomRecordReviewTemplateItems
where RecordReviewTemplateId = @RecordReviewTemplateId
and isnull(RecordDeleted, ''N'') <> ''Y''

open @cRecordReviewTemplateItems

fetch @cRecordReviewTemplateItems into
	@RecordReviewTemplateItemId,
	@Section,
	@ItemNumber,
	@Prompt,
	@HelpText,
	@SQLToEvaluateItem,
	@SQLToFindReferences,
	@NAResponseAllowed,
	@NotifyQAIfAnswerIsNo,
	@ReviewStatusUnacceptableIfAnswerNo


while @@FETCH_STATUS = 0
begin
	-- clear scratch tables
	delete from @tabRecordReviewItemIdentifiers
	delete from @tabDocumentVersions
	delete from @tabEvaluationResults
	
	-- create the CustomRecordReviewItems record
	insert into CustomRecordReviewItems (
		RecordReviewId,
		RecordReviewTemplateItemId
	)
	output inserted.RecordReviewItemId into @tabRecordReviewItemIdentifiers (newRecordReviewItemId)
	values (
		@RecordReviewId,
		@RecordReviewTemplateItemId
	)
	
	select @RecordReviewItemId = newRecordReviewItemId from @tabRecordReviewItemIdentifiers
	
	-- get the reference documents, if any
	if @SQLToFindReferences is not null
	begin
		
		set @SQLToFindReferences = replace(replace(@SQLToFindReferences, ''&lt;'', ''<''), ''&gt;'', ''>'')
		set @SQLToFindReferences = replace(@SQLToFindReferences, ''<ClientId>'', @documentclientId)
		set @SQLToFindReferences = replace(@SQLToFindReferences, ''<ReviewedByStaffId>'', @ReviewedByStaffId)
		set @SQLToFindReferences = replace(@SQLToFindReferences, ''<ReviewedStaffId>'', @ReviewedStaffId)
		set @SQLToFindReferences = replace(@SQLToFindReferences, ''<AssignedDate>'', ''''''''+CAST(@AssignedDate as varchar(30))+'''''''')

	 
		insert into @tabDocumentVersions (DocumentVersionId)
		exec(@SQLToFindReferences)
	
	end

	-- assign document versions in order of DocumentVersionId
	update a set
		a.DocumentVersionId1 = t.DocumentVersionId
	from CustomRecordReviewItems as a
	cross join @tabDocumentVersions as t
	where a.RecordReviewId = @RecordReviewId
	and 0 = (select COUNT(*) from @tabDocumentVersions as t2 where t2.DocumentVersionId < t.DocumentVersionId)
	
	update a set
		a.DocumentVersionId2 = t.DocumentVersionId
	from CustomRecordReviewItems as a
	cross join @tabDocumentVersions as t
	where a.RecordReviewId = @RecordReviewId
	and 1 = (select COUNT(*) from @tabDocumentVersions as t2 where t2.DocumentVersionId < t.DocumentVersionId)

	update a set
		a.DocumentVersionId3 = t.DocumentVersionId
	from CustomRecordReviewItems as a
	cross join @tabDocumentVersions as t
	where a.RecordReviewId = @RecordReviewId
	and 2 = (select COUNT(*) from @tabDocumentVersions as t2 where t2.DocumentVersionId < t.DocumentVersionId)

	-- now get the answer
	
	if @SQLToEvaluateItem is not null
	begin
		set @SQLToEvaluateItem = replace(replace(@SQLToEvaluateItem, ''&lt;'', ''<''), ''&gt;'', ''>'')
		set @SQLToEvaluateItem = replace(@SQLToEvaluateItem, ''<ClientId>'', @documentclientId)
		set @SQLToEvaluateItem = replace(@SQLToEvaluateItem, ''<ReviewedByStaffId>'', @ReviewedByStaffId)
		set @SQLToEvaluateItem = replace(@SQLToEvaluateItem, ''<ReviewedStaffId>'', @ReviewedStaffId)
		set @SQLToEvaluateItem = replace(@SQLToEvaluateItem, ''<AssignedDate>'', ''''''''+CAST(@AssignedDate as varchar(30))+'''''''')
	
		insert into @tabEvaluationResults(EvalResult)
		exec(@SQLToEvaluateItem)
		
		update a set
			a.Answer = t.EvalResult
		from CustomRecordReviewItems as a
		cross join @tabEvaluationResults as t
		where a.RecordReviewId = @RecordReviewId
		
	end
	
	fetch @cRecordReviewTemplateItems into
		@RecordReviewTemplateItemId,
		@Section,
		@ItemNumber,
		@Prompt,
		@HelpText,
		@SQLToEvaluateItem,
		@SQLToFindReferences,
		@NAResponseAllowed,
		@NotifyQAIfAnswerIsNo,
		@ReviewStatusUnacceptableIfAnswerNo


end

close @cRecordReviewTemplateItems

deallocate @cRecordReviewTemplateItems

commit tran


END TRY
BEGIN CATCH

if @@TRANCOUNT = 1 rollback tran

DECLARE @Error varchar(8000)
   SET @Error= Convert(varchar,ERROR_NUMBER()) + ''*****'' + Convert(varchar(4000),ERROR_MESSAGE())
   + ''*****'' + isnull(Convert(varchar,ERROR_PROCEDURE()),''csp_InitializeRecordReviewItemDetails'')
   + ''*****'' + Convert(varchar,ERROR_LINE()) + ''*****'' + Convert(varchar,ERROR_SEVERITY())
   + ''*****'' + Convert(varchar,ERROR_STATE())

   RAISERROR
   (
    @Error, -- Message text.
    16, -- Severity.
    1 -- State.
   );
End CATCH

End

' 
END
GO
