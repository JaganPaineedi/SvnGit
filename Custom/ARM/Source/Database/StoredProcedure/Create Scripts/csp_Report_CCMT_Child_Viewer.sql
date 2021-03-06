/****** Object:  StoredProcedure [dbo].[csp_Report_CCMT_Child_Viewer]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CCMT_Child_Viewer]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_CCMT_Child_Viewer]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CCMT_Child_Viewer]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_CCMT_Child_Viewer]
	-- Add the parameters for the stored procedure here
	@ClientNo			Int,
	@StaffId			Int,
	@staff_super_or_vp	varchar(10),	
	@Choice				Int
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_CCMT_Child_Viewer						*/
/* Creation Date: 01/22/2013                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/
/*                                                                   	*/
/* Purpose: View Child report for CCMT			                     	*/
/*                                                                   	*/
/* Input Parameters: @ClientNo, @StaffId			   			     	*/
/*								     									*/
/* Description: Will display Child report when the choose is made on the*/
/*	form.																*/
/*                                                                   	*/
/* Updates:																*/
/*  Date		Author		Purpose										*/
/*	01/22/2013	MSR			Created										*/
/************************************************************************/
/*
DECLARE
	@ClientNo			Int,
	@StaffId			Int,
	@staff_super_or_vp	varchar(10),	
	@Choice				Int
SELECT
	@ClientNo			= 0,
	@StaffId			= 0,--1396,
	@staff_super_or_vp	= ''vp'',
	@Choice				= 2 --  0 = All Report | 2 = Child Report Alone
--*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
DECLARE
	@Year			Int,
	@CurrentDate	Datetime

SELECT @CurrentDate = GETDATE(),
@Year = datepart(year, @CurrentDate)

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

--IF @Choice = 2 OR @Choice = 3 BEGIN	  -- Commented out as change of code to show all pages.
	IF @ClientNo = 0 BEGIN
		INSERT INTO @TempClient 
		SELECT c.ClientId
		FROM Custom_CCMT_Child_Adolescent_Care_Management cc
		JOIN Clients c 
		ON cc.ClientId = c.ClientId
		AND (ISNULL(c.RecordDeleted, ''N'')<>''Y'')	
		WHERE c.PrimaryClinicianId IN (SELECT * FROM #TempStaff)
		AND (ISNULL(cc.RecordDeleted, ''N'')<>''Y'')
		--ORDER BY c.LastName  
	END	
	ELSE IF @ClientNo <> 0 BEGIN
		INSERT INTO @TempClient 
		VALUES (@ClientNo)
	END	
--END  -- Commented out as change of code to show all pages.
	
	SELECT 
	s.LastName + '', '' + s.FirstName AS ''StaffName'',
	c.ClientId, 
	c.LastName + '', '' + c.FirstName AS ''ClientName'',
    cc.Annual_Dental_Visit,
    cc.Annual_Physical_Exam_at_PCP,
    cc.Children_Wellcare_Visit,
    cc.Quarterly_PCP_HH_ICP_Verification,
    cc.Annual_Verify_Immunizations_UP2Date,
    cc.Annual_BMI,
    cc.Annual_Education_Nutrition_Physical_Activity,
    cc.Annual_Medication_Reconciliation,
    cc.Asthma,
    cc.Tobacco_Use_Education
	FROM Custom_CCMT_Child_Adolescent_Care_Management cc
	JOIN Clients c
	ON cc.ClientId = c.ClientId 
	AND (ISNULL(c.RecordDeleted, ''N'')<>''Y'')
	JOIN Staff s
	ON c.PrimaryClinicianId = s.StaffId 
	AND (ISNULL(s.RecordDeleted, ''N'')<>''Y'')
	WHERE cc.ClientId IN (SELECT * FROM @TempClient) 
	AND cc.RecordDeleted = ''N'' 
	AND DATEPART(YEAR, cc.CreatedDate) = @Year 
	ORDER BY ''StaffName'', ''ClientName''

END
DROP TABLE #TempStaff 
' 
END
GO
