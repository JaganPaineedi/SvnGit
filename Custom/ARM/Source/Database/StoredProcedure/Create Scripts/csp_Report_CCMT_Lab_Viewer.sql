/****** Object:  StoredProcedure [dbo].[csp_Report_CCMT_Lab_Viewer]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CCMT_Lab_Viewer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_CCMT_Lab_Viewer]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CCMT_Lab_Viewer]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_CCMT_Lab_Viewer]
	-- Add the parameters for the stored procedure here
	@ClientNo			Int,
	@StaffId			Int,
	@staff_super_or_vp	varchar(10),
	@Choice				Int	
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_CCMT_Lab_Viewer							*/
/* Creation Date: 01/22/2013                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/
/*                                                                   	*/
/* Purpose: View Lab report for CCMT			                     	*/
/*                                                                   	*/
/* Input Parameters: @ClientNo, @StaffId						     	*/
/*								     									*/
/* Description: Will display Labs for all clients within a staffs case 	*/
/*	load.																*/
/*                                                                   	*/
/* Updates:																*/
/*  Date		Author		Purpose										*/
/*	01/22/2013	MSR			Created										*/
/************************************************************************/
/*
DECLARE
	@StaffId			Int,
	@staff_super_or_vp	varchar(10),
	@ClientNo			Int,	
	@Choice				Int	
SELECT
	@ClientNo			= 0,
	@StaffId			= 1396,
	@staff_super_or_vp	= ''st'',
	@Choice				= 1 -- 0 = All Report | 3 = Lab Report Alone
	
--*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE @TempClient TABLE
(
	ClientId	Int
)	

DECLARE @staffNameTable TABLE
(
	StaffID		char(7),
	StaffName	Varchar(50)
)

INSERT INTO @staffNameTable
SELECT * FROM dbo.fn_Staff_Full_Name()
	
IF OBJECT_ID(''tempdb..#TempStaff'',''U'') IS NOT NULL DROP TABLE #TempStaff	

CREATE TABLE #TempStaff
	(
	StaffId char(10)
	)

IF @StaffId  = 0
	BEGIN
		INSERT INTO #TempStaff (StaffId)
		SELECT s.StaffId FROM  @staffNameTable s ORDER BY s.StaffID 
		
		DELETE FROM #TempStaff
		WHERE StaffId = 000
	END

IF	@staff_super_or_vp like ''Su%'' AND @StaffId  <> 0
--If Super is input then grab all staff 1 level below input staff	
	BEGIN
		INSERT INTO #TempStaff (StaffId)
		SELECT StaffId FROM dbo.fn_Supervisor_List(1, @StaffId)
	END

IF	@staff_super_or_vp like ''VP'' AND @StaffId  <> 0
--If VP is input then grab all staff up to 10 levels below input staff
	BEGIN
			INSERT INTO #TempStaff
			SELECT StaffId FROM dbo.fn_Supervisor_List(10, @StaffId)
	END

IF @staff_super_or_vp LIKE ''St%'' AND @StaffId  <> 0
	BEGIN
		INSERT INTO #TempStaff (StaffId)
		VALUES (@StaffId)
	END	
	
DECLARE
	@Year			Int,
	@CurrentDate	Datetime
	
IF @ClientNo = 0 BEGIN
/* Commented out as change of code to show all pages.
	IF @Choice = 1 OR @Choice = 4 BEGIN
		INSERT INTO @TempClient 
		SELECT c.ClientId
		FROM Custom_CCMT_Adult_Care_Management cc
		JOIN Clients c 
		ON cc.ClientId = c.ClientId
		AND (ISNULL(c.RecordDeleted, ''N'')<>''Y'')		
		WHERE c.PrimaryClinicianId IN (SELECT * FROM #TempStaff)
		AND (ISNULL(cc.RecordDeleted, ''N'')<>''Y'')
		ORDER BY c.LastName 
	END	  -- Commented out as change of code to show all pages.
	IF @Choice = 3 OR @Choice = 4 BEGIN
		INSERT INTO @TempClient 
		SELECT c.ClientId
		FROM Custom_CCMT_Child_Adolescent_Care_Management cc
		JOIN Clients c 
		ON cc.ClientId = c.ClientId
		AND (ISNULL(c.RecordDeleted, ''N'')<>''Y'')		
		WHERE c.PrimaryClinicianId IN (SELECT * FROM #TempStaff) 
		AND (ISNULL(cc.RecordDeleted, ''N'')<>''Y'')
		ORDER BY c.LastName  
	END
*/	
		INSERT INTO @TempClient 
		SELECT c.ClientId
		FROM Custom_CCMT_Lab_Test_Orders_Tracking cc
		JOIN Clients c 
		ON cc.ClientId = c.ClientId
		AND (ISNULL(c.RecordDeleted, ''N'')<>''Y'')		
		WHERE c.PrimaryClinicianId IN (SELECT * FROM #TempStaff) 
		AND (ISNULL(cc.RecordDeleted, ''N'')<>''Y'')
		ORDER BY c.LastName 
END	
ELSE IF @ClientNo <> 0 BEGIN
	INSERT INTO @TempClient 
	VALUES (@ClientNo)
END	

SELECT @CurrentDate = GETDATE(),
@Year = datepart(year, @CurrentDate)
	
	SELECT 
	s.LastName + '', '' + s.FirstName AS ''StaffName'',
	c.LastName + '', '' + c.FirstName AS ''Name'',	
    cc.Date_Lab_Test_Ordered,
    cc.Ordering_Provider,
    cc.Provider_Specialty,
    cc.Provider_Contact,
    cc.Desc_of_Order,
    cc.Date_Order_Filled,
    cc.Date_Receipt_Verified, 
    cc.Client_Lab_Id 
	FROM Custom_CCMT_Lab_Test_Orders_Tracking cc
	JOIN dbo.clients c
	ON cc.ClientId = c.ClientId 
	AND (ISNULL(c.RecordDeleted, ''N'')<>''Y'')
	JOIN dbo.Staff s
	ON c.PrimaryClinicianId = s.StaffId 
	AND (ISNULL(s.RecordDeleted, ''N'')<>''Y'')
	WHERE cc.ClientId IN (SELECT * FROM @TempClient)
	AND cc.RecordDeleted = ''N'' 
	AND DATEPART(YEAR, cc.CreatedDate) = @Year 
	ORDER BY ''StaffName'', ''Name'', cc.Client_Lab_Id 

END
DROP TABLE #TempStaff ' 
END
GO
