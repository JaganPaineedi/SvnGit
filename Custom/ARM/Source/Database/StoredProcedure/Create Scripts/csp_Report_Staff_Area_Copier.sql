/****** Object:  StoredProcedure [dbo].[csp_Report_Staff_Area_Copier]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Staff_Area_Copier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Staff_Area_Copier]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Staff_Area_Copier]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_Staff_Area_Copier]
	@StaffID1		Int,
	@StaffID2		Int,
	@User_Choice	Int,	-- 1 = Delete and Insert / 2 = Copy and Add
	@Area_Choice	Varchar(30)

AS

DECLARE 
	@ModifiedBy		Varchar(30),
	@ModifiedDate	Datetime,
	@Staff1Name		Varchar(50),
	@Staff2Name		Varchar(50),
	@Error_Return	Varchar(2400),
	@TableName		Varchar(50),
	@TableID		Varchar(50),
	@IndexId		Varchar(50),
	@Count			INT,
	@loop			INT,
	@sql			Varchar(1200),
	@sql2			Varchar(1200),
	@num			INT
--*/
-- =============================================
-- Author:		<Michael R. & Ryan M.>
-- Create date: <10/04/2012>
-- Description:	<Description: Copy/override the Proc/Prog/Locations/Proxy information in smartcare from one staff to another.>
-- =============================================
/*
DECLARE 
	@Staff1Name		Varchar(50),
	@Staff2Name		Varchar(50),
	@User_Choice	Int,		-- 1 = Delete and Insert / 2 = Copy and Add / 3 = View
	@Area_Choice	Varchar(30),
	@Error_Return	Varchar(2400),
	@TableName		Varchar(50),
	@TableID		Varchar(50),
	@IndexId		Varchar(50),
	@Count			INT,
	@loop			INT,
	@sql			Varchar(1200),
	@sql2			Varchar(1200),
	@num			INT
	
DECLARE 
	@ModifiedBy		Varchar(30),
	@ModifiedDate	Datetime,
	@StaffID1		Int,
	@StaffID2		Int
	
SELECT
	@StaffID1 = 1896,--1394,
	@StaffID2 = 1920,
	@User_Choice = 3,
	@Area_Choice = ''Programs/Procedures/Locations''
--*/

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
				
--IF (@Staff1Name IS NULL) BEGIN @Staff1Name = @Staff1ID END

