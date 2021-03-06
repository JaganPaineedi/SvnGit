/****** Object:  StoredProcedure [dbo].[csp_Report_psych_testing_documentation]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_psych_testing_documentation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_psych_testing_documentation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_psych_testing_documentation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_psych_testing_documentation]
	@staff_super_or_vp	varchar(10),
	@StaffId			Int,
	@start_date			datetime,
	@end_date			datetime

AS
--*/

/*
DECLARE	
	@staff_super_or_vp	varchar(10),
	@StaffId			Int,
	@start_date			datetime,
	@end_date			datetime
	
SELECT	
	@staff_super_or_vp = ''st'',
	@StaffId = 0,
	--@StaffId = 159,
	--@StaffId = 0,
	@start_date = ''11/1/2012'',
	@end_date = ''11/30/2012''
--*/

/****************************************************************/
/* Stored Procedure: csp_Report_psych_testing_documentation		*/
/* Creation Date:    01/18/2008					*/
/*								*/
/* Purpose:	Clinical Reports -> DOCUMENTATION REPORTS	*/
/*								*/
/* Called By:	Psych Testing Documentation.rpt			*/
/*								*/
/* Updates:							*/
/*   Date	Author		Purpose				*/
/*  01/18/2008	Jess		Created per WO 8837		*/
/*  08/05/2010	Jess		Modified per WO 15354		*/
/*  11/09/2010	Jess		Modified per WO 16196		*/
/*  09/20/2012	R &	M		Modified per Jess			*/
/****************************************************************/

DECLARE	@input_name	varchar(50)

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
		INSERT INTO #TempStaff (StaffId)
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

--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ END OF This Section Grabs the Staff, Super, and VP information ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

SELECT DISTINCT c.LastName + '', '' + c.FirstName as ''Client'', srv.ClientId as ''Client ID'',
	CASE	WHEN	(	datediff(dd, (convert(varchar, datepart(mm, c.dob)) + ''/'' + convert(varchar, datepart(dd, c.dob)) + ''/3004''), (convert(varchar, datepart(mm, srv.DateOfService)) + ''/'' + convert(varchar, datepart(dd, srv.DateOfService)) + ''/3004''))
			) >= 0 
		THEN	datediff(yy, c.dob, srv.DateOfService)
		ELSE	datediff(yy, c.dob, srv.DateOfService) - 1
	END	AS	''Age'',
	srv.DateOfService	as	''Date of Service'',
	s.LastName + '', '' + s.FirstName as ''Clinician'',
    ISNULL(convert(varchar, ds.SignatureDate, 101),'''') as ''Clinician Signature Date'',
    ISNULL(convert(varchar, ds2.SignatureDate, 101),'''') as ''Reviewer Signature Date'',
	
--	dbo.csf_GetGlobalCodeNameById(do.Status) AS	''Document Done?'',
--    ISNULL(convert(varchar, ds.SignatureDate, 101),'''') as ''Document Completed Date'',
	@input_name as ''Name Input''
FROM	Services srv 
LEFT JOIN	Documents do
/*
ON	srv.ServiceId = do.ServiceId
AND	(do.DocumentCodeId = 10018 OR do.DocumentCodeId = 1000126) -- 10018 = Psychological Testing Note & 1000126 = Psychological Test Report
*/
ON	srv.ClientId = do.ClientId
AND	do.DocumentCodeId = 1000214
and (ISNULL(do.RecordDeleted,''N'')<>''Y'')

JOIN	Clients c
ON	srv.ClientId = c.ClientId
AND (ISNULL(c.RecordDeleted,''N'')<>''Y'')
JOIN	Staff s
ON	srv.ClinicianId = s.StaffId
and (ISNULL(s.RecordDeleted,''N'')<>''Y'')
LEFT JOIN DocumentSignatures ds
ON      do.CurrentDocumentVersionId = ds.SignedDocumentVersionId
AND		ds.StaffId = do.AuthorId
and (ISNULL(ds.RecordDeleted,''N'')<>''Y'')
LEFT JOIN DocumentSignatures ds2
ON      do.CurrentDocumentVersionId = ds2.SignedDocumentVersionId
AND		ds2.StaffId = do.ReviewerId
and (ISNULL(ds.RecordDeleted,''N'')<>''Y'')
WHERE (ISNULL(srv.RecordDeleted,''N'')<>''Y'')

AND srv.ClinicianId in	(
				SELECT	ts.StaffId 
				FROM	#TempStaff ts
				)
AND srv.DateOfService  >= @start_date 
AND srv.DateOfService < (@end_date+1)
AND	srv.ProcedureCodeId in (485, 486, 512, 513)	-- 96101 added by Jess on 8/5/10  -- RSC_PSYTES & RSC_PT_VOC added by Jess 11/9/10
AND (srv.Status = 71 OR srv.Status = 75) --Added by Ryan 10/19/12 Pulls only Show ''71'' or Complete ''75'' services.

ORDER BY
	''Clinician'',
	''Client'',
	''Date of Service''
	
DROP TABLE #TempStaff
' 
END
GO
