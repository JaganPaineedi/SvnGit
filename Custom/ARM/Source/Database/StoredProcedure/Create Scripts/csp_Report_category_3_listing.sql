/****** Object:  StoredProcedure [dbo].[csp_Report_category_3_listing]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_category_3_listing]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_category_3_listing]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_category_3_listing]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	proc [dbo].[csp_Report_category_3_listing]
	@FiscalYear int
					
AS
--*/

/*
DECLARE	@FiscalYear int
SELECT	@FiscalYear = ''2011''
--*/

/************************************************************************/
/* Stored Procedure: csp_Report_category_3_listing						*/
/*						(formerly csp_Report_category_3_listing2)		*/
/* Creation Date:    02/02/2001											*/
/*																		*/
/* Purpose: Summarizes units provided by category 3 staff				*/
/*          for a specified date range									*/
/*																		*/
/* Updates:																*/
/*  Date		Author		Purpose										*/
/*	02/02/2001	Li          Created										*/
/*	09/16/05	Brian       Modified so the dates are not hard coded	*/
/*	02/08/06	Jess		added nolock								*/
/*	07/23/06	Jess		Modified per WO 7536 with dates for FY08.	*/
/*	07/24/06	Jess		Modified per WO 7382 to fix bug				*/
/*	07/24/06	Jess		Modified per WO 9281						*/
/*	07/05/12	Jess		Converted from Psych Consult				*/
/************************************************************************/
set nocount on

DECLARE	@StartDate datetime,
        @EndDate datetime,
		@NewDate datetime

SELECT	@NewDate = convert(datetime, ''06/24/'' + convert(varchar(4),(@FiscalYear - 1)))

IF	DATEPART(dw, @NewDate) = 1
	SELECT	@StartDate = @NewDate
ELSE
	SELECT	@StartDate = dateadd(day,((datepart(dw, @NewDate) - 1) * -1) , @NewDate)

SELECT	@EndDate = dateadd(day, 364, @StartDate)

DECLARE	@Services TABLE
(
	ServiceId int,
	StaffId int,
	ProcedureCodeId int,
	DateOfService datetime,
	DurationUnits float
)

INSERT	INTO	@Services
SELECT	S.ServiceId,
		CASE	WHEN	S.GroupServiceId IS NULL	-- If it is NOT a group, use the clinician of the service
				THEN	S.ClinicianId
				WHEN	S.GroupServiceId IS NOT NULL	-- If it IS a group, get all clinicians that lead
				THEN	GSS.StaffId
		END,
		S.ProcedureCodeId,
		S.DateOfService,
		CASE	WHEN	S.GroupServiceId IS NULL	-- If it is NOT a group, use the duration of the service
				THEN	CASE	WHEN	S.UnitType = 110 -- Minutes
								AND	PC.DisplayAs NOT IN	(	''GROUP_CN'',
															''CSP_GROUP'',
															''V_NBCLASS''
														)
								THEN	CONVERT(FLOAT, DATEDIFF(MINUTE, S.DateOfService, S.EndDateOfService)) / 60
								WHEN	S.UnitType = 110 -- Minutes
								AND		PC.DisplayAs = ''CBA_GROUP''
								THEN	(CONVERT(FLOAT, DATEDIFF(MINUTE, S.DateOfService, S.EndDateOfService)) / 60) / 2
								WHEN	S.UnitType = 110 -- Minutes
								AND		PC.DisplayAs IN	(	''GROUP_CN'',
															''CSP_GROUP'',
															''V_NBCLASS''
														)
								THEN	(CONVERT(FLOAT, DATEDIFF(MINUTE, S.DateOfService, S.EndDateOfService)) / 60) / 3
								WHEN	S.UnitType <> 110 -- NOT Minutes
								THEN	CONVERT(FLOAT, DATEDIFF(MINUTE, S.DateOfService, S.EndDateOfService))
						END
				WHEN	S.GroupServiceId IS NOT NULL	-- If it IS a group, use the duration of only the portion of the group that the given staff lead.
				THEN	CASE	WHEN	S.UnitType = 110 -- Minutes
								AND		PC.DisplayAs NOT IN	(	''GROUP_CN'',
																''CSP_GROUP'',
																''V_NBCLASS''
															)
								THEN	CONVERT(FLOAT, DATEDIFF(MINUTE, GSS.DateOfService, GSS.EndDateOfService)) / 60
								WHEN	S.UnitType = 110 -- Minutes
								AND		PC.DisplayAs = ''CBA_GROUP''
								THEN	(CONVERT(FLOAT, DATEDIFF(MINUTE, GSS.DateOfService, GSS.EndDateOfService)) / 60) / 2
								WHEN	S.UnitType = 110 -- Minutes
								AND		PC.DisplayAs IN	(	''GROUP_CN'',
															''CSP_GROUP'',
															''V_NBCLASS''
														)
								THEN	(CONVERT(FLOAT, DATEDIFF(MINUTE, GSS.DateOfService, GSS.EndDateOfService)) / 60) / 3
								WHEN	S.UnitType <> 110 -- NOT Minutes
								THEN	CONVERT(FLOAT, DATEDIFF(MINUTE, GSS.DateOfService, GSS.EndDateOfService))
						END
		END
