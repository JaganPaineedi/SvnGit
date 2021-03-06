/****** Object:  StoredProcedure [dbo].[csp_Report_medicaid_caps]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_medicaid_caps]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_medicaid_caps]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_medicaid_caps]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_medicaid_caps]
	-- Add the parameters for the stored procedure here
	@start_date			datetime,
	@end_date			datetime,
	@staff_super_or_vp	varchar (10),
	@StaffId			Int,
	@service			Int,
	@ClientId			Int,
	@threshold_only		varchar(3),
	@unduplicated_only	varchar(3)
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_medicaid_caps			              	*/
/* Creation Date:	01/14/2012                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/
/*                                                                   	*/
/* Purpose: Generate report to show Medicaid Authorization Caps        	*/
/*                                                                   	*/
/* Input Parameters:	@start_date, @end_date, @staff_super_or_vp,		*/
/*	@StaffId, @service, @ClientId, @threshold_only,	@unduplicated_only	*/
/*								     									*/
/* Description: Will generate a report of clients Total Authorized     	*/
/*	Medicaid Units and the total Units used from services.     			*/
/*                                                                   	*/
/* Updates:																*/
/*  Date		Author		Purpose										*/
/*	01/11/2012	MSR			Convert from PsychConsult to Smartcare		*/
/************************************************************************/
/*
DECLARE	
	@start_date			datetime,
	@end_date			datetime,
	@staff_super_or_vp	varchar (10),
	@StaffId			Int,
	@service			Int,
	@ClientId			Int,
	@threshold_only		varchar(3),
	@unduplicated_only	varchar(3)

SELECT	
	@start_date			= ''01/1/13'',
	@end_date			= ''2/06/13'',
	@staff_super_or_vp	= ''vp'',
	@StaffId			= 0,--1138,
	@service			= 22,
	@ClientId			= 0,
	@threshold_only		= ''yes'',
	@unduplicated_only	= ''no''
--*/
DECLARE	@input_name	varchar(50)

DECLARE	@service_types TABLE
(
	service_type		Int
)

