/****** Object:  StoredProcedure [dbo].[csp_Report_demographics_and_diagnosis_by_age_AllInOne]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_demographics_and_diagnosis_by_age_AllInOne]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_demographics_and_diagnosis_by_age_AllInOne]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_demographics_and_diagnosis_by_age_AllInOne]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE	[dbo].[csp_Report_demographics_and_diagnosis_by_age_AllInOne]
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



/****************************************************************/
/* Stored Procedure: csp_demographics_and_diagnosis_by_age_AllInOne */
/* Creation Date:    05/14/2012									*/
/* Copyright:    Harbor											*/
/*																*/
/* Purpose: QI Reports											*/
/*																*/
/* Called By: Client Demographics with Diagnoses By Age			*/
/*																*/
/* Updates:														*/
/* Date		Author	Purpose										*/
/* 05/03/2012	Rick	Translated From Psych Consult			*/
/****************************************************************/


--***********************************************************************************
--****** DECLARATIONS ***************************************************************
--***********************************************************************************

--***********************************************************************************
--****** END OF DECLARATIONS ********************************************************
--***********************************************************************************


--***********************************************************************************
--****** GET CLIENTS AND DATA *******************************************************
--***********************************************************************************


WITH 

ClientIdActiveRaceAgeZipGender(ClientID, Active, Race, Age, Zip, Gender) AS (
SELECT
  c.ClientID,
  c.Active,
  COALESCE(gc.CodeName, ''Unspecified'') as Race,
  DATEDIFF(YEAR,c.DOB,CURRENT_TIMESTAMP) +
    CASE
      WHEN DATEPART(MONTH,CURRENT_TIMESTAMP) > DATEPART(MONTH,c.DOB) THEN 0
      WHEN DATEPART(MONTH,CURRENT_TIMESTAMP) < DATEPART(MONTH,c.DOB) THEN -1
      WHEN DATEPART(DAY,CURRENT_TIMESTAMP) >= DATEPART(DAY,c.DOB) THEN 0
      ELSE -1
    END
  AS ClientAge,
  COALESCE(a.Zip, ''Unspecified'') AS Zip,
  CASE
    WHEN c.Sex=''M'' THEN ''Male''
    WHEN c.Sex=''F'' THEN ''Female''
    ELSE ''Unspecified''
  END AS Gender
  
FROM Clients c
LEFT JOIN ClientRaces r
ON c.ClientId=r.ClientId
LEFT JOIN GlobalCodes gc
ON r.RaceId=gc.GlobalCodeId
LEFT JOIN ClientAddresses a
ON c.ClientId=a.ClientId
)


--***********************************************************************************
--****** RETURN DATA FOR THE FINAL REPORT *******************************************
--***********************************************************************************


SELECT ClientID, Active, Race, Age, Zip, Gender
from ClientIdActiveRaceAgeZipGender
WHERE Active=''Y''
AND Age BETWEEN @AgeRangeStart AND @AgeRangeEnd
;



' 
END
GO
