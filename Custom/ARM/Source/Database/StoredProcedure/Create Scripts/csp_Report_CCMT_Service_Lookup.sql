/****** Object:  StoredProcedure [dbo].[csp_Report_CCMT_Service_Lookup]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CCMT_Service_Lookup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_CCMT_Service_Lookup]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CCMT_Service_Lookup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--/*
CREATE PROCEDURE [dbo].[csp_Report_CCMT_Service_Lookup]
	-- Add the parameters for the stored procedure here
		@StaffId	Int,
		@ClientId	Int	
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_CCMT_Service_Lookup		              	*/
/* Creation Date: 01/23/2013                                         	*/
/* Copyright:    Harbor						                        	*/
/*                                                                   	*/
/* Purpose: Generate table of client service.	                      	*/
/*                                                                   	*/
/* Input Parameters:  @StaffId, @ClientId								*/
/*								     									*/
/* Description: Generate Table for Staff to pick the Service referrals	*/
/*  they with to update on the Lab Order Insert Form.					*/
/*                                                                   	*/
/* Updates:																*/
/*  Date		Author		Purpose										*/
/*	01/23/2013	MSR			Created										*/	
/************************************************************************/
/*
DECLARE
		@StaffId	Int,
		@ClientId	Int
SELECT
	@ClientId								= 10818,
	@StaffId								= 1830
--*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
DECLARE @Year	Int	

SELECT @Year = datepart(year, GETDATE())

DECLARE @TempService TABLE
(
	ClientServiceId	Varchar(12)
)
	INSERT INTO @TempService 
	VALUES (''New Service'')

	INSERT INTO @TempService 
	SELECT cc.client_Service_Id
	FROM Custom_CCMT_Service_Referral_Tracking cc
	WHERE cc.ClientId = @ClientId 
	AND cc.RecordDeleted = ''N''
	AND DATEPART(YEAR, cc.CreatedDate) = @Year
	
	SELECT * FROM @TempService 
	
END

' 
END
GO
