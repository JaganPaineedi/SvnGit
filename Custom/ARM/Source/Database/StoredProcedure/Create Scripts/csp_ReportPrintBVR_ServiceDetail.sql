/****** Object:  StoredProcedure [dbo].[csp_ReportPrintBVR_ServiceDetail]    Script Date: 06/19/2013 17:49:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintBVR_ServiceDetail]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_ReportPrintBVR_ServiceDetail]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_ReportPrintBVR_ServiceDetail]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[csp_ReportPrintBVR_ServiceDetail](
	@ClaimBatchId  int = null,
	@AuthorizationId int = null,
	@ClientId int = null
	)
/*
Purpose: Selects data to print on BVR claim form based on HCFA1500 claim form data.
      Either @ClaimBatchId or @ClaimProcessId and @ClientId has to be passed in.

Updates: 
Date		Author		Purpose
5/29/12		JJN			Created
09/05/2012	JJN			Added extra inserts to catch all notes and services without notes

*/  

AS
Begin

SET FMTONLY OFF

declare @startDate datetime,
	@endDate datetime



--select @startDate = MIN(s.DateOfService), @endDate = MAX(s.DateOfService)
--from dbo.ClaimBatches as cb
--join dbo.ClaimBatchCharges as cbc on cbc.ClaimBatchId = cb.ClaimBatchId
--join dbo.Charges as chg on chg.ChargeId = cbc.ChargeId
--join dbo.Services as s on s.ServiceId = chg.ServiceId
--where cb.ClaimBatchId = @ClaimBatchId
--and s.ClientId = @ClientId

select @startDate = StartDate, @endDate = EndDate
from dbo.Authorizations
where AuthorizationId = @AuthorizationId

CREATE TABLE #ServiceDetail(
	Rank int,
	ServiceId int,
	Consumer varchar(100),
	ClientId char(8), 
	ReferralSource varchar(100),
	DatesofService varchar(50),
	AuthorizationNumber varchar(20), 
	ServiceDate varchar(11),
	Unittype varchar(11),
	Unit float,
	Billed char(1),
	ServicesProvided varchar(200),
	StaffName varchar(100),
	Comment varchar(max)
	)

--New Notes where service is billable
INSERT INTO #ServiceDetail (ServiceId,ReferralSource,Comment)
SELECT 
	ServiceId = s.ServiceId,
	ReferralSource = notes.ReferralSource,
	Comment = notes.ActivityNote
FROM Authorizations a
JOIN AuthorizationCodeProcedureCodes apc ON apc.AuthorizationCodeId = a.AuthorizationCodeId
JOIN ServiceAuthorizations sa ON sa.AuthorizationId = a.AuthorizationId
JOIN Services s ON s.ServiceId = sa.ServiceId
	AND s.ProcedureCodeId = apc.ProcedureCodeId
JOIN Documents d on d.ServiceId = s.ServiceId 
	AND d.Status = 22
JOIN documentVersions dv ON dv.DocumentVersionId = d.CurrentDocumentVersionId
JOIN CustomDocumentJobDeveloperCoachNote notes ON notes.DocumentVersionId = dv.DocumentVersionId
WHERE s.ClientId = @ClientId
AND a.AuthorizationId = @AuthorizationId
--only show items in the same billing month(s) as the start date and end date
and DATEDIFF(day, s.DateOfService, @startDate) <= 0
and DATEDIFF(day, s.DateOfService, @endDate) >= 0
--
AND s.Status IN (75)
AND IsNULL(s.Billable,''N'') = ''Y''
AND IsNULL(notes.RecordDeleted,''N'') <> ''Y''
AND IsNULL(dv.RecordDeleted,''N'') <> ''Y''
AND IsNULL(d.RecordDeleted,''N'') <> ''Y''
AND IsNULL(sa.RecordDeleted,''N'') <> ''Y''
AND IsNULL(s.RecordDeleted,''N'') <> ''Y''
AND IsNULL(a.RecordDeleted,''N'') <> ''Y''
AND IsNULL(apc.RecordDeleted,''N'') <> ''Y''

--New notes where service is not billable
INSERT INTO #ServiceDetail (ServiceId,ReferralSource,Comment)
SELECT 
	ServiceId = s.ServiceId,
	ReferralSource = notes.ReferralSource,
	Comment = notes.ActivityNote
