/****** Object:  StoredProcedure [dbo].[csp_ReportDisclosureStatus]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDisclosureStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportDisclosureStatus]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportDisclosureStatus]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure [dbo].[csp_ReportDisclosureStatus]

( @DisclosureStatus int, @StartDate datetime, @EndDate datetime )

as

/*
Modified By		Modified Date	Reason
avoss			10.25.2011		Created
wbutt			10.17.2012		Completed
wbutt			10.24.2012		Update date to match request date instead of disclosure date

declare @DisclosureStatus int, @StartDate datetime, @EndDate datetime
set @DisclosureStatus = 21907 --Harbor Clinician Approved

select @StartDate = ''1/1/2010'', @EndDate = getdate()

exec csp_ReportDisclosureStatus  @DisclosureStatus, @StartDate , @EndDate
*/


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @Title varchar(max)
Declare @SubTitle varchar(max)
declare @Comment varchar(max)

Set @Title = ''Disclosure Status Report''
Set @SubTitle = '''' 
set @Comment = ''''


DECLARE @StoredProcedure varchar(300)
SET @StoredProcedure = object_name(@@procid)

IF @StoredProcedure is not NULL
and not exists (Select 1 From CustomReportParts 
				Where StoredProcedure = @StoredProcedure
				)
	BEGIN
		INSERT into CustomReportParts (StoredProcedure, ReportName, Title, SubTitle, Comment)
		Select @StoredProcedure, @Title, @Title, @SubTitle, @Comment
	END
Else
	BEGIN
		UPDATE CustomReportParts
		SET ReportName = @Title
			, Title = @Title
			, SubTitle = @SubTitle
			, Comment = @Comment
		WHERE StoredProcedure = @StoredProcedure
	END


select 
 cd.ClientId
,cd.RequestDate
,c.LastName+ '', '' + c.FirstName as ClientName
,cd.RequestFromName
,isnull(gc.CodeName,'''') as RequestFromRelationship
,isnull(cd.Charges,0.00) as Charges
,isnull(cd.Payments,0.00) as Payments 
,isnull(gc2.CodeName,'''') as DisclosureStatus
,cd.DisclosureDate
,s.LastName+ '', '' + s.FirstName as DisclosedBy
,gc3.CodeName as DiscolsureType
,isnull(cd.DisclosureTypeDescription,'''') as DisclosureTypeDescription
,gc4.CodeName as DisclosurePurpose
,isnull(cd.DisclosurePurposeDescription,'''') as DisclosurePurposeDescription
,cir.ReleaseToName as ClientInformationReleaseToName
,cd.DisclosedToName
,gc5.CodeName as DisclosedToDeliveryType
,cd.Comments
,cd.NameAddress
,cd.CoverLetterComment
into #Report
from ClientDisclosures cd
join Staff s on s.StaffId = cd.DisclosedBy
join Clients c on c.ClientId = cd.ClientId
left join ClientContacts cc on cc.ClientContactId = cd.RequestFromId
left join GlobalCodes gc on gc.GlobalCodeId = cc.Relationship
left join GlobalCodes gc2 on gc2.GlobalCodeId = cd.DisclosureStatus
left join GlobalCodes gc3 on gc3.GlobalCodeId = cd.DisclosureType
left join GlobalCodes gc4 on gc4.GlobalCodeId = cd.DisclosurePurpose
left join GlobalCodes gc5 on gc5.GlobalCodeId = cd.DisclosedToDeliveryType
left join ClientInformationReleases cir on cir.ClientInformationReleaseId = cd.ClientInformationReleaseId
left join ClientContacts cc2 on cc2.ClientContactId = cd.DisclosedToId
left join GlobalCodes gc6 on gc6.GlobalCodeId = cd.DisclosureStatus
where isnull(cd.RecordDeleted,''N'') = ''N''
and cd.DisclosureStatus = @DisclosureStatus
and cd.RequestDate >= @StartDate 
and ( cd.RequestDate <= @EndDate or @EndDate is null )

-------------------------------------

If exists (select 1 from #Report)
	begin 
		select *, @StoredProcedure as StoredProcedure
		from #Report
		order by DisclosureDate, ClientId
	end
else 
		select @Title, @SubTitle, @Comment

drop table #Report



SET TRANSACTION ISOLATION LEVEL READ COMMITTED

' 
END
GO
