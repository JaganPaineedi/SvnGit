/****** Object:  StoredProcedure [dbo].[csp_ReportNoShowLetter]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportNoShowLetter]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportNoShowLetter]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportNoShowLetter]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE        procedure [dbo].[csp_ReportNoShowLetter]
	@run_date datetime,
	@location varchar(24),
	@your_initials varchar(24)
/************************************************************************/
/* SUMMIT POINTE Customization						*/
/* This procedure runs the no-show letter for Summit Pointe''s		*/
/* Practice Management system.						*/
/************************************************************************/


AS
DECLARE @already_run varchar(10)
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
-- Check that today''s date is not entered
--

IF datediff(day, @run_date, getdate()) <= 0
GOTO cur_date

set @already_run = null

--
-- Check for previous run
--
if exists ( 
select *
from Cstm_NoShowReportTracking as l
join Services as s on (s.ServiceId = l.ServiceId)
join Programs as p on (p.ProgramId = s.ProgramId)
where
	datediff(day, @run_date, l.ReportRunDate) = 0
	and
	(
		(@location = ''al'' and p.ProgramName = ''Outpatient Services - Albion'' )	
		or
		(@location = ''lv'' and p.ProgramName = ''Outpatient Services - Lakeview'')	
		or
		(@location = ''bc'' and p.ProgramName = ''Outpatient Services - Downtown'')
	)
)
begin

	set @already_run = ''already_run''

end

--
-- Get all customers who have not yet had a leter printed
--
insert into @results (ServiceId, AlreadyRun, ClientId, CustomerName, ClinicianName, DateOfService, PrintSection, Author)
SELECT
	l.ServiceId,
	@already_run,
	l.ClientId,
	c.FirstName + '' '' + c.LastName,
	st.FirstName + '' '' + st.LastName,
	s.DateOfService,
	CASE WHEN ReportRunDate is NULL THEN 1 ELSE 2 END,
	@your_initials	
from Cstm_NoShowReportTracking as l
join Clients as c on (c.ClientId = l.ClientId)
join Services as s on (s.ServiceId = l.ServiceId)
join staff as st ON (st.StaffId = s.ClinicianId)
join Programs as p on (p.ProgramId = s.ProgramId)
WHERE
(l.ReportRunDate IS NULL OR datediff(day, l.ReportRunDate, @run_date) = 0)
and (
	(@location = ''al'' and p.ProgramName = ''Outpatient Services - Albion'' )	
	or
	(@location = ''lv'' and p.ProgramName = ''Outpatient Services - Lakeview'')	
	or
	(@location = ''bc'' and p.ProgramName = ''Outpatient Services - Downtown'')
)
--
-- only include if the creation date the record is on or before the run date
--
and DATEDIFF(day, s.DateOfService, @run_date) >= 0

--
-- Update addresses
--
update r set
	ClientAddress = ca.Display
from @results as r
join ClientAddresses as ca on (ca.ClientId = r.ClientId)
where isnull(ca.RecordDeleted, ''N'') <> ''Y''
and ca.AddressType = 90




--
-- update dates
--

UPDATE l SET
	ReportRunDate = @run_date, ReportRunInitials = @your_initials
FROM Cstm_NoShowReportTracking AS l
JOIN @results AS r ON (r.ServiceId = l.ServiceId)
WHERE
	l.ReportRunDate is null
	and
	r.PrintSection = 1


IF 0 = (SELECT COUNT(*) FROM @results) GOTO no_records
--INSERT INTO @results (PrintSection, SysComment) VALUES (4,''No Show Letters Start On Next Page'') 

SELECT * FROM @results ORDER BY PrintSection, ClinicianName, CustomerName

RETURN 0

/*
run_already:
INSERT INTO @results (print_section, sys_comment) VALUES (3,''Report has been printed for this run date/location.'')

SELECT * FROM @results

RETURN 0
*/


cur_date:
INSERT INTO @results (PrintSection, SysComment) VALUES (4,''No letters will print for today''''''+ ''s date or a future date'') 

SELECT * FROM @results

RETURN 0

no_records:
INSERT INTO @results (PrintSection, SysComment) VALUES (4,''Zero no-show records for this date/location'')

SELECT * FROM @results

RETURN 0
' 
END
GO