FROM Authorizations a
JOIN AuthorizationCodeProcedureCodes apc ON apc.AuthorizationCodeId = a.AuthorizationCodeId
JOIN Services s ON apc.ProcedureCodeId = s.ProcedureCodeId
JOIN Documents d on d.ServiceId = s.ServiceId
	AND d.Status = 22
JOIN documentVersions dv ON dv.DocumentVersionId = d.CurrentDocumentVersionId
JOIN CustomDocumentJobDeveloperCoachNote notes ON notes.DocumentVersionId = dv.DocumentVersionId
WHERE a.AuthorizationId = @AuthorizationId
AND s.Status IN (75)
AND s.ClientId = @ClientId
--only show items in the same billing month(s) as the start date and end date
and DATEDIFF(day, s.DateOfService, @startDate) <= 0
and DATEDIFF(day, s.DateOfService, @endDate) >= 0
--
AND IsNULL(s.Billable,''N'') = ''N''
AND IsNULL(notes.RecordDeleted,''N'') <> ''Y''
AND IsNULL(dv.RecordDeleted,''N'') <> ''Y''
AND IsNULL(d.RecordDeleted,''N'') <> ''Y''
AND IsNULL(s.RecordDeleted,''N'') <> ''Y''
AND IsNULL(a.RecordDeleted,''N'') <> ''Y''
AND IsNULL(apc.RecordDeleted,''N'') <> ''Y''

--Old notes where service is billable
INSERT INTO #ServiceDetail (ServiceId,Consumer,ReferralSource,ServicesProvided,AuthorizationNumber,StaffName,Comment, ServiceDate)
SELECT 
	ServiceId = s.ServiceId,
	Consumer = notes.PatientName,
	ReferralSource = notes.ReferralSource,
	ServicesProvided = notes.ProcedureDescription,
	AuthorizationNumber = notes.AuthorizationNumber,
	StaffName = notes.StaffName,
	Comment = notes.ActivityNote,
	Convert(varchar(11),notes.NoteDate,101)
FROM Authorizations a
JOIN AuthorizationCodeProcedureCodes apc ON apc.AuthorizationCodeId = a.AuthorizationCodeId
JOIN Services s ON apc.ProcedureCodeId = s.ProcedureCodeId
JOIN ServiceAuthorizations sa ON sa.ServiceId = s.ServiceId
	AND sa.AuthorizationId = a.AuthorizationId
JOIN Documents d on d.ClientId = s.ClientId
	AND d.Status = 22
--	AND CONVERT(varchar,d.EffectiveDate,101) = CONVERT(varchar,s.DateofService,101)
JOIN documentVersions dv ON dv.DocumentVersionId = d.CurrentDocumentVersionId
JOIN CustomDocumentJobDeveloperCoachNotes notes ON notes.DocumentVersionId = dv.DocumentVersionId and DATEDIFF(DAY, notes.NoteDate, s.DateOfService) = 0 
	--and LTRIM(RTRIM(notes.AuthorizationNumber)) = LTRIM(RTRIM(a.AuthorizationNumber))
