/****** Object:  StoredProcedure [dbo].[csp_Report_CCMT_Adult_Start_Date]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CCMT_Adult_Start_Date]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_CCMT_Adult_Start_Date]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_CCMT_Adult_Start_Date]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--/*
CREATE PROCEDURE [dbo].[csp_Report_CCMT_Adult_Start_Date]
	-- Add the parameters for the stored procedure here
	@ClientId	Int
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_CCMT_Adult_Start_Date	              	*/
/* Creation Date: 01/22/2013                                         	*/
/* Copyright:    Harbor                       	*/
/*                                                                   	*/
/* Purpose: Display first day of current year for reports              	*/
/*                                                                   	*/
/* Input Parameters:      									 			*/
/*								     									*/
/* Description: Display first day of current year for use in reports   	*/
/*	that require default date parameter.			 	      			*/
/*                                                                   	*/
/* Updates:																*/
/*  Date		Author		Purpose										*/
/*	01/22/2013	MSR			Created										*/
/************************************************************************/
/*
DECLARE
	@ClientID	INT
SELECT
	@ClientID	= 10818
--*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--DECLARE	@FirstDate	Date
	--SELECT @FirstDate = DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()), 0)
	
	--SELECT @FirstDate AS ''Date''
	
	SELECT c.Annual_Dental_Visit,  c.Annual_Physical_Exam_at_PCP, c.Quarterly_PCP_HH_ICP_Verification,
	c.Annual_BMI, c.Annual_Cholesterol_Labs, c.Annual_BP_Report, c.Annual_Triglyceride_Level,
	c.Annual_Waist_Circumference, c.Annual_Medication_Reconciliation, c.Diabetes_Schizophrenia_BiPolar_Annual,
	c.Tobacco_Use_Education  
	FROM Custom_CCMT_Adult_Care_Management c 
	WHERE c.ClientId = @ClientID AND (ISNULL(c.RecordDeleted,''N'')<>''Y'')

END

' 
END
GO
