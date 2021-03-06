/****** Object:  StoredProcedure [dbo].[csp_Report_FirstScheduledAppointment]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_FirstScheduledAppointment]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_FirstScheduledAppointment]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_FirstScheduledAppointment]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE	[dbo].[csp_Report_FirstScheduledAppointment]
	@start_date datetime,
	@end_date datetime

AS
--*/

/*
DECLARE	@start_date datetime,
	@end_date datetime;

SELECT	@start_date = ''11/6/12'',
	@end_date = ''12/7/12'';
--*/


-- Note: Might need to adjust the check for primary health visits and assessments
-- and might need to check other tables such as events, in case seeing a client
-- without an appointment should disqualify the client from this list?

/************************************************************************/
/* Stored Procedure: csp_Report_FirstScheduledAppointment              	*/
/* Creation Date: 05/30/2012                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/
/*                                                                   	*/
/* Purpose: First Scheduled Appointment Listing                      	*/
/*                                                                   	*/
/* Input Parameters:  @beg_date, @end_date    			     			*/
/*								     									*/
/* Description:  This report lists first appointments scheduled      	*/
/*		 for clients (upcoming).  Purpose is to check	     			*/
/*		 for authorizations.				     						*/
/*		It will check for the first mental health scheduled				*/
/*		appt, even if there was a previous primary health appt			*/
/*		and vice versa													*/
/*                                                                   	*/
/* Updates:																*/
/*   Date	Author		Purpose											*/
/*   01/20/2006	Kris Brahaney	Created									*/
/*   02/13/2006	Jess		modified: proc_chron -> appt_date			*/
/*   03/03/2006	Kris       	Changes requested by Vikki					*/
/*   03/17/2006	Kris													*/
/*   03/30/2006	Kris		Per Vikki, no longer exclude Defiance		*/
/*   09/30/2008	Jess		Modified per WO 10786						*/
/*   07/27/2009	Jess		Modified per WO 13090						*/
/*   12/06/2011	Jess		Modified per WO 20120						*/
/*   06/05/2012	Rick Kohler Convert to SmartCare						*/
/*	 01/04/2013	MSR			Modified per WO 26520						*/
/************************************************************************/


