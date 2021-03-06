/****** Object:  StoredProcedure [dbo].[csp_Report_CCMT_Lab_Test_Orders_Insert]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CCMT_Lab_Test_Orders_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_CCMT_Lab_Test_Orders_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CCMT_Lab_Test_Orders_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_CCMT_Lab_Test_Orders_Insert]
	-- Add the parameters for the stored procedure here
	@StaffId				Int,
	@ClientNo				Int,
	@ClientLabId			Varchar(10),
    @Date_Lab_Test_Ordered	Datetime,
    @Ordering_Provider		Varchar(max),
    @Provider_Specialty		Varchar(max),
    @Provider_Contact		Varchar(15),
    @Desc_of_Order			Varchar(25),
    @Date_Order_Filled		Datetime,
    @Date_Receipt_Verified	Datetime
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_CCMT_Lab_Test_Orders	              	*/
/* Creation Date: 01/22/2013                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/
/*                                                                   	*/
/* Purpose: Insert data for Client Lab tests	                      	*/
/*                                                                   	*/
/* Input Parameters: @StaffId, @ClientNo, @Date_Lab_Test_Ordered,		*/
/*  @Ordering_Provider, @Provider_Specialty, @Provider_Contact,			*/
/*  @Desc_of_Order, @Date_Order_Filled, @Date_Receipt_Verified			*/
/*								     									*/
/* Description: Insert Data into CCMT_Lab_Test_Orders_Tracking that    	*/
/*	Staff will be entering as they receive the information.    			*/
/*                                                                   	*/
/* Updates:																*/
/*  Date		Author		Purpose										*/
/*	01/22/2013	MSR			Created										*/
/************************************************************************/
/*
DECLARE
	@StaffId				Int,
	@ClientNo				Int,
	@ClientLabId			Varchar(10),
    @Date_Lab_Test_Ordered	Datetime,
    @Ordering_Provider		Varchar(max),
    @Provider_Specialty		Varchar(max),
    @Provider_Contact		Varchar(15),
    @Desc_of_Order			Varchar(25),
    @Date_Order_Filled		Datetime,
    @Date_Receipt_Verified	Datetime
SELECT
	@StaffId				= 1830,
	@ClientNo				= 10818,
	@ClientLabId			= ''New Lab'',
    @Date_Lab_Test_Ordered	= ''01/02/2013'',
    @Ordering_Provider		= ''Dr. Smith'',
    @Provider_Specialty		= ''Neuralogist'',
    @Provider_Contact		= ''4199167067'',
    @Desc_of_Order			= ''Cat-Scan'',
    @Date_Order_Filled		= Null,
    @Date_Receipt_Verified	= Null
--*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE
	@Year					Int,
	@CurrentDate			Datetime,
	@CreatedBy				Int,
    @CreatedDate			Datetime,
    @CurrentUser			Varchar(50),
    @ClientName				Varchar(50),
    @SQL1					Varchar(500),
    @ClientAge				Varchar(50)
    
DECLARE @Old_Data TABLE
(    
    Date_Lab_Test_Ordered	Datetime,
    Ordering_Provider		Varchar(max),
    Provider_Specialty		Varchar(max),
    Provider_Contact		Varchar(15),
    Desc_of_Order			Varchar(25),
    Date_Order_Filled		Datetime,
    Date_Receipt_Verified	Datetime,
    Client_Lab_Id			Varchar(10)
)    
     
IF @ClientLabId <> ''New Lab'' BEGIN
INSERT INTO @Old_Data
SELECT cc.Date_Lab_Test_Ordered, cc.Ordering_Provider, cc.Provider_Specialty, cc.Provider_Contact, cc.Desc_of_Order, cc.Date_Order_Filled, cc.Date_Receipt_Verified, cc.Client_Lab_Id
FROM Custom_CCMT_Lab_Test_Orders_Tracking cc
WHERE cc.Client_Lab_Id = @ClientLabId AND cc.RecordDeleted = ''N'' AND cc.ClientId = @ClientNo 
END     
      
SELECT @CurrentDate = GETDATE(),
@Year = datepart(year, @CurrentDate),
@SQL1 = ''''

SELECT @ClientName = (SELECT c.LastName + '', '' + c.FirstName FROM Clients c WHERE c.ClientId = @ClientNo)

IF @ClientLabId = ''New Lab'' BEGIN
	DECLARE @Labs	Int,
	@ClientInitials	Varchar(2)

	SELECT @ClientInitials = SUBSTRING((SELECT c.LastName FROM Clients c WHERE c.ClientId = @ClientNo),1,1) + 
								SUBSTRING((SELECT c.FirstName FROM Clients c WHERE c.ClientId = @ClientNo),1,1)
							
	SELECT @Labs = (SELECT COUNT(cc.CCMTLOT_Id) FROM Custom_CCMT_Lab_Test_Orders_Tracking cc 
					WHERE cc.RecordDeleted = ''N'' AND cc.ClientId = @ClientNo AND DATEPART(YEAR, CreatedDate) = @Year)

	SELECT @ClientLabId = @ClientInitials + CAST(@year AS VARCHAR) + ''-'' + RIGHT(''000''+ CONVERT(VARCHAR,(@Labs+1)),3)
END

SELECT @CurrentUser = (SELECT SUBSTRING(s.FirstName,1,1) +  s.LastName FROM Staff s 
						WHERE s.StaffId = @StaffId AND (ISNULL(s.RecordDeleted, ''N'')<>''Y''))

IF @ClientNo = 0 OR @ClientNo = '''' OR @ClientNo IS NULL GOTO CLIENTNULL

IF EXISTS (SELECT * FROM Custom_CCMT_Lab_Test_Orders_Tracking c 
		   WHERE c.RecordDeleted = ''N'' AND c.Client_Lab_Id = @ClientLabId AND c.ClientId = @ClientNo)
BEGIN
UPDATE Custom_CCMT_Lab_Test_Orders_Tracking
SET ModifiedBy = @CurrentUser, ModifiedDate = @CurrentDate, RecordDeleted = ''Y'', DeletedDate = @CurrentDate, DeletedBy = @CurrentUser
WHERE RecordDeleted = ''N'' AND Client_Lab_Id = @ClientLabId AND ClientId = @ClientNo 
END
	
IF @Date_Lab_Test_Ordered IS NULL OR @Date_Lab_Test_Ordered = '''' OR @Date_Lab_Test_Ordered = '' '' BEGIN
SELECT @Date_Lab_Test_Ordered = (SELECT o.Date_Lab_Test_Ordered FROM @Old_Data o) 
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
IF @Date_Order_Filled IS NULL OR @Date_Order_Filled = '''' OR @Date_Order_Filled = '' '' BEGIN
SELECT @Date_Order_Filled = (SELECT o.Date_Order_Filled FROM @Old_Data o) 
END
IF @Date_Receipt_Verified IS NULL OR @Date_Receipt_Verified = '''' OR @Date_Receipt_Verified = '' '' BEGIN
SELECT @Date_Receipt_Verified = (SELECT o.Date_Receipt_Verified FROM @Old_Data o)
END

	INSERT INTO Custom_CCMT_Lab_Test_Orders_Tracking
	VALUES (@ClientNo, @CurrentUser, @CurrentDate, @CurrentUser, @CurrentDate, ''N'', NULL, NULL, @Date_Lab_Test_Ordered,
	@Ordering_Provider, @Provider_Specialty, @Provider_Contact, @Desc_of_Order, @Date_Order_Filled, @Date_Receipt_Verified, @ClientLabId)

SELECT @SQL1 = ''Data for '' + @ClientName + CHAR(10) + ''was successfully updated by '' + @CurrentUser + ''.''
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
