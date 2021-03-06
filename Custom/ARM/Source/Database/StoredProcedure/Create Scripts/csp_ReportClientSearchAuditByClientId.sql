/****** Object:  StoredProcedure [dbo].[csp_ReportClientSearchAuditByClientId]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientSearchAuditByClientId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportClientSearchAuditByClientId]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportClientSearchAuditByClientId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE procedure [dbo].[csp_ReportClientSearchAuditByClientId]
(@ClientId	int, @SearchStartDate	datetime, 	@SearchEndDate		datetime )

as
/*
--select * from staff where active=''Y'' order by lastname
Declare @ClientId	int,
		@SearchStartDate	datetime,
		@SearchEndDate		datetime

Select	@ClientId = 30,
		@SearchStartDate = ''1/1/2009'',
		@SearchEndDate = Getdate()
*/

declare @Results table ( Staff varchar(80), Client varchar(80), SearchDate datetime, LastName varchar(50), FirstName varchar(30), ClientId int, 
	DOB datetime, SSN varchar(15), MedicaidId varchar(20), ClientSelected varchar(1), PopClientId int, Population varchar(7) )

declare @SAProgramId int 
set @SAProgramId = 1000000000000

Begin	--Search Info--	
insert into @Results
(Staff, Client, SearchDate, LastName, FirstName, ClientId, DOB, SSN, MedicaidId, ClientSelected, PopClientId)
Select	s.LastName+'', ''+s.FirstName as Staff, 
		c.LastName+'', ''+c.FirstName as Client, 
		csa.SearchDate,
		csa.LastName,
		csa.FirstName,	
		csa.ClientID,csa.DOB,csa.SSN,csa.MedicaidID,
		cva.ClientSelected, --, csa.*,cva.*
		c.ClientId
From ClientSearchAudits csa
	Join ClientViewAudits cva on cva.SearchId = csa.SearchId
	Join Staff s on s.StaffId = csa.Staffid
	Join Clients c on c.ClientId = cva.ClientId
where isnull(cva.ClientSelected,''N'') = ''Y''
and (@ClientId = cva.ClientId or @ClientId is null)
and (dbo.RemoveTimestamp(csa.SearchDate) >= @SearchStartDate 
	and dbo.RemoveTimestamp(csa.SearchDate) <= @SearchEndDate)


update r
set Population = case when exists ( select * from clientPrograms cp where cp.ProgramId = @SAProgramId 
	and cp.ClientId = r.PopClientId
	and ( isnull(cp.EnrolledDate,cp.RequestedDate) <= r.SearchDate and (cp.DischargedDate <= r.SearchDate or cp.DischargedDate is null) )
	and exists ( select * from clientPrograms cp2 where cp2.ProgramId <> @SAProgramId
		and cp2.ClientId = r.PopClientId
		and ( isnull(cp2.EnrolledDate,cp.RequestedDate) <= r.SearchDate and (cp2.DischargedDate <= r.SearchDate or cp2.DischargedDate is null) )
	)
)then ''Both'' 
when exists ( select * from clientPrograms cp where cp.ProgramId = @SAProgramId 
	and cp.ClientId = r.PopClientId
	and ( isnull(cp.EnrolledDate,cp.RequestedDate) <= r.SearchDate  and (cp.DischargedDate <= r.SearchDate  or cp.DischargedDate is null) ) 
	and not exists ( select * from clientPrograms cp2 where cp2.ProgramId <> @SAProgramId
		and cp2.ClientId = r.PopClientId
		and ( isnull(cp2.EnrolledDate,cp.RequestedDate) <= r.SearchDate  and (cp2.DischargedDate <= r.SearchDate  or cp2.DischargedDate is null) )
		)
) then ''SA''
when exists ( select * from clientPrograms cp where cp.ProgramId <> @SAProgramId 
	and cp.ClientId = r.PopClientId
	and ( isnull(cp.EnrolledDate,cp.RequestedDate) <= r.SearchDate  and (cp.DischargedDate <= r.SearchDate  or cp.DischargedDate is null) )
	and not exists ( select * from clientPrograms cp2 where cp2.ProgramId = @SAProgramId
		and cp2.ClientId = r.PopClientId
		and ( isnull(cp2.EnrolledDate,cp.RequestedDate) <= r.SearchDate  and (cp2.DischargedDate <= r.SearchDate  or cp2.DischargedDate is null) )
		)
) then ''MH''
else ''UNKN'' end
from @Results r


--select top 1 * from ClientPrograms


select 
r.Staff, 
r.Client, 
r.SearchDate, 
r.LastName, 
r.FirstName, 
r.ClientId, 
r.DOB, 
r.SSN, 
r.MedicaidId, 
r.ClientSelected, 
r.PopClientId,
r.Population
from @Results r

end

/*
		-- Search Date formating -- 
		convert(varchar(10),csa.SearchDate,101) +'' ''+
		case when datepart(hour,csa.SearchDate) > 12 
				then convert(varchar(2),(datepart(hour,csa.SearchDate)-12)) 
			when datepart(hour,csa.SearchDate) < 1 
				then ''12'' 
		else convert(varchar(2),(datepart(hour,csa.SearchDate))) end 
		+ '':''+ 
		case when datepart(minute,csa.SearchDate) < 10 
				then ''0'' 
		else '''' end 
		+ convert(char(2),datepart(minute, csa.SearchDate)) +'' ''+ 
		case when datepart(hour,csa.SearchDate) > 12 
			then ''PM''
		else ''AM'' end as SearchDate,





*/
' 
END
GO
