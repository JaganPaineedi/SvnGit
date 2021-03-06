/****** Object:  StoredProcedure [dbo].[csp_Report_RSC_Spreadsheet_Report]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_RSC_Spreadsheet_Report]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_RSC_Spreadsheet_Report]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_RSC_Spreadsheet_Report]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_RSC_Spreadsheet_Report]
	-- Add the parameters for the stored procedure here
	@StartDate		Datetime,
	@EndDate		Datetime,
	@StaffId		Int,
	@staff_super_vp	varchar(5),
	@Service		Int,
	@CoveragePlanId	Int	
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_RSC_Spreadsheet_Report              	*/
/* Creation Date: 03/13/2013                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/
/*                                                                   	*/
/* Input Parameters: 	@StartDate, @EndDate, @StaffId,					*/
/*	@staff_super_vp, @Service, @CoveragePlanId 			     			*/
/*								     									*/
/* Description: Generates a report to show the number of units that an 	*/
/*	Authorization has and how many have been used in a period of time.	*/
/*                                                                   	*/
/* Updates:																*/
/*  Date		Author		Purpose										*/
/*	03/13/2013	MSR			Modified Original from Pysch Consult		*/	
/************************************************************************/
/*
DECLARE
	@StartDate		Datetime,
	@EndDate		Datetime,
	@StaffId		Int,
	@staff_super_vp	varchar(5),
	@Service		int, --Varchar(100),
	@CoveragePlanId	Int
SELECT
	@StartDate		= ''05/01/2012'',
	@EndDate		= ''05/31/2012'',
	@StaffId		= 0, --1288,
	@staff_super_vp = ''st'',
	@Service		= 0, --371,
	@CoveragePlanId	= 0
--*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF OBJECT_ID(''tempdb..#TempStaff'') IS NOT NULL DROP TABLE #TempStaff
	create table #TempStaff
	(
		StaffId		Int,
		Staffname	Varchar(100)
	)
	
	if @StaffId = 0 begin
	insert #TempStaff 
	SELECT s.StaffId, s.LastName + '', '' + s.FirstName 
	FROM Staff s 
	WHERE (ISNULL(s.RecordDeleted,''N'')<>''Y'')
	AND s.Active = ''Y''
	end
	
	if @StaffId <> 0 and @staff_super_vp = ''su'' begin
		INSERT INTO #TempStaff
		SELECT * FROM dbo.fn_Supervisor_List(1, @StaffId)
	end
	
	if @StaffId <> 0 and @staff_super_vp = ''vp'' begin
		INSERT INTO #TempStaff
		SELECT * FROM dbo.fn_Supervisor_List(10, @StaffId)
	end
	
	if @StaffId <> 0 and @staff_super_vp = ''St'' begin
	insert into #TempStaff 
	select s.StaffId, s.LastName + '', '' + s.FirstName from Staff s where s.StaffId = @StaffId 
	end
	
	IF OBJECT_ID(''tempdb..#TempCoveragePlan'') IS NOT NULL DROP TABLE #TempCoveragePlan
	create table #TempCoveragePlan 
	(
		coverageplanId		int,
		coverageplanname	Varchar(50)
	)
	
	if @CoveragePlanId = 0 begin
		insert #TempCoveragePlan 
		select c.CoveragePlanId, c.CoveragePlanName from CoveragePlans c where c.DisplayAs like ''rsc%'' and c.Active = ''Y''
	end else begin
		insert #TempCoveragePlan 
		select c.CoveragePlanId, c.CoveragePlanName from CoveragePlans c where c.CoveragePlanId = @CoveragePlanId
	end
		
	IF OBJECT_ID(''tempdb..#TempService'') IS NOT NULL DROP TABLE #TempService
	create table #TempService 
	(
		ServiceId	int,
		servicename	Varchar(50)
	)
	
	if @Service = 0 begin
		insert #TempService
		select c.ProcedureCodeId, c.DisplayAs from ProcedureCodes c
	end else begin
		insert #TempService
		select c.ProcedureCodeId, c.DisplayAs from ProcedureCodes c where c.ProcedureCodeId = @Service
	end

--select * from #TempService

--***********************************************************--
--******* This Section Grabs the Total Service Amount *******--
--***********************************************************--
IF OBJECT_ID(''tempdb..#results_before_service_summation'') IS NOT NULL DROP TABLE #results_before_service_summation
CREATE	TABLE	#results_before_service_summation
(
	clientid varchar(20),
	client_name varchar(100),
	proc_code varchar(50),
	auth_num varchar(50), --referral_no
	date_received datetime, --cap_request_date
	begin_date datetime, --orig_entry_date
	end_date datetime, --expiration_date 
	service_authorized float(20), --time_cap_requested
	service_to_date float(20),
	counselor varchar(100),
	staff_name varchar(100),
	clinical_transaction_no varchar(50),
	DateofService datetime,
	coverage_plan_id char(50)
	,UnitsBilled		decimal(18, 2),
	InvoiceDate		Datetime
)
	
INSERT INTO #results_before_service_summation
SELECT	DISTINCT
	c.ClientId,
	c.LastName + '', '' + c.FirstName,
	pc.DisplayAs, 
	a.AuthorizationNumber, 
	a.DateReceived, 
	a.StartDate, 
	a.EndDate, 
	a.Units,
	srv.Unit, 
	cc.bvrcounselor,
	s.LastName + '', '' + s.FirstName,
	ch.ChargeId,
	srv.DateofService,
	cp.CoveragePlanId
	,ch.Units,
	ch.FirstBilledDate 
FROM Clients c 
JOIN ClientCoveragePlans ccp 
	ON ccp.ClientId = c.ClientId 
	and (ISNULL(ccp.RecordDeleted, ''N'')<>''Y'')
JOIN AuthorizationDocuments ad 
	ON ad.ClientCoveragePlanId = ccp.ClientCoveragePlanId 
	and (ISNULL(ad.RecordDeleted, ''N'')<>''Y'')
JOIN Authorizations a 
	ON a.AuthorizationDocumentId = ad.AuthorizationDocumentId 
	and (ISNULL(a.RecordDeleted, ''N'')<>''Y'')
JOIN AuthorizationCodes ac 
	on ac.AuthorizationCodeId = a.AuthorizationCodeId 
	and (ISNULL(ac.RecordDeleted, ''N'')<>''Y'')
JOIN CustomClients cc 
	ON cc.ClientId = c.ClientId 
	and (ISNULL(cc.RecordDeleted, ''N'')<>''Y'')
JOIN AuthorizationCodeProcedureCodes acpc 
	ON acpc.AuthorizationCodeId = a.AuthorizationCodeId 
	and (ISNULL(acpc.RecordDeleted, ''N'')<>''Y'')
JOIN ProcedureCodes pc 
	ON pc.ProcedureCodeId = acpc.ProcedureCodeId 
	and (ISNULL(pc.RecordDeleted, ''N'')<>''Y'')
JOIN ProcedureRates pr
	on pc.ProcedureCodeId = pr.ProcedureCodeId 
	and (ISNULL(pr.RecordDeleted, ''N'')<>''Y'')
JOIN Services srv 
	on srv.ClientId = c.ClientId 
	AND srv.ProcedureCodeId = pc.ProcedureCodeId 
	and (ISNULL(srv.RecordDeleted, ''N'')<>''Y'')
JOIN Staff s 
	on s.StaffId = srv.ClinicianId 
	and (ISNULL(s.RecordDeleted, ''N'')<>''Y'')
JOIN CoveragePlans cp 
	ON cp.CoveragePlanId = ccp.CoveragePlanId 
	and (ISNULL(cp.RecordDeleted, ''N'')<>''Y'')
JOIN Charges ch 
	ON ch.ServiceId = srv.ServiceId 
	and (ISNULL(ch.RecordDeleted, ''N'')<>''Y'')
JOIN ARLedger arl 
	ON arl.ChargeId = ch.ChargeId 
	and (ISNULL(arl.RecordDeleted, ''N'')<>''Y'')
WHERE ccp.CoveragePlanId in (select t.coverageplanId from #TempCoveragePlan t)
AND arl.LedgerType IN (4201,4202)  -- global code for 4201 - Charge / 4202 - Payment
AND srv.Status = 75  -- global code for 75 - Complete
AND	srv.DateofService = arl.DateofService
AND	srv.DateofService  <= dateadd(dd, 1, a.EndDate)
AND	srv.DateofService  >= a.StartDate
AND	srv.DateofService  >= @StartDate
AND	srv.DateofService  <= @EndDate
AND	s.StaffId in (select t.StaffId from #TempStaff t)
AND	pc.DisplayAs in (select t.servicename from #TempService t)

IF OBJECT_ID(''tempdb..#results_after_service_summation '') IS NOT NULL DROP TABLE #results_after_service_summation 
CREATE TABLE	#results_after_service_summation 
(
	client_id char(20),
	client_name varchar(100),
	proc_code varchar(50),
	auth_num varchar(50),
	date_received datetime,
	begin_date datetime,
	end_date datetime,
	service_authorized float(20),
	service_used float(20),
	counselor varchar(100),
	staff_name varchar(100),
	coverage_plan_id varchar(20),
	UnitsBilled		decimal(10, 2),
	InvoiceDate		Date
)

INSERT INTO	
	#results_after_service_summation
SELECT	
	rbss.clientid,
	rbss.client_name,
	rbss.proc_code,
	rbss.auth_num,
	rbss.date_received,
	rbss.begin_date,
	rbss.end_date,
	rbss.service_authorized,
	sum(rbss.service_to_date) as ''Service to Date'',
	rbss.counselor,
	staff_name,
	rbss.coverage_plan_id,
	rbss.UnitsBilled,
	rbss.InvoiceDate 
FROM #results_before_service_summation rbss
GROUP BY	
	rbss.client_name,
	rbss.clientid,
	rbss.proc_code,
	rbss.auth_num,
	rbss.date_received,
	rbss.begin_date,
	rbss.end_date,
	rbss.service_authorized,
	rbss.counselor,
	rbss.staff_name,
	rbss.coverage_plan_id,
	rbss.UnitsBilled,
	rbss.InvoiceDate	
--******************************************************************--
--******* END OF This Section Grabs the Total Service Amount *******--
--******************************************************************--
--*****************************************************************--
--This Section includes all auths with at least 1 transaction******--
--*****************************************************************--
IF OBJECT_ID(''tempdb..#final_results'') IS NOT NULL DROP TABLE #final_results
create table #final_results
(
	client_id char(20),
	client_name varchar(100),
	proc_code varchar(50),
	auth_num varchar(50),
	date_received datetime,
	begin_date datetime,
	end_date datetime,
	service_authorized float(20),
	service_used float(20),
	counselor varchar(100),
	staff_name varchar(100),
	coverage_plan_id varchar(20),
	UnitsBilled		decimal(10, 2),
	InvoiceDate		Date	
)

INSERT	INTO	#final_results
select	rass.*
from	#results_after_service_summation rass
--*****************************************************************--
--END OF This Section gets all auths & data with at least 1 transaction
--*****************************************************************--
--*****************************************************************--
--This Section grabs all auths, used or not************************--
--*****************************************************************--
IF OBJECT_ID(''tempdb..#proc_auth'') IS NOT NULL DROP TABLE #proc_auth 
CREATE TABLE #proc_auth
(
	client_id char(20),
	client_name varchar(100),
	proc_code varchar(50),
	auth_num varchar(50),
	date_received datetime,
	begin_date datetime,
	end_date datetime,
	service_authorized float(20),
	service_to_date float(20),
	counselor varchar(100),
	staff_name varchar(100),
	coverage_plan_id char(20),
	UnitsBilled		decimal(10, 2),
	InvoiceDate		Date,	
)

INSERT INTO #proc_auth 
SELECT	DISTINCT
	c.ClientId,
	c.LastName + '', '' + c.FirstName,
	null,
	a.AuthorizationNumber,
	a.DateReceived,
	a.StartDate,
	a.EndDate,
	a.Units,
	0,
	cc.bvrcounselor,
	null,
	ccp.CoveragePlanId,
	0,
	null
FROM	Clients c
JOIN ClientCoveragePlans ccp 
	ON ccp.ClientId = c.ClientId 
	and (ISNULL(ccp.RecordDeleted, ''N'')<>''Y'')
JOIN AuthorizationDocuments ad 
	ON ad.ClientCoveragePlanId = ccp.ClientCoveragePlanId 
	and (ISNULL(ad.RecordDeleted, ''N'')<>''Y'')
JOIN Authorizations a 
	ON a.AuthorizationDocumentId = ad.AuthorizationDocumentId 
	and (ISNULL(a.RecordDeleted, ''N'')<>''Y'')
JOIN AuthorizationCodes ac 
	on ac.AuthorizationCodeId = a.AuthorizationCodeId 
	and (ISNULL(ac.RecordDeleted, ''N'')<>''Y'')
JOIN CustomClients cc 
	ON cc.ClientId = c.ClientId 
	and (ISNULL(cc.RecordDeleted, ''N'')<>''Y'')
JOIN AuthorizationCodeProcedureCodes acpc
	on a.AuthorizationCodeId = acpc.AuthorizationCodeId 
	and (ISNULL(acpc.RecordDeleted, ''N'')<>''Y'')	
WHERE ccp.CoveragePlanId in (select t.coverageplanId from #TempCoveragePlan t)
AND (a.StartDate between @StartDate and @EndDate
	or a.EndDate between @StartDate and @EndDate)
AND acpc.ProcedureCodeId in (select t.ServiceId from #TempService t)	
--*****************************************************************--
--END OF This Section grabs all auths, used or not*****************--
--*****************************************************************--

INSERT	INTO	#final_results
SELECT	*
FROM	#proc_auth pa
WHERE	pa.auth_num not in	(SELECT	auth_num FROM #final_results) 

SELECT distinct	fr.client_id,
	fr.client_name,
	fr.proc_code,
	fr.auth_num,
	fr.date_received,
	fr.begin_date,
	fr.end_date,
	CASE	WHEN	fr.service_authorized is null
		THEN	0
		ELSE	fr.service_authorized
	END	AS	''service_authorized'',
	fr.service_used,
	fr.counselor,
	fr.staff_name,
	fr.coverage_plan_id,
	fr.UnitsBilled,
	fr.InvoiceDate 
FROM	#final_results fr
ORDER	BY
	fr.client_name,
	fr.auth_num,
	fr.proc_code,
	fr.staff_name
	
drop table #TempCoveragePlan 
drop table #TempService 
drop table #TempStaff 
drop table #final_results 
drop table #proc_auth 
drop table #results_after_service_summation 
drop table #results_before_service_summation 
	
END
' 
END
GO
