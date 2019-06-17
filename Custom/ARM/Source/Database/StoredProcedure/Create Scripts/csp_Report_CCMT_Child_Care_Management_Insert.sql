/****** Object:  StoredProcedure [dbo].[csp_Report_CCMT_Child_Care_Management_Insert]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CCMT_Child_Care_Management_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_CCMT_Child_Care_Management_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CCMT_Child_Care_Management_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_CCMT_Child_Care_Management_Insert]
	-- Add the parameters for the stored procedure here
	@ClientNo										Int,
	@StaffId										Int,
	@Annual_Dental_Visit							datetime,
	@Annual_Physical_Exam_at_PCP					datetime,
	@Children_Wellcare_Visit						varchar(20),
	@Quarterly_PCP_HH_ICP_Verification				datetime,
	@Annual_Verify_Immunizations_UP2Date			datetime,
	@Annual_BMI										datetime,
	@Annual_Education_Nutrition_Physical_Activity	datetime,
	@Annual_Medication_Reconciliation				datetime,
	@Asthma											varchar(20),
	@Tobacco_Use_Education							varchar(20)
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_CCMT_Child_Care_Management_Insert		*/
/* Creation Date: 01/22/2013                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/
/*                                                                   	*/
/* Purpose: Insert HH Client Information by Staff                      	*/
/*                                                                   	*/
/* Input Parameters: @ClientNo, @StaffId, @Annual_Dental_Visit,         */
/*    @Annual_Physical_Exam_at_PCP, @Quarterly_PCP_HH_ICP_Verification, */
/*	  @Annual_BMI, @Annual_Cholesterol_Labs, @Annual_BP_Report,			*/
/*    @Annual_Triglyceride_Level, @Annual_Waist_Circumference			*/
/*    @Annual_Medication_Reconciliation, 								*/
/*    @Diabetes_Schizophrenia_BiPolar_Annual							*/
/*    @Tobacco_Use_Education     			     						*/
/*								     									*/
/* Description: Will insert into CCMT_Child_Care_Management the data    */
/*	  the user enters to create a new line and RecordDelete the old     */
/*	  entry line.														*/
/*                                                                   	*/
/* Updates:																*/
/*  Date		Author		Purpose										*/
/*	01/22/2013	MSR			Created										*/
/************************************************************************/
/*
DECLARE
	@ClientNo										Int,
	@StaffId										Int,
	@Annual_Dental_Visit							datetime,
	@Annual_Physical_Exam_at_PCP					datetime,
	@Children_Wellcare_Visit						varchar(20),
	@Quarterly_PCP_HH_ICP_Verification				datetime,
	@Annual_Verify_Immunizations_UP2Date			datetime,
	@Annual_BMI										datetime,
	@Annual_Education_Nutrition_Physical_Activity	datetime,
	@Annual_Medication_Reconciliation				datetime,
	@Asthma											varchar(20),
	@Tobacco_Use_Education							varchar(20)
SELECT
	@ClientNo										= 10818,
	@StaffId										= 1830,
    @Annual_Dental_Visit							= ''01/01/2013'',
    @Annual_Physical_Exam_at_PCP					= ''01/01/2013'',
	@Children_Wellcare_Visit						= NULL,
    @Quarterly_PCP_HH_ICP_Verification				= ''01/03/2013'',
	@Annual_Verify_Immunizations_UP2Date			= NULL,
    @Annual_BMI										= ''01/03/2013'',
	@Annual_Education_Nutrition_Physical_Activity	= NULL,   
    @Annual_Medication_Reconciliation				= ''01/22/2013'',
	@Asthma											= ''N/A'',   
    @Tobacco_Use_Education							= ''N/A''

--*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
DECLARE
	@Year			Int,
	@CurrentDate	Datetime,
	@CreatedBy		Int,
    @CreatedDate	Datetime,
    @CurrentUser	Varchar(50),
    @ClientName		Varchar(50),
    @SQL1			Varchar(500),
    @ClientAge		VARCHAR(50)
      
SELECT @CurrentDate = GETDATE(),
@Year = datepart(year, @CurrentDate),
@SQL1 = ''''

SELECT @ClientAge = CASE 
		WHEN(datediff(dd, (convert(varchar, datepart(mm, c.dob)) + ''/'' + convert(varchar, datepart(dd, c.dob)) + ''/3004''), (convert(varchar, datepart(mm, @CurrentDate)) + ''/'' + convert(varchar, datepart(dd, @CurrentDate)) + ''/3004''))) >= 0 
		THEN	datediff(yy, c.dob, @CurrentDate)
		ELSE	datediff(yy, c.dob, @CurrentDate) - 1
	END
  FROM Clients c  
  WHERE c.ClientId = @ClientNo

SELECT @CurrentUser = (SELECT SUBSTRING(s.FirstName,1,1) +  s.LastName FROM Staff s 
WHERE s.StaffId = @StaffId AND (ISNULL(s.RecordDeleted, ''N'')<>''Y''))

SELECT @ClientName = (SELECT c.LastName + '', '' + c.FirstName FROM Clients c WHERE c.ClientId = @ClientNo)

--IF @ClientAge >= 18 GOTO ADULTCLIENT
IF @StaffId = 0 OR @StaffId = '''' OR @StaffId IS NULL GOTO STAFFNULL
IF @ClientNo = 0 OR @ClientNo = '''' OR @ClientNo IS NULL GOTO CLIENTNULL

IF EXISTS (SELECT * FROM Custom_CCMT_Child_Adolescent_Care_Management c 
		   WHERE c.RecordDeleted = ''N'' AND c.ClientId = @ClientNo AND DATEPART(YEAR, CreatedDate) = @Year)
BEGIN
UPDATE Custom_CCMT_Child_Adolescent_Care_Management 
SET ModifiedBy = @CurrentUser, ModifiedDate = @CurrentDate, RecordDeleted = ''Y'', DeletedDate = @CurrentDate, DeletedBy = @CurrentUser 
WHERE ClientId = @ClientNo AND DATEPART(YEAR, CreatedDate) = @Year AND RecordDeleted = ''N''
END

INSERT INTO Custom_CCMT_Child_Adolescent_Care_Management 
VALUES(@ClientNo, @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate, ''N'', NULL, NULL, @Annual_Dental_Visit, 
@Annual_Physical_Exam_at_PCP, @Children_Wellcare_Visit, @Quarterly_PCP_HH_ICP_Verification, @Annual_Verify_Immunizations_UP2Date,
@Annual_BMI, @Annual_Education_Nutrition_Physical_Activity, @Annual_Medication_Reconciliation, @Asthma, @Tobacco_Use_Education)

SELECT @SQL1 = ''Data for '' + @ClientName + CHAR(10) + ''was successfully updated by '' + @CurrentUser + ''.''
GOTO END_REPORT

CLIENTNULL:
	SELECT @SQL1 = @SQL1 + ''The value for the Client is not accurate. '' + CHAR(10) + ''You must select a Client to proceed.''
	GOTO END_REPORT
STAFFNULL:
	SELECT @SQL1 = @SQL1 + ''The value for the Staff is not accurate. '' + CHAR(10) + ''You must select a Staff member to proceed.''
	GOTO END_REPORT	
ADULTCLIENT:
	SELECT @SQL1 = @SQL1 + ''The Client is 18 year or older.'' + CHAR(10)+ @ClientName + '' was not successfully updated.''
	GOTO END_REPORT
END_REPORT:
	PRINT @SQL1
	EXEC sp_executesql N''SELECT @SQL1 as Final_Report'', N''@SQL1 varchar(500)'', @SQL1

END
' 
END
GO
