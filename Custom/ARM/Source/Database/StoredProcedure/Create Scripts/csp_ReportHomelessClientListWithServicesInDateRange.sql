/****** Object:  StoredProcedure [dbo].[csp_ReportHomelessClientListWithServicesInDateRange]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportHomelessClientListWithServicesInDateRange]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportHomelessClientListWithServicesInDateRange]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportHomelessClientListWithServicesInDateRange]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE procedure [dbo].[csp_ReportHomelessClientListWithServicesInDateRange]

( @StartDate datetime, @EndDate datetime )

as 

/*
--select * from globalCodes where category = ''LIVINGARRANGEMENT''
modified date	Modified By		Reason
12.07.2010		avoss			created

declare @HomelessId int,@StartDate datetime, @EndDate datetime 
select @HomelessId = 10064, @StartDate = ''10/1/2009'', @EndDate = ''10/1/2010''

exec dbo.csp_ReportHomelessClientListWithServicesInDateRange @StartDate, @EndDate  
*/

declare @HomelessId int
select @HomelessId = 10260


select c.ClientId , c.Active
into #Homeless
From Clients c with(nolock) 
join globalcodes gc with(nolock) on gc.GlobalCodeID = c.LivingArrangement
where gc.GlobalCodeId = @HomelessId
and isnull(c.RecordDeleted,''N'')<>''Y''

select distinct h.ClientId, h.Active 
from #Homeless H 
join services s with(nolock) on s.ClientId = h.ClientId and s.DateOfService >= @StartDate
	and s.DateOfService < @EndDate
	and isnull(s.RecordDeleted,''N'') <> ''Y''
	and s.Status in (  71, 75 )


drop table #Homeless
' 
END
GO
