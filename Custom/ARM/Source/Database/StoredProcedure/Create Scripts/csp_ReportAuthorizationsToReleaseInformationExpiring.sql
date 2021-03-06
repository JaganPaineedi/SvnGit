/****** Object:  StoredProcedure [dbo].[csp_ReportAuthorizationsToReleaseInformationExpiring]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportAuthorizationsToReleaseInformationExpiring]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportAuthorizationsToReleaseInformationExpiring]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportAuthorizationsToReleaseInformationExpiring]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_ReportAuthorizationsToReleaseInformationExpiring]

( @DaysUntilExpired int )

as

/*
Modified By		Modified Date	Reason
avoss			10.25.2011		Created

exec csp_ReportAuthorizationsToReleaseInformationExpiring 30
*/


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

Declare @Title varchar(max)
Declare @SubTitle varchar(max)
declare @Comment varchar(max)

Set @Title = ''Expiring Authroizations to Release Information''
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

declare @Today datetime, @Yesterday datetime
set @Today = dbo.RemoveTimestamp(getdate())
set @Yesterday = dateadd(dd,-1,@Today)

declare @RepId int
select @RepId = 52


select 
	c.ClientId, 
	c.Firstname + '' '' + c.lastname as ClientName,
	isnull(c.PrimaryClinicianId,@RepId) as PrimaryClinicianId,
	case when c.PrimaryClinicianId is null then ''(No Primary Clinician)'' 
		else prc.Firstname + '' '' + prc.lastname end as PrimaryClinician, 
	cir.StartDate,
	cir.EndDate,
	cir.ReleaseToName,
	cir.DocumentAttached,
	datediff(dd,@Today,cir.EndDate) as DaysUntilExpired,
	cir.Comment
into #Report
From clients c 
join ClientInformationReleases cir on cir.ClientId = c.ClientId and isnull(cir.RecordDeleted,''N'')<>''Y''
left join staff prc on prc.StaffId = isnull(c.PrimaryClinicianId,@RepId) and prc.Active=''Y''
where datediff(dd,@Today,cir.EndDate) < @DaysUntilExpired
and not exists ( select 1 from ClientInformationReleases cir2 
	where cir2.ClientId = cir.ClientId
	and ( cir2.ReleaseToId = cir.ReleaseToId 
		or ltrim(rtrim(cir2.ReleaseToName)) = ltrim(rtrim(cir.ReleaseToName))
		)
	and isnull(cir2.RecordDeleted,''N'')<>''Y''
	and cir2.EndDate > cir.EndDate
)

		

-------------------------------------

If exists (select 1 from #Report)
	begin 
		select r.*, @StoredProcedure as StoredProcedure, c.ReportName, c.Title, c.SubTitle, c.Comment
		from #Report r 
		join CustomReportParts c on c.StoredProcedure = @StoredProcedure
		order by EndDate desc, ClientId
	end
else 
		select @Title, @SubTitle, @Comment

drop table #Report

--select *  From CustomReportParts 

SET TRANSACTION ISOLATION LEVEL READ COMMITTED

' 
END
GO
