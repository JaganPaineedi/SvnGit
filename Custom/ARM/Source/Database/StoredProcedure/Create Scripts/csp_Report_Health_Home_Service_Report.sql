/****** Object:  StoredProcedure [dbo].[csp_Report_Health_Home_Service_Report]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Health_Home_Service_Report]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Health_Home_Service_Report]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Health_Home_Service_Report]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_Health_Home_Service_Report]
	@Start_Date			Date,
	@End_Date			Date,
	@Staff_Super_or_VP	varchar(10),
	@Program			Int,	--0 = 6 HH Medicaid SED / 1 = 6 HH Medicaid SPMI / 2 = Both
	@StaffId			Int,
	@ResultType			Int		--0 = Clients Seen / 1 = Clients Not Seen / 2 = All Clients
AS
--*/
/********************************************************************/
/* Stored Procedure: csp_Report_Health_Home_Service_Report			*/
/* Copyright:        Harbor											*/
/*					           										*/
/* Author:		Michael Rowley  									*/
/* Create date: 11/12/2012		    								*/
/* Description:	Generate report of clients enrolled in Health Home. */
/* Updates:															*/
/*  Date		Author		Purpose									*/
/*	11/12/2012	MSR			Created									*/
/*	03/01/2013	MSR			Modified per WO 27545					*/
/*	03/07/2013	MSR			Comment out unneeded section			*/
/*	03/08/2013	MSR			Modified per WO 27545					*/
/*	03/08/2013	Jess		Modified - Added HH_INTCAREPLAN			*/
/*	03/21/2013	Jess		Modified - WO 27962						*/
/*	03/22/2013	Jess		Modified - WO 27962						*/
/********************************************************************/

/*
DECLARE
	@Start_Date			Date,
	@End_Date			Date,
	@Staff_Super_or_VP	varchar(10),
	@Program			Int,	--0 = 6 HH Medicaid SED / 1 = 6 HH Medicaid SPMI / 2 = Both
	@StaffId			Int,
	@ResultType			Int		--0 = Clients Seen / 1 = Clients Not Seen / 2 = All Clients

SELECT 
	@Start_Date		= ''03/01/2013'',
	@End_Date		= ''03/28/2013'',
	@Staff_Super_or_VP = ''vp'',
	@Program		= 2,
	@StaffId		= 0,
	@ResultType		= 0
--*/

