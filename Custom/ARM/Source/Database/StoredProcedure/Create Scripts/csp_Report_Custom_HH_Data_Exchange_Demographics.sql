/****** Object:  StoredProcedure [dbo].[csp_Report_Custom_HH_Data_Exchange_Demographics]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Custom_HH_Data_Exchange_Demographics]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_Custom_HH_Data_Exchange_Demographics]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_Custom_HH_Data_Exchange_Demographics]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE	PROCEDURE [dbo].[csp_Report_Custom_HH_Data_Exchange_Demographics]
	-- Add the parameters for the stored procedure here
	@ClientId	int
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_Custom_HH_Data_Exchange_Demographics 	*/
/* Creation Date: 11/28/2012                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/
/*                                                                   	*/
/* Purpose: Generate list of MHH Demographics	                      	*/
/*                                                                   	*/
/* Input Parameters: @ClientId			     			     			*/
/*								     									*/
/* Description: Generate list of Medical Health Home Demographics for a	*/
/*	Single client.										      			*/
/*                                                                   	*/
/* Updates:																*/
/*  Date		Author		Purpose										*/
/*	11/28/2012	MSR			Created										*/	
/*	02/22/2013	MSR			Update to add Date_Received and ClientName	*/
/************************************************************************/
/*
DECLARE	@ClientId	int
	
SELECT	@ClientId = ''30''
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
	SELECT DISTINCT
	h.ClientId,
	CASE p.ProgramCode
		WHEN ''6 HH Medicaid SPMI'' THEN ''SPMI''
		WHEN ''6 HH Medicaid SED'' THEN ''SED''
		ELSE ''''
	END AS ''Program'',
	h.MC_Plan_Name,
	CASE h.R_TPL
		WHEN ''Y'' THEN ''YES''
		WHEN ''N'' THEN ''NO''
		ELSE ''''
	END AS ''TPL'',
	h.R_MedicareId,
	REPLACE(CASE h.R_PartA
		WHEN ''Y'' THEN ''Part A, ''
		WHEN ''N'' THEN '', ''
	END
	+
	CASE h.R_PartB 
		WHEN ''Y'' THEN ''Part B, ''
		WHEN ''N'' THEN ''''
	END
	+
	CASE h.R_PartC
		WHEN ''Y'' THEN ''Part C, ''
		WHEN ''N'' THEN ''''
	END
	+
	CASE h.R_PartD 
		WHEN ''Y'' THEN ''Part D, ''
		WHEN ''N'' THEN ''''
	END + ''$'', '', $'', '''') AS ''Medicare Part'',
	REPLACE(CASE h.Asthma_Diagnosis
		WHEN ''Y'' THEN ''Asthma Diagnosis, ''
		WHEN ''N'' THEN ''''
	END
	+
	CASE h.Diabetes_Diagnosis
		WHEN ''Y'' THEN ''Diabetes Diagnosis, ''
		WHEN ''N'' THEN ''''
	END
	+
	CASE h.Coronary_Artery_Disease_Diagnosis 
		WHEN ''Y'' THEN ''Coronary Artery Disease Diagnosis, ''
		WHEN ''N'' THEN ''''
	END
	+
	CASE h.Hypertensive_Disease_Diagnosis
		WHEN ''Y'' THEN ''Hypertensive Disease Diagnosis, ''
		WHEN ''N'' THEN ''''
	END
	+
	CASE h.Bipolar_Diagnosis 
		WHEN ''Y'' THEN ''Bipolar Diagnosis, ''
		WHEN ''N'' THEN ''''
	END
	+
	CASE h.Chronic_Obstructive_Pulmonary_Disease_Diagnosis
		WHEN ''Y'' THEN ''Chronic Obstructive Pulmonary Disease Diagnosis, ''
		WHEN ''N'' THEN ''''
	END
	+
	CASE h.Congestive_Heart_Failure_Diagnosis
		WHEN ''Y'' THEN ''Congestive Heart Failure Diagnosis, ''
		WHEN ''N'' THEN ''''
	END
	+
	CASE h.Obesity_Diagnosis 
		WHEN ''Y'' THEN ''Obesity Diagnosis, ''
		WHEN ''N'' THEN ''''
	END
	+
	CASE h.Schizophrenia_Diagnosis 
		WHEN ''Y'' THEN ''Schizophrenia Diagnosis, ''
		WHEN ''N'' THEN ''''
	END
	+
	CASE h.Nicotine_Dependency_Diagnosis 
		WHEN ''Y'' THEN ''Nicotine Dependency Diagnosis, ''
		WHEN ''N'' THEN ''''
	END + ''$'', '', $'', '''') AS ''Diagnosis'',
	RTRIM(h.ER_Vistis) AS ''ER Vistis'',
	RTRIM(h.Hospital_Inpatient_Admissions_psychiatric) AS ''Hospital Inpatient Admissions-psychiatric'',
	RTRIM(h.Hospital_Inpatient_Admissions_non_psychiatric) AS ''Hospital Inpatient Admissions-non-psychiatric'',
	RTRIM(h.Physician_Visits) AS ''Physician Visits'',
	RTRIM(h.Behavioral_Health_Visits) AS ''Behavioral Health Visits'',
	h.Date_Received, t.ClientName 
	FROM dbo.Custom_HH_Data_Exchange_Demographics h
	LEFT	JOIN dbo.ClientPrograms cp
	ON h.ClientId = cp.ClientId 
	AND (ISNULL(cp.RecordDeleted, ''N'')<>''Y'')
	AND cp.ProgramId IN (444,445)
	LEFT	JOIN dbo.Programs p
    ON cp.ProgramId = p.ProgramId 
    AND (ISNULL(p.RecordDeleted, ''N'')<>''Y'')
    JOIN @TempClient t 
    on h.ClientId = t.ClientId 
	WHERE (ISNULL(h.RecordDeleted, ''N'')<>''Y'')
	AND h.ClientId LIKE @ClientId
END
' 
END
GO
