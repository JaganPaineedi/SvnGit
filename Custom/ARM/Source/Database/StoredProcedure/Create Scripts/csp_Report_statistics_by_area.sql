/****** Object:  StoredProcedure [dbo].[csp_Report_statistics_by_area]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_statistics_by_area]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_statistics_by_area]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_statistics_by_area]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE [dbo].[csp_Report_statistics_by_area] 
    @Location varchar(10),
    @Start_Date  datetime,
    @End_Date datetime                                
AS
--*/

/*
DECLARE	@Location varchar(10),
		@Start_Date  datetime,
		@End_Date datetime   

SELECT	@location = ''Secor'',
		@Start_Date = ''04/01/2012'', 
		@End_Date = ''05/01/2012''
--*/

SET NOCOUNT ON -- SET NOCOUNT ON added to prevent extra result sets from interfering with SELECT statements.
/************************************************************************/
/* Stored Procedure: csp_Report_statistics_by_area						*/
/* Creation Date:    03/07/2002											*/
/* Copyright: Harbor													*/
/*																		*/
/* Purpose: List accounts balance by coverage type or payor or staff	*/
/*          or patients or coverage_plan_id								*/
/*																		*/
/* Updates:																*/
/* Date			Author      Purpose										*/
/* 3/07/2002	Li Qin      Created										*/
/* 02/09/2006	Jess		added nolock								*/
/* 02/27/2005	Jess		changed proc_chron -> appt_date				*/
/* 07/04/2012	Jess		Converted from PsychConsult					*/
/************************************************************************/

IF @Location IS NULL
BEGIN
	SELECT @Location = ''%''
END

DECLARE	@Services TABLE
(
	ClientId int,
    ServiceId int,
    ProcedureCode varchar (20),
    MACUCI varchar(20),
    units float
    )
    
INSERT	INTO @Services
SELECT	DISTINCT
		SS.ClientId,
		SS.ServiceId,
		CASE	WHEN	PC.DisplayAs IN	(	''CSP_FCFAM'',
											''CSP_FCLI'',
											''CSP_FFAM'',
											''CSP_FOTH'',
											''CSP_IPADMT'',
											''CSP_TCFAM'',
											''CSP_TCLI'',
											''CSP_TFAM'',
											''CSP_TOTH''
										)
				THEN	''CSP''
				WHEN	PC.DisplayAs LIKE ''EAP_ASS%'' 
				THEN	''EAP_ASSESSMENT''
				WHEN	PC.DisplayAs LIKE ''EAP_COUN%'' 
				THEN	''EAP_COUNSELING''
				WHEN	(	PC.DisplayAs LIKE ''EAP%'' 
						AND PC.DisplayAs NOT IN (''EAP_COUN'',''EAP_ASSESS'')
						)
				THEN	''EAP''
				WHEN	PC.DisplayAs LIKE ''SA%''
				THEN	''SA''
				WHEN	PC.DisplayAs IN	(	''MED IND'',
											''MEDTX_HOSP'',
											''PSYCH_EVAL''
										)
				THEN	''Med Somatic''
				WHEN	PC.DisplayAs IN (	''ASSESSMENT'',
											''INDIV_CN'',
											''GROUP_CN'',
											''CSP_GROUP'',
											''CRISIS_INT'',
											''PART_HOSP'',
											''FAMILY_CN'',
											''COLLAT_CN''
										)
				THEN	PC.DisplayAs
		END,	-- Procedure Code
		CC.MACUCI,
		CASE	WHEN	PC.DisplayAs = ''PART_HOSP''
				THEN	CONVERT(float, DATEDIFF(MINUTE, SS.DateOfService, EndDateOfService)) / 180	--CONVERT(FLOAT,CT.PROC_DURATION)/180
				ELSE	CONVERT(float, DATEDIFF(MINUTE, SS.DateOfService, EndDateOfService)) / 60	--CONVERT(FLOAT,CT.PROC_DURATION)/60
		END	--Units
FROM	Services SS							
JOIN	ProcedureCodes PC
	ON	PC.ProcedureCodeId = SS.ProcedureCodeId
	AND	ISNULL(PC.RecordDeleted,''N'')<>''Y''
JOIN	Locations L
	ON	L.LocationId = SS.LocationId
	AND ISNULL(L.RecordDeleted,''N'')<>''Y''
JOIN	Staff S 
	ON	S.Staffid = SS.ClinicianId
	AND ISNULL(S.RecordDeleted,''N'')<>''Y''
LEFT JOIN	CustomClients CC --cstm_county cc 
	ON	CC.ClientId = SS.ClientId
	AND	ISNULL(CC.RecordDeleted, ''N'') <> ''Y''
WHERE	SS.DateOfService >= @Start_Date
AND		SS.DateOfService < DATEADD(DAY, 1, @End_Date)
AND		SS.Status = ''75'' --Complete
AND		L.LocationName LIKE @location
AND		ISNULL(SS.RecordDeleted,''N'')<>''Y''

--	SELECT * FROM @Services

SELECT ProcedureCode,
       SUM	(	CASE	WHEN	MACUCI IS NULL
						THEN	Units
				END
			)	AS		''Private'',
       SUM	(	CASE	WHEN	MACUCI IS NOT NULL
						THEN	Units
				END
			)	AS		''Public''
FROM	@Services
WHERE	ProcedureCode IS NOT NULL
GROUP BY  ProcedureCode
' 
END
GO
