IF EXISTS (SELECT 1 FROM sys.procedures p WHERE name = 'csp_ReportActiveWithoutDiagnosis')
	DROP PROCEDURE csp_ReportActiveWithoutDiagnosis
GO

SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[csp_ReportActiveWithoutDiagnosis]
@StartDate datetime
/*
Created Date	Created By	Purpose
9/2/2008		avoss		Summit Report

*/


as

Select 
	c.ClientId,
	c.Lastname + ', ' + c.Firstname as ClientName,
	isnull(s.Lastname + ', ' + s.Firstname, '*None*') as PrimaryClinician,
	isnull(p.ProgramName, '*None*') as PrimaryProgram,
	ce.EpisodeNumber, ce.RegistrationDate,
	gc.CodeName as EpisodeStatus,
	ce.InitialRequestDate, ce.AssessmentDate, ce.AssessmentFirstOffered, 
	ce.TxStartDate, ce.TxStartFirstOffered, ce.DischargeDate
from clients c
join clientEpisodes ce on ce.CLientId = c.ClientId and isnull(ce.RecordDeleted, 'N') <> 'Y'
	and ce.EpisodeNumber = c.CurrentEpisodeNumber
left join staff s on s.StaffId = c.PrimaryClinicianId 
left join ClientPrograms as cp on cp.ClientProgramId = c.PrimaryProgramId
left join programs as p on p.ProgramId = cp.ProgramId
left join globalCodes gc on gc.GlobalCodeId = ce.Status
where not exists ( 
		select * from documents as d2 where d2.ClientId = c.ClientId
		and d2.DocumentCodeId = 5 and d2.Status = 22
		and isnull(d2.RecordDeleted, 'N') <> 'Y'
)
and c.Active='Y'
and (isnull(ce.RegistrationDate,'1/1/1900') <= @StartDate or @StartDate is null)
order by 	
	isnull(p.ProgramName, '*None*'), 
	isnull(s.Lastname + ', ' + s.Firstname, '*None*'),
	c.Lastname + ', ' + c.Firstname
GO
