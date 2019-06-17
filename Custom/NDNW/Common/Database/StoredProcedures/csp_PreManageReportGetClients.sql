IF EXISTS (
		SELECT *
		FROM sys.objects
		WHERE object_id = OBJECT_ID(N'csp_PreManageReportGetClients')
			AND type IN (
				N'P'
				,N'PC'
				)
		)
	DROP PROCEDURE csp_PreManageReportGetClients
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================  
-- Author:  Mark Jensen  
-- Create date: 23 MAR 2018 
-- Description: Get client list for Pre Manage Care Report 
-- NDNW Enahancements Task #2
--	
--	25 APR 2018		MJensen		Modified to merge quiet group & act group columns.  Also set quiet group only if currently enrolled in sa program.  NDNW Enhancements #2
-- =============================================  
CREATE PROCEDURE csp_PreManageReportGetClients @StartDate DATE
	,@EndDate DATE
	,@ProgramId VARCHAR(max)
	,@ClinicianId VARCHAR(max)
	,@ActiveClients CHAR(1) -- Y,N,X (all)
AS
BEGIN TRY
	DECLARE @CR CHAR(1) = CHAR(13)
		,@SaServiceAreaId INT
		,@ActProgramId INT

	SET @SaServiceAreaId = (
			SELECT ServiceAreaId
			FROM ServiceAreas
			WHERE ServiceAreaName = 'SA'
			)
	SET @ActProgramId = (
			SELECT programid
			FROM programs
			WHERE ProgramName = 'BHW - ACT'
			)

	CREATE TABLE #PreManageClients (
		Clientid INT
		,FirstName VARCHAR(30)
		,MiddleName VARCHAR(30)
		,LastName VARCHAR(50)
		,BirthDate CHAR(10)
		,Sex CHAR(1)
		,SSN CHAR(11)
		,Address1 VARCHAR(255)
		,Address2 VARCHAR(45)
		,City VARCHAR(45)
		,STATE CHAR(2)
		,ZipCode VARCHAR(20)
		,PhoneNumber VARCHAR(15)
		,Groups VARCHAR(max)
		)

	-- select clients that had a service during the date range, whose primary clinician is in the list, whose status matchees and who is currently active in a selected program
	INSERT INTO #PreManageClients (
		Clientid
		,FirstName
		,MiddleName
		,LastName
		,BirthDate
		,Sex
		,SSN
		,PhoneNumber
		)
	SELECT c.ClientId
		,c.FirstName
		,c.MiddleName
		,c.LastName
		,CONVERT(CHAR(10), CAST(c.dob AS DATE), 120)
		,CASE 
			WHEN c.sex IN (
					'M'
					,'F'
					)
				THEN c.Sex
			WHEN c.sex IS NULL
				THEN 'O'
			ELSE 'O'
			END
		,CASE 
			WHEN c.SSN = 999999999
				THEN ''
			ELSE CAST(ISNULL(c.SSN, '') AS CHAR(9))
			END
		,SUBSTRING(ISNULL(cph.PhoneNumberText, ''), 1, 15)
	FROM Clients c
	JOIN (
		SELECT item
		FROM dbo.fnSplit(@ClinicianId, ',')
		) AS cp ON cp.item = c.PrimaryClinicianId
	LEFT JOIN ClientPhones cph ON cph.ClientId = c.ClientId
		AND Isnull(cph.RecordDeleted, 'N') = 'N'
		AND ISNULL(cph.IsPrimary, 'N') = 'Y'
		AND ISNULL(cph.DoNotContact, 'N') != 'Y'
	WHERE Isnull(c.RecordDeleted, 'N') = 'N'
		AND (
			c.Active = @ActiveClients
			OR @ActiveClients = 'X'
			)
		AND EXISTS (
			SELECT 1
			FROM services s
			WHERE s.ClientId = c.ClientId
				AND CAST(s.DateOfService AS DATE) BETWEEN @StartDate
					AND @EndDate
				AND s.STATUS IN (
					71
					,75
					)
				AND Isnull(s.RecordDeleted, 'N') = 'N'
			)
		AND EXISTS (
			SELECT 1
			FROM ClientPrograms clp
			JOIN (
				SELECT item
				FROM dbo.fnSplit(@ProgramId, ',')
				) AS pp ON pp.item = clp.ProgramId
			WHERE clp.ClientId = c.ClientId
				AND Isnull(clp.RecordDeleted, 'N') = 'N'
				AND clp.STATUS = 4
			)

	-- If client does not have primary phone, use home phone
	UPDATE pmc
	SET pmc.PhoneNumber = cp.PhoneNumberText
	FROM #PreManageClients pmc
	JOIN ClientPhones cp ON cp.ClientId = pmc.Clientid
	WHERE Isnull(cp.RecordDeleted, 'N') = 'N'
		AND cp.PhoneType = 30
		AND ISNULL(cp.DoNotContact, 'N') != 'Y'
		AND ISNULL(pmc.PhoneNumber, '') = ''

	-- add home address to work file 
	UPDATE PMC
	SET pmc.Address1 = CASE 
			WHEN CHARINDEX(@cr, ca.Address, 1) != 0
				THEN SUBSTRING(ca.Address, 1, CHARINDEX(@cr, ca.Address, 1) - 1)
			ELSE ISNULL(ca.Address, '')
			END
		,pmc.Address2 = LEFT(CASE 
				WHEN CHARINDEX(@cr, ca.Address, 1) != 0
					THEN SUBSTRING(ca.Address, CHARINDEX(@cr, ca.Address, 1) + 2, (LEN(ca.Address) - CHARINDEX(@cr, ca.Address, 1) + 2))
				ELSE ''
				END, 45)
		,pmc.City = LEFT(ISNULL(ca.City, ''), 45)
		,pmc.STATE = ISNULL(ca.STATE, '')
		,pmc.ZipCode = LEFT(ISNULL(ca.Zip, ''), 5)
	FROM #PreManageClients AS pmc
	JOIN ClientAddresses ca ON ca.ClientId = pmc.Clientid
	WHERE ca.AddressType = 90
		AND Isnull(ca.RecordDeleted, 'N') = 'N'

	-- update group if client currently enrolled in an sa program
	UPDATE PMC
	SET pmc.Groups = COALESCE(pmc.Groups + '^', '') + 'Quiet Group'
	FROM #PreManageClients pmc
	WHERE EXISTS (
			SELECT 1
			FROM ClientPrograms cp
			JOIN Programs p ON p.ProgramId = cp.ProgramId
			WHERE cp.ClientId = pmc.Clientid
				AND cp.STATUS = 4
				AND p.ServiceAreaId = @SAServiceAreaId
				AND Isnull(cp.RecordDeleted,'N') = 'N'
			)

	-- update Groups with all act programs the client is currently enrolled in 
	UPDATE pmc
	SET pmc.Groups = COALESCE(pmc.Groups + '^', '') + p.ProgramName
	FROM #PreManageClients pmc
	JOIN ClientPrograms cpg ON cpg.ClientId = pmc.Clientid
	JOIN Programs p ON p.ProgramId = cpg.ProgramId
	WHERE cpg.ProgramId = @ActProgramId
		AND cpg.STATUS = 4
		AND Isnull(cpg.RecordDeleted,'N') = 'N'

	--Return values to report
	SELECT Clientid AS [PATIENT PRIMARY IDENTIFIER]
		,FirstName AS [FIRST NAME]
		,MiddleName AS [MIDDLE INITIAL]
		,LastName AS [LAST NAME]
		,BirthDate AS [DATE OF BIRTH]
		,Sex
		,SSN
		,Address1 AS [STREET ADDRESS 1]
		,Address2 AS [STREET ADDRESS 2]
		,City
		,STATE
		,ZipCode AS [ZIP]
		,PhoneNumber AS [PHONE NUMBER]
		,Groups AS [Groups]
	FROM #PreManageClients
	ORDER BY Clientid
END TRY

BEGIN CATCH
	DECLARE @Error VARCHAR(8000)

	SET @Error = CONVERT(VARCHAR, ERROR_NUMBER()) + '*****' + CONVERT(VARCHAR(4000), ERROR_MESSAGE()) + '*****' + ISNULL(CONVERT(VARCHAR, ERROR_PROCEDURE()), 'csp_PreManageReportGetClients ') + '*****' + CONVERT(VARCHAR, ERROR_LINE()) + '*****' + CONVERT(VARCHAR, ERROR_SEVERITY()) + '*****' + CONVERT(VARCHAR, ERROR_STATE())

	RAISERROR (
			@Error
			,-- Message text.                                          
			16
			,-- Severity.                                          
			1 -- State.                                          
			);
END CATCH
GO

