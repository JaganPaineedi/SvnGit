/****** Object:  StoredProcedure [dbo].[csp_Report_client_demographics]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_client_demographics]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_client_demographics]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_client_demographics]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_client_demographics]
	@AgeRangeStart			int,
	@AgeRangeEnd			int,
	@ServiceDateRangeStart	datetime,
	@ServiceDateRangeEnd	datetime,
	@Staff					varchar(10),
	@Program				varchar(10),
	@ProgramType			varchar(10),
	@ProcedureCode			varchar(10),
--	@View					varchar(20),
	@ActiveClientsOnly		char(1)
AS
--*/

/*
DECLARE		@AgeRangeStart			int,
			@AgeRangeEnd			int,
			@ServiceDateRangeStart	datetime,
			@ServiceDateRangeEnd	datetime,
			@Staff					varchar(50),
			@Program				varchar(50),
			@ProgramType			varchar(50),
			@ProcedureCode			varchar(50),
			@View					varchar(20),
			@ActiveClientsOnly		char(1);


SELECT	@AgeRangeStart =			0,
		@AgeRangeEnd =				999,
		@ServiceDateRangeStart =	''7/9/12'',
		@ServiceDateRangeEnd =		''7/10/12'',
		@Staff =					''%'',
		@Program =					''%'',
		@ProgramType =				''%'',
		@ProcedureCode =			''%'',
		@ActiveClientsOnly =		''Y'';

--*/


/********************************************************************/
/* Stored Procedure: csp_Report_client_demographics					*/
/* Creation Date:    07/08/2012										*/
/* Copyright:    Harbor												*/
/*																	*/
/* Purpose: QI Reports												*/
/*																	*/
/* Called By: Client Demographics									*/
/*																	*/
/* Updates:															*/
/* Date			Author	Purpose										*/
/* 07/07/2012	Jess	Created (Modeled after a Psych Consult		*/ 
/*								Canned Report)						*/
/********************************************************************/


--***********************************************************************************
--****** DECLARATIONS ***************************************************************
--***********************************************************************************

WITH 

