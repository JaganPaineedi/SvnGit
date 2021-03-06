/****** Object:  StoredProcedure [dbo].[csp_Report_Custom_HH_Data_Exchange_Claims_History]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Custom_HH_Data_Exchange_Claims_History]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Custom_HH_Data_Exchange_Claims_History]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Custom_HH_Data_Exchange_Claims_History]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_Custom_HH_Data_Exchange_Claims_History]
	-- Add the parameters for the stored procedure here
	@ClientId	Varchar(10)
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_Custom_HH_Data_Exchange_Claims_History 	*/
/* Creation Date: 11/28/2012                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/
/*                                                                   	*/
/* Purpose: Generate list of MHH Claims			                      	*/
/*                                                                   	*/
/* Input Parameters: @ClientId			     			     			*/
/*								     									*/
/* Description: Generate list of Medical Health Home Claims for single 	*/
/*	client.												      			*/
/*                                                                   	*/
/* Updates:																*/
/*  Date		Author		Purpose										*/
/*	11/28/2012	MSR			Created										*/	
/*	02/22/2013	MSR			Update to add Date_Received and ClientName	*/
/************************************************************************/
/*
DECLARE
	@ClientId	int
	
SELECT
	@ClientId = 30
	--@ClientId = ''%''
--*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	Declare @ClientName	Varchar(100)
	
	Select @ClientName = (SELECT c.LastName + '', '' + c.FirstName from Clients c where c.ClientId = @ClientId)
	
	Declare @TempClient Table
	(
		ClientId	Int,
		ClientName	varchar(100)
	)

	Insert into @TempClient 
	Values (@ClientId, @ClientName)

    -- Insert statements for procedure here
	SELECT 
	h.ClientID,
	CASE h.ClaimsCat
		WHEN ''1'' THEN ''ER Visits''
		WHEN ''2'' THEN ''Hospital Inpatient Admissions - Psychiatric''
		WHEN ''3'' THEN ''Hospital Inpatient Admissions - Non-Psychiatric''
		WHEN ''4'' THEN ''Physician Visit Information''
		WHEN ''5'' THEN ''Behavioral Health Visits''
		WHEN ''6'' THEN ''Prescription Medications''
		WHEN ''7'' THEN ''Laboratory and Diagnostic Tests''
		WHEN ''8'' THEN ''Other Claims''
	END AS ''Category'',
	CASE cp.ProgramId 
		WHEN 444 THEN ''SPMI'' -- 444 = 6 HH Medicaid SPMI Program Code
		WHEN 445 THEN ''SED''  -- 445 = 6 HH Medicaid SED Program Code
		ELSE ''''
	END AS ''Program'',
	RTRIM(h.ProvName) AS ''ProvName'',
	CAST(h.DOS AS DATETIME) AS ''DATE OF SERVICE'',
	CASE h.ClaimsCat 
		WHEN ''1'' THEN RTRIM(h.Proc_Code_Desc)
		WHEN ''2'' THEN CASE h.ICD9_Surg_Desc
						WHEN '''' THEN RTRIM(h.Rev_Code_Desc)
						ELSE RTRIM(h.ICD9_Surg_Desc) + '' - '' + RTRIM(h.Rev_Code_Desc)
					  END
		WHEN ''3'' THEN RTRIM(h.Rev_Code_Desc)
		WHEN ''4'' THEN RTRIM(h.Proc_Code_Desc)
		WHEN ''5'' THEN RTRIM(h.Proc_Code_Desc)
		WHEN ''6'' THEN RTRIM(h.PharmName)
		WHEN ''7'' THEN RTRIM(h.Proc_Code_Desc)
		WHEN ''8'' THEN RTRIM(h.Proc_Code_Desc)
	END AS ''NAME'',
	CASE h.ClaimsCat 
		WHEN ''1'' THEN RTRIM(h.Diag_1_Desc) + '' '' + RTRIM(h.Diag_2_Desc)
		WHEN ''2'' THEN RTRIM(h.Diag_1_Desc) + '' '' + RTRIM(h.Diag_2_Desc)
		WHEN ''3'' THEN RTRIM(h.Diag_1_Desc) + '' '' + RTRIM(h.Diag_2_Desc)
		WHEN ''4'' THEN RTRIM(h.Diag_1_Desc) + '' '' + RTRIM(h.Diag_2_Desc)
		WHEN ''5'' THEN RTRIM(h.Diag_1_Desc) + '' '' + RTRIM(h.Proc_Code_Desc)
		WHEN ''6'' THEN RTRIM(h.Days_Supply) + '' DAY SUPPLY OF '' + RTRIM(h.NDC_Desc)
		WHEN ''7'' THEN RTRIM(h.Diag_1_Desc) + '' '' + RTRIM(h.Diag_2_Desc)
		WHEN ''8'' THEN RTRIM(h.Diag_1_Desc) + '' '' + RTRIM(h.Diag_2_Desc)
	END AS ''Description'',
	h.Date_Received, t.ClientName, h.HHClaims_ExtractID 
	FROM dbo.Custom_HH_Data_Exchange_Claims_History h
	Left JOIN dbo.ClientPrograms cp
	ON h.ClientId = cp.ClientId 
	AND (ISNULL(cp.RecordDeleted, ''N'')<>''Y'')
	JOIN @TempClient t 
	on h.ClientID = t.ClientId 
	WHERE (ISNULL(h.RecordDeleted, ''N'')<>''Y'')
	AND h.ClientId = @ClientID
	AND cp.ProgramId IN (444,445) -- 444 = 6 HH Medicaid SPMI and 445 = 6 HH Medicaid SED Program Code
	ORDER BY h.ClientID, h.Date_Received desc, ''Category'', h.DOS 
END
' 
END
GO
