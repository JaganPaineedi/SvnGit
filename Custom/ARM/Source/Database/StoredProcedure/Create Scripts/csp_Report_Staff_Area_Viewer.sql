/****** Object:  StoredProcedure [dbo].[csp_Report_Staff_Area_Viewer]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Staff_Area_Viewer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Staff_Area_Viewer]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Staff_Area_Viewer]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_Staff_Area_Viewer]
	-- Add the parameters for the stored procedure here
	@StaffID1		Int,
	@StaffID2		Int,
	@User_Choice	Int,	-- 1 = Delete and Insert / 2 = Copy and Add  /  3 = View of Areas
	@Area_Choice	Varchar(30)
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_Staff_Area_Viewer		              	*/
/* Creation Date:   01/17/2013                                       	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/
/*                                                                   	*/
/* Purpose:  View areas of two staff.			                     	*/
/*                                                                   	*/
/* Input Parameters: 	@StaffID1, @StaffID2, @User_Choice, @Area_Choice*/
/*								     									*/
/* Description:       	*/
/*		      			*/
/*                                                                   	*/
/* Updates:																*/
/*  Date		Author	Purpose											*/
/*	01/17/2013	MSR		Created to suppliment Staff_Area_Copier			*/
/************************************************************************/
/*
DECLARE
	@StaffID1		Int,
	@StaffID2		Int,
	@User_Choice	Int,	-- 1 = Delete and Insert / 2 = Copy and Add  /  3 = View of Areas
	@Area_Choice	Varchar(30)
SELECT
	@StaffID1 = 1896,
	@StaffID2 = 1920,
	@User_Choice = 3,
	@Area_Choice = ''all''
--*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE 
	@Staff1Name		Varchar(50),
	@Staff2Name		Varchar(50),
	@TableName		Varchar(50),
	@TableID		Varchar(50),
	@IndexId		Varchar(50),
	@Count			INT,
	@loop			INT,
	@sql			Varchar(1200),
	@sql2			Varchar(1200),
	@num			INT	
	
DECLARE @staffNameTable TABLE
	(
	StaffID		char(7),
	StaffName	Varchar(50)
	)
	
DECLARE @TEMPSTAFF TABLE
(
	Num			Int,
	Tablename	Varchar(50),
	TableIndex	Varchar(50),
	TableId		Varchar(50)
)
	
INSERT INTO @staffNameTable
SELECT * FROM dbo.fn_All_Staff_Full_Name()

SELECT	@Staff1Name =	(
				SELECT	st.StaffName 
				FROM	@staffNameTable st
				WHERE	st.StaffID = @StaffID1
				)

SELECT	@Staff2Name =	(
				SELECT	st.StaffName 
				FROM	@staffNameTable st
				WHERE	st.StaffID = @StaffID2 
				)	

IF @Area_Choice LIKE ''Loca%'' BEGIN
	INSERT INTO @TEMPSTAFF VALUES (1, ''StaffLocations'', ''StaffLocationsId'', ''LocationId'')
END

IF @Area_Choice LIKE ''Prog%'' BEGIN
	INSERT INTO @TEMPSTAFF VALUES (1, ''StaffPrograms'', ''StaffProgramId'', ''ProgramId'')
END

IF @Area_Choice LIKE ''Proc%'' BEGIN
	INSERT INTO @TEMPSTAFF VALUES (1, ''StaffProcedures'', ''StaffProcedureId'', ''ProcedureCodeId'')
END

IF @Area_Choice LIKE ''Prox%'' BEGIN
	INSERT INTO @TEMPSTAFF VALUES (1, ''StaffProxies'', ''StaffProxyId'', ''ProxyForStaffId'')
END

IF @Area_Choice = ''Program/Procedure'' BEGIN
	INSERT INTO @TEMPSTAFF VALUES (2, ''StaffProcedures'', ''StaffProcedureId'', ''ProcedureCodeId'')
END

IF @Area_Choice LIKE ''All%'' BEGIN
	INSERT INTO @TEMPSTAFF VALUES
	(1, ''StaffLocations'', ''StaffLocationsId'', ''LocationId''), (2, ''StaffPrograms'', ''StaffProgramId'', ''ProgramId''),
	(3, ''StaffProcedures'', ''StaffProcedureId'', ''ProcedureCodeId''), (4, ''StaffProxies'', ''StaffProxyId'', ''ProxyForStaffId'')
END

IF @Area_Choice = ''Programs/Procedures/Locations'' BEGIN
	INSERT INTO @TEMPSTAFF VALUES (2, ''StaffProcedures'', ''StaffProcedureId'', ''ProcedureCodeId'')
	INSERT INTO @TEMPSTAFF VALUES (3, ''StaffLocations'', ''StaffLocationsId'', ''LocationId'')
END

IF @User_Choice = 3 AND @StaffID1 <> 0 AND @StaffID2 <> 0 BEGIN
IF OBJECT_ID(''tempdb..#TempArea'') IS NOT NULL BEGIN DROP TABLE #TempArea END
CREATE TABLE #TempArea
(
	AreaType	Varchar(20),
	AreaCode	Varchar(100),
	StaffId		Int
)

DECLARE 
@USERNAME1 VARCHAR(50) = (SELECT TOP 1 s.LastName + '', '' + s.FirstName FROM Staff s WHERE s.StaffId = @StaffId1 ),
@USERNAME2 VARCHAR(50) = (SELECT TOP 1 s.LastName + '', '' + s.FirstName FROM Staff s WHERE s.StaffId = @StaffId2 ),
@CodeName  VARCHAR(50),
@ShortName Varchar(50)

SELECT @loop = 1, @Count = COUNT(TableId) FROM @TEMPSTAFF 

WHILE @loop <= @Count
	BEGIN
		SELECT @ShortName = SUBSTRING((SELECT t.Tablename FROM @TEMPSTAFF t WHERE t.Num = @loop),6,15)
		SELECT @TableName = (SELECT t.Tablename FROM @TEMPSTAFF t WHERE t.Num = @loop)
		SELECT @TableID = (SELECT t.TableId FROM @TEMPSTAFF t WHERE t.Num = @loop)
		SELECT @IndexId = (SELECT t.TableIndex FROM @TEMPSTAFF t WHERE t.Num = @loop)
		SELECT @CodeName = CASE 
							WHEN @ShortName like ''Prog%'' THEN ''ProgramCode'' 
							WHEN @ShortName like ''Proc%'' THEN ''DisplayAs''
							WHEN @ShortName like ''Prox%'' THEN ''LastName + '''', '''' + a.FirstName'' 
							WHEN @ShortName like ''Loca%'' THEN ''LocationCode''							
							END
						
		SELECT @sql2 = CASE
							WHEN @ShortName like ''Prog%'' THEN ''FROM StaffPrograms sp JOIN Programs a ON sp.ProgramId = a.ProgramId AND (ISNULL(a.RecordDeleted, ''''N'''')<>''''Y'''')'' 							
							WHEN @ShortName like ''Proc%'' THEN ''FROM StaffProcedures sp JOIN ProcedureCodes a ON sp.ProcedureCodeId = a.ProcedureCodeId AND (ISNULL(a.RecordDeleted, ''''N'''')<>''''Y'''')''
							WHEN @ShortName like ''Prox%'' THEN ''FROM StaffProxies sp JOIN Staff a ON sp.ProxyForStaffId = a.StaffId AND (ISNULL(a.RecordDeleted, ''''N'''')<>''''Y'''')'' 
							WHEN @ShortName like ''Loca%'' THEN ''FROM StaffLocations sp JOIN Locations a ON sp.LocationId = a.LocationId AND (ISNULL(a.RecordDeleted, ''''N'''')<>''''Y'''')''							
						END						
		SELECT @sql = ''
INSERT INTO #TempArea 
SELECT '''''' + @ShortName + '''''', a.'' + @CodeName + '', sp.StaffId ''+ @sql2 + ''
WHERE sp.StaffId = '''''' + CAST(@StaffID1 AS VARCHAR) + '''''' AND a.Active = ''''Y'''' AND (ISNULL(sp.RecordDeleted, ''''N'''')<>''''Y'''')

INSERT INTO #TempArea
SELECT '''''' + @ShortName + '''''', a.'' + @CodeName + '', sp.StaffId ''+ @sql2 + ''
WHERE sp.StaffId = '''''' + CAST(@StaffID2 AS VARCHAR) + '''''' AND a.Active = ''''Y'''' AND (ISNULL(sp.RecordDeleted, ''''N'''')<>''''Y'''')
''

	SELECT @loop = @loop + 1
	--PRINT @SQL
	EXEC(@SQL)
	END
	
SELECT @sql = ''
SELECT l.AreaType, '''''' + @Staff1Name + '''''' AS ''''Staff1Name'''',
MAX(CASE WHEN l.StaffId = '''''' + CAST(@StaffId1 AS VARCHAR) + '''''' THEN l.AreaCode ELSE NULL END) AS ''''Staff1Area'''',
 '''''' + @Staff2Name + '''''' AS ''''Staff2Name'''',
MAX(CASE WHEN l.StaffId = '''''' + CAST(@StaffId2 AS VARCHAR) + '''''' THEN l.AreaCode ELSE NULL END) AS ''''Staff2Area''''
FROM #TempArea l
GROUP BY l.AreaType, l.AreaCode
ORDER BY l.AreaType''

PRINT @sql
EXEC(@sql)
 
END
END
' 
END
GO
