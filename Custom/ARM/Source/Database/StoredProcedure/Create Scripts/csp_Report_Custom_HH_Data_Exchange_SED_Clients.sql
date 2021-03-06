/****** Object:  StoredProcedure [dbo].[csp_Report_Custom_HH_Data_Exchange_SED_Clients]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Custom_HH_Data_Exchange_SED_Clients]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Custom_HH_Data_Exchange_SED_Clients]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Custom_HH_Data_Exchange_SED_Clients]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_Custom_HH_Data_Exchange_SED_Clients]
	-- Add the parameters for the stored procedure here
	@ClientId	Varchar(10)
AS
--*/
-- =============================================
-- Author:		<Ryan Mapes>
-- Create date: <2/05/13>
-- Description:	<Modified from csp_Report_Custom_HH_Data_Exchange_Claims_History by Michael Rowley per WO 27008, sorts the table Custom_HH_Data_Exchange_Claims_History SED clients by the description "routine child health exam-". >
-- =============================================
--/*
--DECLARE
--	@ClientId	Varchar(10)
	
--SELECT
--	--@ClientId = ''40464''
--	@ClientId = ''%''
--*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 
	h.ClientID, c.LastName, c.FirstName, c.PrimaryClinicianId, s.LastName, s.FirstName
	--CASE h.ClaimsCat
	--	WHEN ''1'' THEN ''ER Visits''
	--	WHEN ''2'' THEN ''Hospital Inpatient Admissions - Psychiatric''
	--	WHEN ''3'' THEN ''Hospital Inpatient Admissions - Non-Psychiatric''
	--	WHEN ''4'' THEN ''Physician Visit Information''
	--	WHEN ''5'' THEN ''Behavioral Health Visits''
	--	WHEN ''6'' THEN ''Prescription Medications''
	--	WHEN ''7'' THEN ''Laboratory and Diagnostic Tests''
	--	WHEN ''8'' THEN ''Other Claims''
	--END AS ''Category'',
	--CASE cp.ProgramId 
	--	WHEN 444 THEN ''SPMI'' -- 444 = 6 HH Medicaid SPMI Program Code
	--	WHEN 445 THEN ''SED''  -- 445 = 6 HH Medicaid SED Program Code
	--	ELSE ''''
	--END AS ''Program'',
	--RTRIM(h.ProvName) AS ''ProvName'',
	--CAST(h.DOS AS DATETIME) AS ''DATE OF SERVICE'',
	--CASE h.ClaimsCat 
	--	WHEN ''1'' THEN RTRIM(h.Proc_Code_Desc)
	--	WHEN ''2'' THEN CASE h.ICD9_Surg_Desc
	--					WHEN '''' THEN RTRIM(h.Rev_Code_Desc)
	--					ELSE RTRIM(h.ICD9_Surg_Desc) + '' - '' + RTRIM(h.Rev_Code_Desc)
	--				  END
	--	WHEN ''3'' THEN RTRIM(h.Rev_Code_Desc)
	--	WHEN ''4'' THEN RTRIM(h.Proc_Code_Desc)
	--	WHEN ''5'' THEN RTRIM(h.Proc_Code_Desc)
	--	WHEN ''6'' THEN RTRIM(h.PharmName)
	--	WHEN ''7'' THEN RTRIM(h.Proc_Code_Desc)
	--	WHEN ''8'' THEN RTRIM(h.Proc_Code_Desc)
	--END AS ''NAME'',
	--CASE h.ClaimsCat 
	--	WHEN ''1'' THEN RTRIM(h.Diag_1_Desc) + '' '' + RTRIM(h.Diag_2_Desc)
	--	WHEN ''2'' THEN RTRIM(h.Diag_1_Desc) + '' '' + RTRIM(h.Diag_2_Desc)
	--	WHEN ''3'' THEN RTRIM(h.Diag_1_Desc) + '' '' + RTRIM(h.Diag_2_Desc)
	--	WHEN ''4'' THEN RTRIM(h.Diag_1_Desc) + '' '' + RTRIM(h.Diag_2_Desc)
	--	WHEN ''5'' THEN RTRIM(h.Diag_1_Desc) + '' '' + RTRIM(h.Proc_Code_Desc)
	--	WHEN ''6'' THEN RTRIM(h.Days_Supply) + '' DAY SUPPLY OF '' + RTRIM(h.[NDC Desc])
	--	WHEN ''7'' THEN RTRIM(h.Diag_1_Desc) + '' '' + RTRIM(h.Diag_2_Desc)
	--	WHEN ''8'' THEN RTRIM(h.Diag_1_Desc) + '' '' + RTRIM(h.Diag_2_Desc)
	--END AS ''Description''
	FROM dbo.Custom_HH_Data_Exchange_Claims_History h
	JOIN dbo.ClientPrograms cp
	ON h.ClientId = cp.ClientId 
	AND (ISNULL(cp.RecordDeleted, ''N'')<>''Y'')
	JOIN Clients c
	on h.ClientID = c.ClientId
	AND (ISNULL(c.RecordDeleted, ''N'')<>''Y'')
	Join Staff s
	on c.primaryclinicianid = s.staffid
	Where(ISNULL(c.RecordDeleted, ''N'')<>''Y'')
	AND (ISNULL(h.RecordDeleted, ''N'')<>''Y'')
	AND h.ClientId LIKE @ClientID
	AND cp.ProgramId IN (445) -- 444 = 6 HH Medicaid SPMI and 445 = 6 HH Medicaid SED Program Code
AND (Diag_Admit_Desc Like ''%ROUTIN CHILD HEALTH EXAM%''
OR Diag_1_Desc Like ''%ROUTIN CHILD HEALTH EXAM%''
OR Diag_2_Desc Like ''%ROUTIN CHILD HEALTH EXAM%'')
	GROUP BY h.ClientID, c.LastName, c.FirstName, c.PrimaryClinicianId, s.FirstName, s.LastName

Order by ClientID	
	--ORDER BY h.ClientID, h.ClaimsCat, h.DOS 
END
' 
END
GO
