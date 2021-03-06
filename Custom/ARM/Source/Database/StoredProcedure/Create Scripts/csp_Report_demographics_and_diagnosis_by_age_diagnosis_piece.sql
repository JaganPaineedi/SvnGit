/****** Object:  StoredProcedure [dbo].[csp_Report_demographics_and_diagnosis_by_age_diagnosis_piece]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_demographics_and_diagnosis_by_age_diagnosis_piece]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_demographics_and_diagnosis_by_age_diagnosis_piece]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_demographics_and_diagnosis_by_age_diagnosis_piece]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE	[dbo].[csp_Report_demographics_and_diagnosis_by_age_diagnosis_piece]
	@AgeRangeStart	int,
	@AgeRangeEnd		int
AS
--*/

/*
DECLARE	@AgeRangeStart	int,
	@AgeRangeEnd		int;

SELECT	@AgeRangeStart =	3,
	@AgeRangeEnd =	4;
*/



/************************************************************************************/
/* Stored Procedure: csp_Report_demographics_and_diagnosis_by_age_diagnosis_piece	*/
/* Creation Date:    05/14/2012														*/
/* Copyright:    Harbor																*/
/*																					*/
/* Purpose: QI Reports																*/
/*																					*/
/* Called By: Client Demographics with Diagnoses By Age								*/
/*																					*/
/* Updates:																			*/
/* Date			Author	Purpose														*/
/* 07/08/2012	Jess	Created to go along with									*/
/*							csp_Report_demographics_and_diagnosis_by_age			*/
/************************************************************************************/


--***********************************************************************************
--****** GET CLIENTS AND DATA *******************************************************
--***********************************************************************************


WITH 

ClientIdActiveDiagnosis(ClientID, Active, Age, Diagnosis) AS (
SELECT	C.ClientID,
		C.Active,
		DATEDIFF(YEAR,c.DOB,CURRENT_TIMESTAMP) +	CASE	WHEN	DATEPART(MONTH,CURRENT_TIMESTAMP) > DATEPART(MONTH,c.DOB)
															THEN	0
															WHEN	DATEPART(MONTH,CURRENT_TIMESTAMP) < DATEPART(MONTH,c.DOB)
															THEN	-1
															WHEN	DATEPART(DAY,CURRENT_TIMESTAMP) >= DATEPART(DAY,c.DOB)
															THEN	0
															ELSE	-1
													END
		AS ClientAge,
		D1.DSMCode

FROM	Clients c
JOIN	Documents D
ON		C.ClientId = D.ClientId
AND		D.DocumentCodeId = 5 -- Diagnosis Document
AND		D.Status = 22 -- Signed
AND		ISNULL(D.RecordDeleted, ''N'') <> ''Y''
JOIN	DiagnosesIAndII D1
ON		D.CurrentDocumentVersionId = D1.DocumentVersionId
AND		ISNULL(D1.RuleOut, ''N'') <> ''Y''
AND		ISNULL(D1.RecordDeleted, ''N'') <> ''Y''
WHERE	D.EffectiveDate =	(	SELECT	MAX(D2.EffectiveDate)
								FROM	Documents D2
								WHERE	D.ClientId = D2.ClientId
								AND		D2.DocumentCodeId = 5 -- Diagnosis Document
								AND		D2.Status = 22 -- Signed
								AND		ISNULL(D2.RecordDeleted, ''N'') <> ''Y''
							)

UNION ALL

SELECT	C.ClientID,
		C.Active,
		DATEDIFF(YEAR,c.DOB,CURRENT_TIMESTAMP) +	CASE	WHEN	DATEPART(MONTH,CURRENT_TIMESTAMP) > DATEPART(MONTH,c.DOB)
															THEN	0
															WHEN	DATEPART(MONTH,CURRENT_TIMESTAMP) < DATEPART(MONTH,c.DOB)
															THEN	-1
															WHEN	DATEPART(DAY,CURRENT_TIMESTAMP) >= DATEPART(DAY,c.DOB)
															THEN	0
															ELSE	-1
													END
		AS ClientAge,
		D3.ICDCode

FROM	Clients c
JOIN	Documents D
ON		C.ClientId = D.ClientId
AND		D.DocumentCodeId = 5 -- Diagnosis Document
AND		D.Status = 22 -- Signed
AND		ISNULL(D.RecordDeleted, ''N'') <> ''Y''
JOIN	DiagnosesIIICodes D3
ON		D.CurrentDocumentVersionId = D3.DocumentVersionId
AND		ISNULL(D3.RecordDeleted, ''N'') <> ''Y''
WHERE	D.EffectiveDate =	(	SELECT	MAX(D2.EffectiveDate)
								FROM	Documents D2
								WHERE	D.ClientId = D2.ClientId
								AND		D2.DocumentCodeId = 5 -- Diagnosis Document
								AND		D2.Status = 22 -- Signed
								AND		ISNULL(D2.RecordDeleted, ''N'') <> ''Y''
							)


)


--***********************************************************************************
--****** RETURN DATA FOR THE FINAL REPORT *******************************************
--***********************************************************************************

SELECT	DISTINCT
		ClientID,
		Active,
		Age,
		Diagnosis
FROM	ClientIdActiveDiagnosis
WHERE	Active=''Y''
AND		Age BETWEEN @AgeRangeStart AND @AgeRangeEnd
ORDER	BY
		Diagnosis
;




' 
END
GO