FROM	Services S
JOIN	ProcedureCodes PC
ON		S.ProcedureCodeId = PC.ProcedureCodeId
AND		ISNULL(PC.RecordDeleted, ''N'') <> ''Y''
JOIN	StaffSalaries SS
ON		S.ClinicianId = SS.StaffId
AND		ISNULL(SS.RecordDeleted, ''N'') <> ''Y''
LEFT	JOIN	CustomServices CS
ON		S.ServiceId = CS.ServiceId
AND		(	CS.VOT IS NULL
		OR	CS.VOT = ''''
		)
AND		ISNULL(CS.RecordDeleted, ''N'') <> ''Y''
LEFT JOIN	GroupServiceStaff GSS
ON		S.GroupServiceId = GSS.GroupServiceId
AND		ISNULL(GSS.RecordDeleted, ''N'') <> ''Y''

WHERE	S.DateOfService >= @StartDate
AND		S.DateOfService <= @EndDate
AND		S.Status = ''75'' -- Complete
AND		SS.EmploymentType in (''1000343'', ''1000344'') -- Category 3, Temp/Contingency
AND		PC.DisplayAs NOT IN	(	''V_NBWORK'',
								''V_NBSY''
							)


--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ Flat Fee Groups Section Added by Jess 10/21/10 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
DECLARE	@flat_fee_group TABLE
(
	StaffId int,
	ProcedureCodeId int,
	DateOfService datetime,
	DurationUnits float
)

DECLARE	@flat_fee_group_results TABLE
(
	StaffId int,
	ProcedureCodeId int,
	DateOfService datetime,
	DurationUnits float
)

INSERT @flat_fee_group
SELECT	DISTINCT
		S.ClinicianId,
		S.ProcedureCodeId,
		S.DateOfService,
		DATEDIFF(MINUTE, S.DateOfService, S.EndDateOfService)
FROM	Services S
JOIN	ProcedureCodes PC
ON		S.ProcedureCodeId = PC.ProcedureCodeId
AND		ISNULL(PC.RecordDeleted, ''N'') <> ''Y''
JOIN	StaffSalaries SS
ON		S.ClinicianId = SS.StaffId
AND		ISNULL(SS.RecordDeleted, ''N'') <> ''Y''
LEFT	JOIN	CustomServices CS
ON		S.ServiceId = CS.ServiceId
AND		(	CS.VOT IS NULL
		OR	CS.VOT = ''''
		)
AND		ISNULL(CS.RecordDeleted, ''N'') <> ''Y''

WHERE	PC.DisplayAs in	(	''V_NBWORK'',
							''V_NBSY''
						)
