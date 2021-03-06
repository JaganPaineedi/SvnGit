/****** Object:  StoredProcedure [dbo].[csp_RSC_Invoice_5]    Script Date: 06/19/2013 17:49:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RSC_Invoice_5]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_RSC_Invoice_5]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_RSC_Invoice_5]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'  
CREATE	PROCEDURE	[dbo].[csp_RSC_Invoice_5]
	@begin_date datetime = ''19000101'',
	@end_date datetime = ''20301230'',
	@staff_lname varchar(30) = ''%'',
	@staff_fname varchar(20) = ''%'',
	@service varchar(20) = ''%'',
	@coverage_plan_id varchar(90) = ''LIKE ''''RSC%''''''
	
as
BEGIN

SET NOCOUNT ON

SELECT	@end_date = dateadd(dd, 1, @end_date)

DECLARE	@sqlone varchar(5000)
DECLARE	@sqltwo varchar(100)
DECLARE	@sqlthree varchar(100)
DECLARE	@sqlfour varchar(100)
DECLARE	@sqlfive varchar(100)
DECLARE	@sqlsix varchar(100)
DECLARE	@sqlseven varchar(100)
DECLARE	@sqleight varchar(100)


--***********************************************************--
--******* This Section Grabs the Total Service Amount *******--
--***********************************************************--
CREATE	TABLE	#results_before_service_summation
	(
	patient_id char(8),
	episode_id char(8),
	client_lname varchar(30),
	client_fname varchar(30),
	proc_code varchar(10),
	auth_num varchar(10), --referral_no
	date_received datetime, --cap_request_date
	begin_date datetime, --orig_entry_date
	end_date datetime, --expiration_date 
	service_authorized float(8), --time_cap_requested
	service_to_date float(8),
	amt_auth money,
	counselor varchar(30),
	staff_lname varchar(30),
	staff_fname varchar(30),
	clinical_transaction_no varchar(12),
	proc_chron datetime,
	coverage_plan_id char(10)
	)

--SELECT	@sqlone = ''
INSERT INTO #results_before_service_summation
SELECT	DISTINCT
	c.ClientId,
	NULL, c.LastName, c.FirstName,
	pc.DisplayAs, a.AuthorizationNumber, 
	a.StartDateRequested, a.StartDate, a.EndDate, a.Units,
	pct.Unit, a.UnitsRequested, cc.bvrcounselor,
	s.LastName, s.FirstName,
	ch.ChargeId,
	pct.DateofService,
	cp.CoveragePlanId
FROM Clients c 
JOIN ClientCoveragePlans ccp ON ccp.ClientId = c.ClientId
JOIN AuthorizationDocuments ad ON ad.ClientCoveragePlanId = ccp.ClientCoveragePlanId
JOIN Authorizations a ON a.AuthorizationDocumentId = ad.AuthorizationDocumentId
JOIN AuthorizationCodes ac on ac.AuthorizationCodeId = a.AuthorizationCodeId
JOIN CustomClients cc ON cc.ClientId = c.ClientId
JOIN AuthorizationCodeProcedureCodes acpc ON acpc.AuthorizationCodeId = a.AuthorizationCodeId
JOIN ProcedureCodes pc ON pc.ProcedureCodeId = acpc.ProcedureCodeId
JOIN Services pct on pct.ClientId = c.ClientId AND pct.ProcedureCodeId = pc.ProcedureCodeId
JOIN Staff s on s.StaffId = pct.ClinicianId
JOIN CoveragePlans cp ON cp.CoveragePlanId = ccp.CoveragePlanId
JOIN Charges ch ON ch.ServiceId = pct.ServiceId
JOIN ARLedger bl ON bl.ChargeId = ch.ChargeId
WHERE ac.AuthorizationCodeName LIKE Coalesce(@coverage_plan_id,''ac.AuthorizationCodeName'')
AND bl.LedgerType IN (4201,4202)
AND pct.Status = 75
AND	pct.DateofService = bl.DateofService
AND	pct.DateofService  <= dateadd(dd, 1, a.EndDate)
AND	pct.DateofService  >= a.StartDate
AND	pct.DateofService  >= @begin_date--***********
--SELECT	@sqltwo = '' 
AND	pct.DateofService  <= @end_date--*************
--SELECT	@sqlthree = '' 
AND	s.LastName like @staff_lname--***************
--SELECT	@sqlfour = '''''' 
AND	s.FirstName like @staff_fname--***************
--SELECT	@sqlfive = '''''' 
AND	pc.DisplayAs like @service--************
--SELECT	@sqlsix = ''''

--select @sqlseven = 	'''''''' + (convert(varchar(10), @begin_date, 101)) + ''''''''
--select @sqleight = 	'''''''' + (convert(varchar(10), @end_date, 101)) + ''''''''

--print (@sqlone + @sqlseven + @sqltwo + @sqleight + @sqlthree + @staff_lname + @sqlfour + @staff_fname + @sqlfive + @service + @sqlsix + '''''''')
--exec(@sqlone + @sqlseven + @sqltwo + @sqleight + @sqlthree + @staff_lname + @sqlfour + @staff_fname + @sqlfive + @service + @sqlsix + '''''''')

CREATE TABLE	#results_after_service_summation 
	(
	patient_id char(8),
	episode_id char(8),
	client_lname varchar(30),
	client_fname varchar(30),
	proc_code varchar(10),
	auth_num varchar(10),
	date_received datetime,
	begin_date datetime,
	end_date datetime,
	service_authorized float(8),
	service_used float(8),
	amt_auth money,
	counselor varchar(30),
	staff_lname varchar(30),
	staff_fname varchar(30),
	coverage_plan_id varchar(10)
	)

INSERT INTO	
	#results_after_service_summation
SELECT	
	rbss.patient_id,
	rbss.episode_id,
	rbss.client_lname,
	rbss.client_fname,
	rbss.proc_code,
	rbss.auth_num,
	rbss.date_received,
	rbss.begin_date,
	rbss.end_date,
	rbss.service_authorized,
	sum(rbss.service_to_date) as ''Service to Date'',
	rbss.amt_auth,
	rbss.counselor,
	staff_lname,
	staff_fname,
	rbss.coverage_plan_id
FROM #results_before_service_summation rbss
GROUP BY	
	rbss.client_lname,
	rbss.client_fname,
	rbss.patient_id,
	rbss.episode_id,
	rbss.proc_code,
	rbss.auth_num,
	rbss.date_received,
	rbss.begin_date,
	rbss.end_date,
	rbss.service_authorized,
	rbss.amt_auth,
	rbss.counselor,
	rbss.staff_lname,
	rbss.staff_fname,
	rbss.coverage_plan_id


--******************************************************************--
--******* END OF This Section Grabs the Total Service Amount *******--
--******************************************************************--

--**********************************************************--
--******* This Section Grabs the total Used Amount *******--
--**********************************************************--
CREATE TABLE	#temp_used_amount1
	(
	client_lname varchar(30),
	client_fname varchar(30),
	proc_code varchar(10),
	auth_num varchar(10),
	date_received datetime,
	begin_date datetime,
	end_date datetime,
	staff_lname varchar(30),
	staff_fname varchar(30),
	amount_used money,
	coverage_plan_id varchar(20),
	invoiced varchar(1)
	)	

CREATE TABLE	#temp_used_amount2
	(
	client_lname varchar(30),
	client_fname varchar(30),
	proc_code varchar(10),
	auth_num varchar(10),
	date_received datetime,
	begin_date datetime,
	end_date datetime,
	staff_lname varchar(30),
	staff_fname varchar(30),
	amount_used money,
	coverage_plan_id varchar(20),
	invoiced varchar(1)
	)	

INSERT INTO #temp_used_amount1
SELECT	DISTINCT
	rbss.client_lname,
	rbss.client_fname,
	rbss.proc_code,
	rbss.auth_num,
	rbss.date_received,
	rbss.begin_date,
	rbss.end_date,
	rbss.staff_lname,
	rbss.staff_fname,
	sum(bl.amount) as ''Amount Summed'',
	bl.CoveragePlanId,
	case 
		when bl.PostedDate is null then ''N''
		when bl.PostedDate is not null then ''Y''
	end
FROM #results_before_service_summation rbss
JOIN ARLedger bl with (nolock)
	ON	rbss.patient_id = bl.ClientId
	AND	rbss.clinical_transaction_no = bl.ChargeId
	AND	rbss.coverage_plan_id = bl.CoveragePlanId
	AND	bl.LedgerType in (4201,4202)
	

GROUP BY
	rbss.client_lname,
	rbss.client_fname,
	rbss.proc_code,
	rbss.auth_num,
	rbss.date_received,
	rbss.begin_date,
	rbss.end_date,
	rbss.staff_lname,
	rbss.staff_fname,
	bl.CoveragePlanId,
	bl.PostedDate

INSERT	INTO	#temp_used_amount2
SELECT	client_lname,
	client_fname,
	proc_code,
	auth_num,
	date_received,
	begin_date,
	end_date,	
	staff_lname,
	staff_fname,
	sum(amount_used),
	coverage_plan_id,
	invoiced
FROM	#temp_used_amount1
GROUP	BY
	client_lname,
	client_fname,
	proc_code,
	auth_num,
	date_received,
	begin_date,
	end_date,	
	staff_lname,
	staff_fname,
	coverage_plan_id,
	invoiced
--*****************************************************************--
--******* END OF This Section Grabs the total Used Amount *******--
--*****************************************************************--

--**********************************************************--
--******* This Section Grabs the total Billed Amount *******--
--**********************************************************--

DECLARE	@invoiced_amount table
	(
	auth_num varchar(10),
	amount_billed money
	)	

INSERT INTO @invoiced_amount 
SELECT	DISTINCT
	tua.auth_num,
	sum(tua.amount_used)
FROM	#temp_used_amount2 tua
WHERE	tua.invoiced = ''Y''
GROUP	BY	tua.auth_num

--*****************************************************************--
--******* END OF This Section Grabs the total Billed Amount *******--
--*****************************************************************--

--*****************************************************************--
--This Section includes all auths with at least 1 transaction******--
--*****************************************************************--
DECLARE	@final_results 	TABLE
	(
	patient_id char(8),
	episode_id char(8),
	client_lname varchar(30),
	client_fname varchar(30),
	proc_code varchar(10),
	auth_num varchar(10),
	date_received datetime,
	begin_date datetime,
	end_date datetime,
	service_authorized float(8),
	service_used float(8),
	amt_auth money,
	counselor varchar(30),
	staff_lname varchar(30),
	staff_fname varchar(30),
	coverage_plan_id varchar(10),
	amount_used money,
	amount_billed money,
	amount_available money
	)

INSERT	INTO	@final_results
select	rass.*,
	tua.amount_used,
	case	when	ia.amount_billed is null
		then	0
		else	ia.amount_billed
	end,
--	ia.amount_billed,
	case	when	tua.amount_used is null
		then	rass.amt_auth
		else	rass.amt_auth - tua.amount_used
	end
--	rass.amt_auth - ia.amount_billed as ''Amount Available''
	
from	#results_after_service_summation rass
join	#temp_used_amount2 tua
on	rass.auth_num = tua.auth_num
and	rass.proc_code = tua.proc_code
and	rass.staff_lname = tua.staff_lname
and	rass.staff_fname = tua.staff_fname
left join	@invoiced_amount ia
on	rass.auth_num = ia.auth_num
--*****************************************************************--
--END OF This Section gets all auths & data with at least 1 transaction
--*****************************************************************--

--*****************************************************************--
--This Section grabs all auths, used or not************************--
--*****************************************************************--
CREATE TABLE #proc_auth
	(
	patient_id char(8),
	episode_id char(3),
	client_lname varchar(30),
	client_fname varchar(30),
	proc_code varchar(10),
	auth_num varchar(10),
	date_received datetime,
	begin_date datetime,
	end_date datetime,
	service_authorized float(8),
	service_to_date float(8),
	amt_auth money,
	counselor varchar(30),
	staff_lname varchar(30),
	staff_fname varchar(30),
	coverage_plan_id char(10),
	amount_used money,
	amount_billed money,
	amount_available money
	)


declare @sql3 varchar(2500)
declare @sql4 varchar(250)
declare @sql5 varchar(250)
declare @sql6 varchar(250)
declare @sql7 varchar(250)
select @sql3 ='''' 	
--''
INSERT INTO #proc_auth 
SELECT	DISTINCT
	c.ClientId,
	NULL,
	c.LastName,
	c.FirstName,
	null,
	a.AuthorizationNumber,
	a.StartDateRequested,
	a.StartDate,
	a.EndDate,
	a.Units,
	0,
	a.UnitsRequested,
	cc.bvrcounselor,
	null,
	null,
	ccp.CoveragePlanId,
	0,
	0,
	a.UnitsRequested

FROM	Clients c
JOIN ClientCoveragePlans ccp ON ccp.ClientId = c.ClientId
JOIN AuthorizationDocuments ad ON ad.ClientCoveragePlanId = ccp.ClientCoveragePlanId
JOIN Authorizations a ON a.AuthorizationDocumentId = ad.AuthorizationDocumentId
JOIN AuthorizationCodes ac on ac.AuthorizationCodeId = a.AuthorizationCodeId
JOIN CustomClients cc ON cc.ClientId = c.ClientId
WHERE AuthorizationCodeName LIKE Coalesce(@coverage_plan_id,''AuthorizationCodeName'')
AND (
	a.StartDate between @begin_date and @end_date
--select @sql4 = 	'''''''' + (convert(varchar(10),@begin_date, 101)) + ''''''''
--select @sql5 = 	'''''''' + (convert(varchar(10),@end_date, 101)) + ''''''''
--select @sql6 = 	
	or a.EndDate between @begin_date and @end_date)
	
--select @sql7 =
--	'')''

--print (@sql3 + @sql4 + '' and '' + @sql5 + @sql6 +  @sql4 + '' and '' + @sql5 + @sql7)
--exec (@sql3 + @sql4 + '' and '' + @sql5 + @sql6 +  @sql4 + '' and '' + @sql5 + @sql7)



--*****************************************************************--
--END OF This Section grabs all auths, used or not*****************--
--*****************************************************************--

INSERT	INTO	@final_results
SELECT	*
FROM	#proc_auth pa
WHERE	pa.auth_num not in	(
				SELECT	auth_num
				FROM	@final_results
				)

SELECT	fr.patient_id,
	fr.episode_id,
	fr.client_lname,
	fr.client_fname,
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
	fr.amt_auth,
	fr.counselor,
	fr.staff_lname,
	fr.staff_fname,
	fr.coverage_plan_id,
	fr.amount_used,
	fr.amount_billed,
	fr.amount_available
	--@begin_date,
	--@end_date,
	--@staff_lname,
	--@staff_fname,
	--@service,
	--@coverage_plan_id
FROM	@final_results fr
ORDER	BY
	fr.client_lname,
	fr.client_fname,
	fr.auth_num,
	fr.proc_code,
	fr.staff_lname,
	fr.staff_fname


drop TABLE	#results_before_service_summation
drop table	#results_after_service_summation
drop table	#temp_used_amount1
drop table	#temp_used_amount2
drop table	#proc_auth

END
' 
END
GO