ClientIdActiveRaceAgeZipGender(ClientID, Active, Race, Age, Zip, Gender, Diagnosis) AS (
SELECT	C.ClientID,
		C.Active,
		COALESCE(GC.CodeName, ''Unspecified''), --Race
		DATEDIFF(YEAR, C.DOB, S.DateOfService) +	CASE	WHEN	DATEPART(MONTH, S.DateOfService) > DATEPART(MONTH, C.DOB)
															THEN	0
															WHEN	DATEPART(MONTH, S.DateOfService) < DATEPART(MONTH, C.DOB)
															THEN	-1
															WHEN	DATEPART(DAY, S.DateOfService) >= DATEPART(DAY, C.DOB)
															THEN	0
															ELSE	-1
													END,	-- Client Age
		COALESCE(CA.Zip, ''Unspecified''), -- Zip
		CASE	WHEN	C.Sex = ''M''
				THEN	''Male''
				WHEN	C.Sex = ''F''
				THEN	''Female''
				ELSE	''Unspecified''
		END,	--Gender
		D1.DSMCode

FROM	Clients C
LEFT JOIN	ClientRaces CR
ON		C.ClientId =CR.ClientId
AND		ISNULL(CR.RecordDeleted, ''N'') <> ''Y''
LEFT JOIN	GlobalCodes GC
ON		CR.RaceId = GC.GlobalCodeId
AND		ISNULL(GC.RecordDeleted, ''N'') <> ''Y''
LEFT JOIN	ClientAddresses CA
ON		C.ClientId = CA.ClientId
AND		ISNULL(CA.RecordDeleted, ''N'') <> ''Y''
JOIN	Services S
ON		C.ClientId = S.ClientId
AND		S.DateOfService >= @ServiceDateRangeStart
AND		S.DateOfService < DATEADD(DD, 1, @ServiceDateRangeEnd)
AND		S.Status = 75 -- Complete
AND		S.ProgramId like @Program
AND		S.ProcedureCodeId like @ProcedureCode
AND		S.ClinicianId like @Staff
AND		ISNULL(S.RecordDeleted, ''N'') <> ''Y''
JOIN	Programs P
ON		S.ProgramId = P.ProgramId
AND		P.ServiceAreaId like @ProgramType
AND		ISNULL(P.RecordDeleted, ''N'') <> ''Y''
LEFT JOIN	Documents D
ON		C.ClientId = D.ClientId
AND		D.DocumentCodeId = 5 -- Diagnosis Document
AND		D.Status = 22 -- Signed
AND		ISNULL(D.RecordDeleted, ''N'') <> ''Y''
AND		D.EffectiveDate =	(	SELECT	MAX(D2.EffectiveDate)
								FROM	Documents D2
								WHERE	D.ClientId = D2.ClientId
								AND		D2.DocumentCodeId = 5 -- Diagnosis Document
								AND		D2.Status = 22 -- Signed
								AND		ISNULL(D2.RecordDeleted, ''N'') <> ''Y''
							)
LEFT JOIN	DiagnosesIAndII D1
ON		D.CurrentDocumentVersionId = D1.DocumentVersionId
AND		ISNULL(D1.RuleOut, ''N'') <> ''Y''
AND		ISNULL(D1.RecordDeleted, ''N'') <> ''Y''
WHERE	ISNULL(C.RecordDeleted, ''N'') <> ''Y''

UNION ALL

SELECT	C.ClientID,
		C.Active,
		COALESCE(GC.CodeName, ''Unspecified''), --Race
		DATEDIFF(YEAR, C.DOB, S.DateOfService) +	CASE	WHEN	DATEPART(MONTH, S.DateOfService) > DATEPART(MONTH, C.DOB)
															THEN	0
															WHEN	DATEPART(MONTH, S.DateOfService) < DATEPART(MONTH, C.DOB)
															THEN	-1
															WHEN	DATEPART(DAY, S.DateOfService) >= DATEPART(DAY, C.DOB)
															THEN	0
															ELSE	-1
													END,	-- Client Age
		COALESCE(CA.Zip, ''Unspecified''), -- Zip
		CASE	WHEN	C.Sex = ''M''
				THEN	''Male''
				WHEN	C.Sex = ''F''
				THEN	''Female''
				ELSE	''Unspecified''
		END,	--Gender
		D3.ICDCode

FROM	Clients C
LEFT JOIN	ClientRaces CR
ON		C.ClientId =CR.ClientId
AND		ISNULL(CR.RecordDeleted, ''N'') <> ''Y''
LEFT JOIN	GlobalCodes GC
ON		CR.RaceId = GC.GlobalCodeId
AND		ISNULL(GC.RecordDeleted, ''N'') <> ''Y''
LEFT JOIN	ClientAddresses CA
ON		C.ClientId = CA.ClientId
AND		ISNULL(CA.RecordDeleted, ''N'') <> ''Y''
JOIN	Services S
ON		C.ClientId = S.ClientId
AND		S.DateOfService >= @ServiceDateRangeStart
AND		S.DateOfService < DATEADD(DD, 1, @ServiceDateRangeEnd)
AND		S.Status = 75 -- Complete
AND		S.ProgramId like @Program
AND		S.ProcedureCodeId like @ProcedureCode
AND		S.ClinicianId like @Staff
AND		ISNULL(S.RecordDeleted, ''N'') <> ''Y''
JOIN	Programs P
ON		S.ProgramId = P.ProgramId
AND		P.ServiceAreaId like @ProgramType
AND		ISNULL(P.RecordDeleted, ''N'') <> ''Y''
LEFT JOIN	Documents D
ON		C.ClientId = D.ClientId
AND		D.DocumentCodeId = 5 -- Diagnosis Document
AND		D.Status = 22 -- Signed
AND		ISNULL(D.RecordDeleted, ''N'') <> ''Y''
AND		D.EffectiveDate =	(	SELECT	MAX(D2.EffectiveDate)
								FROM	Documents D2
								WHERE	D.ClientId = D2.ClientId
								AND		D2.DocumentCodeId = 5 -- Diagnosis Document
								AND		D2.Status = 22 -- Signed
								AND		ISNULL(D2.RecordDeleted, ''N'') <> ''Y''
							)
LEFT JOIN	DiagnosesIIICodes D3
ON		D.CurrentDocumentVersionId = D3.DocumentVersionId
AND		ISNULL(D3.RecordDeleted, ''N'') <> ''Y''
WHERE	ISNULL(C.RecordDeleted, ''N'') <> ''Y''

)


--***********************************************************************************
--****** RETURN DATA FOR THE FINAL REPORT *******************************************
--***********************************************************************************

SELECT	ClientID,
		Race,
		Age,
		CASE	WHEN	Age < 18
				THEN	''Child/Youth''
				ELSE	''Adult''
		END	AS	''Age Type'',
		Zip,
		Gender,
		Diagnosis
FROM	ClientIdActiveRaceAgeZipGender
WHERE	Active like @ActiveClientsOnly
AND		Age BETWEEN @AgeRangeStart AND @AgeRangeEnd
ORDER	BY
		ClientID
;

' 
END
GO
