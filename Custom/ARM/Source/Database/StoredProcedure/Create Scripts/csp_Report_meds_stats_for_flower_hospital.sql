/****** Object:  StoredProcedure [dbo].[csp_Report_meds_stats_for_flower_hospital]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_meds_stats_for_flower_hospital]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_meds_stats_for_flower_hospital]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_meds_stats_for_flower_hospital]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'-- =============================================
-- Author:		Brian M
-- Create date: 06/14/2012
-- Description:	Converted from Psychconsult
-- =============================================
--/*
CREATE PROCEDURE [dbo].[csp_Report_meds_stats_for_flower_hospital]
	-- Add the parameters for the stored procedure here
		@cpt_input			varchar(200),
		@staff_last_name	varchar(30),
		@staff_first_name	varchar(20)
AS
--*/

/*
DECLARE	@cpt_input		varchar(200),
	@staff_last_name	varchar(30),
	@staff_first_name	varchar(20)

--SELECT	@cpt_input = ''%'',
SELECT	@cpt_input = ''90805, 90807, 90809, 90811, 90813, 90862'',
	@staff_last_name = ''%'',--''nayak'',
	@staff_first_name = ''%''--''c%''
--*/
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

DECLARE	@staff	TABLE
	( staff_id char(10)
	)

INSERT	INTO	@staff
	SELECT	StaffId
	FROM	Staff S
	WHERE	S.LastName LIKE @staff_last_name
		AND	S.FirstName LIKE @staff_first_name
	--	AND	(	s.type <> ''REFERRING'' -- ??????????????????
	--	OR	s.type is null
	--		)
	--	AND	S.Active = ''Y''

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ Takes the list of comma separated CPT codes and splits them out into a temp table ~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DECLARE	@cpt TABLE
( cpt_code	varchar(200)
)

DECLARE	@cpt_codes TABLE
( cpt_code char(25)
)

DECLARE	@x int,
		@len int

IF	@cpt_input <> ''%''
BEGIN
	INSERT	INTO	@cpt
	VALUES	(@cpt_input)

	SELECT	@x = charindex	('','', 	(	SELECT	ltrim(rtrim(cpt_code))
						FROM	@cpt
					)
				)

	WHILE	@x > 1
	BEGIN
		SELECT	@x = charindex	('','',	(	SELECT	ltrim(rtrim(cpt_code))
							FROM	@cpt
						)
					)

		SELECT	@len =	(	SELECT	len(cpt_code)
					FROM	@cpt
				)
		SET	@len = @len - @x

		SELECT	@x = @x - 1

		IF	@x > 1
		BEGIN
			INSERT	INTO	@cpt_codes
			SELECT	substring(ltrim(rtrim(cpt_code)), 1, @x)
			FROM	@cpt
		END

		UPDATE	@cpt
		SET	cpt_code =	(	SELECT	substring(ltrim(rtrim(cpt_code)), (@x + 2), @len)
						FROM	@cpt
					)
	END

	DELETE
	FROM	@cpt_codes
	WHERE	cpt_code is null
	OR	cpt_code = ''''

	INSERT	INTO	@cpt_codes
	SELECT	ltrim(rtrim(cpt_code))
	FROM	@cpt
END

IF	@cpt_input = ''%''
BEGIN	
	INSERT	INTO	@cpt_codes
	SELECT	DISTINCT
		BillingCode
	FROM ProcedureRates	PR		--cpt_code 
	WHERE ISNULL(PR.RecordDeleted,''N'')<>''Y'' 
	ORDER	BY
		BillingCode						--cpt_code
END
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ END OF Takes the list of comma separated CPT codes and splits them out into a temp table ~ 
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/*
select @cpt_input
select * from @cpt_codes
--*/

DECLARE	@transactions TABLE
(
	clinical_transaction_no int,
	clinician_id char(10),
	age_category varchar (16),
	cpt_code varchar(20)--int
)

INSERT	INTO	@transactions
SELECT	SS.ServiceId,
	SS.ClinicianId,
	CASE	WHEN	C.DOB <= dateadd(yy, -13, SS.DateOfService)
		THEN	''Adolescent/Adult''
		WHEN	C.DOB > dateadd(yy, -13, SS.DateOfService)
		THEN	''Child''
		WHEN	C.DOB is null
		THEN	''Unknown Age''
	END	AS	''Age Category'',
	PR.BillingCode     --pct.cpt_code
FROM Services SS	 
	JOIN ProcedureRates PR							
		ON (PR.ProcedureRateId = SS.ProcedureRateId
		AND ISNULL(PR.RecordDeleted,''N'')<>''Y'')
	JOIN Clients C
		ON	(SS.ClientId = C.ClientId
		AND ISNULL(C.RecordDeleted,''N'')<>''Y'') 
	JOIN @cpt_codes cc
		ON	cc.cpt_code = PR.BillingCode 
	JOIN @staff ast
		ON	SS.ClinicianId = ast.staff_id		
WHERE	SS.DateOfService >= dateadd(yy, -2, getdate())
		AND	SS.Status = ''75'' --''CO''
		AND ISNULL(SS.RecordDeleted,''N'')<>''Y''					
ORDER BY
	''Age Category''

--select ''transactions'', * from 	@transactions

SELECT	S.LastName + '', '' + S.FirstName AS ''Staff'',
	t.cpt_code,
	t.age_category,
	COUNT(DISTINCT t.clinical_transaction_no) as ''Transaction Count'',
	convert(varchar, dateadd(yy, -2, getdate()), 101) as ''Start Date'',
	convert(varchar, getdate(), 101) as ''End Date''	
FROM @transactions t
	JOIN Staff S
		ON (t.clinician_id = S.StaffId
		AND ISNULL(S.RecordDeleted,''N'')<>''Y'')
		 
GROUP	BY
	S.LastName + '', '' + S.FirstName,
	age_category,
	cpt_code
	
ORDER	BY
	''Staff'',
	age_category,
	cpt_code
' 
END
GO
