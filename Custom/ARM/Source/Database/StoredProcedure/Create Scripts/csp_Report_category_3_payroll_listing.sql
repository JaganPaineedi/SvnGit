/****** Object:  StoredProcedure [dbo].[csp_Report_category_3_payroll_listing]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_category_3_payroll_listing]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_category_3_payroll_listing]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_category_3_payroll_listing]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_category_3_payroll_listing]
	@StaffLastName varchar(30),
	@StaffFirstName varchar(20),
	@StartDate datetime,
	@EndDate datetime

AS
--*/

/*
DECLARE	@staff_last_name varchar(30),
	@StaffLastName varchar(30),
	@StaffFirstName varchar(20),
	@StartDate datetime,
	@EndDate datetime

SELECT	@StaffLastName = ''%'',
		@StaffFirstName = ''%'',
		@StartDate = ''1/1/12'',
		@EndDate = ''10/1/12''
--*/

/****************************************************************/
/* Stored Procedure: csp_Report_category_3_payroll_listing		*/
/*																*/
/*	Updates:													*/
/*	Date		Author	Purpose									*/
/*	11-08-04	Brian	work order  2653						*/
/*	02-08-06	Jess	added nolock							*/
/*	02-24-06	Jess	removed clinical_transaction view		*/
/*	05-12-08	Jess	re-vamped report completely				*/
/*	07-05-12	Jess	Converted from Psych Consult			*/
/****************************************************************/

IF	@StaffLastName IS NULL SELECT @StaffLastName = ''%''
IF	@StaffFirstName IS NULL SELECT @StaffFirstName = ''%''

SELECT	ltrim(rtrim(ST.FirstName)) + '' '' + ltrim(rtrim(ST.LastName)) AS ''Staff'',
		S.ClientId,
		S.DateOfService,
		DATEDIFF(MINUTE, S.DateOfService, S.EndDateOfService) AS ''Duration'',
		C.LastName + '', '' + C.FirstName AS ''Client'',
		PC.DisplayAs as ''Procedure Code'',
		S.Charge
FROM	Staff ST
JOIN	StaffSalaries SS
	ON	ST.StaffId = SS.StaffId
	AND	SS.EmploymentType = 1000343	-- Category 3
	AND	ISNULL(SS.RecordDeleted, ''N'') <> ''Y''
JOIN	Services S
	ON	ST.StaffId = S.ClinicianId
	AND	ISNULL(S.RecordDeleted, ''N'') <> ''Y''
JOIN	Clients C
	ON	S.ClientId = C.ClientId
	AND	ISNULL(C.RecordDeleted, ''N'') <> ''Y''
JOIN	ProcedureCodes PC
ON		S.ProcedureCodeId = PC.ProcedureCodeId
WHERE	ST.Active = ''Y''
AND		ST.LastName like @StaffLastName
AND		ST.FirstName like @StaffFirstName
AND		S.DateOfService BETWEEN @StartDate AND DATEADD(DD, 1, @EndDate)
AND		ISNULL(ST.RecordDeleted, ''N'') <> ''Y''
AND		S.Status = 75	-- Complete
ORDER	BY
		ST.LastName,
		ST.FirstName,
		S.DateOfService,
		''Client''
' 
END
GO
