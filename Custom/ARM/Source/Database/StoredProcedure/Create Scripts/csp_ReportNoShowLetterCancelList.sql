/****** Object:  StoredProcedure [dbo].[csp_ReportNoShowLetterCancelList]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportNoShowLetterCancelList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportNoShowLetterCancelList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportNoShowLetterCancelList]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_ReportNoShowLetterCancelList]
	@run_date datetime,
	@location varchar(24)
/************************************************************************/
/* SUMMIT POINTE Customization						*/
/* This procedure runs the no-show potential cancel list.  Called as a	*/
/* sub report from the no-show letter in Reporting Services.		*/
/************************************************************************/

as

DECLARE @results TABLE
(
	SysComment 	VARCHAR(2000) null,
	ServiceId int null,
	ClientId	int null,
	CustomerName	VARCHAR(128) null,
	ClinicianName	VARCHAR(128) null,
	ClientAddress	VARCHAR(2000) null,
	DateOfService	DATETIME null,
	ReportRunDate	DATETIME null,
	PrintSection	TINYINT null,
	AlreadyRun	varchar(10),
	Author		varchar(24)
)

--
-- Get all customers previously run but now 10 or more days after run date
--
insert into @results (ServiceId, ClientId, CustomerName, ClinicianName, DateOfService, ReportRunDate, PrintSection)
SELECT
	l.ServiceId,
	l.ClientId,
	c.FirstName + '' '' + c.LastName,
	st.FirstName + '' '' + st.LastName,
	s.DateOfService,
	l.ReportRunDate,
	3
from Cstm_NoShowReportTracking as l
join Clients as c on (c.ClientId = l.ClientId)
join Services as s on (s.ServiceId = l.ServiceId)
join staff as st ON (st.StaffId = s.ClinicianId)
join Programs as p on (p.ProgramId = s.ProgramId)
WHERE
((l.PotentialCancelPrintDate IS NULL) OR (datediff(day, @run_date, l.PotentialCancelPrintDate) = 0))
and (
	(@location = ''al'' and p.ProgramName = ''Outpatient Services - Albion'' )	
	or
	(@location = ''lv'' and p.ProgramName = ''Outpatient Services - Lakeview'')	
	or
	(@location = ''bc'' and p.ProgramName = ''Outpatient Services - Downtown'')
)
and datediff(day, l.ReportRunDate, @run_date) >= 10	

UPDATE l SET
	PotentialCancelPrintDate = @run_date
FROM Cstm_NoShowReportTracking AS l
JOIN @results AS r ON (r.ServiceId = l.ServiceId)
WHERE
	r.PrintSection = 3
	AND
	l.PotentialCancelPrintDate IS NULL

select * from @results order by ClinicianName, CustomerName
' 
END
GO
