IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE OBJECT_ID = OBJECT_ID(N'[ssp_PMProcedureRatesInitData]')
			AND OBJECTPROPERTY(OBJECT_ID, N'IsProcedure') = 1
		)
	DROP PROCEDURE [dbo].[ssp_PMProcedureRatesInitData]
GO

SET ANSI_NULLS OFF
GO

SET QUOTED_IDENTIFIER OFF
GO

CREATE PROCEDURE [dbo].[ssp_PMProcedureRatesInitData]
	/********************************************************************************                                                  
-- Stored Procedure: ssp_PMProcedureRatesInitData
--
-- Copyright: Streamline Healthcate Solutions
--
-- Purpose: Procedure to return dropdown list data for the client procedure rates list page.
--
-- Author:  Girish Sanaba
-- Date:    16 Apr 2011
--
-- *****History****
-- Modified By  :   Swapan Mohan
-- Modified On  :   17 Dec 2012
-- Purpose      :   Added ISNULL Check on Degree Column of Staff table as it is giving Blank staff names 
                    When Degree is 0.
-- 13 Dec 2013  Manju P   Modified to get DisplayAs as StaffName from staff table. What/Why: Task: Core Bugs #1315 Staff Detail Changes                    
-- 19 Oct 2015			Revathi							what:Changed code to display Clients LastName and FirstName when ClientType=''I'' else  OrganizationName.        
--														why:task #609, Network180 Customization

*********************************************************************************/
AS
BEGIN
	--Degrees
	SELECT DISTINCT GC.GlobalCodeId
		,GC.CodeName
		,ISNULL(GC.SortOrder, 9999) AS SortOrder
	FROM GlobalCodes GC
	INNER JOIN ProcedureRateDegrees PRD ON GC.GlobalCodeId = PRD.Degree
	WHERE GC.Category = 'DEGREE'
		AND (
			GC.RecordDeleted = 'N'
			OR GC.RecordDeleted IS NULL
			)
		AND ISNULL(PRD.RecordDeleted, 'N') = 'N'
		AND GC.Active = 'Y'
	ORDER BY SortOrder
		,CodeName

	--Programs              
	SELECT DISTINCT P.ProgramId
		,P.ProgramCode
	FROM Programs P
	INNER JOIN ProcedureRatePrograms PRP ON P.ProgramId = PRP.ProgramId
	WHERE ISNULL(P.RecordDeleted, 'N') = 'N'
		AND P.Active = 'Y'
	ORDER BY ProgramCode

	--Staff              
	SELECT S.StaffId
		,CASE 
			WHEN --S.DEGREE IS NULL
				ISNULL(S.DEGREE, 0) = 0
				THEN S.DisplayAs --S.LastName + ', ' + S.FirstName                
			ELSE S.DisplayAs + ' ' + GC.CodeName --S.LastName + ', ' + S.FirstName + ' ' + GC.CodeName                
			END AS 'StaffName'
	FROM Staff S
	LEFT JOIN GlobalCodes GC ON GC.GlobalCodeId = S.Degree
	WHERE S.Active = 'Y'
		AND ISNULL(S.RecordDeleted, 'N') = 'N'
	ORDER BY StaffName

	--Clients              
	SELECT DISTINCT C.ClientId
		,
		--Added by Revathi   19 Oct 2015  
		CASE 
			WHEN ISNULL(C.ClientType, 'I') = 'I'
				THEN ISNULL(C.LastName, '') + ', ' + ISNULL(C.FirstName, '')
			ELSE ISNULL(C.OrganizationName, '')
			END AS ClientName
	FROM Clients C
	INNER JOIN ProcedureRates PR ON C.ClientId = PR.ClientId
	WHERE ISNULL(C.RecordDeleted, 'N') = 'N'
		AND C.Active = 'Y'
	ORDER BY ClientName

	/*Location*/
	SELECT DISTINCT L.LocationId
		,L.LocationCode AS LocationName
	FROM ProcedureRateLocations PRL
	INNER JOIN Locations L ON PRL.LocationId = L.LocationId
	WHERE L.Active = 'Y'
		AND ISNULL(PRL.RecordDeleted, 'N') = 'N'
	ORDER BY LocationName

	RETURN
END
GO