join CustomLegacyDocumentServices as cld on cld.DocumentId = d.DocumentId and cld.ServiceId = s.ServiceId
WHERE s.ClientId = @ClientId 
AND a.AuthorizationId = @AuthorizationId
AND s.Status IN (75)
--only show items in the same billing month(s) as the start date and end date
and DATEDIFF(day, s.DateOfService, @startDate) <= 0
and DATEDIFF(day, s.DateOfService, @endDate) >= 0
--
-- handle case of 2 documents on same service
AND NOT EXISTS (
	SELECT * 
	FROM Documents d1
	join CustomLegacyDocumentServices as cld2 on cld2.DocumentId = d1.DocumentId and cld2.ServiceId = s.ServiceId
	where d1.DocumentCodeId = d.DocumentCodeId
	and d1.Status = 22
	and ISNULL(d1.RecordDeleted, ''N'') <> ''Y''
	and d1.DocumentId > d.DocumentId
)
AND s.ServiceId NOT IN (SELECT ServiceId FROM #ServiceDetail)
AND IsNULL(s.Billable,''N'') = ''Y''
AND IsNULL(notes.RecordDeleted,''N'') <> ''Y''
AND IsNULL(a.RecordDeleted,''N'') <> ''Y''
AND IsNULL(s.RecordDeleted,''N'') <> ''Y''
AND IsNULL(d.RecordDeleted,''N'') <> ''Y''
AND IsNULL(dv.RecordDeleted,''N'') <> ''Y''
AND IsNULL(apc.RecordDeleted,''N'') <> ''Y''

--old notes where service is not billable
INSERT INTO #ServiceDetail (ServiceId,Consumer,ReferralSource,ServicesProvided,AuthorizationNumber,StaffName,Comment, ServiceDate)
SELECT 
	ServiceId = s.ServiceId,
	Consumer = notes.PatientName,
	ReferralSource = notes.ReferralSource,
	ServicesProvided = notes.ProcedureDescription,
	AuthorizationNumber = notes.AuthorizationNumber,
	StaffName = notes.StaffName,
	Comment = notes.ActivityNote,
	Convert(varchar(11),notes.NoteDate,101)
FROM Authorizations a
JOIN AuthorizationCodeProcedureCodes apc ON apc.AuthorizationCodeId = a.AuthorizationCodeId
JOIN Services s ON apc.ProcedureCodeId = s.ProcedureCodeId
JOIN Documents d on d.ClientId = s.ClientId
	AND d.Status = 22
JOIN documentVersions dv ON dv.DocumentVersionId = d.CurrentDocumentVersionId
JOIN CustomDocumentJobDeveloperCoachNotes notes ON notes.DocumentVersionId = dv.DocumentVersionId and DATEDIFF(DAY, notes.NoteDate, s.DateOfService) = 0
	--and LTRIM(RTRIM(notes.AuthorizationNumber)) = LTRIM(RTRIM(a.AuthorizationNumber))
join CustomLegacyDocumentServices as cld on cld.DocumentId = d.DocumentId and cld.ServiceId = s.ServiceId
WHERE s.ClientId = @ClientId
AND a.AuthorizationId = @AuthorizationId
AND s.ServiceId NOT IN (SELECT ServiceId FROM #ServiceDetail)
AND s.Status IN (75)
--only show items in the same billing month(s) as the start date and end date
and DATEDIFF(day, s.DateOfService, @startDate) <= 0
and DATEDIFF(day, s.DateOfService, @endDate) >= 0
--
AND NOT EXISTS (
	SELECT * 
	FROM Documents d1
	join CustomLegacyDocumentServices as cld2 on cld2.DocumentId = d1.DocumentId and cld2.ServiceId = s.ServiceId
	where d1.DocumentCodeId = d.DocumentCodeId
	and d1.Status = 22
	and ISNULL(d1.RecordDeleted, ''N'') <> ''Y''
	and d1.DocumentId > d.DocumentId
)
AND IsNULL(s.Billable,''N'') = ''N''
AND IsNULL(notes.RecordDeleted,''N'') <> ''Y''
AND IsNULL(a.RecordDeleted,''N'') <> ''Y''
AND IsNULL(s.RecordDeleted,''N'') <> ''Y''
AND IsNULL(d.RecordDeleted,''N'') <> ''Y''
AND IsNULL(dv.RecordDeleted,''N'') <> ''Y''
AND IsNULL(apc.RecordDeleted,''N'') <> ''Y''

--billable services where there is no note
INSERT INTO #ServiceDetail (ServiceId)
SELECT 
	ServiceId = s.ServiceId
FROM Authorizations a
JOIN AuthorizationCodeProcedureCodes apc ON apc.AuthorizationCodeId = a.AuthorizationCodeId
JOIN ServiceAuthorizations sa ON sa.AuthorizationId = a.AuthorizationId
JOIN Services s ON s.ServiceId = sa.ServiceId
	AND s.ProcedureCodeId = apc.ProcedureCodeId
WHERE s.ClientId = @ClientId
AND a.AuthorizationId = @AuthorizationId
AND s.Status IN (75)
AND s.ServiceID NOT IN (SELECT ServiceId FROM #ServiceDetail)
and DATEDIFF(day, s.DateOfService, @startDate) <= 0
and DATEDIFF(day, s.DateOfService, @endDate) >= 0
AND IsNULL(s.Billable,''N'') = ''Y''
AND IsNULL(sa.RecordDeleted,''N'') <> ''Y''
AND IsNULL(s.RecordDeleted,''N'') <> ''Y''
AND IsNULL(a.RecordDeleted,''N'') <> ''Y''
AND IsNULL(apc.RecordDeleted,''N'') <> ''Y''

--non billable services where there is no note
INSERT INTO #ServiceDetail (ServiceId)
SELECT 
	ServiceId = s.ServiceId
FROM Authorizations a
JOIN AuthorizationCodeProcedureCodes apc ON apc.AuthorizationCodeId = a.AuthorizationCodeId
JOIN Services s ON s.ProcedureCodeId = apc.ProcedureCodeId
WHERE s.ClientId = @ClientId
AND a.AuthorizationId = @AuthorizationId
AND s.Status IN (75)
AND s.ServiceID NOT IN (SELECT ServiceId FROM #ServiceDetail)
and DATEDIFF(day, s.DateOfService, @startDate) <= 0
and DATEDIFF(day, s.DateOfService, @endDate) >= 0
AND IsNULL(s.Billable,''N'') = ''N''
AND IsNULL(s.RecordDeleted,''N'') <> ''Y''
AND IsNULL(a.RecordDeleted,''N'') <> ''Y''
AND IsNULL(apc.RecordDeleted,''N'') <> ''Y''

UPDATE sd SET
	Consumer = COALESCE(sd.Consumer, cl.LastName + '', '' + cl.FirstName, ''[Not Found]''),
	ClientId = Right(''0000000''+Cast(cl.ClientId as varchar(8)),8), 
	ReferralSource = COALESCE(sd.ReferralSource,ccl.BVRCounselor,''[Not Found]''),
	DatesofService = CONVERT(varchar(11),a.StartDate,101)+'' - ''+CONVERT(varchar(11),a.EndDate,101),
	AuthorizationNumber = COALESCE(sd.AuthorizationNumber,a.AuthorizationNumber,''[Not Found]''),
	ServiceDate = ISNULL(ServiceDate, Convert(varchar(11),s.DateofService,101)),	
	Unittype = CASE WHEN s.UnitType=110 THEN ''Hours'' ELSE ut.CodeName END,
	Unit = CASE WHEN s.UnitType=110 THEN s.Unit/60 ELSE s.Unit END,
	Billed = COALESCE(s.Billable,''N''),
	ServicesProvided = COALESCE(sd.ServicesProvided,pc.ProcedureCodeName,''[Not Found]''),
	StaffName = COALESCE(sd.StaffName,st.LastName + '', '' + st.FirstName,''[Not Found]''),
	Comment = COALESCE(sd.Comment,''[Not Found]'')
FROM #ServiceDetail sd
JOIN Services s ON s.ServiceId = sd.ServiceId
JOIN Clients cl ON cl.ClientId = s.ClientId 
LEFT JOIN CustomClients ccl ON ccl.ClientId = cl.ClientId
JOIN Authorizations a ON a.AuthorizationId = @AuthorizationId
JOIN ProcedureCodes pc ON pc.ProcedureCodeId = s.ProcedureCodeId
JOIN Staff st ON st.StaffId = s.ClinicianId
JOIN GlobalCodes ut ON ut.GlobalCodeId = s.UnitType AND ut.Category = ''UNITTYPE''
WHERE IsNull(s.RecordDeleted,''N'') <> ''Y''
AND IsNull(cl.RecordDeleted,''N'') <> ''Y''
AND IsNull(ccl.RecordDeleted,''N'') <> ''Y''
AND IsNull(a.RecordDeleted,''N'') <> ''Y''
AND IsNull(pc.RecordDeleted,''N'') <> ''Y''
AND IsNull(st.RecordDeleted,''N'') <> ''Y''
AND IsNull(ut.RecordDeleted,''N'') <> ''Y''

SELECT [Rank] = RANK() OVER (ORDER BY ServiceDate),
	ServiceId,Consumer,ClientId,ReferralSource,DatesofService,AuthorizationNumber,
	ServiceDate,Unittype,Unit,Billed,ServicesProvided,StaffName,Comment
FROM #ServiceDetail 

End



' 
END
GO
