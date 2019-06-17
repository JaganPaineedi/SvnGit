/****** Object:  StoredProcedure [dbo].[csp_ReportSummitBoardReportClientsServedOver65]    Script Date: 04/18/2013 12:07:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportSummitBoardReportClientsServedOver65]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportSummitBoardReportClientsServedOver65]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportSummitBoardReportClientsServedOver65]    Script Date: 04/18/2013 12:07:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE			Procedure [dbo].[csp_ReportSummitBoardReportClientsServedOver65]
@Start_Date		datetime,
@End_Date		datetime,
@Affiliate_Id	int,
@Source         int
AS

/*
declare @Start_Date		datetime,
@End_Date		datetime,
@Affiliate_Id	int,
@Source         int

set @start_date = '10/1/2006'
set @End_date = '09/30/2007'
set @affiliate_id = 100
set @source = NULL
*/


Select count(distinct c.patient_id) as ClientsServed,
'' as Comment
--program_name,  count(distinct c.patient_id)
from Client c
Join Service s on c.patient_id = s.patient_id and s.episode_id = c.episode_id 
where s.date_of_service >= @Start_Date and s.date_of_service <= @End_Date
and c.Affiliate_id = (@Affiliate_Id)
and s.Affiliate_id = @Affiliate_id
and dbo.GetAge(c.dob, s.date_of_service) >= 65
--and s.program_name not in ('Bridges', 'Crisis On Call', 'Connections - VA', 'Connections','INPATIENT', 'Medical Services - Inpatient' )
and s.Status in ('SH', 'CO')
and (
	((@Source) = 1 and s.Source_System = 'PM' and s.Billable = 'Y')
	or ((@Source) = 2 and s.Source_System = 'CM' and isnull(s.External_payments, 0) <> 0)
	or ((@Source) is NULL and ((s.Source_System = 'PM' and s.Billable = 'Y')or (s.Source_System = 'CM' and isnull(s.External_payments, 0) <> 0)))
	)
--group by program_name


--select distinct program_name
--from service
--where affiliate_id = 100
--and date_of_service >= '10/1/2006'
--and date_of_service <= '10/1/2008'
--order by program_name




/*
for board report for Reporting Services
declare 
@FY1 int, @FY2 int, @Age int,
@Affiliate_Id	int,
@Source         int

/**/
--set for now remove if passed
select @affiliate_id = 100, @source = NULL, @FY1 = 2007, @FY2  = 2008, @Age = 65

Declare 
@FY1StartDate datetime, @FY1EndDate datetime, 
@FY1Label varchar(50),
@FY2StartDate datetime, @FY2EndDate datetime, 
@FY2Label varchar(50)

select 
@FY1StartDate = '10/1/' + convert(varchar(4),@FY1 - 1), 
@FY1EndDate = '9/30/' + convert(varchar(4),@FY1),
@FY1Label = 'FY ' + convert(varchar(4),@FY1 - 1) + ' / ' + convert(varchar(4),@FY1),
@FY2StartDate = '10/1/' + convert(varchar(4),@FY2 - 1), 
@FY2EndDate = '9/30/' + convert(varchar(4),@FY2),
@FY2Label = 'FY ' + convert(varchar(4),@FY2 - 1)+ ' / ' + convert(varchar(4),@FY2)

declare @FY1Table table(ClientsServed int)
declare @FY2Table table(ClientsServed int)

--FY1
insert into @FY1Table
Select count(distinct c.patient_id) as ClientsServed
from Client c
Join Service s on c.patient_id = s.patient_id and s.episode_id = c.episode_id 
where s.date_of_service >= @FY1StartDate and s.date_of_service <= @FY1EndDate
and c.Affiliate_id = (@Affiliate_Id)
and s.Affiliate_id = @Affiliate_id
and dbo.GetAge(c.dob, s.date_of_service) >= @Age
and s.Status in ('SH', 'CO')
and (
	((@Source) = 1 and s.Source_System = 'PM' and s.Billable = 'Y')
	or ((@Source) = 2 and s.Source_System = 'CM' and isnull(s.External_payments, 0) <> 0)
	or ((@Source) is NULL and ((s.Source_System = 'PM' and s.Billable = 'Y')or (s.Source_System = 'CM' and isnull(s.External_payments, 0) <> 0)))
	)



insert into @FY2Table
Select count(distinct c.patient_id) as ClientsServed
from Client c
Join Service s on c.patient_id = s.patient_id and s.episode_id = c.episode_id 
where s.date_of_service >= @FY2StartDate and s.date_of_service <= @FY2EndDate
and c.Affiliate_id = (@Affiliate_Id)
and s.Affiliate_id = @Affiliate_id
and dbo.GetAge(c.dob, s.date_of_service) >= @Age
and s.Status in ('SH', 'CO')
and (
	((@Source) = 1 and s.Source_System = 'PM' and s.Billable = 'Y')
	or ((@Source) = 2 and s.Source_System = 'CM' and isnull(s.External_payments, 0) <> 0)
	or ((@Source) is NULL and ((s.Source_System = 'PM' and s.Billable = 'Y')or (s.Source_System = 'CM' and isnull(s.External_payments, 0) <> 0)))
	)


select 
'Clients Served Over Age ' +  Convert(varchar(3),@Age) as AgeGroup, 
fy1.ClientsServed,
@FY1Label as FiscalYear
from @FY1Table fy1
union all
select 
'Clients Served Over Age ' + Convert(varchar(3),@Age) as AgeGroup, 
fy2.ClientsServed,
@FY2Label as FiscalYear
from @FY2Table fy2

*/

GO

