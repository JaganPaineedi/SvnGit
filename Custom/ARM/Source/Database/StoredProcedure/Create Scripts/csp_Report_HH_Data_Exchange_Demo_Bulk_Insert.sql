/****** Object:  StoredProcedure [dbo].[csp_Report_HH_Data_Exchange_Demo_Bulk_Insert]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_HH_Data_Exchange_Demo_Bulk_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_HH_Data_Exchange_Demo_Bulk_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_HH_Data_Exchange_Demo_Bulk_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_HH_Data_Exchange_Demo_Bulk_Insert]
	-- Add the parameters for the stored procedure here
	@FileName		Varchar(50),
	--@FileType		Int,  -- 0 = Demographic / 1 = Claims / 2 = Hospital_Utilization
	@DateReceived	Datetime	
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_HH_Data_Exchange_Demo_Bulk_Insert      	*/
/* Creation Date: 02/12/2013                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/
/*                                                                   	*/
/* Purpose: Bulk Insert of State Medicaid Demo file.                   	*/
/*                                                                   	*/
/* Input Parameters: 	@FileName, @sql     			     			*/
/*								     									*/
/* Description: Bulk insert into Staging table then convert and insert  */
/*	into main Custom_HH_Data_Exchange_Demographic table.      			*/
/*                                                                   	*/
/* Updates:																*/
/*  Date		Author		Purpose										*/
/*	02/12/2013	MSR			Created										*/	
/************************************************************************/
/*
DECLARE
	@FileName		Varchar(50),
	--@FileType		Int,  -- 0 = Demographic / 1 = Claims / 2 = Hospital_Utilization
	@DateReceived	Datetime
SELECT
	@FileName		= ''2341639_130205._PPDEMO-Original'',
	--@FileType		= 0,
	@DateReceived	= ''20130207''
--*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
declare @date	datetime,
		@sql		Varchar(500),
		@sqlinsert	Varchar(5000),
		@Sqlinsert2	Varchar(8000),
		@vcount	Int
		
select	@date	= GETDATE()

IF OBJECT_ID(''tempdb..#temp_demo'') IS NOT NULL DROP TABLE #temp_demo
Create Table #temp_demo
(
	R_MedicaidId varchar(15) NOT NULL, 
	R_First_Name varchar(15) NULL, 
	R_Middle_Init varchar(4) NULL, 
	R_Last_Name varchar(20) NULL,
	R_Street_1 varchar(60) NULL, 
	R_Street_2 varchar(60) NULL, 
	R_City varchar(30) NULL, 
	R_State varchar(4) NULL, 
	R_Zip varchar(5) NULL,
	R_Zip_4 varchar(6) NULL, 
	R_Phone varchar(10) NULL, 
	R_County varchar(10) NULL, 
	R_Gender varchar(6) NULL, 
	R_DOB varchar(8) NULL,
	R_Language varchar(6) NULL, 
	R_Language_Desc varchar(100) NULL, 
	MC_Effective_Date varchar(8) NULL, 
	MC_End_Date varchar(8) NULL,
	MC_PlanId varchar(15) NULL, 
	MC_Plan_Name varchar(50) NULL, 
	R_TPL varchar(5) NULL, 
	R_MedicareId varchar(12) NULL,
	R_PartA varchar(7) NULL, 
	R_PartB varchar(7) NULL, 
	R_PartC varchar(7) NULL, 
	R_PartD varchar(7) NULL, 
	Asthma_Diagnosis varchar(8) NULL,
	Diabetes_Diagnosis varchar(8) NULL, 
	Coronary_Artery_Disease_Diagnosis varchar(8) NULL, 
	Hypertensive_Disease_Diagnosis varchar(8) NULL,
	Bipolar_Diagnosis varchar(8) NULL, 
	Chronic_Obstructive_Pulmonary_Disease_Diagnosis varchar(8) NULL, 
	Congestive_Heart_Failure_Diagnosis varchar(8) NULL, 
	Obesity_Diagnosis varchar(8) NULL, 
	Schizophrenia_Diagnosis varchar(8) NULL,
	Nicotine_Dependency_Diagnosis varchar(8) NULL, 
	ER_Vistis varchar(10) NULL, 
	Hospital_Inpatient_Admissions_psychiatric varchar(10) NULL,
	Hospital_Inpatient_Admissions_non_psychiatric varchar(10) NULL, 
	Physician_Visits varchar(10) NULL,
	Behavioral_Health_Visits varchar(10) NULL, 
	MFrequent_Primary_Diagnois_Code varchar(12) NULL,
	MFrequent_Primary_Diagnois_Code_Desc varchar(40) NULL, 
	MFrequent_Secondary_Diagnois_Code varchar(12) NULL,
	MFrequent_Secondary_Diagnois_Code_Desc varchar(40) NULL, 
	ER_Visits_MFrequent_Provider_Name varchar(50) NULL,
	ER_Visits_MFrequent_Provider_Address_1 varchar(60) NULL, 
	ER_Visits_MFrequent_Provider_Address_2 varchar(60) NULL,
	ER_Visits_MFrequent_Provider_City varchar(30) NULL, 
	ER_Visits_MFrequent_Provider_State varchar(9) NULL,
	ER_Visits_MFrequent_Provider_Zip varchar(10) NULL, 
	ER_Visits_MFrequent_Provider_Zip4 varchar(11) NULL,
	ER_Visits_MFrequent_Provider_Phone varchar(10) NULL, 
	Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Name varchar(50) NULL,
	Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Address_1 varchar(60) NULL,
	Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Address_2 varchar(60) NULL,
	Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_City varchar(30) NULL,
	Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_State varchar(9) NULL,
	Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Zip varchar(10) NULL,
	Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Zip4 varchar(11) NULL,
	Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Phone varchar(10) NULL,
	Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Name varchar(50) NULL,
	Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Address_1 varchar(60) NULL,
	Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Address_2 varchar(60) NULL,
	Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_City varchar(30) NULL,
	Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_State varchar(9) NULL,
	Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Zip varchar(10) NULL,
	Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Zip4 varchar(11) NULL,
	Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Phone varchar(10) NULL,
	Primary_Care_Visits_MFrequent_Provider_Name varchar(50) NULL, 
	Primary_Care_Visits_MFrequent_Provider_Address_1 varchar(60) NULL,
	Primary_Care_Visits_MFrequent_Provider_Address_2 varchar(60) NULL, 
	Primary_Care_Visits_MFrequent_Provider_City varchar(30) NULL,
	Primary_Care_Visits_MFrequent_Provider_State varchar(9) NULL, 
	Primary_Care_Visits_MFrequent_Provider_Zip varchar(10) NULL,
	Primary_Care_Visits_MFrequent_Provider_Zip4 varchar(11) NULL, 
	Primary_Care_Visits_MFrequent_Provider_Phone varchar(10) NULL,
	Behavioral_Health_Visits_MFrequent_Provider_Name varchar(50) NULL, 
	Behavioral_Health_Visits_MFrequent_Provider_Address_1 varchar(60) NULL,
	Behavioral_Health_Visits_MFrequent_Provider_Address_2 varchar(60) NULL,
	Behavioral_Health_Visits_MFrequent_Provider_City varchar(30) NULL, 
	Behavioral_Health_Visits_MFrequent_Provider_State varchar(9) NULL,
	Behavioral_Health_Visits_MFrequent_Provider_Zip varchar(10) NULL, 
	Behavioral_Health_Visits_MFrequent_Provider_Zip4 varchar(11) NULL,
	Behavioral_Health_Visits_MFrequent_Provider_Phone varchar(10) NULL, 
	R_SSN varchar(9) NULL, 
	R_Assignment_Plan_Effective_Date varchar(8) NULL, 
	R_Assignment_Plan_End_Date varchar(8) NULL, 
	Provider_Medicaid_Id varchar(15) NULL
)


--DECLARE @Temp TABLE
--(
--	Temptablename	varchar(50),
--	StageTableName	Varchar(100),
--	TableName	Varchar(100)	
--)
	
--if @FileType = 0 begin
--	INSERT INTO @Temp 
--	VALUES (''#temp_demo'', ''Custom_HH_Data_Exchange_Demographics_Stage'', ''dbo.Custom_HH_Data_Exchange_Demographics'')
--END	

--if @FileType = 1 begin
--	insert into @Temp 
--	values (''#temp_claim'', ''Custom_HH_Data_Exchange_Claims_History_Stage'', ''Custom_HH_Data_Exchange_Claims_History'')
--end
		
SELECT @sql = 
''BULK INSERT #temp_demo
   FROM ''''\\harborfiles\mrowley$\Health Home\Data Exchange\'' + convert(varchar,@DateReceived, 112) + ''\'' + @filename + ''.csv''''
   WITH 
      (
         FIELDTERMINATOR =''''~'''',
         ROWTERMINATOR =''''\n''''
      );''

print @sql
exec(@sql)          

delete from #temp_demo 
where R_MedicaidId like ''R-Med%''
		
Insert into Custom_HH_Data_Exchange_Demographics_Stage         
select ''script27304'', @date, ''script27304'', @date, ''N'', Null, Null,	@DateReceived, Null, dbo.UDF_ParseAlphaChars(R_MedicaidId)
, rtrim(R_First_Name), R_Middle_Init, rtrim(R_Last_Name), rtrim(R_Street_1), rtrim(R_Street_2), rtrim(R_City), rtrim(R_State)
, R_Zip, R_Zip_4, R_Phone, R_County, R_Gender, convert(date, R_DOB), R_Language
, R_Language_Desc, convert(date, MC_Effective_Date), convert(date, MC_End_Date), MC_PlanId, MC_Plan_Name, R_TPL, R_MedicareId
, R_PartA, R_PartB, R_PartC, R_PartD, Asthma_Diagnosis, Diabetes_Diagnosis, Coronary_Artery_Disease_Diagnosis
, Hypertensive_Disease_Diagnosis, Bipolar_Diagnosis, Chronic_Obstructive_Pulmonary_Disease_Diagnosis, Congestive_Heart_Failure_Diagnosis
,Obesity_Diagnosis, Schizophrenia_Diagnosis, Nicotine_Dependency_Diagnosis, ER_Vistis, Hospital_Inpatient_Admissions_psychiatric
,Hospital_Inpatient_Admissions_non_psychiatric, Physician_Visits, Behavioral_Health_Visits, MFrequent_Primary_Diagnois_Code
,MFrequent_Primary_Diagnois_Code_Desc, MFrequent_Secondary_Diagnois_Code, MFrequent_Secondary_Diagnois_Code_Desc
,ER_Visits_MFrequent_Provider_Name, ER_Visits_MFrequent_Provider_Address_1, ER_Visits_MFrequent_Provider_Address_2
,ER_Visits_MFrequent_Provider_City, ER_Visits_MFrequent_Provider_State, ER_Visits_MFrequent_Provider_Zip
,ER_Visits_MFrequent_Provider_Zip4, ER_Visits_MFrequent_Provider_Phone
,Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Name
,Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Address_1
,Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Address_2
,Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_City
,Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_State
,Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Zip
,Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Zip4
,Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Phone
,Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Name
,Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Address_1
,Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Address_2
,Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_City
,Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_State
,Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Zip
,Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Zip4
,Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Phone
,Primary_Care_Visits_MFrequent_Provider_Name, Primary_Care_Visits_MFrequent_Provider_Address_1
,Primary_Care_Visits_MFrequent_Provider_Address_2, Primary_Care_Visits_MFrequent_Provider_City
,Primary_Care_Visits_MFrequent_Provider_State, Primary_Care_Visits_MFrequent_Provider_Zip
,Primary_Care_Visits_MFrequent_Provider_Zip4, Primary_Care_Visits_MFrequent_Provider_Phone
,Behavioral_Health_Visits_MFrequent_Provider_Name, Behavioral_Health_Visits_MFrequent_Provider_Address_1
,Behavioral_Health_Visits_MFrequent_Provider_Address_2, Behavioral_Health_Visits_MFrequent_Provider_City
,Behavioral_Health_Visits_MFrequent_Provider_State, Behavioral_Health_Visits_MFrequent_Provider_Zip
,Behavioral_Health_Visits_MFrequent_Provider_Zip4, Behavioral_Health_Visits_MFrequent_Provider_Phone
,dbo.UDF_ParseAlphaChars(R_SSN), convert(date, R_Assignment_Plan_Effective_Date), convert(date, R_Assignment_Plan_End_Date)
, Provider_Medicaid_Id 
from #temp_demo 

update Custom_HH_Data_Exchange_Demographics_Stage 
set ClientId = c.ClientId 
from Custom_HH_Data_Exchange_Demographics_Stage cs
join dbo.clients c
on cs.R_SSN = c.SSN 
AND (ISNULL(c.RecordDeleted, ''N'')<>''Y'')	
where (cs.R_SSN <> ''000000000'' or cs.R_SSN is not null)
--and cs.ClientId is null
and c.Active = ''Y''

--select @vcount = @@ROWCOUNT 
--select @sql = ''Number of rows update is in first pass: '' + cast(@vcount as varchar) + CHAR(13)
	
update Custom_HH_Data_Exchange_Demographics_Stage 
set ClientId = c.ClientId 
from Custom_HH_Data_Exchange_Demographics_Stage cs
join dbo.clients c
on cs.R_SSN = c.SSN 
AND (ISNULL(c.RecordDeleted, ''N'')<>''Y'')	
where (cs.R_SSN <> ''000000000'' or cs.R_SSN is not null)
and cs.ClientId is null	

--select @vcount = @@ROWCOUNT 
--select @sql = @sql + ''Number of rows update is in second pass: '' + cast(@vcount as varchar) + CHAR(13)
	
UPDATE h
SET h.ClientId = c.ClientId
FROM Custom_HH_Data_Exchange_Demographics_Stage h 
JOIN dbo.ClientCoveragePlans cp
ON rtrim(ltrim(h.R_MedicaidId)) = cp.InsuredId 
AND (ISNULL(cp.RecordDeleted, ''N'')<>''Y'')
JOIN dbo.clients c
ON cp.ClientId = c.ClientId 
AND (ISNULL(c.RecordDeleted, ''N'')<>''Y'')
join dbo.ClientPrograms c2
on c.ClientId = c2.ClientId 
AND (ISNULL(c2.RecordDeleted, ''N'')<>''Y'')
WHERE h.ClientId IS NULL
AND (c2.ProgramId = 444 or c2.ProgramId = 445)
AND (h.R_Last_Name = c.LastName 
or h.R_First_Name = c.FirstName)
and h.R_DOB = c.DOB 

--select @vcount = @@ROWCOUNT 
--select @sql = @sql + ''Number of rows update is in third pass: '' + cast(@vcount as varchar) + CHAR(13)

----update h
----set h.ClientId = null
----from Custom_HH_Data_Exchange_Demographics_Stage h
----where h.R_SSN = ''000000000''
	
----update Custom_HH_Data_Exchange_Demographics_Stage 
----set R_SSN = c2.SSN from Custom_HH_Data_Exchange_Demographics c
----join clients c2
----on c.ClientId = c2.ClientId 
----where c.R_SSN = ''000000000'' and c.ClientId is not null	
	
INSERT INTO Custom_HH_Data_Exchange_Demographics 
SELECT * from Custom_HH_Data_Exchange_Demographics_Stage c
where exists 
(	Select * from Custom_HH_Data_Exchange_Demographics c2 
	where 
	c.R_SSN = c2.R_SSN and 
	(  (c.R_MedicaidId <> c2.R_MedicaidId 
	or (c.R_MedicaidId is null and c2.R_MedicaidId is Not null)
	or (c.R_MedicaidId is Not null and c2.R_MedicaidId is null))
	or (c.R_First_Name <> c2.R_First_Name
	or (c.R_First_Name is null and c2.R_First_Name is Not null)
	or (c.R_First_Name is Not null and c2.R_First_Name is null))
	or (c.R_Middle_Init <> c2.R_Middle_Init 
	or (c.R_Middle_Init is null and c2.R_Middle_Init is not null)
	or (c.R_Middle_Init is not null and c2.R_Middle_Init is null))
	or (c.R_Last_Name <> c2.R_Last_Name
	or (c.R_Last_Name is null and c2.R_Last_Name is not null))
	or (c.R_Last_Name is not null and c2.R_Last_Name is null)
	or (c.R_Street_1 <> c2.R_Street_1
	or (c.R_Street_1 is null and c2.R_Street_1 is not null)
	or (c.R_Street_1 is not null and  c2.R_Street_1 is null))
	or (c.R_Street_2 <> c2.R_Street_2
	or (c.R_Street_2 is null and c2.R_Street_2 is not null)
	or (c.R_Street_2 is not null and c2.R_Street_2 is null))
	or (c.R_City <> c2.R_City
	or (c.R_City is null and c2.R_City is not null)
	or (c.R_City is not null and c2.R_City is null))
	or (c.R_State <> c2.R_State
	or (c.R_State is null and c2.R_State is Not null)
	or (c.R_State is not null and c2.R_State is null))
	or (c.R_Zip <> c2.R_Zip
	or (c.R_Zip is null and c2.R_Zip is not null)
	or (c.R_Zip is not null and c2.R_Zip is null))
	or (c.R_Zip_4 <> c2.R_Zip_4
	or (c.R_Zip_4 is null and c2.R_Zip_4 is not null)
	or (c.R_Zip_4 is not null and c2.R_Zip_4 is null))
	or (c.R_Phone <> c2.R_Phone
	or (c.R_Phone is null and c2.R_Phone is not null)
	or (c.R_Phone is not null and c2.R_Phone is null))
	or (c.R_County <> c2.R_County
	or (c.R_County is null and c2.R_County is not null) 
	or (c.R_County is not null and c2.R_County is null))
	or (c.R_Gender <> c2.R_Gender
	or (c.R_Gender is null and c2.R_Gender is not null)
	or (c.R_Gender is not null and c2.R_Gender is null))
	or (c.R_DOB <> c2.R_DOB
	or (c.R_DOB is null and c2.R_DOB is not null)
	or (c.R_DOB is not null and c2.R_DOB is null))
	or (c.R_Language <> c2.R_Language
	or (c.R_Language is null and c2.R_Language is not null)
	or (c.R_Language is not null and c2.R_Language is null))
	or (c.R_Language_Desc <> c2.R_Language_Desc 
	or (c.R_Language_Desc is null and c2.R_Language_Desc is not null)
	or (c.R_Language_Desc is not null and c2.R_Language_Desc is null))
	or (c.MC_Effective_Date <> c2.MC_Effective_Date
	or (c.MC_Effective_Date is null and c2.MC_Effective_Date is not null)
	or (c.MC_Effective_Date is not null and c2.MC_Effective_Date is null))
	or (c.MC_End_Date <> c2.MC_End_Date
	or (c.MC_End_Date is null and c2.MC_End_Date is not null)
	or (c.MC_End_Date is not null and c2.MC_End_Date is null))
	or (c.MC_PlanId <> c2.MC_PlanId
	or (c.MC_PlanId is null and c2.MC_PlanId is not null)
	or (c.MC_PlanId is not null and c2.MC_PlanId is null))
	or (c.MC_Plan_Name <> c2.MC_Plan_Name
	or (c.MC_Plan_Name is null and c2.MC_Plan_Name is not null)
	or (c.MC_Plan_Name is not null and c2.MC_Plan_Name is null))
	or (c.R_TPL <> c2.R_TPL
	or (c.R_TPL is null and c2.R_TPL is not null)
	or (c.R_TPL is not null and c2.R_TPL is null))
	or (c.R_MedicareId <> c2.R_MedicareId
	or (c.R_MedicareId is null and c2.R_MedicareId is not null)
	or (c.R_MedicareId is not null and c2.R_MedicareId is null))
	or (c.R_PartA <> c2.R_PartA
	or (c.R_PartA is null and c2.R_PartA is not null)
	or (c.R_PartA is not null and c2.R_PartA is null)) 
	or (c.R_PartB <> c2.R_PartB
	or (c.R_PartB is null and c2.R_PartB is not null)
	or (c.R_PartB is not null and c2.R_PartB is null))
	or (c.R_PartC <> c2.R_PartC
	or (c.R_PartC is null and c2.R_PartC is not null)
	or (c.R_PartC is not null and c2.R_PartC is null))
	or (c.R_PartD <> c2.R_PartD
	or (c.R_PartD is null and c2.R_PartD is not null)
	or (c.R_PartD is not null and c2.R_PartD is null))
	or (c.Asthma_Diagnosis <> c2.Asthma_Diagnosis
	or (c.Asthma_Diagnosis is null and c2.Asthma_Diagnosis is not null)
	or (c.Asthma_Diagnosis is not null and c2.Asthma_Diagnosis is null))
	or (c.Diabetes_Diagnosis <> c2.Diabetes_Diagnosis
	or (c.Diabetes_Diagnosis is null and c2.Diabetes_Diagnosis is not null)
	or (c.Diabetes_Diagnosis is not null and c2.Diabetes_Diagnosis is null))
	or (c.Coronary_Artery_Disease_Diagnosis <> c2.Coronary_Artery_Disease_Diagnosis
	or (c.Coronary_Artery_Disease_Diagnosis is null and c2.Coronary_Artery_Disease_Diagnosis is not null)
	or (c.Coronary_Artery_Disease_Diagnosis is not null and c2.Coronary_Artery_Disease_Diagnosis is null))
	or (c.Hypertensive_Disease_Diagnosis <> c2.Hypertensive_Disease_Diagnosis
	or (c.Hypertensive_Disease_Diagnosis is null and c2.Hypertensive_Disease_Diagnosis is not null)
	or (c.Hypertensive_Disease_Diagnosis is not null and c2.Hypertensive_Disease_Diagnosis is null))
	or (c.Bipolar_Diagnosis <> c2.Bipolar_Diagnosis
	or (c.Bipolar_Diagnosis is null and c2.Bipolar_Diagnosis is not null)
	or (c.Bipolar_Diagnosis is not null and c2.Bipolar_Diagnosis is null))
	or (c.Chronic_Obstructive_Pulmonary_Disease_Diagnosis <> c2.Chronic_Obstructive_Pulmonary_Disease_Diagnosis
	or (c.Chronic_Obstructive_Pulmonary_Disease_Diagnosis is null and c2.Chronic_Obstructive_Pulmonary_Disease_Diagnosis is not null)
	or (c.Chronic_Obstructive_Pulmonary_Disease_Diagnosis is not null and c2.Chronic_Obstructive_Pulmonary_Disease_Diagnosis is null))
	or (c.Congestive_Heart_Failure_Diagnosis <> c2.Congestive_Heart_Failure_Diagnosis
	or (c.Congestive_Heart_Failure_Diagnosis is null and c2.Congestive_Heart_Failure_Diagnosis is not null)
	or (c.Congestive_Heart_Failure_Diagnosis is not null and c2.Congestive_Heart_Failure_Diagnosis is null))
	or (c.Obesity_Diagnosis <> c2.Obesity_Diagnosis
	or (c.Obesity_Diagnosis is null and c2.Obesity_Diagnosis is not null)
	or (c.Obesity_Diagnosis is not null and c2.Obesity_Diagnosis is null))
	or (c.Schizophrenia_Diagnosis <> c2.Schizophrenia_Diagnosis
	or (c.Schizophrenia_Diagnosis is null and c2.Schizophrenia_Diagnosis is not null)
	or (c.Schizophrenia_Diagnosis is not null and c2.Schizophrenia_Diagnosis is null))
	or (c.Nicotine_Dependency_Diagnosis <> c2.Nicotine_Dependency_Diagnosis
	or (c.Nicotine_Dependency_Diagnosis is null and c2.Nicotine_Dependency_Diagnosis is not null)
	or (c.Nicotine_Dependency_Diagnosis is not null and c2.Nicotine_Dependency_Diagnosis is null))
	or (c.ER_Vistis <> c2.ER_Vistis
	or (c.ER_Vistis is null and c2.ER_Vistis is not null)
	or (c.ER_Vistis is not null and c2.ER_Vistis is null))
	or (c.Hospital_Inpatient_Admissions_psychiatric <> c2.Hospital_Inpatient_Admissions_psychiatric
	or (c.Hospital_Inpatient_Admissions_psychiatric is null and c2.Hospital_Inpatient_Admissions_psychiatric is not null)
	or (c.Hospital_Inpatient_Admissions_psychiatric is not null and c2.Hospital_Inpatient_Admissions_psychiatric is null))
	or (c.Hospital_Inpatient_Admissions_non_psychiatric <> c2.Hospital_Inpatient_Admissions_non_psychiatric
	or (c.Hospital_Inpatient_Admissions_non_psychiatric is null and c2.Hospital_Inpatient_Admissions_non_psychiatric is not null)
	or (c.Hospital_Inpatient_Admissions_non_psychiatric is not null and c2.Hospital_Inpatient_Admissions_non_psychiatric is null))
	or (c.Physician_Visits <> c2.Physician_Visits
	or (c.Physician_Visits is null and c2.Physician_Visits is not null)
	or (c.Physician_Visits is not null and c2.Physician_Visits is null))
	or (c.Behavioral_Health_Visits <> c2.Behavioral_Health_Visits
	or (c.Behavioral_Health_Visits is null and c2.Behavioral_Health_Visits is not null)
	or (c.Behavioral_Health_Visits is not null and c2.Behavioral_Health_Visits is null))
	or (c.MFrequent_Primary_Diagnois_Code <> c2.MFrequent_Primary_Diagnois_Code
	or (c.MFrequent_Primary_Diagnois_Code is null and c2.MFrequent_Primary_Diagnois_Code is not null)
	or (c.MFrequent_Primary_Diagnois_Code is not null and c2.MFrequent_Primary_Diagnois_Code is null))
	or (c.MFrequent_Primary_Diagnois_Code_Desc <> c2.MFrequent_Primary_Diagnois_Code_Desc
	or (c.MFrequent_Primary_Diagnois_Code_Desc is null and c2.MFrequent_Primary_Diagnois_Code_Desc is not null)
	or (c.MFrequent_Primary_Diagnois_Code_Desc is not null and c2.MFrequent_Primary_Diagnois_Code_Desc is null))
	or (c.MFrequent_Secondary_Diagnois_Code <> c2.MFrequent_Secondary_Diagnois_Code
	or (c.MFrequent_Secondary_Diagnois_Code is null and c2.MFrequent_Secondary_Diagnois_Code is not null)
	or (c.MFrequent_Secondary_Diagnois_Code is not null and c2.MFrequent_Secondary_Diagnois_Code is null))
	or (c.MFrequent_Secondary_Diagnois_Code_Desc <> c2.MFrequent_Secondary_Diagnois_Code_Desc
	or (c.MFrequent_Secondary_Diagnois_Code_Desc is null and c2.MFrequent_Secondary_Diagnois_Code_Desc is not null)
	or (c.MFrequent_Secondary_Diagnois_Code_Desc is not null and c2.MFrequent_Secondary_Diagnois_Code_Desc is null))
	or (c.ER_Visits_MFrequent_Provider_Name <> c2.ER_Visits_MFrequent_Provider_Name
	or (c.ER_Visits_MFrequent_Provider_Name is null and c2.ER_Visits_MFrequent_Provider_Name is not null)
	or (c.ER_Visits_MFrequent_Provider_Name is not null and c2.ER_Visits_MFrequent_Provider_Name is null))
	or (c.ER_Visits_MFrequent_Provider_Address_1 <> c2.ER_Visits_MFrequent_Provider_Address_1
	or (c.ER_Visits_MFrequent_Provider_Address_1 is null and c2.ER_Visits_MFrequent_Provider_Address_1 is not null)
	or (c.ER_Visits_MFrequent_Provider_Address_1 is not null and c2.ER_Visits_MFrequent_Provider_Address_1 is null))
	or (c.ER_Visits_MFrequent_Provider_City <> c2.ER_Visits_MFrequent_Provider_City
	or (c.ER_Visits_MFrequent_Provider_City is null and c2.ER_Visits_MFrequent_Provider_City is not null)
	or (c.ER_Visits_MFrequent_Provider_City is not null and c2.ER_Visits_MFrequent_Provider_City is null))
	or (c.ER_Visits_MFrequent_Provider_State <> c2.ER_Visits_MFrequent_Provider_State
	or (c.ER_Visits_MFrequent_Provider_State is null and c2.ER_Visits_MFrequent_Provider_State is not null)
	or (c.ER_Visits_MFrequent_Provider_State is not null and c2.ER_Visits_MFrequent_Provider_State is null))
	or (c.ER_Visits_MFrequent_Provider_Zip <> c2.ER_Visits_MFrequent_Provider_Zip
	or (c.ER_Visits_MFrequent_Provider_Zip is null and c2.ER_Visits_MFrequent_Provider_Zip is not null)
	or (c.ER_Visits_MFrequent_Provider_Zip is not null and c2.ER_Visits_MFrequent_Provider_Zip is null))
	or (c.ER_Visits_MFrequent_Provider_Zip4 <> c2.ER_Visits_MFrequent_Provider_Zip4
	or (c.ER_Visits_MFrequent_Provider_Zip4 is null and c2.ER_Visits_MFrequent_Provider_Zip4 is not null) 
	or (c.ER_Visits_MFrequent_Provider_Zip4 is not null and c2.ER_Visits_MFrequent_Provider_Zip4 is null))
	or (c.ER_Visits_MFrequent_Provider_Phone <> c2.ER_Visits_MFrequent_Provider_Phone
	or (c.ER_Visits_MFrequent_Provider_Phone is null and c2.ER_Visits_MFrequent_Provider_Phone is not null) 
	or (c.ER_Visits_MFrequent_Provider_Phone is not null and c2.ER_Visits_MFrequent_Provider_Phone is null))
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Name <> c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Name
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Name is null and c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Name is not null)
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Name is not null and c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Name is null))
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Address_1 <> c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Address_1
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Address_1 is null and c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Address_1 is not null)
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Address_1 is not null and c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Address_1 is null))
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Address_2 <> c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Address_2
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Address_2 is null and c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Address_2 is not null)
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Address_2 is not null and c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Address_2 is null))
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_City <> c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_City
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_City is null and c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_City is not null)
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_City is not null and c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_City is null))
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_State <> c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_State
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_State is null and c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_State is not null)
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_State is not null and c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_State is null))
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Zip <> c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Zip
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Zip is null and c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Zip is not null)
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Zip is not null and c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Zip is null))
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Zip4 <> c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Zip4
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Zip4 is null and c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Zip4 is not null)
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Zip4 is not null and c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Zip4 is null))
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Phone <> c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Phone
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Phone is null and c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Phone is not null) 
	or (c.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Phone is not null and c2.Hospital_Inpatient_Admissions_psychiatric_MFrequent_Provider_Phone is null))
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Name <> c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Name
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Name is null and c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Name is not null)
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Name is not null and c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Name is null))
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Address_1 <> c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Address_1
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Address_1 is null and c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Address_1 is not null)
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Address_1 is not null and c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Address_1 is null))
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Address_2 <> c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Address_2
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Address_2 is null and c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Address_2 is not null)
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Address_2 is not null and c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Address_2 is null))
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_City <> c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_City
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_City is null and c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_City is not null)
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_City is not null and c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_City is null))
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_State <> c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_State
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_State is null and c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_State is not null)
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_State is not null and c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_State is null))
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Zip <> c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Zip
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Zip is null and c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Zip is not null)
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Zip is not null and c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Zip is null))
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Zip4 <> c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Zip4
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Zip4 is null and c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Zip4 is not null)
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Zip4 is not null and c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Zip4 is null))
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Phone <> c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Phone 
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Phone is null and  c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Phone is not null)
	or (c.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Phone is not null and c2.Hospital_Inpatient_Admissions_non_psychiatric_MFrequent_Provider_Phone is null))
	or (c.Primary_Care_Visits_MFrequent_Provider_Name <> c2.Primary_Care_Visits_MFrequent_Provider_Name
	or (c.Primary_Care_Visits_MFrequent_Provider_Name is null and c2.Primary_Care_Visits_MFrequent_Provider_Name is not null)
	or (c.Primary_Care_Visits_MFrequent_Provider_Name is not null and c2.Primary_Care_Visits_MFrequent_Provider_Name is null))
	or (c.Primary_Care_Visits_MFrequent_Provider_Address_1 <> c2.Primary_Care_Visits_MFrequent_Provider_Address_1
	or (c.Primary_Care_Visits_MFrequent_Provider_Address_1 is null and c2.Primary_Care_Visits_MFrequent_Provider_Address_1 is not null)
	or (c.Primary_Care_Visits_MFrequent_Provider_Address_1 is not null and c2.Primary_Care_Visits_MFrequent_Provider_Address_1 is null))
	or (c.Primary_Care_Visits_MFrequent_Provider_Address_2 <> c2.Primary_Care_Visits_MFrequent_Provider_Address_2
	or (c.Primary_Care_Visits_MFrequent_Provider_Address_2 is null and c2.Primary_Care_Visits_MFrequent_Provider_Address_2 is not null)
	or (c.Primary_Care_Visits_MFrequent_Provider_Address_2 is not null and c2.Primary_Care_Visits_MFrequent_Provider_Address_2 is null))
	or (c.Primary_Care_Visits_MFrequent_Provider_City <> c2.Primary_Care_Visits_MFrequent_Provider_City
	or (c.Primary_Care_Visits_MFrequent_Provider_City is null and c2.Primary_Care_Visits_MFrequent_Provider_City is not null)
	or (c.Primary_Care_Visits_MFrequent_Provider_City is not null and c2.Primary_Care_Visits_MFrequent_Provider_City is null))
	or (c.Primary_Care_Visits_MFrequent_Provider_State <> c2.Primary_Care_Visits_MFrequent_Provider_State
	or (c.Primary_Care_Visits_MFrequent_Provider_State is null and c2.Primary_Care_Visits_MFrequent_Provider_State is not null) 
	or (c.Primary_Care_Visits_MFrequent_Provider_State is not null and c2.Primary_Care_Visits_MFrequent_Provider_State is null))
	or (c.Primary_Care_Visits_MFrequent_Provider_Zip <> c2.Primary_Care_Visits_MFrequent_Provider_Zip
	or (c.Primary_Care_Visits_MFrequent_Provider_Zip is null and c2.Primary_Care_Visits_MFrequent_Provider_Zip is not null)
	or (c.Primary_Care_Visits_MFrequent_Provider_Zip is not null and c2.Primary_Care_Visits_MFrequent_Provider_Zip is null))
	or (c.Primary_Care_Visits_MFrequent_Provider_Zip4 <> c2.Primary_Care_Visits_MFrequent_Provider_Zip4
	or (c.Primary_Care_Visits_MFrequent_Provider_Zip4 is null and c2.Primary_Care_Visits_MFrequent_Provider_Zip4 is not null) 
	or (c.Primary_Care_Visits_MFrequent_Provider_Zip4 is not null and c2.Primary_Care_Visits_MFrequent_Provider_Zip4 is null))
	or (c.Primary_Care_Visits_MFrequent_Provider_Phone <> c2.Primary_Care_Visits_MFrequent_Provider_Phone
	or (c.Primary_Care_Visits_MFrequent_Provider_Phone is null and c2.Primary_Care_Visits_MFrequent_Provider_Phone is not null)
	or (c.Primary_Care_Visits_MFrequent_Provider_Phone is not null and c2.Primary_Care_Visits_MFrequent_Provider_Phone is null))
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Name <> c2.Behavioral_Health_Visits_MFrequent_Provider_Name
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Name is null and c2.Behavioral_Health_Visits_MFrequent_Provider_Name is not null)
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Name is not null and c2.Behavioral_Health_Visits_MFrequent_Provider_Name is null))
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Address_1 <> c2.Behavioral_Health_Visits_MFrequent_Provider_Address_1
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Address_1 is null and c2.Behavioral_Health_Visits_MFrequent_Provider_Address_1 is not null)
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Address_1 is not null and c2.Behavioral_Health_Visits_MFrequent_Provider_Address_1 is null))
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Address_2 <> c2.Behavioral_Health_Visits_MFrequent_Provider_Address_2
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Address_2 is null and c2.Behavioral_Health_Visits_MFrequent_Provider_Address_2 is not null)
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Address_2 is not null and c2.Behavioral_Health_Visits_MFrequent_Provider_Address_2 is null))
	or (c.Behavioral_Health_Visits_MFrequent_Provider_City <> c2.Behavioral_Health_Visits_MFrequent_Provider_City
	or (c.Behavioral_Health_Visits_MFrequent_Provider_City is null and c2.Behavioral_Health_Visits_MFrequent_Provider_City is not null)
	or (c.Behavioral_Health_Visits_MFrequent_Provider_City is not null and c2.Behavioral_Health_Visits_MFrequent_Provider_City is null))
	or (c.Behavioral_Health_Visits_MFrequent_Provider_State <> c2.Behavioral_Health_Visits_MFrequent_Provider_State
	or (c.Behavioral_Health_Visits_MFrequent_Provider_State is null and c2.Behavioral_Health_Visits_MFrequent_Provider_State is not null)
	or (c.Behavioral_Health_Visits_MFrequent_Provider_State is not null and c2.Behavioral_Health_Visits_MFrequent_Provider_State is null))
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Zip <> c2.Behavioral_Health_Visits_MFrequent_Provider_Zip
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Zip is null and c2.Behavioral_Health_Visits_MFrequent_Provider_Zip is not null)
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Zip is not null and c2.Behavioral_Health_Visits_MFrequent_Provider_Zip is null))
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Zip4 <> c2.Behavioral_Health_Visits_MFrequent_Provider_Zip4
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Zip4 is null and c2.Behavioral_Health_Visits_MFrequent_Provider_Zip4 is not null) 
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Zip4 is not null and c2.Behavioral_Health_Visits_MFrequent_Provider_Zip4 is null)) 
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Phone <> c2.Behavioral_Health_Visits_MFrequent_Provider_Phone
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Phone is null and c2.Behavioral_Health_Visits_MFrequent_Provider_Phone is not null)
	or (c.Behavioral_Health_Visits_MFrequent_Provider_Phone is not null and c2.Behavioral_Health_Visits_MFrequent_Provider_Phone is null))
	or (c.R_Assignment_Plan_Effective_Date <> c2.R_Assignment_Plan_Effective_Date
	or (c.R_Assignment_Plan_Effective_Date is null and c2.R_Assignment_Plan_Effective_Date is not null)
	or (c.R_Assignment_Plan_Effective_Date is not null and c2.R_Assignment_Plan_Effective_Date is null)) 
	or (c.R_Assignment_Plan_End_Date <> c2.R_Assignment_Plan_End_Date
	or (c.R_Assignment_Plan_End_Date is null and c2.R_Assignment_Plan_End_Date is not null)
	or (c.R_Assignment_Plan_End_Date is not null and c2.R_Assignment_Plan_End_Date is null))
	or (c.Provider_Medicaid_Id <> c2.Provider_Medicaid_Id
	or (c.Provider_Medicaid_Id is null and c2.Provider_Medicaid_Id is Not null)
	or (c.Provider_Medicaid_Id is not null and c2.Provider_Medicaid_Id is null))
))

INSERT INTO Custom_HH_Data_Exchange_Demographics 
select * from Custom_HH_Data_Exchange_Demographics_Stage a
where Not exists 
(select * from Custom_HH_Data_Exchange_Demographics b where a.R_SSN = b.R_SSN)	

drop table #temp_demo 

--PRINT @sql
--exec(@sql)

select distinct c.R_MedicaidId, c.R_First_Name, c.R_Last_Name, c.R_Street_1, c.R_City, c.R_State, c.R_Zip, c.R_Gender, c.R_DOB, c.R_SSN
from Custom_HH_Data_Exchange_Demographics_Stage  c
where c.clientId is null
order by c.R_MedicaidId, c.R_First_Name, c.R_Last_Name 

delete from Custom_HH_Data_Exchange_Demographics_Stage 

END

' 
END
GO