IF OBJECT_ID(''tempdb..#TempStaff'') IS NOT NULL DROP TABLE #TempStaff
CREATE TABLE #TempStaff
(
	StaffID		Int,
	StaffName	Varchar(100)
)

IF @StaffId  = 0
	BEGIN
		INSERT INTO #TempStaff (StaffId, StaffName)
		SELECT s.StaffId, s.LastName + '', '' + s.FirstName 
		FROM Staff s 
		WHERE (ISNULL(s.RecordDeleted,''N'')<>''Y'')
		AND s.Active = ''Y''
		ORDER BY s.StaffID 
		
		--DELETE FROM #TempStaff
		--WHERE StaffId = 000
	END

IF	@staff_super_or_vp like ''Su%'' AND @StaffId  <> 0
--If Super is input then grab all staff 1 level below input staff	
	BEGIN
		INSERT INTO #TempStaff (StaffId, StaffName)
		SELECT * FROM dbo.fn_Supervisor_List(1, @StaffId)
	END

IF	@staff_super_or_vp like ''VP'' AND @StaffId  <> 0
--If VP is input then grab all staff up to 10 levels below input staff
	BEGIN
		INSERT INTO #TempStaff (StaffId, StaffName)
		SELECT * FROM dbo.fn_Supervisor_List(10, @StaffId)
	END

IF @staff_super_or_vp LIKE ''St%'' AND @StaffId  <> 0
	BEGIN
		INSERT INTO #TempStaff (StaffId)
		VALUES (@StaffId)
		
		UPDATE #TempStaff 
		SET StaffName = (SELECT s.LastName + '', '' + s.FirstName 
						FROM #TempStaff ts JOIN dbo.Staff s 
						ON ts.StaffID = s.StaffId
						WHERE (ISNULL(s.RecordDeleted,''N'')<>''Y''))
	END

INSERT INTO #TempStaff
select s.StaffId, ''Inactive - '' +  s.LastName + '', '' + s.FirstName 
from Staff s 
where s.Active = ''N'' and s.Clinician = ''Y''	

--IF @StaffId = 0 BEGIN
--INSERT INTO #TempStaff (StaffID, StaffName)
--SELECT s.StaffId, s.LastName + '', '' + s.FirstName 
--FROM dbo.Staff s 
--WHERE (ISNULL(s.RecordDeleted,''N'')<>''Y'') 
--AND s.Active = ''Y''
--AND s.Clinician = ''Y''
--END 
--ELSE BEGIN
--INSERT INTO #TempStaff (StaffID)
--VALUES (@StaffId)

--UPDATE #TempStaff 
--SET StaffName = (SELECT s.LastName + '', '' + s.FirstName 
--					FROM #TempStaff ts JOIN dbo.Staff s 
--					ON ts.StaffID = s.StaffId
--					WHERE (ISNULL(s.RecordDeleted,''N'')<>''Y''))
--END 
--Select * From #TempStaff
IF EXISTS (SELECT * FROM sys.tables WHERE name=''#HH_Client'') DROP TABLE #HH_Client

CREATE TABLE #HH_Client
(
	SEEN			Varchar(50),	
	ClientNo		Int,
	ClientName		Varchar(100),
	Program			Varchar(100),
	StaffName		Varchar(50),
	DateofService	DATETIME,
	LastHarborDate	DATETIME,
	ProcedureCode	Varchar(20)
)

--DECLARE @HH_Service TABLE
--(
--	ClientNo		Int,
--	LastServiceDate	DATETIME
--)

--DECLARE @NON_HH_Service TABLE
--(
--	ClientNu		Int,
--	LastHarborDate	DATETIME,
--	ProcedureCode	Varchar(20)
--)

BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

INSERT INTO #HH_Client (ClientNo, ClientName, Program)
SELECT DISTINCT 
c.ClientId 
,c.LastName + '', '' + c.FirstName 
,pg.ProgramCode 
FROM Clients c
JOIN ClientPrograms cp
ON cp.ClientId = c.ClientId
AND (ISNULL(cp.RecordDeleted,''N'')<>''Y'')
JOIN Programs PG
ON pg.ProgramId = cp.ProgramId 
AND (ISNULL(PG.RecordDeleted,''N'')<>''Y'')
join ClientEpisodes ce -- Added by MSR 03/08/2013
on c.ClientId = ce.ClientId  -- Added by MSR 03/08/2013
and c.CurrentEpisodeNumber = ce.EpisodeNumber  -- Added by MSR 03/08/2013
AND (ISNULL(ce.RecordDeleted,''N'')<>''Y'') -- Added by MSR 03/08/2013
WHERE (ISNULL(c.RecordDeleted,''N'')<>''Y'')
--AND c.Active = ''Y''	-- Removed by JMB 1/25/13
and (cp.DischargedDate >= @Start_Date or cp.DischargedDate is null) -- Added by MSR 03/01/2013
and cp.EnrolledDate <= @End_Date -- Added by MSR 03/01/2013
and (ce.DischargeDate >= @Start_Date or ce.DischargeDate is null) -- Added by MSR 03/08/2013
and ce.RegistrationDate <= @End_Date -- Added by MSR 03/08/2013
AND pg.ProgramId IN (444, 445) -- 6 HH Medicaid SPMI & 6 HH Medicaid SED Program Codes

IF @Program = 0 BEGIN
DELETE FROM #HH_Client 
WHERE Program <> ''6 HH Medicaid SED''
END
IF @Program = 1 BEGIN
DELETE FROM #HH_Client 
WHERE Program <> ''6 HH Medicaid SPMI''
END	
IF @Program = 2 BEGIN
DELETE FROM #HH_Client 
WHERE Program <> ''6 HH Medicaid SED'' AND Program <> ''6 HH Medicaid SPMI''
END	 

UPDATE HC
SET SEEN = ''X''
FROM #HH_Client HC
INNER JOIN dbo.Services s
ON hc.ClientNo = s.ClientId
WHERE s.ProcedureCodeId IN	(	696,	-- HH_Service
								725,	-- HH_INTCAREPLAN		-- Added by Jess 3/8/13
								728,	-- HH_COMPHLTHEVAL		-- Added by Jess 3/21/13
								729,	-- HH_COMMUNCATIONPLAN	-- Added by Jess 3/21/13
								730,	-- HH_TRANSITIONPLAN	-- Added by Jess 3/21/13
								731		-- HH_CRISISPLAN		-- Added by Jess 3/22/13
							)


AND (ISNULL(s.RecordDeleted,''N'')<>''Y'')
--AND s.Status IN (71, 75)  -- Show & Complete Global Codes  -- Show & Complete Global Codes
AND s.Status IN (75)  -- Complete Global Codes.  JMB
AND (s.DateOfService > @Start_Date
AND s.DateOfService <= DATEADD(DAY,1, @End_Date))
AND s.DateOfService <> ''2012-11-07 06:00:00.000''	-- Exclude mass letter mailing transaction.  JMB
AND s.DateOfService <> ''2012-10-29 06:00:00.000''	-- Exclude mass enrollment transaction.  JMB

IF @ResultType = 0 BEGIN
DELETE #HH_Client 
WHERE SEEN <> ''X'' OR SEEN IS NULL
END
IF @ResultType = 1 BEGIN
DELETE #HH_Client 
WHERE SEEN = ''X''
END

update hc 
set hc.DateofService = rs.tsum
from (select  max(s.DateOfService) tsum,hc.ClientNo
FROM #HH_Client hc
inner join Services s
on hc.ClientNo = s.ClientId
WHERE (ISNULL(s.RecordDeleted,''N'')<>''Y'')
AND s.ProgramId IN (444, 445) -- 6 HH Medicaid SPMI & 6 HH Medicaid SED Program Codes
AND	s.ProcedureCodeId IN	(	696,	-- HH_Service
								725,	-- HH_INTCAREPLAN		-- Added by Jess 2/8/13
								728,	-- HH_COMPHLTHEVAL		-- Added by Jess 3/21/13
								729,	-- HH_COMMUNCATIONPLAN	-- Added by Jess 3/21/13
								730,	-- HH_TRANSITIONPLAN	-- Added by Jess 3/21/13
								731		-- HH_CRISISPLAN		-- Added by Jess 3/22/13
							)
--AND s.Status IN (71, 75)  -- Show & Complete Global Codes
AND s.Status IN (75)  -- Complete Global Codes.  JMB
--AND (s.DateOfService > @Start_Date  -- Removed by JMB
--AND s.DateOfService <= DATEADD(DAY,1, @End_Date))  -- Removed by JMB
AND s.DateOfService <> ''2012-11-07 06:00:00.000''	-- Exclude mass letter mailing transaction.  JMB
AND s.DateOfService <> ''2012-10-29 06:00:00.000''	-- Exclude mass enrollment transaction.  JMB
group By hc.ClientNo
)rs 
inner join #HH_Client hc on hc.ClientNo=rs.ClientNo

UPDATE HC
SET hc.StaffName = s.StaffName
FROM #HH_Client hc
JOIN clients c
ON hc.ClientNo = c.ClientId   
AND (ISNULL(c.RecordDeleted,''N'')<>''Y'')
JOIN #TempStaff s
ON c.PrimaryClinicianId = s.StaffID 
--WHERE hc.DateofService = srv.DateOfService 

IF @StaffId <> 0 BEGIN
DELETE hc FROM #HH_Client hc
--INNER JOIN #TempStaff tc
--ON hc.StaffName <> tc.StaffName 
WHERE hc.StaffName IS NULL
END

update hc 
set hc.LastHarborDate = rs.tsum
from (select  max(s.DateOfService) tsum,hc.ClientNo
FROM #HH_Client hc
inner join Services s
on hc.ClientNo = s.ClientId
WHERE (ISNULL(s.RecordDeleted,''N'')<>''Y'')
AND s.ProcedureCodeId NOT IN	(	697,	-- HH_PMPM 
									696,	-- HH_SERVICE
									725,	-- HH_INTCAREPLAN		-- Added by Jess 3/8/13
									728,	-- HH_COMPHLTHEVAL		-- Added by Jess 3/21/13
									729,	-- HH_COMMUNCATIONPLAN	-- Added by Jess 3/21/13
									730,	-- HH_TRANSITIONPLAN	-- Added by Jess 3/21/13
									731		-- HH_CRISISPLAN		-- Added by Jess 3/22/13
								)							
--AND s.Status IN (71, 75)  -- Show & Complete Global Codes
AND s.Status IN (75)  -- Complete Global Codes.  JMB
group By hc.ClientNo
)rs 
inner join #HH_Client hc on hc.ClientNo=rs.ClientNo

--INSERT @NON_HH_Service (ClientNu, LastHarborDate)
--SELECT srv.ClientId, MAX(srv.DateOfService)
--FROM #HH_Client  c
--LEFT JOIN Services srv
--ON c.ClientNo = srv.ClientId
--WHERE (ISNULL(srv.RecordDeleted,''N'')<>''Y'')
--AND srv.ProcedureCodeId <> 696

--GROUP BY srv.ClientId
--ORDER BY srv.ClientId 

UPDATE #HH_Client
SET ProcedureCode = p.DisplayAs 
FROM ProcedureCodes p 
JOIN Services s
ON p.ProcedureCodeId = s.ProcedureCodeId
AND (ISNULL(s.RecordDeleted,''N'')<>''Y'')
WHERE ClientNo = s.ClientId
AND LastHarborDate = s.DateOfService 
AND s.ProcedureCodeId NOT IN	(	697,	-- HH_PMPM 
									696,	-- HH_SERVICE
									725,	-- HH_INTCAREPLAN		-- Added by Jess 3/8/13
									728,	-- HH_COMPHLTHEVAL		-- Added by Jess 3/21/13
									729,	-- HH_COMMUNCATIONPLAN	-- Added by Jess 3/21/13
									730,	-- HH_TRANSITIONPLAN	-- Added by Jess 3/21/13
									731		-- HH_CRISISPLAN		-- Added by Jess 3/22/13
								)								
--AND s.Status IN (71, 75)  -- Show & Complete Global Codes
AND s.Status IN (75)  -- Complete Global Codes.  JMB
AND (ISNULL(p.RecordDeleted,''N'')<>''Y'')
		
--UPDATE #HH_Client   
--SET LastHarborDate = nh.LastHarborDate, ProcedureCode = nh.ProcedureCode 
--FROM @NON_HH_Service nh
--WHERE ClientNo = nh.ClientNu
 
update #HH_Client 
set StaffName = ''No Primary Clinician''
where StaffName is null

SELECT *
FROM #HH_Client  hc
ORDER BY 
--hc.LastHarborDate 
hc.StaffName
,hc.ClientName

DROP TABLE #HH_Client
DROP TABLE #TempStaff 
            
END
' 
END
GO