SELECT 
	@ModifiedBy = ''Script24640'',
	@ModifiedDate = GETDATE(),
	@Error_Return = ''''

IF @User_Choice = 1 BEGIN
	SELECT @Error_Return = @Error_Return + ''DELETE AND INSERT OF '' + @Area_Choice + CHAR(10)
	+ ''FOR '' + @Staff1Name + '' TO '' + @Staff2Name + ''. '' + CHAR(10)
END
IF @User_Choice <> 3 BEGIN
	SET @Error_Return = @Error_Return + ''COPY AND ADD OF '' + @Area_Choice + CHAR(10)
	+ ''FOR '' + @Staff1Name + '' TO '' + @Staff2Name + ''. '' + CHAR(10)
END

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

IF @Area_Choice = ''Programs/Procedures/Locations'' BEGIN
	INSERT INTO @TEMPSTAFF VALUES (2, ''StaffProcedures'', ''StaffProcedureId'', ''ProcedureCodeId'')
	INSERT INTO @TEMPSTAFF VALUES (3, ''StaffLocations'', ''StaffLocationsId'', ''LocationId'')
END

IF @Area_Choice LIKE ''All%'' BEGIN
	INSERT INTO @TEMPSTAFF VALUES
	(1, ''StaffLocations'', ''StaffLocationsId'', ''LocationId''),
	(2, ''StaffPrograms'', ''StaffProgramId'', ''ProgramId''),
	(3, ''StaffProcedures'', ''StaffProcedureId'', ''ProcedureCodeId''),
	(4, ''StaffProxies'', ''StaffProxyId'', ''ProxyForStaffId'')
END

IF @StaffID1 = 0 OR @Staff1Name = ''All Staff'' GOTO StaffOneNull
IF @StaffID2 = 0 OR @Staff2Name = ''All Staff'' GOTO StaffTwoNull

SELECT @Count = COUNT(TableId) FROM @TEMPSTAFF 
SELECT @loop = 1

IF @User_Choice = 1 BEGIN
	/*
		Changes the RecordDeleted column in the Proc / Prog / Loca / Proxy Databases to ''Y'' where the ID Numbers 
		from the second staff member is not part of the first staff member so that the second staff member does not have Id number 
	--*/
	WHILE @loop <= @Count 
	BEGIN
		SELECT @TableName = (SELECT t.Tablename FROM @TEMPSTAFF t WHERE t.Num = @loop)
		SELECT @SQL = ''
			UPDATE dbo.'' + @TableName  + '' 
			SET RecordDeleted = ''''Y'''', ModifiedDate = '''''' + CAST(@ModifiedDate AS VARCHAR) + '''''', ModifiedBy = '''''' + @ModifiedBy + '''''',
			DeletedDate = '''''' + CAST(@ModifiedDate AS VARCHAR) + '''''', DeletedBy = '''''' + @ModifiedBy + ''''''
			WHERE StaffId = '''''' + CAST(@StaffID2 AS VARCHAR) + ''''''''
		SELECT @loop = @loop + 1
		--PRINT @SQL
		EXEC (@SQL)
	END
END
SELECT @loop = 1

	/*
		Adds Proc / Prog / Loca / Proxy ID Number from the first staff member to the second staff member.
	--*/
IF @User_Choice <> 3 BEGIN --TRAN

WHILE @loop <= @Count 
BEGIN
--PRINT ''HELLO''
	SELECT @TableName = (SELECT t.Tablename FROM @TEMPSTAFF t WHERE t.Num = @loop)
	SELECT @TableID = (SELECT t.TableId FROM @TEMPSTAFF t WHERE t.Num = @loop)
	SELECT @IndexId = (SELECT t.TableIndex FROM @TEMPSTAFF t WHERE t.Num = @loop)
	SELECT @sql = ''
	UPDATE dbo.'' + @TableName  + ''
	SET RecordDeleted = ''''N'''', ModifiedDate = '''''' + CAST(@ModifiedDate AS VARCHAR) + '''''', ModifiedBy = '''''' + @ModifiedBy + '''''',
	DeletedDate = NULL, DeletedBy = NULL
	FROM dbo.'' + @TableName  + '' 
	WHERE '' + @IndexId + '' IN (SELECT s1.'' + @IndexId + ''  
		FROM (SELECT * 
				FROM dbo.'' + @TableName  + '') s1
		WHERE s1.StaffId =  '''''' + CAST(@StaffID2 AS VARCHAR) + ''''''
		AND s1.RecordDeleted = ''''Y''''
		AND EXISTS
			(SELECT * FROM dbo.'' + @TableName  + '' s2
			WHERE s1.'' + @TableID + '' = s2.'' + @TableID + '' 
			AND s2.StaffId = '''''' + CAST(@StaffID1 AS VARCHAR) + ''''''
			AND (s2.RecordDeleted = ''''N'''' OR s2.RecordDeleted IS NULL)))''
	--PRINT @SQL
	EXEC (@SQL)
	SELECT @num = @@ROWCOUNT 
		
	SELECT @Error_Return = @Error_Return + CHAR(10) + CAST(@num AS NVarchar) +
	'' Row(s) Updated in the '' + @TableName  + '' Table.''
		
	SELECT @SQL2 = ''
	INSERT INTO dbo.'' + @TableName  + ''(StaffId, '' + @TableID + '', CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted)
		SELECT DISTINCT '''''' + CAST(@StaffID2 AS VARCHAR) + '''''', s1.'' + @TableID + '', '''''' + @ModifiedBy + '''''', 
		'''''' + CAST(@ModifiedDate AS VARCHAR) + '''''', '''''' + @ModifiedBy + '''''', '''''' + CAST(@ModifiedDate AS VARCHAR) + '''''', ''''N''''
			FROM (SELECT * 
				FROM dbo.'' + @TableName  + '' ts
				WHERE (ISNULL(ts.RecordDeleted,''''N'''')<>''''Y'''')
				) s1
			WHERE s1.StaffId = '''''' + CAST(@StaffID1 AS VARCHAR) + '''''' 
			AND NOT EXISTS
				(SELECT * FROM dbo.'' + @TableName  + '' s2
				WHERE s1.'' + @TableID + '' = s2.'' + @TableID + ''
				AND s2.StaffId = '''''' + CAST(@StaffID2 AS VARCHAR) + '''''')
	''

	--PRINT @SQL2
	EXEC (@SQL2)
	SELECT @num = @@ROWCOUNT 

	SELECT @Error_Return = @Error_Return + CHAR(10) + CAST(@num AS NVarchar) + 
	'' Row(s) Inserted into the '' + @TableName  + '' Table.''
	SELECT @Error_Return = @Error_Return + CHAR(10)
	SELECT @loop = @loop + 1

END	
END

	SELECT @Error_Return = @Error_Return + CHAR(10) + ''Process Completed Successfully! ''
GOTO END_REPORT

StaffOneNull:
	SELECT @Error_Return = @Error_Return + CHAR(10) + ''The Value for Staff Number One is not Accurate. '' + CHAR(10)
	GOTO NO_ALL_STAFF
StaffTwoNull:
	SELECT @Error_Return = @Error_Return + CHAR(10) + ''The Value for Staff Number Two is not Accurate. '' + CHAR(10)
	GOTO NO_ALL_STAFF
NO_ALL_STAFF:
	SELECT @Error_Return = @Error_Return + ''You must select a staff member to proceed. '' + CHAR(10)
	GOTO END_REPORT
END_REPORT:
IF (@User_Choice = 3 AND (@StaffID1 = 0 OR @StaffID2 = 0)) OR (@User_Choice = 1 OR @User_Choice = 2) BEGIN
	--PRINT @Error_return
	EXEC sp_executesql N''SELECT @Error_Return as Final_Report'', N''@Error_Return varchar(2400)'', @Error_Return
END
' 
END
GO
