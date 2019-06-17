/****** Object:  StoredProcedure [dbo].[csp_ReportOutpatientAdmissions]    Script Date: 04/18/2013 11:21:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportOutpatientAdmissions]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportOutpatientAdmissions]
GO

/****** Object:  StoredProcedure [dbo].[csp_ReportOutpatientAdmissions]    Script Date: 04/18/2013 11:21:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO







CREATE   PROCEDURE [dbo].[csp_ReportOutpatientAdmissions]

@StartDate		datetime,
@EndDate		datetime
/********************************************************************************
-- Stored Procedure: dbo.csp_ReportOutpatientAdmissions 
--
-- Copyright: 2007 Streamline Healthcate Solutions
--
-- Purpose: Outpatient Admissions Report 
--
-- Updates:                     		                                
-- Date			Author		Purpose
-- 05-25-2007	AVOSS		Created.      
--
*********************************************************************************/
as

select 
	c.ClientId, 
	c.LastName + ', ' + c.FirstName as ClientName, 
	convert(varchar(10),cp.RequestedDate,101) as RequestedDate, 
	convert(varchar(10),cp.EnrolledDate,101) as EnrolledDate,
	convert(varchar(10),cp.DischargedDate,101)as DischargeDate, 
	cp.PrimaryAssignment, 
	s.LastName + ', ' + s.FirstName as PrimaryClinician, 
	p.ProgramCode
from clientPrograms cp
join clients c on c.clientId = cp.clientid
join staff s on s.staffid = c.primaryclinicianId
join programs p on p.programId = cp.programid
where cp.EnrolledDate >= @StartDate
and cp.EnrolledDate <= @EndDate
and p.programid not in (0,19)
and isnull(c.RecordDeleted, 'N') = 'N'
and isnull(p.RecordDeleted, 'N') = 'N'
and isnull(cp.RecordDeleted, 'N') = 'N'
and isnull(s.RecordDeleted, 'N') = 'N'
Order By p.ProgramCode, cp.EnrolledDate



GO

