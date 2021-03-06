/****** Object:  StoredProcedure [dbo].[csp_Report_Clinician_Case_Load]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Clinician_Case_Load]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Clinician_Case_Load]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Clinician_Case_Load]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_Clinician_Case_Load]
	-- Add the parameters for the stored procedure here
	@StaffId		Int
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_Clinician_Case_Load		              	*/
/* Creation Date: 01/22/2013                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/
/*                                                                   	*/
/* Purpose: Determine Case Load of each Clinician                      	*/
/*                                                                   	*/
/* Input Parameters: @StaffId			     			     			*/
/*								     									*/
/* Description: Create table of Clients for each Clinician to be used   */
/*	to populate pulldown on forms						      			*/
/*                                                                   	*/
/* Updates:																*/
/*  Date		Author		Purpose										*/
/*	01/22/2013	MSR			Created										*/
/************************************************************************/
/*
DECLARE
	@StaffId		Int

SELECT
	@StaffId		= 1830
--*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @Temp TABLE
	(
		ClientNo	Int,
		ClientName	Varchar(100)
	)
	
	INSERT INTO @Temp 
	VALUES (0, ''All Clients'')
	
	INSERT INTO @Temp 
	SELECT c.ClientId, c.LastName + '', '' + c.FirstName AS ''Client'' 
	FROM Clients c 
	WHERE c.PrimaryClinicianId = @StaffId 
	AND c.Active = ''Y''
	AND ISNULL(c.RecordDeleted, ''N'')<>''Y''
	ORDER BY c.LastName 
	
	SELECT * FROM @Temp 
	
END
' 
END
GO