AND		SS.EmploymentType in (''1000343'', ''1000344'') -- Category 3, Temp/Contingency

--SELECT	* FROM @flat_fee_group


INSERT	INTO	@flat_fee_group_results
SELECT	DISTINCT
		StaffId,
		ProcedureCodeId,
		DateOfService,
		MAX(DurationUnits)
FROM	@flat_fee_group
GROUP	BY
		StaffId,
		ProcedureCodeId,
		DateOfService

INSERT	INTO	@Services
SELECT	0,
		StaffId, 
		ProcedureCodeId, 
		DateOfService, 
		convert(float, DurationUnits) / 60
FROM	@flat_fee_group_results
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~ END OF Flat Fee Groups Section Added by Jess 10/21/10 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
--~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


SELECT	PC.DisplayAs AS ''Services'',
		ST.StaffId,
		ST.LastName + '', '' + ST.FirstName AS ''Staff'',
		@StartDate AS ''StartDate'',
		@EndDate AS ''EndDate'',
		SUM	(	CASE	WHEN	(	S.DateOfService >= @StartDate
								AND	S.DateOfService < dateadd(day, 14, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units01,  -- week 1 & 2
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 14, @StartDate)
								AND	S.DateOfService < dateadd(day, 28, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units02,  -- week 3 & 4
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 28, @StartDate)
								AND	S.DateOfService < dateadd(day, 42, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units03,  -- week 5 & 6
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 42, @StartDate)
								AND	S.DateOfService < dateadd(day, 56, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units04,  -- week 7 & 8
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 56, @StartDate)
								AND	S.DateOfService < dateadd(day, 70, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units05,  -- week 9 & 10
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 70, @StartDate)
								AND	S.DateOfService < dateadd(day, 84, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units06,  -- week 11 & 12
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 84, @StartDate)
								AND	S.DateOfService < dateadd(day, 98, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units07,  -- week 13 & 14
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 98, @StartDate)
								AND	S.DateOfService < dateadd(day, 112, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units08,  -- week 15 & 16
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 112, @StartDate)
								AND	S.DateOfService < dateadd(day, 126, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units09,  -- week 17 & 18
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 126, @StartDate)
								AND	S.DateOfService < dateadd(day, 140, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units10,  -- week 19 & 20
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 140, @StartDate)
								AND	S.DateOfService < dateadd(day, 154, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units11,  -- week 21 & 22
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 154, @StartDate)
								AND	S.DateOfService < dateadd(day, 168, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units12,  -- week 23 & 24
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 168, @StartDate)
								AND	S.DateOfService < dateadd(day, 182, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units13,  -- week 25 & 26
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 182, @StartDate)
								AND	S.DateOfService < dateadd(day, 196, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units14,  -- week 27 & 28
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 196, @StartDate)
								AND	S.DateOfService < dateadd(day, 210, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units15,  -- week 29 & 30
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 210, @StartDate)
								AND	S.DateOfService < dateadd(day, 224, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units16, -- week 31 & 32
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 224, @StartDate)
								AND	S.DateOfService < dateadd(day, 238, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units17, -- week 33 & 34
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 238, @StartDate)
								AND	S.DateOfService < dateadd(day, 252, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units18, -- week 35 & 36
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 252, @StartDate)
								AND	S.DateOfService < dateadd(day, 266, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units19, -- week 37 & 38
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 266, @StartDate)
								AND	S.DateOfService < dateadd(day, 280, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units20,  -- week 39 & 40
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 280, @StartDate)
								AND	S.DateOfService < dateadd(day, 294, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units21,  -- week 41 & 42
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 294, @StartDate)
								AND	S.DateOfService < dateadd(day, 308, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units22,  -- week 43 & 44
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 308, @StartDate)
								AND	S.DateOfService < dateadd(day, 322, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units23,  -- week 45 & 46
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 322, @StartDate)
								AND	S.DateOfService < dateadd(day, 336, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units24,  -- week 47 & 48
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 336, @StartDate)
								AND	S.DateOfService < dateadd(day, 350, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units25,  -- week 49 & 50
		SUM	(	CASE	WHEN	(	S.DateOfService >= dateadd(day, 350, @StartDate)
								AND	S.DateOfService < dateadd(day, 364, @StartDate)
								)
						THEN	S.DurationUnits
						ELSE	0
				END
			)	AS	Units26,  -- week 51 & 52
		SUM	(S.DurationUnits) AS ''UnitsYTD'',
		convert(varchar(5), @StartDate, 101) + ''-'' + convert(varchar(5), dateadd(day, 13, @StartDate), 101) AS ''Pay01'',
		convert(varchar(5), dateadd(day, 14, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 27, @StartDate), 101) AS ''Pay02'',
		convert(varchar(5), dateadd(day, 28, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 41, @StartDate), 101) AS ''Pay03'',
		convert(varchar(5), dateadd(day, 42, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 55, @StartDate), 101) AS ''Pay04'',
		convert(varchar(5), dateadd(day, 56, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 69, @StartDate), 101) AS ''Pay05'',
		convert(varchar(5), dateadd(day, 70, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 83, @StartDate), 101) AS ''Pay06'',
		convert(varchar(5), dateadd(day, 84, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 97, @StartDate), 101) AS ''Pay07'',
		convert(varchar(5), dateadd(day, 98, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 111, @StartDate), 101) AS ''Pay08'',
		convert(varchar(5), dateadd(day, 112, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 125, @StartDate), 101) AS ''Pay09'',
		convert(varchar(5), dateadd(day, 126, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 139, @StartDate), 101) AS ''Pay10'',
		convert(varchar(5), dateadd(day, 140, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 153, @StartDate), 101) AS ''Pay11'',
		convert(varchar(5), dateadd(day, 154, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 167, @StartDate), 101) AS ''Pay12'',
		convert(varchar(5), dateadd(day, 168, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 181, @StartDate), 101) AS ''Pay13'',
		convert(varchar(5), dateadd(day, 182, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 195, @StartDate), 101) AS ''Pay14'',
		convert(varchar(5), dateadd(day, 196, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 209, @StartDate), 101) AS ''Pay15'',
		convert(varchar(5), dateadd(day, 210, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 223, @StartDate), 101) AS ''Pay16'',
		convert(varchar(5), dateadd(day, 224, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 237, @StartDate), 101) AS ''Pay17'',
		convert(varchar(5), dateadd(day, 238, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 251, @StartDate), 101) AS ''Pay18'',
		convert(varchar(5), dateadd(day, 252, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 265, @StartDate), 101) AS ''Pay19'',
		convert(varchar(5), dateadd(day, 266, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 279, @StartDate), 101) AS ''Pay20'',
		convert(varchar(5), dateadd(day, 280, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 293, @StartDate), 101) AS ''Pay21'',
		convert(varchar(5), dateadd(day, 294, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 307, @StartDate), 101) AS ''Pay22'',
		convert(varchar(5), dateadd(day, 308, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 321, @StartDate), 101) AS ''Pay23'',
		convert(varchar(5), dateadd(day, 322, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 335, @StartDate), 101) AS ''Pay24'',
		convert(varchar(5), dateadd(day, 336, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 349, @StartDate), 101) AS ''Pay25'',
		convert(varchar(5), dateadd(day, 350, @StartDate), 101) + ''-'' + convert(varchar(5), dateadd(day, 363, @StartDate), 101) AS ''Pay26''
FROM	@Services S
JOIN	Staff ST
ON		S.StaffId = ST.StaffId
JOIN	ProcedureCodes PC
ON		S.ProcedureCodeId = PC.ProcedureCodeId
GROUP	BY
		PC.DisplayAs,
		ST.StaffId,
		ST.LastName,
		ST.FirstName,
		PC.ProcedureCodeName
' 
END
GO
