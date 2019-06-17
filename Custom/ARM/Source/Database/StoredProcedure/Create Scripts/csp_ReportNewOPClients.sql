/****** Object:  StoredProcedure [dbo].[csp_ReportNewOPClients]    Script Date: 04/18/2013 11:08:37 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportNewOPClients]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportNewOPClients]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportNewOPClients]    Script Date: 04/18/2013 11:08:37 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[csp_ReportNewOPClients]
(
@StartDate datetime, @EndDate datetime,  @Frequency int, @Interval varchar(5)
)

as
/*
Modified Date	Modified By		Reason
04/28/2009		avoss			created

--Testing
declare @StartDate datetime, @EndDate datetime, @Interval varchar(5), @Frequency int

set @StartDate = '1/1/2009'
set @EndDate = dateAdd(dd, 60, @StartDate)
set @interval = 'Month'
set @Frequency = 1
*/

set @Frequency = -@Frequency


declare @OPPrograms table ( ProgramId int )
insert into @OPPrograms
select programId from programs where programId in ( 12, 13, 14 )

--select * from programs
declare @Services table ( clientId int, FirstOPService datetime )
insert into @Services 
select s.ClientId, min(s.DateOfService) as FirstOPService
from services s
where isnull(s.RecordDeleted, 'N')<>'Y'
and s.ProgramId in ( select programId from @OPPrograms )
and s.DateOfService >= @StartDate
and s.DateOfService <= @EndDate
group by s.ClientId

select 
	1 as ReportGroup,
	ClientId, 
	FirstOPService 
from @services a
where not exists ( select * from services s
	where isnull(s.RecordDeleted,'N')<>'Y'
	and s.ClientId = a.ClientId 	
	and s.DateOfService < a.FirstOPService 
	and s.ProgramId in ( select programId from @OPPrograms )
	and (( @Interval = 'Year' and s.DateOfService > dateadd(year, @Frequency, a.FirstOPService) ) or
		 ( @Interval = 'Month' and s.DateOfService > dateadd(month, @Frequency, a.FirstOPService) ))
	)



GO