IF OBJECT_ID(''tempdb..#ClientCoverage'') IS NOT NULL BEGIN DROP TABLE #ClientCoverage END
IF OBJECT_ID(''tempdb..#ClientCoverage2'') IS NOT NULL BEGIN DROP TABLE #ClientCoverage2 END

-- Create #ClientCoverage to store results of select statement
CREATE TABLE #ClientCoverage
(
	ClientId				Int,
	ServiceId				Int,
	AppointmentDateTime		Datetime,
	ClientLastName			Varchar(50),
	ClientFirstName			Varchar(50),
	ProcedureDisplayAs		Varchar(50),
	StaffLastName			Varchar(50),
	StaffFirstName			Varchar(50),
	IsPrimaryHealth			Int,
	IsAssessment			Int,
	LocationName			Varchar(50),
	PrimaryCoverageName		Varchar(50),
	SecondaryCoverageName	Varchar(50)
)

-- Create #ClientCoverage2 to store Coverageplans to be combined into a single entity per client
CREATE TABLE #ClientCoverage2
(
	ClientId		Int,
	CoveragePlans	Varchar(500),
	COB				Int
)
;
 
with

-- List service statuses that mean a visit has occurred
VisitOccurredStatusCodes(StatusCode) as (
  select GlobalCodeId
  from GlobalCodes
  where Category=''SERVICESTATUS''
  and CodeName in (''COMPLETE'',''SHOW'')
)
,

-- List service statuses that mean an appointment is scheduled
AppointmentScheduledStatusCodes(StatusCode) as (
  select GlobalCodeId
  from GlobalCodes
  where Category=''SERVICESTATUS''
  and CodeName in (''SCHEDULED'')
)
,

-- List completed visits
Visit(Clientid,StaffId,ServiceId,/*ProcedureName,*/ProcedureDisplayAs,AppointmentDateTime,LocationId,
  IsPrimaryHealth,IsAssessment) as (
select
  a.ClientId,
  a.ClinicianId as StaffId,
  a.ServiceId,
--  pc.ProcedureCodeName as ProcedureName,
  pc.DisplayAs as ProcedureDisplayAs,
  a.DateOfService as AppointmentDateTime,
  a.LocationId,

--  Updated by Jess 6/6/12
--  case when c.ProgramCode like ''PR_HLT%'' then 1 else 0 end as IsPrimaryHealth,
case when (c.ProgramCode like ''PR_HLT%'' or c.ProgramID = ''33'') -- Primary Physician Services
     then 1 else 0 end as IsPrimaryHealth,

--  Updated by Jess 6/6/12
--  case when c.ProgramCode in (''ASSESSMENT'',''ASSMT_UPD'',''ASMT_OMCAP'') then 1 else 0 end as IsAssessment
  case when pc.DisplayAs in (''ASSESSMENT'',''ASSMT_UPD'',''ASMT_OMCAP'') then 1 else 0 end as IsAssessment

from (select * from Services where coalesce(RecordDeleted,''N'')<>''Y'') a
LEFT join (select * from Programs where coalesce(RecordDeleted,''N'')<>''Y'') c
on a.ProgramId=c.ProgramId
left join (select * from ProcedureCodes where coalesce(RecordDeleted,''N'')<>''Y'') pc
on a.ProcedureCodeId=pc.ProcedureCodeId
where a.Status in (select StatusCode from VisitOccurredStatusCodes)
)
,

-- List appointments
Appt(Clientid,StaffId,ServiceId,/*ProcedureName,*/ProcedureDisplayAs,AppointmentDateTime, CreatedDate, LocationId,
  IsPrimaryHealth,IsAssessment) as (
select
  a.ClientId,
  a.ClinicianId as StaffId,
  a.ServiceId,
--  pc.ProcedureCodeName as ProcedureName,
  pc.DisplayAs as ProcedureDisplayAs,
  a.DateOfService as AppointmentDateTime,
  a.CreatedDate as CreatedDate,
  a.LocationId,

--  Updated by Jess 6/6/12
--  case when c.ProgramCode like ''PR_HLT%'' then 1 else 0 end as IsPrimaryHealth,
case when (c.ProgramCode like ''PR_HLT%'' or c.ProgramID = ''33'') -- Primary Physician Services
     then 1 else 0 end as IsPrimaryHealth,
  
--  Updated by Jess 6/6/12
--case when c.ProgramCode in (''ASSESSMENT'',''ASSMT_UPD'',''ASMT_OMCAP'') then 1 else 0 end as IsAssessment
  case when pc.DisplayAs in (''ASSESSMENT'',''ASSMT_UPD'',''ASMT_OMCAP'') then 1 else 0 end as IsAssessment

from (select * from Services where coalesce(RecordDeleted,''N'')<>''Y'') a
LEFT join (select * from Programs where coalesce(RecordDeleted,''N'')<>''Y'') c
on a.ProgramId=c.ProgramId
left join (select * from ProcedureCodes where coalesce(RecordDeleted,''N'')<>''Y'') pc
on a.ProcedureCodeId=pc.ProcedureCodeId
where a.Status in (select StatusCode from AppointmentScheduledStatusCodes)
)
,
-- Coverages
Coverage(ClientId, CoveragePlanId, COBRank, DisplayName) as (
select
  c.ClientId,
  c.ClientCoveragePlanId,
  h.COBOrder,
  coalesce(p.DisplayAs,cast(c.ClientCoveragePlanId as varchar(12))) as DisplayName

from (select * from ClientCoverageHistory where coalesce(RecordDeleted,''N'')<>''Y'' and EndDate is null) h

join (select * from ClientCoveragePlans where coalesce(recorddeleted,''N'')<>''Y'') c
on h.ClientCoveragePlanId=c.ClientCoveragePlanId

join (select * from CoveragePlans where coalesce(RecordDeleted,''N'')<>''Y'') p
on p.CoveragePlanId=c.CoveragePlanId
)
,

-- Finally extract the rest of the information to be reported
ReportData(ClientId,ServiceId,AppointmentDateTime,ClientLastName,ClientFirstName,
  /*ProcedureName,*/ProcedureDisplayAs,StaffLastName,StaffFirstName,
  IsPrimaryHealth,IsAssessment,
  LocationName,PrimaryCoverageName,SecondaryCoverageName) as (
	select DISTINCT
	ap.ClientId,
	ap.ServiceId,
	ap.AppointmentDateTime,
	c.LastName as ClientLastName,
	c.FirstName as ClientFirstName,
	--ap.ProcedureName,
	ap.ProcedureDisplayAs,
	st.LastName as StaffLastName,
	st.FirstName as StaffFirstName,
	ap.IsPrimaryHealth,
	ap.IsAssessment,
	loc.LocationName,
	c1.DisplayName as PrimaryCoverageName,
	c2.DisplayName as SecondaryCoverageName

	from Appt ap

	left join (select * from Clients where coalesce(RecordDeleted,''N'')<>''Y'') c
	on ap.ClientId=c.ClientId

	left join (select * from Staff where coalesce(RecordDeleted,''N'')<>''Y'') st
	on ap.StaffId=st.StaffId

	left join (select * from Locations where coalesce(RecordDeleted,''N'')<>''Y'') loc
	on ap.LocationId=loc.LocationId

	left join (select * from Coverage where COBRank=1) c1
	on ap.Clientid=c1.ClientId

	left join (select * from Coverage where COBRank=2) c2
	on ap.Clientid=c2.ClientId

	-- Limit the list top the specified date range
	where ap.CreatedDate >= @start_date 
	and ap.CreatedDate < dateadd(dd, 1, @end_date)
	and
	(
	-- Want only the first scheduled appointment for each class (primary and non-primary care)
	  (
		  not exists (
		  select *
		  from Appt x
		  where x.ClientId=ap.ClientId
		  and x.IsPrimaryHealth=ap.IsPrimaryHealth
		  and x.AppointmentDateTime<ap.AppointmentDateTime
		  )
	-- And want to rule out appointments whenever there has been a previous visit for the same class
		  and not exists (
		  select *
		  from Visit x
		  where x.ClientId=ap.ClientId
		  and x.IsPrimaryHealth=ap.IsPrimaryHealth
		  and x.AppointmentDateTime<ap.AppointmentDateTime
		  )
	  )
	-- But we want to list all scheduled assessments regardless of past visits
	  or ap.IsAssessment<>0 
	)
)

--Insert results from ReportData into #ClientCoverage
INSERT INTO #ClientCoverage 
select distinct *
from ReportData
;

--Insert ClientId and PrimaryCoverageName into #ClientCoverage2
INSERT INTO #ClientCoverage2 (ClientId, CoveragePlans, COB)
SELECT c.ClientId, c.PrimaryCoverageName, 1 FROM #ClientCoverage c

--Insert ClientId and SecondaryCoverageName into #ClientCoverage2
INSERT INTO #ClientCoverage2 (ClientId, CoveragePlans, COB)
SELECT c.ClientId, c.SecondaryCoverageName, 2 FROM #ClientCoverage c

--Select to display data from #ClientCoverage and Combine CoveragePlans based on ClientId and ordered by COB from #ClientCoverage2
SELECT DISTINCT c.ClientId,
c.ServiceId,
c.AppointmentDateTime,
c.ClientLastName,
c.ClientFirstName,
c.ProcedureDisplayAs,
c.StaffLastName,
c.StaffFirstName,
c.IsPrimaryHealth,
c.IsAssessment,
c.LocationName,
REPLACE((Select c2.CoveragePlans + '', '' AS [text()]
	From #ClientCoverage2 c2
	Where c2.ClientId =c.ClientId
	GROUP BY c2.CoveragePlans 
	ORDER BY MIN(c2.COB)
	For XML PATH ('''')) + ''$'', '', $'', '''') AS ''CoveragePlans''
FROM #ClientCoverage c

DROP TABLE #ClientCoverage 
DROP TABLE #ClientCoverage2 
' 
END
GO