IF OBJECT_ID(''tempdb..#authorizations'',''U'') IS NOT NULL DROP TABLE #authorizations
CREATE TABLE #authorizations
(
	ClientId			Int,
	ServiceId			Int,
	service_type		varchar(10),
	authorization_no	Varchar(35),
	authorized_units	float,
	units_used			float
)

IF OBJECT_ID(''tempdb..#authorizations_used'',''U'') IS NOT NULL DROP TABLE #authorizations_used
CREATE TABLE #authorizations_used
(
	ClientId			Int,
	ServiceId			Int,
	service_type		varchar(10),
	authorization_no	VARCHAR(35),
	units_used			float
)

IF OBJECT_ID(''tempdb..#auth_staff'',''U'') IS NOT NULL DROP TABLE #auth_staff
CREATE TABLE #auth_staff
(
	ClientId			Int,
	ServiceId			Int,
	service_type		varchar(10),
	authorization_no	VARCHAR(35),
	staff_id			INT
)

IF OBJECT_ID(''tempdb..#classrooms'',''U'') IS NOT NULL DROP TABLE #classrooms
CREATE TABLE #classrooms -- For Partial Hosp Only
(
	ClientId			Int,
	ServiceId			Int,
	service_type		varchar(10),
	authorization_no	VARCHAR(35),
	classroom			varchar(10)
)

DECLARE	@prior_auth_forms	 TABLE
(
	ClientId			Int,
	ServiceId			Int,
	service_type		varchar(10),
	authorization_no	VARCHAR(35),
	status				varchar(10),
	response_date		datetime,
	amount_requested	int,
	amount_approved		int
)

IF OBJECT_ID(''tempdb..#tj_modifier'',''U'') IS NOT NULL DROP TABLE #tj_modifier
CREATE TABLE #tj_modifier
(
	ClientId		Int,
	ServiceId		Int,
	tj_modifier		char(1)
)

IF OBJECT_ID(''tempdb..#results'',''U'') IS NOT NULL DROP TABLE #results
CREATE TABLE #results
(
	ClientId			Int,
	ServiceId			Int,
	--referral_no		Varchar(35),  -- Removed from table MSR 01/14/13
	authorized_units	float,
	units_used			float,
	staff_id			Int,
	classroom			varchar(10),	-- For Partial Hosp Only
	--status			varchar(25),  -- Removed from table MSR 01/14/13
	service_type		varchar(25),
	auth_no				varchar(35),
	response_date		datetime,
	amount_requested	int,
	amount_approved		int,
	tj_modifier			char(1)
)

IF OBJECT_ID(''tempdb..#summed_results'',''U'') IS NOT NULL DROP TABLE #summed_results
CREATE TABLE #summed_results
(
	client			varchar(55),
	staff			varchar(55),
	ClientId		Int,
	ServiceId		Int,
	--referral_no		varchar(35),  -- Removed from table MSR 01/14/13
	authorized_units	float,
	units_used		float,
	staff_id		Int,
	classroom		varchar(10),	-- For Partial Hosp Only
	--status			varchar(25),  -- Removed from table MSR 01/14/13
	service_type		varchar(25),
	auth_no			varchar(35),
	response_date		datetime,
	amount_requested	int,
	amount_approved		int,
	tj_modifier		char(1),
	warning_flag		char(1)
)
--***************************************************************************
--***** Michael''s Staff_Super_or_VP Module *************************************
--***************************************************************************
BEGIN
DECLARE @staffNameTable TABLE
	(
	StaffID		char(7),
	StaffName	Varchar(50)
	)
	
INSERT INTO @staffNameTable
SELECT * FROM dbo.fn_Staff_Full_Name()

SELECT	@input_name =	(
				SELECT	st.StaffName 
				FROM	@staffNameTable st
				WHERE	st.StaffID = @StaffId 
				)
END

IF OBJECT_ID(''tempdb..#TempStaff'',''U'') IS NOT NULL DROP TABLE #TempStaff	

CREATE TABLE #TempStaff
	(
	StaffId char(10)
	)

IF @StaffId  = 0
	BEGIN
		INSERT INTO #TempStaff (StaffId)
		SELECT s.StaffId FROM  @staffNameTable s ORDER BY s.StaffID 
		
		DELETE FROM #TempStaff
		WHERE StaffId = 000
	END 

IF	@staff_super_or_vp like ''Su%'' AND @StaffId  <> 0
--If Super is input then grab all staff 1 level below input staff	
	BEGIN
			INSERT INTO #TempStaff
			SELECT StaffId FROM dbo.fn_Supervisor_List(1, @StaffId)
	END

IF	@staff_super_or_vp like ''VP'' AND @StaffId  <> 0
--If VP is input then grab all staff up to 10 levels below input staff
	BEGIN
			INSERT INTO #TempStaff
			SELECT StaffId FROM dbo.fn_Supervisor_List(10, @StaffId)
	END

IF @staff_super_or_vp LIKE ''St%'' AND @StaffId  <> 0
	BEGIN
		INSERT INTO #TempStaff (StaffId)
		VALUES (@StaffId)
	END

--SELECT * FROM #TempStaff ORDER BY StaffId

--***************************************************************************
--***** END OF Jess''s Staff_Super_or_VP Module ******************************
--***************************************************************************

--Added Table to store Clients for user pull-down on form.  MSR 01/15/2013
DECLARE @ClientTable TABLE
(
	ClientID	Int,
	ClientName	Varchar(50)
)

--Fills @ClientTable depending on the choice made by the user on the form
If @ClientId <> 0 BEGIN
INSERT INTO @ClientTable 
SELECT c.ClientId, c.LastName + '', '' + c.FirstName FROM Clients c WHERE c.ClientId = @ClientId 
END
ELSE BEGIN
INSERT INTO @ClientTable 
SELECT * FROM dbo.fn_Active_Client_Table()

DELETE FROM @ClientTable 
WHERE ClientID = 0
END

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ Get list of services ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IF	@service <> 0
BEGIN
-- Change Insert based on user pull-down on form.  MSR 01/10/2013
	INSERT	INTO	@service_types
	VALUES (@service)
	--SELECT	CASE	WHEN	@service like ''Pa%''
	--		THEN	27 -- Authorization Code for ''MCDPARHOSP''
	--		WHEN	@service like ''Co%''
	--		THEN	''MCDCOUNSEL''
	--		WHEN	@service like ''CP%''
	--		THEN	22 -- Authorization Code for ''MCDCPST''
	--		WHEN	@service like ''DA%M%''
	--		THEN	''MCDDABYMD''
	--		WHEN	@service like ''DA%''
	--		THEN	''MCDDA''
	--		WHEN	@service like ''Ph%''
	--		THEN	''MCDPHARM''
	--		WHEN	@service like ''Cr%''
	--		THEN	''MCDCRISIS''
	--		WHEN	@service like ''Ps%''
	--		THEN	''MCDPEBYAPN''
	--	END
END

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Removed Partial Hosp from Threshold report.  Jess 5/7/12 ~~~~~~~~~~~
/*
ELSE IF	(	@unduplicated_only like ''Y%''
	OR	@threshold_only like ''Y%''
	)
BEGIN
	INSERT	INTO	@service_types	SELECT	27 -- Authorization Code for ''MCDPARHOSP''
	INSERT	INTO	@service_types	SELECT	22 -- Authorization Code for ''MCDCPST''
END
*/

ELSE IF	@threshold_only like ''Y%''
BEGIN
	INSERT	INTO	@service_types	SELECT	22 -- Authorization Code for 22 -- Authorization Code for ''MCDCPST'' MSR 01/14/13
END

ELSE IF	@unduplicated_only like ''Y%''
BEGIN
	INSERT	INTO	@service_types	SELECT	22 -- Authorization Code for 22 -- Authorization Code for ''MCDCPST'' MSR 01/14/13
	INSERT	INTO	@service_types	SELECT	27 -- Authorization Code for 27 -- Authorization Code for ''MCDPARHOSP'' MSR 01/14/13
END
-- END OF Removed Partial Hosp from Threshold report.  Jess 5/7/12 ~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ELSE IF	@service = 0
BEGIN
	INSERT	INTO	@service_types	SELECT	21 -- Authorization Code for ''MCDCOUNSEL'' MSR 01/14/13
	INSERT	INTO	@service_types	SELECT	22 -- Authorization Code for 22 -- Authorization Code for ''MCDCPST'' MSR 01/14/13
	INSERT	INTO	@service_types	SELECT	23 -- Authorization Code for ''MCDCRISIS'' MSR 01/14/13
	INSERT	INTO	@service_types	SELECT	24 -- Authorization Code for ''MCDDA'' MSR 01/14/13
	INSERT	INTO	@service_types	SELECT	25 -- Authorization Code for ''MCDDABYMD'' MSR 01/14/13
	INSERT	INTO	@service_types	SELECT	27 -- Authorization Code for 27 -- Authorization Code for ''MCDPARHOSP'' MSR 01/14/13
	INSERT	INTO	@service_types	SELECT	28 -- Authorization Code for ''MCDPEBYAPN'' MSR 01/14/13
	INSERT	INTO	@service_types	SELECT	29 -- Authorization Code for ''MCDPHARM'' MSR 01/14/13
END

--SELECT * FROM @service_types 
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ END OF Get list of services ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

--select ''@service_types'', * from @service_types

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	INSERT	INTO	#authorizations
	SELECT	DISTINCT
		cc.ClientId,
		SA.ServiceId,
		a.AuthorizationCodeId,
		a.AuthorizationNumber,
		CASE	WHEN a.AuthorizationCodeId = 27
				THEN 60*ISNULL(a.Units,0)
				ELSE ISNULL(a.Units,0)
		END,
		CASE	WHEN a.AuthorizationCodeId = 27
				THEN 60* sum(ISNULL(a.UnitsUsed,0))
				ELSE sum(ISNULL(a.UnitsUsed,0))
		END
	FROM	dbo.Authorizations a
	JOIN	@service_types st
	ON	a.AuthorizationCodeId = st.service_type
	JOIN dbo.AuthorizationDocuments ad
	ON a.AuthorizationDocumentId = ad.AuthorizationDocumentId 
	AND (ISNULL(ad.RecordDeleted,''N'')<>''Y'')
	JOIN dbo.ClientCoveragePlans cc
	ON ad.ClientCoveragePlanId = cc.ClientCoveragePlanId 
	AND (ISNULL(cc.RecordDeleted,''N'')<>''Y'')	
	JOIN dbo.ServiceAuthorizations sa
	ON cc.ClientCoveragePlanId = sa.ClientCoveragePlanId 
	AND (ISNULL(sa.RecordDeleted,''N'')<>''Y'')		
	JOIN	services srv
	ON	sa.ServiceId = srv.ServiceId
	AND	cc.ClientId = srv.ClientId
	AND (ISNULL(srv.RecordDeleted,''N'')<>''Y'')	
	AND	a.StartDate <= srv.DateOfService
	AND	a.EndDate >= srv.DateOfService
	AND	srv.status in (71, 75) -- Global Codes for ''Show'' and ''Complete'' MSR 01/14/13
	JOIN dbo.Clients c
	ON srv.ClientId = c.ClientId 
	AND (ISNULL(c.RecordDeleted,''N'')<>''Y'')	
	AND c.Active = ''Y''
	WHERE	a.StartDate <= @end_date
	AND	a.EndDate >= @start_date
	AND (ISNULL(a.RecordDeleted,''N'')<>''Y'')	
	AND c.ClientId IN (SELECT ClientID FROM @ClientTable)
	GROUP	BY
		cc.ClientId,
		SA.ServiceId,
		a.AuthorizationCodeId,
		a.AuthorizationNumber,
		a.Units

--select ''#authorizations'', * from #authorizations ORDER BY ClientId 

/*
	INSERT	INTO	#authorizations_used
	SELECT	DISTINCT
		a.ClientId,
		a.ServiceId,
		a.service_type,
		a.referral_no,
		a.authorization_no,
		60 * COUNT(DISTINCT srv.appt_date)
	FROM	#authorizations a
	JOIN	services_cov sa
	ON	a.authorization_no = sa.authorization_no
	AND	a.ClientId = sa.ClientId
	AND	a.ServiceId = sa.ServiceId
	JOIN	services srv
	ON	sa.clinical_transaction_no = srv.clinical_transaction_no
	AND	sa.ClientId = srv.ClientId
	AND	sa.ServiceId = srv.ServiceId
	WHERE	srv.status in (71, 75) -- Global Codes for ''Show'' and ''Complete''
	GROUP	BY
		a.ClientId,
		a.ServiceId,
		a.service_type,
		a.referral_no,
		a.authorization_no

select ''#authorizations used'', * from #authorizations_used

*/

IF	@unduplicated_only like ''Y%''
BEGIN
	INSERT	INTO	#auth_staff
	SELECT	DISTINCT
		a.ClientId,
		a.ServiceId,
		a.service_type,
		a.authorization_no,
		srv.LocationId
	FROM	#authorizations a
	JOIN	Services srv
	ON	a.ClientId = srv.ClientId
	AND (ISNULL(srv.RecordDeleted, ''N'')<>''Y'')
	AND	a.ServiceId = srv.ServiceId
	AND	srv.DateOfService >= @start_date
	AND	srv.DateOfService <= @end_date
	AND	srv.ProcedureCodeId = 457 -- Procedure Code for ''PART_HOSP'' MSR 01/14/13
	AND	srv.status in (71, 75) -- Global Codes for ''Show'' and ''Complete'' MSR 01/14/13
	WHERE	a.service_type = 27 -- Authorization Code for ''MCDPARHOSP'' MSR 01/14/13
	AND	srv.DateOfService =	(	SELECT	MAX(srv2.DateOfService)
						FROM	Services srv2
						WHERE	srv.ClientId = srv2.ClientId
						AND (ISNULL(srv2.RecordDeleted, ''N'')<>''Y'')
						AND	srv.ServiceId = srv2.ServiceId
						AND	srv2.ProcedureCodeId = 457 -- Procedure Code for ''PART_HOSP'' MSR 01/14/13
						AND	srv2.status in (71, 75) -- Global Codes for ''Show'' and ''Complete'' MSR 01/14/13
						AND	srv2.DateOfService >= @start_date
						AND	srv2.DateOfService <= @end_date
					)

	INSERT	INTO	#auth_staff
	SELECT	DISTINCT
		a.ClientId,
		a.ServiceId,
		a.service_type,
		a.authorization_no,
		c.PrimaryClinicianId 
	FROM	#authorizations a
	LEFT	JOIN	services srv
	ON	a.ClientId = srv.ClientId
	AND	a.ServiceId = srv.ServiceId
	AND (ISNULL(srv.RecordDeleted, ''N'')<>''Y'')	
	JOIN clients c
	ON srv.ClientId = c.ClientId 
	AND (ISNULL(c.RecordDeleted, ''N'')<>''Y'')	
	WHERE	a.service_type = 22 -- Authorization Code for ''MCDCPST'' MSR 01/14/13
END
ELSE
BEGIN
	INSERT	INTO	#auth_staff
	SELECT	DISTINCT
		a.ClientId,
		a.ServiceId,
		a.service_type,
		a.authorization_no,
		srv.ClinicianId 
	FROM	#authorizations a
	JOIN	services srv
	ON	a.ClientId = srv.ClientId
	AND	a.ServiceId = srv.ServiceId
	AND (ISNULL(srv.RecordDeleted, ''N'')<>''Y'')	
	WHERE	srv.status in (71, 75) -- Global Codes for ''Show'' and ''Complete'' MSR 01/14/13
END

--select ''#auth_staff'', * from #auth_staff

INSERT	INTO	#classrooms
SELECT	DISTINCT
	a.ClientId,
	a.ServiceId,
	a.service_type,
	a.authorization_no,
	g.GroupName 
FROM	#authorizations a
JOIN	Services srv
ON	a.ClientId = srv.ClientId
AND	a.ServiceId = srv.ServiceId
AND	srv.DateOfService >= @start_date
AND	srv.DateOfService <= @end_date
AND	srv.ProcedureCodeId = 457 -- Procedure Code for ''PART_HOSP'' MSR 01/14/13
AND	srv.status in (71, 75) -- Global Codes for ''Show'' and ''Complete'' MSR 01/14/13
AND (ISNULL(srv.RecordDeleted, ''N'')<>''Y'')
JOIN dbo.GroupServices gs
ON srv.GroupServiceId = gs.GroupServiceId 
AND (ISNULL(gs.RecordDeleted, ''N'')<>''Y'')
JOIN dbo.Groups g
ON gs.GroupId = g.GroupId 
AND (ISNULL(g.RecordDeleted, ''N'')<>''Y'')
WHERE	a.service_type = 27 -- Authorization Code for ''MCDPARHOSP'' MSR 01/14/13
AND	srv.DateOfService =	(	SELECT	MAX(srv2.DateOfService)
					FROM	services srv2 
					WHERE	srv.ClientId = srv2.ClientId
					AND	srv.ServiceId = srv2.ServiceId
					AND	srv2.ProcedureCodeId = 457 -- Procedure Code for ''PART_HOSP'' MSR 01/14/13
					AND	srv2.status in (71, 75) -- Global Codes for ''Show'' and ''Complete'' MSR 01/14/13
					AND	srv2.DateOfService >= @start_date
					AND	srv2.DateOfService <= @end_date
					AND (ISNULL(srv2.RecordDeleted, ''N'')<>''Y'')					
				)

--select ''#classrooms'', * from #classrooms

 --Commented out MSR 01/10/2013 to be modified at a future date.
--INSERT	INTO	@prior_auth_forms
--SELECT	DISTINCT
--	a.ClientId,
--	a.ServiceId,
--	a.service_type,
--	a.authorization_no,
--	CASE	WHEN	srv.status <> 75 -- Global Codes for ''Complete''
--		THEN	''In Process''
--		ELSE	convert(varchar, srv.DateOfService, 101)
--	END,
--	CASE	WHEN	cmaa.response_date is NOT NULL
--		THEN	cmaa.response_date
--		ELSE	cmar.response_date
--	END,
--	CASE	WHEN	cmaa.response_date is NOT NULL
--		THEN	cmaa.requested_amount
--		ELSE	cmar.requested_amount
--	END,
--	CASE	WHEN	cmaa.response_date is NOT NULL
--		THEN	cmaa.approved_amount
--		WHEN	cmar.response_date is NULL
--		THEN	NULL
--		ELSE	0
--	END	
--FROM	#authorizations a
--JOIN	services srv
--	ON	a.ClientId = srv.ClientId
--	AND	a.ServiceId = srv.ServiceId
--	AND	(	a.service_type = 27 -- Authorization Code for ''MCDPARHOSP'' AND srv.proc_code = ''MAUTH_PREQ''
--		OR	a.service_type = 22 -- Authorization Code for ''MCDCPST''
--		AND srv.ProcedureCodeId = 647 -- Procedure Code for ''MAUTH_CREQ''
--		)
--	AND	srv.status <> ''ER''
--	AND	srv.DateOfService >= @start_date
--JOIN	dbo.GroupServices gs
--ON	srv.GroupServiceId = gs.GroupServiceId
----AND	ltrim(rtrim(gs.remark)) = a.referral_no
--LEFT	JOIN	doc_entity de
--ON	srv.clinical_transaction_no = de.clinical_transaction_no
--AND	de.doc_code = ''MAUTH_A_DT''
--AND	de.is_locked = ''Y''
--AND	de.status <> ''ER''
--LEFT	JOIN	cstm_mcd_auth_acc cmaa
--ON	de.doc_session_no = cmaa.doc_session_no
--AND	de.current_version_no = cmaa.version_no
--LEFT	JOIN	doc_entity de2 
--ON	srv.clinical_transaction_no = de2.clinical_transaction_no
--AND	de2.doc_code = ''MAUTH_R_DT''
--AND	de2.is_locked = ''Y''
--AND	de2.status <> ''ER''
--LEFT	JOIN	cstm_mcd_auth_rej cmar
--ON	de2.doc_session_no = cmar.doc_session_no
--AND	de2.current_version_no = cmar.version_no


--select ''@prior_auth_forms'', * from @prior_auth_forms

INSERT	INTO	#tj_modifier
SELECT	a.ClientId,
	a.ServiceId,
	''Y''
FROM	#authorizations a
JOIN	dbo.ClientCoveragePlans cp
ON	a.ClientId = cp.ClientId
AND	(cp.CoveragePlanId IN (1816, 1817, 1818, 1819, 1827))	-- CoveragePlan Codes for DFMCD4801T, DFMCD4802T, 
															-- DFMCD48OAT, DFMCD48OYT, MHMCD4803T MSR 01/14/13
AND (ISNULL(cp.RecordDeleted, ''N'')<>''Y'')															

INSERT	INTO	#results (ClientId, ServiceId, authorized_units, units_used, staff_id, classroom, service_type, auth_no, response_date, amount_requested, amount_approved, tj_modifier)
SELECT DISTINCT	a.ClientId,
	a.ServiceId,
	convert(float, a.authorized_units) / convert(float, 60) as ''Authorized Units'',
	CASE	WHEN	a.units_used IS NULL
		THEN	0
		ELSE	convert(float, a.units_used) / convert(float, 60)
	END	AS	''Units Used'',
	ast.staff_id,
	c.classroom,
	a.service_type,
	a.authorization_no,
	''01/01/2000'', --paf.response_date, MSR 01/14/13
	0, --paf.amount_requested, MSR 01/14/13
	0, --paf.amount_approved, MSR 01/14/13
	tj.tj_modifier
/*
	CASE	WHEN	(	a.service_type = 27 -- Authorization Code for ''MCDPARHOSP''
			AND	(convert(float, a.authorized_units) / convert(float, 60)) - (convert(float, au.units_used) / convert(float, 60)) <= 20	-- Authorized Units - Units Used
			)
*/
/*
	CASE	WHEN	(	a.service_type = 27 -- Authorization Code for ''MCDPARHOSP''
			AND	(''Authorized Units'' / convert(float, 60)) - (''Units Used'' / convert(float, 60)) <= 20	-- Authorized Units - Units Used
			)
		THEN	''Y''
		WHEN	(	a.service_type = 22 -- Authorization Code for ''MCDCPST''
			AND	(convert(float, a.authorized_units) / convert(float, 60)) - (convert(float, au.units_used) / convert(float, 60)) <= 24	-- Authorized Units - Units Used
			)
		THEN	''Y''
		ELSE	''N''
	END	AS	''warning_flag''
*/
FROM	#authorizations a
LEFT JOIN	#auth_staff ast
ON a.ServiceId = ast.ServiceId 
LEFT JOIN	#classrooms c
ON	a.authorization_no = c.authorization_no
LEFT JOIN	#tj_modifier tj
ON	a.ServiceId = tj.ServiceId
AND	a.ClientId = tj.ClientId

  --SELECT ''Results'', * from #results --order by units_used desc	-- TEMP BY JESS 5/7/12

INSERT	INTO	#summed_results
SELECT	
c.LastName + '', '' + c.FirstName as ''Client'',
	CASE	WHEN	s.StaffId IS NULL
		THEN	CAST(r.staff_id AS Varchar)
		ELSE	s.LastName + '', '' + s.FirstName
	END	AS	''Staff'',
	r.*,
	CASE	WHEN	(	r.service_type = 27 -- Authorization Code for ''MCDPARHOSP'' MSR 01/14/13
			AND	r.authorized_units - r.units_used <= 20	-- Authorized Units - Units Used MSR 01/14/13
			)
		THEN	''Y''
		WHEN	(	r.service_type = 22 -- Authorization Code for ''MCDCPST'' MSR 01/14/13
			AND	r.authorized_units - r.units_used <= 24	-- Authorized Units - Units Used MSR 01/14/13
			)
		THEN	''Y''
		ELSE	''N''
	END	AS	''warning_flag''
FROM	#results r
LEFT JOIN	Clients c
ON	r.ClientId = c.ClientId
AND (ISNULL(c.RecordDeleted, ''N'')<>''Y'')
LEFT JOIN	staff s
ON	r.staff_id = s.StaffId
AND (ISNULL(s.RecordDeleted, ''N'')<>''Y'')


IF	@threshold_only like ''Y%''
BEGIN
	DELETE
	FROM	#summed_results
	WHERE	warning_flag = ''N''
END


--/*
--select ''#authorizations'', * from #authorizations WHERE ClientId = 30
--select ''#auth_staff'', * from #auth_staff WHERE ClientId = 30
--select ''#classrooms'', * from #classrooms WHERE ClientId = 30
--select ''@prior_auth_forms'', * from @prior_auth_forms WHERE ClientId = 30
--select ''#results'', * from #results WHERE ClientId = 30
--select ''#summed_results'', * from #summed_results sr ORDER BY sr.staff 
--*/


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ FINAL RESULTS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
IF	@unduplicated_only like ''Y%''
BEGIN
	SELECT	DISTINCT
		sr.client,
		CAST(sr.ClientId as Int) as ''clientId'',
		sr.staff,
		sr.staff_id,
		CASE	WHEN	sr.service_type = 22 -- Authorization Code for ''MCDCPST'' MSR 01/14/13
			THEN	ac.DisplayAs
			WHEN	sr.service_type = 27 -- Authorization Code for ''MCDPARHOSP'' MSR 01/14/13
			THEN	ac.DisplayAs + '' '' + ISNULL(sr.classroom,'''') -- sr.staff MSR 01/14/13
		END	AS	''service'',
		sr.authorized_units,
		sr.units_used,
		sr.classroom as ''classroom'',
		''z'' AS ''status'',
		CASE	WHEN	sr.service_type = 22 -- Authorization Code for ''MCDCPST'' MSR 01/14/13
			THEN	sr.staff
			WHEN	sr.service_type = 27 -- Authorization Code for ''MCDPARHOSP'' MSR 01/14/13
			THEN	sr.classroom
		END	AS	''service_type'',
		sr.auth_no,
		sr.response_date,
		sr.amount_requested,
		sr.amount_approved,
		CASE	WHEN	sr.tj_modifier IS NULL
			THEN	''N''
			ELSE	sr.tj_modifier
		END	AS	''tj_modifier'',
		CASE	WHEN	sr.warning_flag IS NULL
			THEN	''N''
			ELSE	sr.warning_flag
		END	AS	''warning_flag'',
		@input_name as ''Name Input'',
		sr.authorized_units - sr.units_used as ''Units Remaining''
	FROM	#summed_results sr
	LEFT JOIN	#TempStaff ts
	ON		sr.staff_id = ts.StaffID
		--OR	sr.staff_id in (''Robinson'', ''Westfield''))		
	LEFT JOIN dbo.AuthorizationCodes ac
	ON sr.service_type = ac.AuthorizationCodeId 
	AND (ISNULL(ac.RecordDeleted, ''N'')<>''Y'')	

END

ELSE
BEGIN
	SELECT	DISTINCT
		sr.client,
		sr.ClientId,
		sr.staff,
		sr.staff_id,
		ac.DisplayAs as ''Service'',				
		sr.authorized_units,
		sr.units_used,
		sr.classroom,
		''z'' AS ''status'',
		sr.service_type,
		sr.auth_no,
		sr.response_date,
		sr.amount_requested,
		sr.amount_approved,
		CASE	WHEN	sr.tj_modifier IS NULL
			THEN	''N''
			ELSE	sr.tj_modifier
		END	AS	''tj_modifier'',
		CASE	WHEN	sr.warning_flag IS NULL
			THEN	''N''
			ELSE	sr.warning_flag
		END	AS	''warning_flag'',
		@input_name as ''Name Input'',
		sr.authorized_units - sr.units_used as ''Units Remaining''
	FROM	#summed_results sr
	JOIN	#TempStaff ts
	ON		sr.staff_id = ts.StaffID
	JOIN dbo.AuthorizationCodes ac
	ON sr.service_type = ac.AuthorizationCodeId 
	AND (ISNULL(ac.RecordDeleted, ''N'')<>''Y'')	
	--ORDER BY sr.staff, sr.ClientId 
		
END

DROP TABLE #TempStaff 
DROP TABLE #auth_staff 
DROP TABLE #authorizations 
DROP TABLE #authorizations_used 
DROP TABLE #classrooms
DROP TABLE #tj_modifier 
DROP TABLE #results 
DROP TABLE #summed_results

' 
END
GO
