/****** Object:  StoredProcedure [dbo].[csp_Report_HH_Data_Exchange_Claim_Bulk_Insert]    Script Date: 06/19/2013 17:49:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_HH_Data_Exchange_Claim_Bulk_Insert]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[csp_Report_HH_Data_Exchange_Claim_Bulk_Insert]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[csp_Report_HH_Data_Exchange_Claim_Bulk_Insert]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'--/*
CREATE PROCEDURE [dbo].[csp_Report_HH_Data_Exchange_Claim_Bulk_Insert]
	-- Add the parameters for the stored procedure here
	@FileName		Varchar(50),
	--@FileType		Int,  -- 0 = Demographic / 1 = Claims / 2 = Hospital_Utilization
	@DateReceived	Datetime	
AS
--*/
/************************************************************************/
/* Stored Procedure: csp_Report_HH_Data_Exchange_Claim_Bulk_Insert     	*/
/* Creation Date: 02/12/2013                                         	*/
/* Copyright:    Harbor Behavioral Healthcare                        	*/
/*                                                                   	*/
/* Purpose: Bulk Insert of State Medicaid Claim file.                   	*/
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
	@FileName		= ''2341639_130304._PPCLMS'',
	--@FileType		= 0,
	@DateReceived	= ''20130305''
--*/
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
declare @date	datetime,
		@sql		Varchar(500),
		@sqlinsert	Varchar(5000),
		@Sqlinsert2	Varchar(8000)

select	@date	= GETDATE()

IF OBJECT_ID(''tempdb..#temp_Claim'') IS NOT NULL DROP TABLE #temp_Claim
Create Table #temp_Claim
(
	RecipientId varchar(15) NULL, ClaimsCat varchar(10) NULL, ProvName varchar(50) NULL, ProvAddress1 varchar(60) NULL,
	ProvAddress2 varchar(60) NULL, ProvCity varchar(30) NULL, ProvState varchar(6) NULL, ProvZip varchar(7) NULL,
	ProvZip4 varchar(8) NULL, ProvPhone varchar(10) NULL, DOS varchar(8) NULL, PharmName varchar(50) NULL, NDC varchar(12) NULL,
	NDC_Desc varchar(50) NULL, Days_Supply varchar(9) NULL, Qty_Dispense varchar(13) NULL, Dispense_Date varchar(8) NULL, 
	Admission_Date varchar(8) NULL,	Discharge_Date varchar(8) NULL, Diag_Admit varchar(50) NULL, Diag_Admit_Desc varchar(50) NULL, 
	Diag_1 varchar(50) NULL, Diag_1_Desc varchar(50) NULL, Diag_2 varchar(50) NULL, Diag_2_Desc varchar(50) NULL, 
	Proc_Code varchar(50) NULL, Proc_Code_Desc varchar(50) NULL, Rev_Code varchar(8) NULL, Rev_Code_Desc varchar(71) NULL, 
	ICD9_Surg varchar(50) NULL, ICD9_Surg_Desc varchar(50) NULL, R_Prov_Type varchar(50) NULL, R_Prov_Type_Desc varchar(51) NULL, 
	R_Prov_Spec varchar(50) NULL, R_PRov_Spec_Desc varchar(50) NULL, Prop_Days_Covered varchar(11) NULL
)


--DECLARE @Temp TABLE
--(
--	Temptablename	varchar(50),
--	StageTableName	Varchar(100),
--	TableName	Varchar(100)	
--)
	
--if @FileType = 0 begin
--	INSERT INTO @Temp 
--	VALUES (''#temp_demo'', ''Custom_HH_Data_Exchange_Claims_History_Stage'', ''dbo.Custom_HH_Data_Exchange_Demographics'')
--END	

--if @FileType = 1 begin
--	insert into @Temp 
--	values (''#temp_claim'', ''Custom_HH_Data_Exchange_Claims_History_Stage'', ''Custom_HH_Data_Exchange_Claims_History'')
--end
		
SELECT @sql = 
''BULK INSERT #temp_Claim
   FROM ''''\\harborfiles\mrowley$\Health Home\Data Exchange\'' + convert(varchar,@DateReceived, 112) + ''\'' + @filename + ''.csv''''
   WITH 
      (
         FIELDTERMINATOR =''''~'''',
         ROWTERMINATOR =''''\n''''
      );''

print @sql
exec(@sql)          

delete from #temp_Claim 
where RecipientId like ''Rec%''
		
Insert into Custom_HH_Data_Exchange_Claims_History_Stage         
select ''script27304'', @date, ''script27304'', @date, ''N'', Null, Null,	@DateReceived, Null, dbo.UDF_ParseAlphaChars(RecipientId)
	  , rtrim(ClaimsCat), rtrim(ProvName),rtrim(ProvAddress1)
	  , rtrim(ProvAddress2), dbo.UDF_ParseAlphaChars(ProvCity), ProvState, ProvZip, ProvZip4
	  , ProvPhone, convert(date, DOS), PharmName, NDC
      ,NDC_Desc, CONVERT(int,Days_Supply), cast((Qty_Dispense/1000) as decimal(10, 3)), convert(date, Dispense_Date), convert(date, Admission_Date)
      , convert(date, Discharge_Date), Diag_Admit, Diag_Admit_Desc, Diag_1, Diag_1_Desc, Diag_2, Diag_2_Desc, Proc_Code
      , Proc_Code_Desc, convert(int,Rev_Code),Rev_Code_Desc, ICD9_Surg, ICD9_Surg_Desc, R_Prov_Type, R_Prov_Type_Desc, R_Prov_Spec
      , R_PRov_Spec_Desc, dbo.UDF_ParseAlphaChars(Prop_Days_Covered)
from #temp_claim    

UPDATE ch
SET ch.ClientID = d.ClientId 
FROM Custom_HH_Data_Exchange_Claims_History_Stage ch
INNER JOIN dbo.Custom_HH_Data_Exchange_Demographics d
ON ch.RecipientId = d.R_MedicaidId 
	
drop table #temp_Claim 

insert into Custom_HH_Data_Exchange_Claims_History 
select CreatedBy, CreatedDate, ModifiedBy, ModifiedDate, RecordDeleted, DeletedDate, DeletedBy, Date_Received, ClientID
      ,RecipientId, ClaimsCat, ProvName, ProvAddress1, ProvAddress2, ProvCity, ProvState, ProvZip, ProvZip4, ProvPhone
      ,DOS, PharmName, NDC, NDC_Desc, Days_Supply, Qty_Dispense, Dispense_Date, Admission_Date, Discharge_Date, Diag_Admit
      ,Diag_Admit_Desc, Diag_1, Diag_1_Desc, Diag_2, Diag_2_Desc, Proc_Code, Proc_Code_Desc, Rev_Code, Rev_Code_Desc
      ,ICD9_Surg, ICD9_Surg_Desc,R_Prov_Type, R_Prov_Type_Desc, R_Prov_Spec, R_PRov_Spec_Desc, Prop_Days_Covered 
      from Custom_HH_Data_Exchange_Claims_History_Stage 

delete from Custom_HH_Data_Exchange_Claims_History_Stage 

select c.RecipientId,cd.R_First_Name, cd.R_Last_Name, cd.R_Street_1, cd.R_City, cd.R_State, cd.R_Zip, cd.R_Gender, cd.R_DOB, cd.R_SSN  
from Custom_HH_Data_Exchange_Claims_History c
join Custom_HH_Data_Exchange_Demographics cd
on c.RecipientId = cd.R_MedicaidId 
where c.clientId is null  

END

' 
END
GO
