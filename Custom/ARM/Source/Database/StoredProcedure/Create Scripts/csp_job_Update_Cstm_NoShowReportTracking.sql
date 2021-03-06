/****** Object:  StoredProcedure [dbo].[csp_job_Update_Cstm_NoShowReportTracking]    Script Date: 06/19/2013 17:49:45 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_job_Update_Cstm_NoShowReportTracking]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_job_Update_Cstm_NoShowReportTracking]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_job_Update_Cstm_NoShowReportTracking]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'create procedure [dbo].[csp_job_Update_Cstm_NoShowReportTracking] as
/************************************************************************/
/* SUMMIT POINTE Customization						*/
/* This procedure inserts new rows into the Cstm_NoShowReportTracking	*/
/* table for use by the No-Show Letters Report.				*/
/* This should be run nightly by the SQL job scheduler.			*/
/************************************************************************/

insert into Cstm_NoShowReportTracking
(serviceid, clientid, createddate)
select
s.ServiceId,
s.ClientId,
getdate()
from Services as s
join Programs as p on (p.ProgramId = s.ProgramId)
join ProcedureCodes as pc on (pc.ProcedureCodeId = s.ProcedureCodeId)
where
isnull(s.RecordDeleted, ''N'') <> ''Y''
-- Need to base this on a procedure category but using ProcedureCodeName for now
and (pc.ProcedureCodeName like ''%INDIVIDUAL THERAPY%'' or pc.ProcedureCodeName like ''%FAMILY THERAPY%'')
-- Outpatient only
and p.ProgramCode in (''Outpatient Services - Albion'',''Outpatient Services - Downtown'',''Outpatient Services - Lakeview'')
-- no-show
and s.status = 72
-- and this was their most recent appt. in an OP program
and not exists
(
	select *
	from Services as s2
	join Programs as p2 on (p2.ProgramId = s2.ProgramId)
	join ProcedureCodes as pc2 on (pc2.ProcedureCodeId = s2.ProcedureCodeId)
	where
	isnull(s2.RecordDeleted, ''N'') <> ''Y''
	-- Need to base this on a procedure category but using ProcedureCodeName for now
	and (pc2.ProcedureCodeName like ''%INDIVIDUAL THERAPY%'' or pc2.ProcedureCodeName like ''%FAMILY THERAPY%'')
	-- Outpatient only
	and p2.ProgramCode in (''Outpatient Services - Albion'',''Outpatient Services - Downtown'',''Outpatient Services - Lakeview'')
	and s2.ClientId = s.ClientId
	and s2.DateOfService > s.DateOfService
)
-- and we''re not already tracking this client
and not exists
(
	select *
	from Cstm_NoShowReportTracking as t
	where
		t.ClientId = s.ClientId
		and (t.ReportRunDate is null or t.PotentialCancelPrintDate is null)
)


/*
	-- this is legacy code that may or may not be implemented this way for Summit
	--
	-- flag patients for notification of cancellation to clinician
	--
	UPDATE track SET
		cancel_dt = GETDATE()
	FROM cstm_no_show_report_tracking AS track
	JOIN inserted AS i ON (i.patient_id = track.patient_id AND i.episode_id = track.episode_id)
	JOIN deleted AS d ON (d.clinical_transaction_no = i.clinical_transaction_no)
	WHERE
		i.status = ''CA''
		AND
		i.status <> d.status
		AND
		NOT EXISTS
		(
			SELECT *
			FROM patient_clin_tran AS pct
			WHERE
				pct.patient_id = i.patient_id
				AND
				pct.episode_id = i.episode_id
				AND
				pct.status = ''SC''
				AND
				pct.clinical_transaction_no <> i.clinical_transaction_no
		)

*/
' 
END
GO
