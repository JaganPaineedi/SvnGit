/****** Object:  StoredProcedure [dbo].[csp_ReportReleaseOfInformationExpiring]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportReleaseOfInformationExpiring]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportReleaseOfInformationExpiring]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportReleaseOfInformationExpiring]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE Procedure [dbo].[csp_ReportReleaseOfInformationExpiring]

@DaysUntilExpiration int


as
/*
modified by		modifided date		reason
avoss			08.25.2011			created
jschultz		09.1.2011			revised

exec dbo.csp_ReportReleaseOfInformationExpiring

*/


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

declare @Today datetime, @Yesterday datetime
set @Today = dbo.RemoveTimestamp(getdate())
set @Yesterday = dateadd(dd,-1,@Today)

declare @RepId int, @StartDate datetime
select @RepId = 52, @StartDate = ''12/1/2011''

select cir.ReleaseToName,
	convert(varchar(12),cir.EndDate,101),	
	c.ClientId, 
	c.Firstname + '' '' + c.lastname as ClientName,
	isnull(c.PrimaryClinicianId,@RepId) as PrimaryClinicianId,
	case when c.PrimaryClinicianId is null 
		then ''(No Primary Clinician)'' 
		else prc.Firstname + '' '' + prc.lastname 
	end as PrimaryClinician,  
	datediff(dd,@Today,cir.EndDate) as DaysUntilExpired,
	cir.ClientInformationReleaseId,
	cir.Startdate,
	cir.Enddate
From clients c 
join ClientInformationReleases cir on cir.ClientId = c.ClientId and isnull(cir.RecordDeleted,''N'')<>''Y''
left join staff prc on prc.StaffId = isnull(c.PrimaryClinicianId,@RepId) and prc.Active=''Y''
where datediff(dd,@Today,cir.EndDate) < @DaysUntilExpiration
	and not exists ( select 1 from ClientInformationReleases cir2 
		where cir2.ClientId = cir.ClientId
		and (cir2.ReleaseToId = cir.ReleaseToId 
		or ltrim(rtrim(cir2.ReleaseToName)) = ltrim(rtrim(cir.ReleaseToName))
		)
	and isnull(cir2.RecordDeleted,''N'')<>''Y''
	and cir2.EndDate > cir.EndDate)


SET TRANSACTION ISOLATION LEVEL READ COMMITTED

--select * from ClientInformationReleases

--insert into ClientInformationReleases
--(ClientId, ReleaseToId, ReleaseToName, StartDate, EndDate, Comment, DocumentAttached, RowIdentifier)
--Values
--(114681, 83553, ''Putman, David'', GETDATE(), ''201-09-15'', null, null, NEWID())
' 
END
GO
