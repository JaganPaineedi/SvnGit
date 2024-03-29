/****** Object:  StoredProcedure [dbo].[csp_Report_CCMT_Service_Referral_Insert]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CCMT_Service_Referral_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_CCMT_Service_Referral_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CCMT_Service_Referral_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_CCMT_Service_Referral_Insert]
	-- Add the parameters for the stored procedure here
	@StaffId									Int,
	@ClientNo									Int,
	@ClientServiceId							Varchar(12),
    @Date_Service_Referral						Datetime,
    @Ordering_Provider							Varchar(max),
    @Provider_Specialty							Varchar(max),
    @Provider_Contact							Varchar(15),
    @Desc_of_Order								Varchar(50),
    @First_Scheduled_Date_Service				Datetime,
    @Attendance_Confirmed						Varchar(3),
    @Date_Record_New_Service_Receieved			Datetime,
    @Date_Record_Ordering_Provider_Confirmed	Datetime,
    @Date_Record_PCP_Confirmed					Datetime
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_CCMT_Service_Referral	              	*/
/* Creation Date: 01/22/2013                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/
/*                                                                   	*/
/* Purpose: Insert data for Client referred Services                   	*/
/*                                                                   	*/
/* Input Parameters: @StaffId, @ClientNo, @Date_Lab_Test_Ordered,		*/
/*  @Ordering_Provider, @Provider_Specialty, @Provider_Contact,			*/
/*  @Desc_of_Order, @Date_Order_Filled, @Date_Receipt_Verified			*/
/*								     									*/
/* Description: Insert Data into CCMT_Service_Referral_Tracking that    */
/*	Staff will be entering as they receive the information.    			*/
/*                                                                   	*/
/* Updates:																*/
/*  Date		Author		Purpose										*/
/*	01/22/2013	MSR			Created										*/
/************************************************************************/
/*
DECLARE
	@StaffId									Int,
	@ClientNo									Int,
	@ClientServiceId							Varchar(12),
    @Date_Service_Referral						Datetime,
    @Ordering_Provider							Varchar(max),
    @Provider_Specialty							Varchar(max),
    @Provider_Contact							Varchar(15),
    @Desc_of_Order								Varchar(50),
    @First_Scheduled_Date_Service				Datetime,
    @Attendance_Confirmed						Varchar(3),
    @Date_Record_New_Service_Receieved			Datetime,
    @Date_Record_Ordering_Provider_Confirmed	Datetime,
    @Date_Record_PCP_Confirmed					Datetime
SELECT
	@StaffId									= 1830,
	@ClientNo									= 10818,
	@ClientServiceId							= ''New Service'',	
    @Date_Service_Referral						= ''01/01/2013'',
    @Ordering_Provider							= ''Dr. Jones'',
    @Provider_Specialty							= ''Osteopathic'',
    @Provider_Contact							= ''419-613-0576'',
    @Desc_of_Order								= ''Nutrition Intervention.'',
    @First_Scheduled_Date_Service				= ''01/07/2013'',
    @Attendance_Confirmed						= ''Yes'',
    @Date_Record_New_Service_Receieved			= ''01/09/2013'',
    @Date_Record_Ordering_Provider_Confirmed	= ''01/10/2013'',
    @Date_Record_PCP_Confirmed					= ''01/10/2013''
--*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE
	@Year										Int,
	@CurrentDate								Datetime,
	@CreatedBy									Int,
    @CreatedDate								Datetime,
    @CurrentUser								Varchar(50),
    @ClientName									Varchar(50),
    @SQL1										Varchar(500),
    @ClientAge									VARCHAR(50)
    
DECLARE @Old_Data TABLE
(    
    Date_Service_Referral						Datetime,
    Ordering_Provider							Varchar(max),
    Provider_Specialty							Varchar(max),
    Provider_Contact							Varchar(15),
    Desc_of_Order								Varchar(50),
    First_Scheduled_Date_Service				Datetime,
    Attendance_Confirmed						Varchar(3),
    Date_Record_New_Service_Receieved			Datetime,
    Date_Record_Ordering_Provider_Confirmed 	Datetime,
    Date_Record_PCP_Confirmed					Datetime, 
    ClientServiceId								Varchar(10)    
 )
 
IF @ClientServiceId <> ''New Service'' BEGIN
INSERT INTO @Old_Data
SELECT cc.Date_Service_Referral, cc.Ordering_Provider, cc.Provider_Specialty, cc.Provider_Contact, cc.Desc_of_Order, cc.First_Scheduled_Date_Service, cc.Attendance_Confirmed, cc.Date_Record_New_Service_Receieved, cc.Date_Record_Ordering_Provider_Confirmed, cc.Date_Record_PCP_Confirmed, cc.Client_Service_Id 
FROM Custom_CCMT_Service_Referral_Tracking cc
WHERE cc.Client_Service_Id = @ClientServiceId AND cc.RecordDeleted = ''N'' AND cc.ClientId = @ClientNo 
END
      
SELECT @CurrentDate = GETDATE(),
@Year = datepart(year, @CurrentDate),
@SQL1 = ''''

SELECT @ClientName = (SELECT c.LastName + '', '' + c.FirstName FROM Clients c WHERE c.ClientId = @ClientNo)

IF @ClientServiceId = ''New Service'' BEGIN
	DECLARE @Service	Int,
	@ClientInitials	Varchar(2)

	SELECT @ClientInitials = SUBSTRING((SELECT c.LastName FROM Clients c WHERE c.ClientId = @ClientNo),1,1) + 
								SUBSTRING((SELECT c.FirstName FROM Clients c WHERE c.ClientId = @ClientNo),1,1)
							
	SELECT @Service = (SELECT COUNT(cc.CCMTSRT_Id) FROM Custom_CCMT_Service_Referral_Tracking cc 
					WHERE cc.RecordDeleted = ''N'' AND cc.ClientId = @ClientNo AND DATEPART(YEAR, CreatedDate) = @Year)

	SELECT @ClientServiceId = @ClientInitials + CAST(@year AS VARCHAR) + ''-'' + RIGHT(''000''+ CONVERT(VARCHAR,(@Service+1)),3)
END

SELECT @CurrentUser = (SELECT SUBSTRING(s.FirstName,1,1) +  s.LastName FROM Staff s 
WHERE s.StaffId = @StaffId AND (ISNULL(s.RecordDeleted, ''N'')<>''Y''))

IF @ClientNo = 0 OR @ClientNo = '''' OR @ClientNo IS NULL GOTO CLIENTNULL

IF EXISTS (SELECT * FROM Custom_CCMT_Service_Referral_Tracking c 
		   WHERE c.RecordDeleted = ''N'' AND c.Client_Service_Id = @ClientServiceId AND c.ClientId = @ClientNo)
BEGIN
UPDATE Custom_CCMT_Service_Referral_Tracking
SET ModifiedBy = @CurrentUser, ModifiedDate = @CurrentDate, RecordDeleted = ''Y'', DeletedDate = @CurrentDate, DeletedBy = @CurrentUser
WHERE RecordDeleted = ''N'' AND Client_Service_Id = @ClientServiceId AND ClientId = @ClientNo 
END

IF @Date_Service_Referral IS NULL OR @Date_Service_Referral = '''' OR @Date_Service_Referral = '' '' BEGIN
SELECT @Date_Service_Referral = (SELECT o.Date_Service_Referral FROM @Old_Data o) 
END
IF @Ordering_Provider IS NULL OR @Ordering_Provider = '''' OR @Ordering_Provider = '' '' BEGIN
SELECT @Ordering_Provider = (SELECT o.Ordering_Provider FROM @Old_Data o) 
END
IF @Provider_Specialty IS NULL OR @Provider_Specialty = '''' OR @Provider_Specialty = '' '' BEGIN
SELECT @Provider_Specialty = (SELECT o.Provider_Specialty FROM @Old_Data o) 
END
IF @Provider_Contact IS NULL OR @Provider_Contact = '''' OR @Provider_Contact = '' '' BEGIN
SELECT @Provider_Contact = (SELECT o.Provider_Contact FROM @Old_Data o) 
END
IF @Desc_of_Order IS NULL OR @Desc_of_Order = '''' OR @Desc_of_Order = '' '' BEGIN
SELECT @Desc_of_Order = (SELECT o.Desc_of_Order FROM @Old_Data o) 
END
IF @First_Scheduled_Date_Service IS NULL OR @First_Scheduled_Date_Service = '''' OR @First_Scheduled_Date_Service = '' '' BEGIN
SELECT @First_Scheduled_Date_Service = (SELECT o.First_Scheduled_Date_Service FROM @Old_Data o) 
END
IF @Attendance_Confirmed IS NULL OR @Attendance_Confirmed = '''' OR @Attendance_Confirmed = '' '' BEGIN
SELECT @Attendance_Confirmed = (SELECT o.Attendance_Confirmed FROM @Old_Data o)
END
IF @Date_Record_New_Service_Receieved IS NULL OR @Date_Record_New_Service_Receieved = '''' OR @Date_Record_New_Service_Receieved = '' '' BEGIN
SELECT @Date_Record_New_Service_Receieved = (SELECT o.Date_Record_New_Service_Receieved FROM @Old_Data o)
END
IF @Date_Record_Ordering_Provider_Confirmed IS NULL OR @Date_Record_Ordering_Provider_Confirmed = '''' OR @Date_Record_Ordering_Provider_Confirmed = '' '' BEGIN
SELECT @Date_Record_Ordering_Provider_Confirmed = (SELECT o.Date_Record_Ordering_Provider_Confirmed FROM @Old_Data o)
END
IF @Date_Record_PCP_Confirmed  IS NULL OR @Date_Record_PCP_Confirmed = '''' OR @Date_Record_PCP_Confirmed = '' '' BEGIN
SELECT @Date_Record_PCP_Confirmed = (SELECT o.Date_Record_PCP_Confirmed FROM @Old_Data o)
END

	INSERT INTO Custom_CCMT_Service_Referral_Tracking
	VALUES (@ClientNo, @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate, ''N'', NULL, NULL, @Date_Service_Referral, @Ordering_Provider,
	@Provider_Specialty, @Provider_Contact, @Desc_of_Order, @First_Scheduled_Date_Service, @Attendance_Confirmed,
    @Date_Record_New_Service_Receieved, @Date_Record_Ordering_Provider_Confirmed, @Date_Record_PCP_Confirmed, @ClientServiceId)

IF @ClientServiceId = ''New Service'' BEGIN
SELECT @SQL1 = ''Data for '' + @ClientName + CHAR(10) + ''was successfully inserted by '' + @CurrentUser + ''.''
END
ELSE
BEGIN
SELECT @SQL1 = ''Data for '' + @ClientName + CHAR(10) + ''was successfully updated by '' + @CurrentUser + ''.''
END

GOTO END_REPORT

CLIENTNULL:
	SELECT @SQL1 = @SQL1 + ''The value for the Client is not accurate. '' + CHAR(10) + ''You must select a Client to proceed.''
	GOTO END_REPORT
END_REPORT:
	PRINT @SQL1
	EXEC sp_executesql N''SELECT @SQL1 as Final_Report'', N''@SQL1 varchar(500)'', @SQL1
	
END
' 
END
GO
