/****** Object:  StoredProcedure [dbo].[csp_Report_initial_visits_with_insurance]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_initial_visits_with_insurance]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_initial_visits_with_insurance]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_initial_visits_with_insurance]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_initial_visits_with_insurance]
	@location	varchar(10)
AS
--*/

/*
DECLARE	@location varchar(10)
SELECT	@location = ''%''
--*/

SET NOCOUNT ON;	-- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
/********************************************************************/
/* Stored Procedure: csp_Report_eap_clients_seen_for_company		*/
/* Creation Date:    06/22/2012										*/
/* Copyright: Harbor												*/
/*																	*/
/* Updates:															*/
/* Date       	Author		Purpose									*/
/* 06/22/2012	Brian M		Converted from PsychConsult				*/
/*********************************************************************/
SELECT	C.ClientId,
		C.LastName + '', '' + C.FirstName as ''Client'',
		SS.DateOfService,
		PC.DisplayAs AS ''Procedure Code'',
		CC.PrimaryInsCoName, --pc.primary_ins_co_name,
		L.LocationName, 
		S.LastName + '', '' + S.FirstName as ''Clinician'',
		CASE WHEN (datediff(dd, (convert(varchar, datepart(mm, C.DOB)) + 
			''/'' + convert(varchar, datepart(dd, C.DOB)) + ''/3004''),
			(convert(varchar, datepart(mm, getdate())) + ''/'' +
			convert(varchar, datepart(dd, getdate())) + ''/3004''))) >= 0 
			THEN	datediff(yy, C.DOB, getdate())
		ELSE	datediff(yy, C.DOB, getdate()) - 1
		END	AS	''Age''
FROM	Clients C
JOIN	Services SS
	ON	C.ClientId = SS.ClientId
	AND ISNULL(SS.RecordDeleted,''N'')<>''Y''
LEFT JOIN ProcedureCodes PC
	ON	PC.ProcedureCodeId = SS.ProcedureCodeId
	AND	ISNULL(PC.RecordDeleted,''N'')<>''Y''
JOIN	Locations L
	ON	L.LocationId = SS.LocationId	
	AND	L.LocationCode LIKE @location
	AND	ISNULL(L.RecordDeleted,''N'')<>''Y'' 
LEFT JOIN CustomClients CC	
	ON	C.ClientId = CC.ClientId
	AND ISNULL(CC.RecordDeleted,''N'')<>''Y''
JOIN Staff S
	ON	SS.ClinicianId = S.StaffId
	AND ISNULL(S.RecordDeleted,''N'')<>''Y''
WHERE	SS.Status = ''70'' --Scheduled  --''SC''
AND		NOT	EXISTS	(	SELECT	SS2.ClientId
						FROM	Services SS2
						WHERE	SS2.Status IN (''71'', ''75'') -- Show,Complete(''SH'', ''CO'')
						AND		SS2.ClientId = SS.ClientId
						AND		ISNULL(SS2.RecordDeleted,''N'')<>''Y''
					)
AND		ISNULL(C.RecordDeleted,''N'')<>''Y''
ORDER	BY
		L.LocationName,
		SS.DateOfService' 
END
GO
