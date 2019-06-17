----- STEP 1 ----------

IF ((select DataModelVersion FROM SystemConfigurations)  < 15.27)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.27 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------

------------------We are adding  fields in ClaimUB04s table

IF COL_LENGTH('ClaimUB04s','PageNumber') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD PageNumber int NULL 
END 
IF COL_LENGTH('ClaimUB04s','Field67POA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67POA varchar(1) NULL 
END
IF COL_LENGTH('ClaimUB04s','Field67aPOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67aPOA varchar(1) NULL 
END
IF COL_LENGTH('ClaimUB04s','Field67bPOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67bPOA varchar(1) NULL 
END

IF COL_LENGTH('ClaimUB04s','Field67cPOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67cPOA varchar(1) NULL 
END

IF COL_LENGTH('ClaimUB04s','Field67dPOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67dPOA varchar(1) NULL 
END
IF COL_LENGTH('ClaimUB04s','Field67ePOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67ePOA varchar(1) NULL 
END

IF COL_LENGTH('ClaimUB04s','Field67fPOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67fPOA varchar(1) NULL 
END
IF COL_LENGTH('ClaimUB04s','Field67gPOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67gPOA varchar(1) NULL 
END
IF COL_LENGTH('ClaimUB04s','Field67hPOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67hPOA varchar(1) NULL 
END
IF COL_LENGTH('ClaimUB04s','Field67iPOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67iPOA varchar(1) NULL 
END
IF COL_LENGTH('ClaimUB04s','Field67jPOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67jPOA varchar(1) NULL 
END
IF COL_LENGTH('ClaimUB04s','Field67kPOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67kPOA varchar(1) NULL 
END
IF COL_LENGTH('ClaimUB04s','Field67lPOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67lPOA varchar(1) NULL 
END
IF COL_LENGTH('ClaimUB04s','Field67mPOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67mPOA varchar(1) NULL 
END
IF COL_LENGTH('ClaimUB04s','Field67nPOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67nPOA varchar(1) NULL 
END
IF COL_LENGTH('ClaimUB04s','Field67oPOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67oPOA varchar(1) NULL 
END
IF COL_LENGTH('ClaimUB04s','Field67pPOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67pPOA varchar(1) NULL 
END
IF COL_LENGTH('ClaimUB04s','Field67qPOA') IS NULL
BEGIN
	ALTER TABLE ClaimUB04s  ADD Field67qPOA varchar(1) NULL 
END
--------------END addition of field
IF OBJECT_ID('tempdb..#ColumnExists') IS NOT NULL
 DROP TABLE #ColumnExists
 
CREATE TABLE #ColumnExists (value INT)
 IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN

IF COL_LENGTH('ClaimUB04s','ClaimUB04Id') IS NOT NULL
BEGIN
	INSERT INTO #ColumnExists
			(value)
		VALUES (1)
	PRINT 'ClaimUB04Id Column already exists in ClaimUB04s - Skipping operation'
END
END
GO

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN	
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ClaimUB04s') AND type in (N'U'))     Exec sp_rename  ClaimUB04s,ClaimUB04s_Temp111
	PRINT 'STEP 1 COMPLETED'
END
Go
--End of Step 1
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN
	IF EXISTS (SELECT * FROM sys.objects WHERE object_id=OBJECT_ID(N'ssp_DeleteTableChecks') AND type IN (N'P',N'PC')) 
	DROP PROCEDURE ssp_DeleteTableChecks
END
GO

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN
	exec ('create proc [dbo].[ssp_DeleteTableChecks]  
	@TableName varchar(128)   
	as  
	  
	create table #temp1  
	(ConstraintName varchar(128) null,  
	ConstraintDefinition varchar(1000) null,  
	Col1 int null,  
	Col2 int null)  
	  
	declare @ConstraintName varchar(128)  
	declare @DropSQLString varchar(1000)  
	  
	insert into #temp1  
	exec sp_MStablechecks @TableName  
	  
	if @@error <> 0 return  
	  
	declare cur_DropCheck cursor for  
	select ConstraintName  
	from #temp1  
	  
	if @@error <> 0 return  
	  
	open cur_DropCheck  
	  
	if @@error <> 0 return  
	  
	fetch cur_DropCheck into @ConstraintName  
	  
	while @@Fetch_Status = 0  
	begin  
	  
	set @DropSQLString = ''ALTER TABLE '' + @TableName + '' DROP CONSTRAINT '' + @ConstraintName  
	  
	if @@error <> 0 return  
	  
	print @DropSQLString  
	execute(@DropSQLString)  
	  
	if @@error <> 0 return  
	  
	fetch cur_DropCheck into @ConstraintName  
	  
	if @@error <> 0 return  
	  
	end  
	  
	close cur_DropCheck  
	  
	if @@error <> 0 return  
	  
	deallocate cur_DropCheck  
	  
	if @@error <> 0 return ') 
END
GO
--End of Step 1	
------ STEP 2 ----------
--Part1 Begin
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	exec ssp_DeleteTableChecks 'ClaimUB04s_Temp111'
--Part2 Begins
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	BEGIN
	declare @PKName nvarchar(max)
	declare @tempPK  nvarchar(max)

	IF EXISTS(SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'ClaimUB04s_Temp111') AND is_primary_key=1)
	BEGIN
		SET @PKName=(SELECT name FROM sys.indexes WHERE object_id = OBJECT_ID(N'ClaimUB04s_Temp111') AND is_primary_key=1)
		SET @tempPK=@PKName +'_Temp111'
		Exec sp_rename  @PKName,@tempPK
	END			
	END
-----End of Step 2 -------
------ STEP 3 ------------

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce )
BEGIN 
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ClaimLineItemGroups_ClaimUB04s_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimUB04s_Temp111]'))
	ALTER TABLE [dbo].[ClaimUB04s_Temp111] DROP CONSTRAINT ClaimLineItemGroups_ClaimUB04s_FK	
END

------ END OF STEP 3 -----

------ STEP 4 ----------
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN
	/* 
	 * TABLE: ClaimUB04s 
	 */

	CREATE TABLE ClaimUB04s(
		ClaimUB04Id							int IDENTITY(1,1)		NOT NULL,    
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedDate							datetime				NULL,
		DeletedBy							type_UserId				NULL,
		ClaimLineItemGroupId				int						NOT NULL,
		Field1ProviderName					varchar(25)				NULL,
		FieldProviderAddress				varchar(25)				NULL,
		FieldProviderCityStateZip			varchar(25)				NULL,
		FieldProviderTelephoneFax			varchar(25)				NULL,
		Field2PayToName						varchar(25)				NULL,
		Field2PayToAddress					varchar(25)				NULL,
		Field2PayToCityState				varchar(25)				NULL,
		Field3aPatientControlNumber			varchar(20)				NULL,
		Field3bMedicalRecordNumber			varchar(24)				NULL,
		Field4TypeOfBill					varchar(4)				NULL,
		Field5TaxIdType						varchar(5)				NULL,
		Field5TaxId							varchar(10)				NULL,
		Field6StatementFrom					varchar(10)				NULL,
		Field6StatementTo					varchar(10)				NULL,
		Field7Unlabelled					varchar(10)				NULL,
		Field8aPatientId					varchar(19)				NULL,
		Field8bPatientName					varchar(29)				NULL,
		Field9aPatientAddress				varchar(40)				NULL,
		Field9bCity							varchar(30)				NULL,
		Field9cState						varchar(2)				NULL,
		Field9dZip							varchar(10)				NULL,
		Field9eCountryCode					varchar(3)				NULL,
		Field10PatientDOB					varchar(10)				NULL,
		Field11PatientSex					varchar(2)				NULL,
		Field12AdmissionDate				varchar(10)				NULL,
		Field13AdmissionHour				varchar(2)				NULL,
		Field14AdmissionType				varchar(2)				NULL,
		Field15AdmissionSource				char(1)					NULL,
		Field16DischargeHour				varchar(2)				NULL,
		Field17DischargeStatus				varchar(2)				NULL,
		Field18ConditionCode				varchar(2)				NULL,
		Field19ConditionCode				varchar(2)				NULL,
		Field20ConditionCode				varchar(2)				NULL,
		Field21ConditionCode				varchar(2)				NULL,
		Field22ConditionCode				varchar(2)				NULL,
		Field23ConditionCode				varchar(2)				NULL,
		Field24ConditionCode				varchar(2)				NULL,
		Field25ConditionCode				varchar(2)				NULL,
		Field26ConditionCode				varchar(2)				NULL,
		Field27ConditionCode				varchar(2)				NULL,
		Field28ConditionCode				varchar(2)				NULL,
		Field29AccidentState				varchar(2)				NULL,
		Field30aUnlabelled					varchar(12)				NULL,
		Field30bUnlabelled					varchar(13)				NULL,
		Field31aOccurenceCode				varchar(2)				NULL,
		Field31aOccurenceDate				varchar(10)				NULL,
		Field31bOccurenceCode				varchar(2)				NULL,
		Field31bOccurenceDate				varchar(10)				NULL,
		Field32aOccurenceCode				varchar(2)				NULL,
		Field32aOccurenceDate				varchar(10)				NULL,
		Field32bOccurenceCode				varchar(2)				NULL, 
		Field32bOccurenceDate				varchar(10)				NULL,
		Field33aOccurenceCode				varchar(2)				NULL,
		Field33aOccurenceDate				varchar(10)				NULL,
		Field33bOccurenceCode				varchar(2)				NULL,
		Field33bOccurenceDate				varchar(10)				NULL, 	
		Field34aOccurenceCode				varchar(2)				NULL,
		Field34aOccurenceDate				varchar(10)				NULL,
		Field34bOccurenceCode				varchar(2)				NULL,  
		Field34bOccurenceDate				varchar(10)				NULL,
		Field35aOccuranceCode				varchar(2)				NULL,
		Field35aOccuranceFrom				varchar(10)				NULL,
		Field35aOccuranceTo					varchar(10)				NULL,
		Field35bOccuranceCode				varchar(2)				NULL,
		Field35bOccuranceFrom				varchar(10)				NULL,
		Field35bOccuranceTo					varchar(10)				NULL,
		Field36aOccuranceCode				varchar(2)				NULL,
		Field36aOccuranceFrom				varchar(10)				NULL,
		Field36aOccuranceTo					varchar(10)				NULL,
		Field36bOccuranceCode				varchar(2)				NULL,
		Field36bOccuranceFrom				varchar(10)				NULL,
		Field36bOccuranceTo					varchar(10)				NULL,
		Field37aUnlabelled					varchar(10)				NULL,
		Field37bUnlabelled					varchar(10)				NULL,
		Field38ResponsibleAddress1			varchar(40)				NULL,
		Field38ResponsibleAddress2			varchar(40)				NULL,
		Field38ResponsibleAddress3			varchar(40)				NULL,
		Field38ResponsibleAddress4			varchar(40)				NULL,
		Field38ResponsibleAddress5			varchar(40)				NULL,
		Field39aValueCode					varchar(2)				NULL,
		Field39aValueAmountWhole			varchar(6)				NULL,
		Field39aValueDecimal				varchar(2)				NULL,
		Field39bValueCode					varchar(2)				NULL,
		Field39bValueAmountWhole			varchar(6)				NULL,
		Field39bValueDecimal				varchar(2)				NULL,
		Field39cValueCode					varchar(2)				NULL,
		Field39cValueAmountWhole			varchar(6)				NULL,
		Field39cValueDecimal				varchar(2)				NULL,
		Field39dValueCode					varchar(2)				NULL,
		Field39dValueAmountWhole			varchar(6)				NULL,
		Field39dValueDecimal				varchar(2)				NULL,
		Field40aValueCode					varchar(2)				NULL,
		Field40aValueAmountWhole			varchar(6)				NULL,
		Field40aValueDecimal				varchar(2)				NULL,
		Field40bValueCode					varchar(2)				NULL,
		Field40bValueAmountWhole			varchar(6)				NULL,
		Field40bValueDecimal				varchar(2)				NULL,
		Field40cValueCode					varchar(2)				NULL,
		Field40cValueAmountWhole			varchar(6)				NULL,
		Field40cValueDecimal				varchar(2)				NULL,
		Field40dValueCode					varchar(2)				NULL,
		Field40dValueAmountWhole			varchar(6)				NULL,
		Field40dValueDecimal				varchar(2)				NULL,
		Field41aValueCode					varchar(2)				NULL,
		Field41aValueAmountWhole			varchar(6)				NULL,
		Field41aValueDecimal				varchar(2)				NULL,
		Field41bValueCode					varchar(2)				NULL,
		Field41bValueAmountWhole			varchar(6)				NULL,
		Field41bValueDecimal				varchar(2)				NULL,
		Field41cValueCode					varchar(2)				NULL,
		Field41cValueAmountWhole			varchar(6)				NULL,
		Field41cValueDecimal				varchar(2)				NULL,
		Field41dValueCode					varchar(2)				NULL,
		Field41dValueAmountWhole			varchar(6)				NULL,
		Field41dValueDecimal				varchar(2)				NULL,
		Field42RevenueCode1					varchar(4)				NULL,
		Field43RevenueDescription1			varchar(24)				NULL,
		Field44HCPCSCode1					varchar(14)				NULL,
		Field45ServiceDate1					varchar(10)				NULL,
		Field46ServiceUnits1				varchar(7)				NULL,
		Field47TotalChargesWhole1			varchar(6)				NULL,
		Field47TotalChargesDecimal1			varchar(2)				NULL,
		Field48NonCoveredChargesWhole1		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal1	varchar(2)				NULL,
		Field49Unlabelled1					varchar(2)				NULL,
		Field42RevenueCode2					varchar(4)				NULL,
		Field43RevenueDescription2			varchar(24)				NULL,
		Field44HCPCSCode2					varchar(14)				NULL,
		Field45ServiceDate2					varchar(10)				NULL,
		Field46ServiceUnits2				varchar(7)				NULL,
		Field47TotalChargesWhole2			varchar(6)				NULL,
		Field47TotalChargesDecimal2			varchar(2)				NULL,
		Field48NonCoveredChargesWhole2		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal2	varchar(2)				NULL,
		Field49Unlabelled2					varchar(2)				NULL,
		Field42RevenueCode3					varchar(4)				NULL,
		Field43RevenueDescription3			varchar(24)				NULL,
		Field44HCPCSCode3					varchar(14)				NULL,
		Field45ServiceDate3					varchar(10)				NULL,
		Field46ServiceUnits3				varchar(7)				NULL,
		Field47TotalChargesWhole3			varchar(6)				NULL,
		Field47TotalChargesDecimal3			varchar(2)				NULL,
		Field48NonCoveredChargesWhole3		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal3	varchar(2)				NULL,
		Field49Unlabelled3					varchar(2)				NULL,
		Field42RevenueCode4					varchar(4)				NULL,
		Field43RevenueDescription4			varchar(24)				NULL,
		Field44HCPCSCode4					varchar(14)				NULL,
		Field45ServiceDate4					varchar(10)				NULL,
		Field46ServiceUnits4				varchar(7)				NULL,
		Field47TotalChargesWhole4			varchar(6)				NULL,
		Field47TotalChargesDecimal4			varchar(2)				NULL,
		Field48NonCoveredChargesWhole4		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal4	varchar(2)				NULL,
		Field49Unlabelled4					varchar(2)				NULL,
		Field42RevenueCode5					varchar(4)				NULL,
		Field43RevenueDescription5			varchar(24)				NULL,
		Field44HCPCSCode5					varchar(14)				NULL,
		Field45ServiceDate5					varchar(10)				NULL,
		Field46ServiceUnits5				varchar(7)				NULL,
		Field47TotalChargesWhole5			varchar(6)				NULL,
		Field47TotalChargesDecimal5			varchar(2)				NULL,
		Field48NonCoveredChargesWhole5		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal5	varchar(2)				NULL,
		Field49Unlabelled5					varchar(2)				NULL,
		Field42RevenueCode6					varchar(4)				NULL,
		Field43RevenueDescription6			varchar(24)				NULL,
		Field44HCPCSCode6					varchar(14)				NULL,
		Field45ServiceDate6					varchar(10)				NULL,
		Field46ServiceUnits6				varchar(7)				NULL,
		Field47TotalChargesWhole6			varchar(6)				NULL,
		Field47TotalChargesDecimal6			varchar(2)				NULL,
		Field48NonCoveredChargesWhole6		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal6	varchar(2)				NULL,
		Field49Unlabelled6					varchar(2)				NULL,
		Field42RevenueCode7					varchar(4)				NULL,
		Field43RevenueDescription7			varchar(24)				NULL,
		Field44HCPCSCode7					varchar(14)				NULL,
		Field45ServiceDate7					varchar(10)				NULL,
		Field46ServiceUnits7				varchar(7)				NULL,
		Field47TotalChargesWhole7			varchar(6)				NULL,
		Field47TotalChargesDecimal7			varchar(2)				NULL,
		Field48NonCoveredChargesWhole7		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal7	varchar(2)				NULL,
		Field49Unlabelled7					varchar(2)				NULL,
		Field42RevenueCode8					varchar(4)				NULL,
		Field43RevenueDescription8			varchar(24)				NULL,
		Field44HCPCSCode8					varchar(14)				NULL,
		Field45ServiceDate8					varchar(10)				NULL,
		Field46ServiceUnits8				varchar(7)				NULL,
		Field47TotalChargesWhole8			varchar(6)				NULL,
		Field47TotalChargesDecimal8			varchar(2)				NULL,
		Field48NonCoveredChargesWhole8		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal8	varchar(2)				NULL,
		Field49Unlabelled8					varchar(2)				NULL,
		Field42RevenueCode9					varchar(4)				NULL,
		Field43RevenueDescription9			varchar(24)				NULL,
		Field44HCPCSCode9					varchar(14)				NULL,
		Field45ServiceDate9					varchar(10)				NULL,
		Field46ServiceUnits9				varchar(7)				NULL,
		Field47TotalChargesWhole9			varchar(6)				NULL,
		Field47TotalChargesDecimal9			varchar(2)				NULL,
		Field48NonCoveredChargesWhole9		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal9	varchar(2)				NULL,
		Field49Unlabelled9					varchar(2)				NULL,
		Field42RevenueCode10				varchar(4)				NULL,
		Field43RevenueDescription10			varchar(24)				NULL,
		Field44HCPCSCode10					varchar(14)				NULL,
		Field45ServiceDate10				varchar(10)				NULL,
		Field46ServiceUnits10				varchar(7)				NULL,
		Field47TotalChargesWhole10			varchar(6)				NULL,
		Field47TotalChargesDecimal10		varchar(2)				NULL,
		Field48NonCoveredChargesWhole10		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal10	varchar(2)				NULL,
		Field49Unlabelled10					varchar(2)				NULL,
		Field42RevenueCode11				varchar(4)				NULL,
		Field43RevenueDescription11			varchar(24)				NULL,
		Field44HCPCSCode11					varchar(14)				NULL,
		Field45ServiceDate11				varchar(10)				NULL,
		Field46ServiceUnits11				varchar(7)				NULL,
		Field47TotalChargesWhole11			varchar(6)				NULL,
		Field47TotalChargesDecimal11		varchar(2)				NULL,
		Field48NonCoveredChargesWhole11		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal11	varchar(2)				NULL,
		Field49Unlabelled11					varchar(2)				NULL,
		Field42RevenueCode12				varchar(4)				NULL,
		Field43RevenueDescription12			varchar(24)				NULL,
		Field44HCPCSCode12					varchar(14)				NULL,
		Field45ServiceDate12				varchar(10)				NULL,
		Field46ServiceUnits12				varchar(7)				NULL,
		Field47TotalChargesWhole12			varchar(6)				NULL,
		Field47TotalChargesDecimal12		varchar(2)				NULL,
		Field48NonCoveredChargesWhole12		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal12	varchar(2)				NULL,
		Field49Unlabelled12					varchar(2)				NULL,
		Field42RevenueCode13				varchar(4)				NULL,
		Field43RevenueDescription13			varchar(24)				NULL,
		Field44HCPCSCode13					varchar(14)				NULL,
		Field45ServiceDate13				varchar(10)				NULL,
		Field46ServiceUnits13				varchar(7)				NULL,
		Field47TotalChargesWhole13			varchar(6)				NULL,
		Field47TotalChargesDecimal13		varchar(2)				NULL,
		Field48NonCoveredChargesWhole13		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal13	varchar(2)				NULL,
		Field49Unlabelled13					varchar(2)				NULL,
		Field42RevenueCode14				varchar(4)				NULL,
		Field43RevenueDescription14			varchar(24)				NULL,
		Field44HCPCSCode14					varchar(14)				NULL,
		Field45ServiceDate14				varchar(10)				NULL,
		Field46ServiceUnits14				varchar(7)				NULL,
		Field47TotalChargesWhole14			varchar(6)				NULL,
		Field47TotalChargesDecimal14		varchar(2)				NULL,
		Field48NonCoveredChargesWhole14		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal14	varchar(2)				NULL,
		Field49Unlabelled14					varchar(2)				NULL,
		Field42RevenueCode15				varchar(4)				NULL,
		Field43RevenueDescription15			varchar(24)				NULL,
		Field44HCPCSCode15					varchar(14)				NULL,
		Field45ServiceDate15				varchar(10)				NULL,
		Field46ServiceUnits15				varchar(7)				NULL,
		Field47TotalChargesWhole15			varchar(6)				NULL,
		Field47TotalChargesDecimal15		varchar(2)				NULL,
		Field48NonCoveredChargesWhole15		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal15	varchar(2)				NULL,
		Field49Unlabelled15					varchar(2)				NULL,
		Field42RevenueCode16				varchar(4)				NULL,
		Field43RevenueDescription16			varchar(24)				NULL,
		Field44HCPCSCode16					varchar(14)				NULL,
		Field45ServiceDate16				varchar(10)				NULL,
		Field46ServiceUnits16				varchar(7)				NULL,
		Field47TotalChargesWhole16			varchar(6)				NULL,
		Field47TotalChargesDecimal16		varchar(2)				NULL,
		Field48NonCoveredChargesWhole16		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal16	varchar(2)				NULL,
		Field49Unlabelled16					varchar(2)				NULL,
		Field42RevenueCode17				varchar(4)				NULL,
		Field43RevenueDescription17			varchar(24)				NULL,
		Field44HCPCSCode17					varchar(14)				NULL,
		Field45ServiceDate17				varchar(10)				NULL,
		Field46ServiceUnits17				varchar(7)				NULL,
		Field47TotalChargesWhole17			varchar(6)				NULL,
		Field47TotalChargesDecimal17		varchar(2)				NULL,
		Field48NonCoveredChargesWhole17		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal17	varchar(2)				NULL,
		Field49Unlabelled17					varchar(2)				NULL,
		Field42RevenueCode18				varchar(4)				NULL,
		Field43RevenueDescription18			varchar(24)				NULL,
		Field44HCPCSCode18					varchar(14)				NULL,
		Field45ServiceDate18				varchar(10)				NULL,
		Field46ServiceUnits18				varchar(7)				NULL,
		Field47TotalChargesWhole18			varchar(6)				NULL,
		Field47TotalChargesDecimal18		varchar(2)				NULL,
		Field48NonCoveredChargesWhole18		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal18	varchar(2)				NULL,
		Field49Unlabelled18					varchar(2)				NULL,
		Field42RevenueCode19				varchar(4)				NULL,
		Field43RevenueDescription19			varchar(24)				NULL,
		Field44HCPCSCode19					varchar(14)				NULL,
		Field45ServiceDate19				varchar(10)				NULL,
		Field46ServiceUnits19				varchar(7)				NULL,
		Field47TotalChargesWhole19			varchar(6)				NULL,
		Field47TotalChargesDecimal19		varchar(2)				NULL,
		Field48NonCoveredChargesWhole19		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal19	varchar(2)				NULL,
		Field49Unlabelled19					varchar(2)				NULL,
		Field42RevenueCode20				varchar(4)				NULL,
		Field43RevenueDescription20			varchar(24)				NULL,
		Field44HCPCSCode20					varchar(14)				NULL,
		Field45ServiceDate20				varchar(10)				NULL,
		Field46ServiceUnits20				varchar(7)				NULL,
		Field47TotalChargesWhole20			varchar(6)				NULL,
		Field47TotalChargesDecimal20		varchar(2)				NULL,
		Field48NonCoveredChargesWhole20		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal20	varchar(2)				NULL,
		Field49Unlabelled20					varchar(2)				NULL,
		Field42RevenueCode21				varchar(4)				NULL,
		Field43RevenueDescription21			varchar(24)				NULL,
		Field44HCPCSCode21					varchar(14)				NULL,
		Field45ServiceDate21				varchar(10)				NULL,
		Field46ServiceUnits21				varchar(7)				NULL,
		Field47TotalChargesWhole21			varchar(6)				NULL,
		Field47TotalChargesDecimal21		varchar(2)				NULL,
		Field48NonCoveredChargesWhole21		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal21	varchar(2)				NULL,
		Field49Unlabelled21					varchar(2)				NULL,
		Field42RevenueCode22				varchar(4)				NULL,
		Field43RevenueDescription22			varchar(24)				NULL,
		Field44HCPCSCode22					varchar(14)				NULL,
		Field45ServiceDate22				varchar(10)				NULL,
		Field46ServiceUnits22				varchar(7)				NULL,
		Field47TotalChargesWhole22			varchar(6)				NULL,
		Field47TotalChargesDecimal22		varchar(2)				NULL,
		Field48NonCoveredChargesWhole22		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal22	varchar(2)				NULL,
		Field49Unlabelled22					varchar(2)				NULL,
		Field43PageNumber					varchar(3)				NULL,
		Field43PageOf						varchar(3)				NULL,
		Field44CreationDate					varchar(10)				NULL,
		Field47TotalChargesWhole23			varchar(6)				NULL,
		Field47TotalChargesDecimal23		varchar(2)				NULL,
		Field48NonCoveredChargesWhole23		varchar(6)				NULL,
		Field48NonCoveredChargesDecimal23	varchar(2)				NULL,
		Field50aPayerName					varchar(23)				NULL,
		Field50bPayerName					varchar(23)				NULL,
		Field50cPayerName					varchar(23)				NULL,
		Field51aHealthPlanId				varchar(15)				NULL,
		Field51bHealthPlanId				varchar(15)				NULL,
		Field51cHealthPlanId				varchar(15)				NULL,
		Field52aReleaseOfInformation		varchar(1)				NULL,
		Field52bReleaseOfInformation		varchar(1)				NULL,
		Field52cReleaseOfInformation		varchar(1)				NULL,
		Field53aAssignmentOfBenefits		varchar(1)				NULL,
		Field53bAssignmentOfBenefits		varchar(1)				NULL,
		Field53cAssignmentOfBenefits		varchar(1)				NULL,
		Field54aPriorPaymentsWhole			varchar(6)				NULL,
		Field54aPriorPaymentsDecimal		varchar(6)				NULL,
		Field54bPriorPaymentsWhole			varchar(6)				NULL,
		Field54bPriorPaymentsDecimal		varchar(6)				NULL,
		Field54cPriorPaymentsWhole			varchar(6)				NULL,
		Field54cPriorPaymentsDecimal		varchar(6)				NULL,
		Field55aEstimatedAmountWhole		varchar(6)				NULL,
		Field55aEstimatedAmountDecimal		varchar(6)				NULL,
		Field55bEstimatedAmountWhole		varchar(6)				NULL,
		Field55bEstimatedAmountDecimal		varchar(6)				NULL,
		Field55cEstimatedAmountWhole		varchar(6)				NULL,
		Field55cEstimatedAmountDecimal		varchar(6)				NULL,
		Field56FacilityNPI					varchar(15)				NULL,
		Field57aOtherProviderId				varchar(15)				NULL,
		Field57bOtherProviderId				varchar(15)				NULL,
		Field57cOtherProviderId				varchar(15)				NULL,
		Field58aInsuredName					varchar(25)				NULL,
		Field58bInsuredName					varchar(25)				NULL,
		Field58cInsuredName					varchar(25)				NULL,
		Field59aPatientRelationship			varchar(2)				NULL,
		Field59bPatientRelationship			varchar(2)				NULL,
		Field59cPatientRelationship			varchar(2)				NULL,
		Field60aInsuredId					varchar(20)				NULL,
		Field60bInsuredId					varchar(20)				NULL,
		Field60cInsuredId					varchar(20)				NULL,
		Field61aGroupName					varchar(14)				NULL,
		Field61bGroupName					varchar(14)				NULL,
		Field61cGroupName					varchar(14)				NULL,
		Field62aGroupNumber					varchar(17)				NULL,
		Field62bGroupNumber					varchar(17)				NULL,
		Field62cGroupNumber					varchar(17)				NULL,
		Field63aAuthorizationCode			varchar(30)				NULL,
		Field63bAuthorizationCode			varchar(30)				NULL,
		Field63cAuthorizationCode			varchar(30)				NULL,
		Field64aDocumentControlNumber		varchar(26)				NULL,
		Field64bDocumentControlNumber		varchar(26)				NULL,
		Field64cDocumentControlNumber		varchar(26)				NULL,
		Field65aEmployerName				varchar(25)				NULL,
		Field65bEmployerName				varchar(25)				NULL,
		Field65cEmployerName				varchar(25)				NULL,
		Field66DiagnosisVersion				varchar(1)				NULL,
		Field67PrincipalDiagnosis			varchar(8)				NULL,
		Field67POA							varchar(1)				NULL,
		Field67aOtherDiagnosis				varchar(8)				NULL,
		Field67aPOA							varchar(1)				NULL,
		Field67bOtherDiagnosis				varchar(8)				NULL,
		Field67bPOA							varchar(1)				NULL,
		Field67cOtherDiagnosis				varchar(8)				NULL,
		Field67cPOA							varchar(1)				NULL,
		Field67dOtherDiagnosis				varchar(8)				NULL,
		Field67dPOA							varchar(1)				NULL,
		Field67eOtherDiagnosis				varchar(8)				NULL,
		Field67ePOA							varchar(1)				NULL,
		Field67fOtherDiagnosis				varchar(8)				NULL,
		Field67fPOA							varchar(1)				NULL,
		Field67gOtherDiagnosis				varchar(8)				NULL,
		Field67gPOA							varchar(1)				NULL,
		Field67hOtherDiagnosis				varchar(8)				NULL,
		Field67hPOA							varchar(1)				NULL,
		Field67iOtherDiagnosis				varchar(8)				NULL,
		Field67iPOA							varchar(1)				NULL,
		Field67jOtherDiagnosis				varchar(8)				NULL,
		Field67jPOA							varchar(1)				NULL,
		Field67kOtherDiagnosis				varchar(8)				NULL,
		Field67kPOA							varchar(1)				NULL,
		Field67lOtherDiagnosis				varchar(8)				NULL,
		Field67lPOA							varchar(1)				NULL,
		Field67mOtherDiagnosis				varchar(8)				NULL,
		Field67mPOA							varchar(1)				NULL,
		Field67nOtherDiagnosis				varchar(8)				NULL,
		Field67nPOA							varchar(1)				NULL,
		Field67oOtherDiagnosis				varchar(8)				NULL,
		Field67oPOA							varchar(1)				NULL,
		Field67pOtherDiagnosis				varchar(8)				NULL,
		Field67pPOA							varchar(1)				NULL,
		Field67qOtherDiagnosis				varchar(8)				NULL,
		Field67qPOA							varchar(1)				NULL,
		Field68aUnlabelled					varchar(8)				NULL,
		Field68bUnlabelled					varchar(9)				NULL,
		Field69AdmittingDiagnosis			varchar(8)				NULL,
		Field70aReasonForVisitCode			varchar(7)				NULL,
		Field70bReasonForVisitCode			varchar(7)				NULL,
		Field70cReasonForVisitCode			varchar(7)				NULL,
		Field71PPSCode						varchar(3)				NULL,
		Field72aECICode						varchar(8)				NULL,
		Field72bECICode						varchar(8)				NULL,
		Field72cECICode						varchar(8)				NULL,
		Field73Unlabelled					varchar(9)				NULL,
		Field74PrincipalProcedureCode		varchar(7)				NULL,
		Field74PrincipalProcedureDate		varchar(10)				NULL,
		Field74aOtherProcedureCode			varchar(7)				NULL,
		Field74aOtherProcedureDate			varchar(10)				NULL,
		Field74bOtherProcedureCode			varchar(7)				NULL,
		Field74bOtherProcedureDate			varchar(10)				NULL,
		Field74cOtherProcedureCode			varchar(7)				NULL,
		Field74cOtherProcedureDate			varchar(10)				NULL,
		Field74dOtherProcedureCode			varchar(7)				NULL,
		Field74dOtherProcedureDate			varchar(10)				NULL,
		Field74eOtherProcedureCode			varchar(7)				NULL,
		Field74eOtherProcedureDate			varchar(10)				NULL,
		Field75aUnlabelled					varchar(4)				NULL,
		Field75bUnlabelled					varchar(4)				NULL,
		Field75cUnlabelled					varchar(4)				NULL,
		Field75dUnlabelled					varchar(4)				NULL,
		Field76AttendingNPI					varchar(15)				NULL,
		Field76AttendingQualifier			varchar(2)				NULL,
		Field76AttendingProviderId			varchar(9)				NULL,
		Field76AttendingLastName			varchar(16)				NULL,
		Field76AttendingFirstName			varchar(12)				NULL,
		Field77OperatingNPI					varchar(15)				NULL,
		Field77OperatingQualifier			varchar(2)				NULL,
		Field77OperatingProviderId			varchar(9)				NULL,
		Field77OperatingLastName			varchar(16)				NULL,
		Field77OperatingFirstName			varchar(12)				NULL,
		Field78OtherType					varchar(2)				NULL,
		Field78OtherNPI						varchar(15)				NULL,
		Field78OtherQualifier				varchar(2)				NULL,
		Field78OtherProviderId				varchar(9)				NULL,
		Field78OtherLastName				varchar(16)				NULL,
		Field78OtherFirstName				varchar(12)				NULL,
		Field79OtherType					varchar(2)				NULL,
		Field79OtherNPI						varchar(15)				NULL,
		Field79OtherQualifier				varchar(2)				NULL,
		Field79OtherProviderId				varchar(9)				NULL,
		Field79OtherLastName				varchar(16)				NULL,
		Field79OtherFirstName				varchar(12)				NULL,
		Field80aRemarks						varchar(19)				NULL,
		Field80bRemarks						varchar(24)				NULL,
		Field80cRemarks						varchar(24)				NULL,
		Field80dRemarks						varchar(24)				NULL,
		Field81aQualifier					varchar(2)				NULL,
		Field81aCode						varchar(10)				NULL,
		Field81aValue						varchar(12)				NULL,
		Field81bQualifier					varchar(2)				NULL,
		Field81bCode						varchar(10)				NULL,
		Field81bValue						varchar(12)				NULL,
		Field81cQualifier					varchar(2)				NULL,
		Field81cCode						varchar(10)				NULL,
		Field81cValue						varchar(12)				NULL,
		Field81dQualifier					varchar(2)				NULL,
		Field81dCode						varchar(10)				NULL,
		Field81dValue						varchar(12)				NULL,	
		PageNumber							int						NULL,					
		CONSTRAINT ClaimUB04s_PK PRIMARY KEY CLUSTERED (ClaimUB04Id) 
		)


IF OBJECT_ID('ClaimUB04s') IS NOT NULL
    PRINT '<<< CREATED TABLE ClaimUB04s >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ClaimUB04s >>>', 16, 1)


/* 
 * TABLE: ClaimUB04s 
  */



ALTER TABLE ClaimUB04s ADD CONSTRAINT ClaimLineItemGroups_ClaimUB04s_FK 
FOREIGN KEY (ClaimLineItemGroupId)
REFERENCES ClaimLineItemGroups(ClaimLineItemGroupId)

PRINT 'STEP 4 COMPLETED'

END
--END Of STEP 4

------ STEP 5 ----------------
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN
INSERT INTO [ClaimUB04s]
             ( [CreatedBy]
			  ,[CreatedDate]
			  ,[ModifiedBy]
			  ,[ModifiedDate]
			  ,[RecordDeleted]
			  ,[DeletedDate]
			  ,[DeletedBy]
			  ,[ClaimLineItemGroupId]
			  ,[PageNumber]
			  ,[Field1ProviderName]
			  ,[FieldProviderAddress]
			  ,[FieldProviderCityStateZip]
			  ,[FieldProviderTelephoneFax]
			  ,[Field2PayToName]
			  ,[Field2PayToAddress]
			  ,[Field2PayToCityState]
			  ,[Field3aPatientControlNumber]
			  ,[Field3bMedicalRecordNumber]
			  ,[Field4TypeOfBill]
			  ,[Field5TaxIdType]
			  ,[Field5TaxId]
			  ,[Field6StatementFrom]
			  ,[Field6StatementTo]
			  ,[Field7Unlabelled]
			  ,[Field8aPatientId]
			  ,[Field8bPatientName]
			  ,[Field9aPatientAddress]
			  ,[Field9bCity]
			  ,[Field9cState]
			  ,[Field9dZip]
			  ,[Field9eCountryCode]
			  ,[Field10PatientDOB]
			  ,[Field11PatientSex]
			  ,[Field12AdmissionDate]
			  ,[Field13AdmissionHour]
			  ,[Field14AdmissionType]
			  ,[Field15AdmissionSource]
			  ,[Field16DischargeHour]
			  ,[Field17DischargeStatus]
			  ,[Field18ConditionCode]
			  ,[Field19ConditionCode]
			  ,[Field20ConditionCode]
			  ,[Field21ConditionCode]
			  ,[Field22ConditionCode]
			  ,[Field23ConditionCode]
			  ,[Field24ConditionCode]
			  ,[Field25ConditionCode]
			  ,[Field26ConditionCode]
			  ,[Field27ConditionCode]
			  ,[Field28ConditionCode]
			  ,[Field29AccidentState]
			  ,[Field30aUnlabelled]
			  ,[Field30bUnlabelled]
			  ,[Field31aOccurenceCode]				
			  ,[Field31aOccurenceDate]				
			  ,[Field31bOccurenceCode]				
			  ,[Field31bOccurenceDate]				
			  ,[Field32aOccurenceCode]				
			  ,[Field32aOccurenceDate]				
			  ,[Field32bOccurenceCode]				
			  ,[Field32bOccurenceDate]				
			  ,[Field33aOccurenceCode]				
			  ,[Field33aOccurenceDate]
			  ,[Field33bOccurenceCode]				
			  ,[Field33bOccurenceDate]					
			  ,[Field34aOccurenceCode]				
			  ,[Field34aOccurenceDate]				
			  ,[Field34bOccurenceCode]				
			  ,[Field34bOccurenceDate]				
			  ,[Field35aOccuranceCode]
			  ,[Field35aOccuranceFrom]
			  ,[Field35aOccuranceTo]
			  ,[Field35bOccuranceCode]
			  ,[Field35bOccuranceFrom]
			  ,[Field35bOccuranceTo]
			  ,[Field36aOccuranceCode]
			  ,[Field36aOccuranceFrom]
			  ,[Field36aOccuranceTo]
			  ,[Field36bOccuranceCode]
			  ,[Field36bOccuranceFrom]
			  ,[Field36bOccuranceTo]
			  ,[Field37aUnlabelled]
			  ,[Field37bUnlabelled]
			  ,[Field38ResponsibleAddress1]
			  ,[Field38ResponsibleAddress2]
			  ,[Field38ResponsibleAddress3]
			  ,[Field38ResponsibleAddress4]
			  ,[Field38ResponsibleAddress5]
			  ,[Field39aValueCode]
			  ,[Field39aValueAmountWhole]
			  ,[Field39aValueDecimal]
			  ,[Field39bValueCode]
			  ,[Field39bValueAmountWhole]
			  ,[Field39bValueDecimal]
			  ,[Field39cValueCode]
			  ,[Field39cValueAmountWhole]
			  ,[Field39cValueDecimal]
			  ,[Field39dValueCode]
			  ,[Field39dValueAmountWhole]
			  ,[Field39dValueDecimal]
			  ,[Field40aValueCode]
			  ,[Field40aValueAmountWhole]
			  ,[Field40aValueDecimal]
			  ,[Field40bValueCode]
			  ,[Field40bValueAmountWhole]
			  ,[Field40bValueDecimal]
			  ,[Field40cValueCode]
			  ,[Field40cValueAmountWhole]
			  ,[Field40cValueDecimal]
			  ,[Field40dValueCode]
			  ,[Field40dValueAmountWhole]
			  ,[Field40dValueDecimal]
			  ,[Field41aValueCode]
			  ,[Field41aValueAmountWhole]
			  ,[Field41aValueDecimal]
			  ,[Field41bValueCode]
			  ,[Field41bValueAmountWhole]
			  ,[Field41bValueDecimal]
			  ,[Field41cValueCode]
			  ,[Field41cValueAmountWhole]
			  ,[Field41cValueDecimal]
			  ,[Field41dValueCode]
			  ,[Field41dValueAmountWhole]
			  ,[Field41dValueDecimal]
			  ,[Field42RevenueCode1]
			  ,[Field43RevenueDescription1]
			  ,[Field44HCPCSCode1]
			  ,[Field45ServiceDate1]
			  ,[Field46ServiceUnits1]
			  ,[Field47TotalChargesWhole1]
			  ,[Field47TotalChargesDecimal1]
			  ,[Field48NonCoveredChargesWhole1]
			  ,[Field48NonCoveredChargesDecimal1]
			  ,[Field49Unlabelled1]
			  ,[Field42RevenueCode2]
			  ,[Field43RevenueDescription2]
			  ,[Field44HCPCSCode2]
			  ,[Field45ServiceDate2]
			  ,[Field46ServiceUnits2]
			  ,[Field47TotalChargesWhole2]
			  ,[Field47TotalChargesDecimal2]
			  ,[Field48NonCoveredChargesWhole2]
			  ,[Field48NonCoveredChargesDecimal2]
			  ,[Field49Unlabelled2]
			  ,[Field42RevenueCode3]
			  ,[Field43RevenueDescription3]
			  ,[Field44HCPCSCode3]
			  ,[Field45ServiceDate3]
			  ,[Field46ServiceUnits3]
			  ,[Field47TotalChargesWhole3]
			  ,[Field47TotalChargesDecimal3]
			  ,[Field48NonCoveredChargesWhole3]
			  ,[Field48NonCoveredChargesDecimal3]
			  ,[Field49Unlabelled3]
			  ,[Field42RevenueCode4]
			  ,[Field43RevenueDescription4]
			  ,[Field44HCPCSCode4]
			  ,[Field45ServiceDate4]
			  ,[Field46ServiceUnits4]
			  ,[Field47TotalChargesWhole4]
			  ,[Field47TotalChargesDecimal4]
			  ,[Field48NonCoveredChargesWhole4]
			  ,[Field48NonCoveredChargesDecimal4]
			  ,[Field49Unlabelled4]
			  ,[Field42RevenueCode5]
			  ,[Field43RevenueDescription5]
			  ,[Field44HCPCSCode5]
			  ,[Field45ServiceDate5]
			  ,[Field46ServiceUnits5]
			  ,[Field47TotalChargesWhole5]
			  ,[Field47TotalChargesDecimal5]
			  ,[Field48NonCoveredChargesWhole5]
			  ,[Field48NonCoveredChargesDecimal5]
			  ,[Field49Unlabelled5]
			  ,[Field42RevenueCode6]
			  ,[Field43RevenueDescription6]
			  ,[Field44HCPCSCode6]
			  ,[Field45ServiceDate6]
			  ,[Field46ServiceUnits6]
			  ,[Field47TotalChargesWhole6]
			  ,[Field47TotalChargesDecimal6]
			  ,[Field48NonCoveredChargesWhole6]
			  ,[Field48NonCoveredChargesDecimal6]
			  ,[Field49Unlabelled6]
			  ,[Field42RevenueCode7]
			  ,[Field43RevenueDescription7]
			  ,[Field44HCPCSCode7]
			  ,[Field45ServiceDate7]
			  ,[Field46ServiceUnits7]
			  ,[Field47TotalChargesWhole7]
			  ,[Field47TotalChargesDecimal7]
			  ,[Field48NonCoveredChargesWhole7]
			  ,[Field48NonCoveredChargesDecimal7]
			  ,[Field49Unlabelled7]
			  ,[Field42RevenueCode8]
			  ,[Field43RevenueDescription8]
			  ,[Field44HCPCSCode8]
			  ,[Field45ServiceDate8]
			  ,[Field46ServiceUnits8]
			  ,[Field47TotalChargesWhole8]
			  ,[Field47TotalChargesDecimal8]
			  ,[Field48NonCoveredChargesWhole8]
			  ,[Field48NonCoveredChargesDecimal8]
			  ,[Field49Unlabelled8]
			  ,[Field42RevenueCode9]
			  ,[Field43RevenueDescription9]
			  ,[Field44HCPCSCode9]
			  ,[Field45ServiceDate9]
			  ,[Field46ServiceUnits9]
			  ,[Field47TotalChargesWhole9]
			  ,[Field47TotalChargesDecimal9]
			  ,[Field48NonCoveredChargesWhole9]
			  ,[Field48NonCoveredChargesDecimal9]
			  ,[Field49Unlabelled9]
			  ,[Field42RevenueCode10]
			  ,[Field43RevenueDescription10]
			  ,[Field44HCPCSCode10]
			  ,[Field45ServiceDate10]
			  ,[Field46ServiceUnits10]
			  ,[Field47TotalChargesWhole10]
			  ,[Field47TotalChargesDecimal10]
			  ,[Field48NonCoveredChargesWhole10]
			  ,[Field48NonCoveredChargesDecimal10]
			  ,[Field49Unlabelled10]
			  ,[Field42RevenueCode11]
			  ,[Field43RevenueDescription11]
			  ,[Field44HCPCSCode11]
			  ,[Field45ServiceDate11]
			  ,[Field46ServiceUnits11]
			  ,[Field47TotalChargesWhole11]
			  ,[Field47TotalChargesDecimal11]
			  ,[Field48NonCoveredChargesWhole11]
			  ,[Field48NonCoveredChargesDecimal11]
			  ,[Field49Unlabelled11]
			  ,[Field42RevenueCode12]
			  ,[Field43RevenueDescription12]
			  ,[Field44HCPCSCode12]
			  ,[Field45ServiceDate12]
			  ,[Field46ServiceUnits12]
			  ,[Field47TotalChargesWhole12]
			  ,[Field47TotalChargesDecimal12]
			  ,[Field48NonCoveredChargesWhole12]
			  ,[Field48NonCoveredChargesDecimal12]
			  ,[Field49Unlabelled12]
			  ,[Field42RevenueCode13]
			  ,[Field43RevenueDescription13]
			  ,[Field44HCPCSCode13]
			  ,[Field45ServiceDate13]
			  ,[Field46ServiceUnits13]
			  ,[Field47TotalChargesWhole13]
			  ,[Field47TotalChargesDecimal13]
			  ,[Field48NonCoveredChargesWhole13]
			  ,[Field48NonCoveredChargesDecimal13]
			  ,[Field49Unlabelled13]
			  ,[Field42RevenueCode14]
			  ,[Field43RevenueDescription14]
			  ,[Field44HCPCSCode14]
			  ,[Field45ServiceDate14]
			  ,[Field46ServiceUnits14]
			  ,[Field47TotalChargesWhole14]
			  ,[Field47TotalChargesDecimal14]
			  ,[Field48NonCoveredChargesWhole14]
			  ,[Field48NonCoveredChargesDecimal14]
			  ,[Field49Unlabelled14]
			  ,[Field42RevenueCode15]
			  ,[Field43RevenueDescription15]
			  ,[Field44HCPCSCode15]
			  ,[Field45ServiceDate15]
			  ,[Field46ServiceUnits15]
			  ,[Field47TotalChargesWhole15]
			  ,[Field47TotalChargesDecimal15]
			  ,[Field48NonCoveredChargesWhole15]
			  ,[Field48NonCoveredChargesDecimal15]
			  ,[Field49Unlabelled15]
			  ,[Field42RevenueCode16]
			  ,[Field43RevenueDescription16]
			  ,[Field44HCPCSCode16]
			  ,[Field45ServiceDate16]
			  ,[Field46ServiceUnits16]
			  ,[Field47TotalChargesWhole16]
			  ,[Field47TotalChargesDecimal16]
			  ,[Field48NonCoveredChargesWhole16]
			  ,[Field48NonCoveredChargesDecimal16]
			  ,[Field49Unlabelled16]
			  ,[Field42RevenueCode17]
			  ,[Field43RevenueDescription17]
			  ,[Field44HCPCSCode17]
			  ,[Field45ServiceDate17]
			  ,[Field46ServiceUnits17]
			  ,[Field47TotalChargesWhole17]
			  ,[Field47TotalChargesDecimal17]
			  ,[Field48NonCoveredChargesWhole17]
			  ,[Field48NonCoveredChargesDecimal17]
			  ,[Field49Unlabelled17]
			  ,[Field42RevenueCode18]
			  ,[Field43RevenueDescription18]
			  ,[Field44HCPCSCode18]
			  ,[Field45ServiceDate18]
			  ,[Field46ServiceUnits18]
			  ,[Field47TotalChargesWhole18]
			  ,[Field47TotalChargesDecimal18]
			  ,[Field48NonCoveredChargesWhole18]
			  ,[Field48NonCoveredChargesDecimal18]
			  ,[Field49Unlabelled18]
			  ,[Field42RevenueCode19]
			  ,[Field43RevenueDescription19]
			  ,[Field44HCPCSCode19]
			  ,[Field45ServiceDate19]
			  ,[Field46ServiceUnits19]
			  ,[Field47TotalChargesWhole19]
			  ,[Field47TotalChargesDecimal19]
			  ,[Field48NonCoveredChargesWhole19]
			  ,[Field48NonCoveredChargesDecimal19]
			  ,[Field49Unlabelled19]
			  ,[Field42RevenueCode20]
			  ,[Field43RevenueDescription20]
			  ,[Field44HCPCSCode20]
			  ,[Field45ServiceDate20]
			  ,[Field46ServiceUnits20]
			  ,[Field47TotalChargesWhole20]
			  ,[Field47TotalChargesDecimal20]
			  ,[Field48NonCoveredChargesWhole20]
			  ,[Field48NonCoveredChargesDecimal20]
			  ,[Field49Unlabelled20]
			  ,[Field42RevenueCode21]
			  ,[Field43RevenueDescription21]
			  ,[Field44HCPCSCode21]
			  ,[Field45ServiceDate21]
			  ,[Field46ServiceUnits21]
			  ,[Field47TotalChargesWhole21]
			  ,[Field47TotalChargesDecimal21]
			  ,[Field48NonCoveredChargesWhole21]
			  ,[Field48NonCoveredChargesDecimal21]
			  ,[Field49Unlabelled21]
			  ,[Field42RevenueCode22]
			  ,[Field43RevenueDescription22]
			  ,[Field44HCPCSCode22]
			  ,[Field45ServiceDate22]
			  ,[Field46ServiceUnits22]
			  ,[Field47TotalChargesWhole22]
			  ,[Field47TotalChargesDecimal22]
			  ,[Field48NonCoveredChargesWhole22]
			  ,[Field48NonCoveredChargesDecimal22]
			  ,[Field49Unlabelled22]
			  ,[Field43PageNumber]
			  ,[Field43PageOf]
			  ,[Field44CreationDate]
			  ,[Field47TotalChargesWhole23]
			  ,[Field47TotalChargesDecimal23]
			  ,[Field48NonCoveredChargesWhole23]
			  ,[Field48NonCoveredChargesDecimal23]
			  ,[Field50aPayerName]
			  ,[Field50bPayerName]
			  ,[Field50cPayerName]
			  ,[Field51aHealthPlanId]
			  ,[Field51bHealthPlanId]
			  ,[Field51cHealthPlanId]
			  ,[Field52aReleaseOfInformation]
			  ,[Field52bReleaseOfInformation]
			  ,[Field52cReleaseOfInformation]
			  ,[Field53aAssignmentOfBenefits]
			  ,[Field53bAssignmentOfBenefits]
			  ,[Field53cAssignmentOfBenefits]
			  ,[Field54aPriorPaymentsWhole]
			  ,[Field54aPriorPaymentsDecimal]
			  ,[Field54bPriorPaymentsWhole]
			  ,[Field54bPriorPaymentsDecimal]
			  ,[Field54cPriorPaymentsWhole]
			  ,[Field54cPriorPaymentsDecimal]
			  ,[Field55aEstimatedAmountWhole]
			  ,[Field55aEstimatedAmountDecimal]
			  ,[Field55bEstimatedAmountWhole]
			  ,[Field55bEstimatedAmountDecimal]
			  ,[Field55cEstimatedAmountWhole]
			  ,[Field55cEstimatedAmountDecimal]
			  ,[Field56FacilityNPI]
			  ,[Field57aOtherProviderId]
			  ,[Field57bOtherProviderId]
			  ,[Field57cOtherProviderId]
			  ,[Field58aInsuredName]
			  ,[Field58bInsuredName]
			  ,[Field58cInsuredName]
			  ,[Field59aPatientRelationship]
			  ,[Field59bPatientRelationship]
			  ,[Field59cPatientRelationship]
			  ,[Field60aInsuredId]
			  ,[Field60bInsuredId]
			  ,[Field60cInsuredId]
			  ,[Field61aGroupName]
			  ,[Field61bGroupName]
			  ,[Field61cGroupName]
			  ,[Field62aGroupNumber]
			  ,[Field62bGroupNumber]
			  ,[Field62cGroupNumber]
			  ,[Field63aAuthorizationCode]
			  ,[Field63bAuthorizationCode]
			  ,[Field63cAuthorizationCode]
			  ,[Field64aDocumentControlNumber]
			  ,[Field64bDocumentControlNumber]
			  ,[Field64cDocumentControlNumber]
			  ,[Field65aEmployerName]
			  ,[Field65bEmployerName]
			  ,[Field65cEmployerName]
			  ,[Field66DiagnosisVersion]
			  ,[Field67PrincipalDiagnosis]
			  ,[Field67POA]
			  ,[Field67aOtherDiagnosis]
			  ,[Field67aPOA]
			  ,[Field67bOtherDiagnosis]
			  ,[Field67bPOA]
			  ,[Field67cOtherDiagnosis]
			  ,[Field67cPOA]
			  ,[Field67dOtherDiagnosis]
			  ,[Field67dPOA]
			  ,[Field67eOtherDiagnosis]
			  ,[Field67ePOA]
			  ,[Field67fOtherDiagnosis]
			  ,[Field67fPOA]
			  ,[Field67gOtherDiagnosis]
			  ,[Field67gPOA]
			  ,[Field67hOtherDiagnosis]
			  ,[Field67hPOA]
			  ,[Field67iOtherDiagnosis]
			  ,[Field67iPOA]
			  ,[Field67jOtherDiagnosis]
			  ,[Field67jPOA]
			  ,[Field67kOtherDiagnosis]
			  ,[Field67kPOA]
			  ,[Field67lOtherDiagnosis]
			  ,[Field67lPOA]
			  ,[Field67mOtherDiagnosis]
			  ,[Field67mPOA]
			  ,[Field67nOtherDiagnosis]
			  ,[Field67nPOA]
			  ,[Field67oOtherDiagnosis]
			  ,[Field67oPOA]
			  ,[Field67pOtherDiagnosis]
			  ,[Field67pPOA]
			  ,[Field67qOtherDiagnosis]
			  ,[Field67qPOA]
			  ,[Field68aUnlabelled]
			  ,[Field68bUnlabelled]
			  ,[Field69AdmittingDiagnosis]
			  ,[Field70aReasonForVisitCode]
			  ,[Field70bReasonForVisitCode]
			  ,[Field70cReasonForVisitCode]
			  ,[Field71PPSCode]
			  ,[Field72aECICode]
			  ,[Field72bECICode]
			  ,[Field72cECICode]
			  ,[Field73Unlabelled]
			  ,[Field74PrincipalProcedureCode]
			  ,[Field74PrincipalProcedureDate]
			  ,[Field74aOtherProcedureCode]
			  ,[Field74aOtherProcedureDate]
			  ,[Field74bOtherProcedureCode]
			  ,[Field74bOtherProcedureDate]
			  ,[Field74cOtherProcedureCode]
			  ,[Field74cOtherProcedureDate]
			  ,[Field74dOtherProcedureCode]
			  ,[Field74dOtherProcedureDate]
			  ,[Field74eOtherProcedureCode]
			  ,[Field74eOtherProcedureDate]
			  ,[Field75aUnlabelled]
			  ,[Field75bUnlabelled]
			  ,[Field75cUnlabelled]
			  ,[Field75dUnlabelled]
			  ,[Field76AttendingNPI]
			  ,[Field76AttendingQualifier]
			  ,[Field76AttendingProviderId]
			  ,[Field76AttendingLastName]
			  ,[Field76AttendingFirstName]
			  ,[Field77OperatingNPI]
			  ,[Field77OperatingQualifier]
			  ,[Field77OperatingProviderId]
			  ,[Field77OperatingLastName]
			  ,[Field77OperatingFirstName]
			  ,[Field78OtherType]
			  ,[Field78OtherNPI]
			  ,[Field78OtherQualifier]
			  ,[Field78OtherProviderId]
			  ,[Field78OtherLastName]
			  ,[Field78OtherFirstName]
			  ,[Field79OtherType]
			  ,[Field79OtherNPI]
			  ,[Field79OtherQualifier]
			  ,[Field79OtherProviderId]
			  ,[Field79OtherLastName]
			  ,[Field79OtherFirstName]
			  ,[Field80aRemarks]
			  ,[Field80bRemarks]
			  ,[Field80cRemarks]
			  ,[Field80dRemarks]
			  ,[Field81aQualifier]
			  ,[Field81aCode]
			  ,[Field81aValue]
			  ,[Field81bQualifier]
			  ,[Field81bCode]
			  ,[Field81bValue]
			  ,[Field81cQualifier]
			  ,[Field81cCode]
			  ,[Field81cValue]
			  ,[Field81dQualifier]
			  ,[Field81dCode]
			  ,[Field81dValue]			 
			  )
     SELECT    [CreatedBy]
			  ,[CreatedDate]
			  ,[ModifiedBy]
			  ,[ModifiedDate]
			  ,[RecordDeleted]
			  ,[DeletedDate]
			  ,[DeletedBy]
			  ,[ClaimLineItemGroupId]
			  ,[PageNumber]
			  ,[Field1ProviderName]
			  ,[FieldProviderAddress]
			  ,[FieldProviderCityStateZip]
			  ,[FieldProviderTelephoneFax]
			  ,[Field2PayToName]
			  ,[Field2PayToAddress]
			  ,[Field2PayToCityState]
			  ,[Field3aPatientControlNumber]
			  ,[Field3bMedicalRecordNumber]
			  ,[Field4TypeOfBill]
			  ,[Field5TaxIdType]
			  ,[Field5TaxId]
			  ,[Field6StatementFrom]
			  ,[Field6StatementTo]
			  ,[Field7Unlabelled]
			  ,[Field8aPatientId]
			  ,[Field8bPatientName]
			  ,[Field9aPatientAddress]
			  ,[Field9bCity]
			  ,[Field9cState]
			  ,[Field9dZip]
			  ,[Field9eCountryCode]
			  ,[Field10PatientDOB]
			  ,[Field11PatientSex]
			  ,[Field12AdmissionDate]
			  ,[Field13AdmissionHour]
			  ,[Field14AdmissionType]
			  ,[Field15AdmissionSource]
			  ,[Field16DischargeHour]
			  ,[Field17DischargeStatus]
			  ,[Field18ConditionCode]
			  ,[Field19ConditionCode]
			  ,[Field20ConditionCode]
			  ,[Field21ConditionCode]
			  ,[Field22ConditionCode]
			  ,[Field23ConditionCode]
			  ,[Field24ConditionCode]
			  ,[Field25ConditionCode]
			  ,[Field26ConditionCode]
			  ,[Field27ConditionCode]
			  ,[Field28ConditionCode]
			  ,[Field29AccidentState]
			  ,[Field30aUnlabelled]
			  ,[Field30bUnlabelled]
			  ,[Field31aOccurenceCode]				
			  ,[Field31aOccurenceDate]				
			  ,[Field31bOccurenceCode]				
			  ,[Field31bOccurenceDate]				
			  ,[Field32aOccurenceCode]				
			  ,[Field32aOccurenceDate]				
			  ,[Field32bOccurenceCode]				
			  ,[Field32bOccurenceDate]				
			  ,[Field33aOccurenceCode]				
			  ,[Field33aOccurenceDate]
			  ,[Field33bOccurenceCode]				
			  ,[Field33bOccurenceDate]					
			  ,[Field34aOccurenceCode]				
			  ,[Field34aOccurenceDate]				
			  ,[Field34bOccurenceCode]				
			  ,[Field34bOccurenceDate]				
			  ,[Field35aOccuranceCode]
			  ,[Field35aOccuranceFrom]
			  ,[Field35aOccuranceTo]
			  ,[Field35bOccuranceCode]
			  ,[Field35bOccuranceFrom]
			  ,[Field35bOccuranceTo]
			  ,[Field36aOccuranceCode]
			  ,[Field36aOccuranceFrom]
			  ,[Field36aOccuranceTo]
			  ,[Field36bOccuranceCode]
			  ,[Field36bOccuranceFrom]
			  ,[Field36bOccuranceTo]
			  ,[Field37aUnlabelled]
			  ,[Field37bUnlabelled]
			  ,[Field38ResponsibleAddress1]
			  ,[Field38ResponsibleAddress2]
			  ,[Field38ResponsibleAddress3]
			  ,[Field38ResponsibleAddress4]
			  ,[Field38ResponsibleAddress5]
			  ,[Field39aValueCode]
			  ,[Field39aValueAmountWhole]
			  ,[Field39aValueDecimal]
			  ,[Field39bValueCode]
			  ,[Field39bValueAmountWhole]
			  ,[Field39bValueDecimal]
			  ,[Field39cValueCode]
			  ,[Field39cValueAmountWhole]
			  ,[Field39cValueDecimal]
			  ,[Field39dValueCode]
			  ,[Field39dValueAmountWhole]
			  ,[Field39dValueDecimal]
			  ,[Field40aValueCode]
			  ,[Field40aValueAmountWhole]
			  ,[Field40aValueDecimal]
			  ,[Field40bValueCode]
			  ,[Field40bValueAmountWhole]
			  ,[Field40bValueDecimal]
			  ,[Field40cValueCode]
			  ,[Field40cValueAmountWhole]
			  ,[Field40cValueDecimal]
			  ,[Field40dValueCode]
			  ,[Field40dValueAmountWhole]
			  ,[Field40dValueDecimal]
			  ,[Field41aValueCode]
			  ,[Field41aValueAmountWhole]
			  ,[Field41aValueDecimal]
			  ,[Field41bValueCode]
			  ,[Field41bValueAmountWhole]
			  ,[Field41bValueDecimal]
			  ,[Field41cValueCode]
			  ,[Field41cValueAmountWhole]
			  ,[Field41cValueDecimal]
			  ,[Field41dValueCode]
			  ,[Field41dValueAmountWhole]
			  ,[Field41dValueDecimal]
			  ,[Field42RevenueCode1]
			  ,[Field43RevenueDescription1]
			  ,[Field44HCPCSCode1]
			  ,[Field45ServiceDate1]
			  ,[Field46ServiceUnits1]
			  ,[Field47TotalChargesWhole1]
			  ,[Field47TotalChargesDecimal1]
			  ,[Field48NonCoveredChargesWhole1]
			  ,[Field48NonCoveredChargesDecimal1]
			  ,[Field49Unlabelled1]
			  ,[Field42RevenueCode2]
			  ,[Field43RevenueDescription2]
			  ,[Field44HCPCSCode2]
			  ,[Field45ServiceDate2]
			  ,[Field46ServiceUnits2]
			  ,[Field47TotalChargesWhole2]
			  ,[Field47TotalChargesDecimal2]
			  ,[Field48NonCoveredChargesWhole2]
			  ,[Field48NonCoveredChargesDecimal2]
			  ,[Field49Unlabelled2]
			  ,[Field42RevenueCode3]
			  ,[Field43RevenueDescription3]
			  ,[Field44HCPCSCode3]
			  ,[Field45ServiceDate3]
			  ,[Field46ServiceUnits3]
			  ,[Field47TotalChargesWhole3]
			  ,[Field47TotalChargesDecimal3]
			  ,[Field48NonCoveredChargesWhole3]
			  ,[Field48NonCoveredChargesDecimal3]
			  ,[Field49Unlabelled3]
			  ,[Field42RevenueCode4]
			  ,[Field43RevenueDescription4]
			  ,[Field44HCPCSCode4]
			  ,[Field45ServiceDate4]
			  ,[Field46ServiceUnits4]
			  ,[Field47TotalChargesWhole4]
			  ,[Field47TotalChargesDecimal4]
			  ,[Field48NonCoveredChargesWhole4]
			  ,[Field48NonCoveredChargesDecimal4]
			  ,[Field49Unlabelled4]
			  ,[Field42RevenueCode5]
			  ,[Field43RevenueDescription5]
			  ,[Field44HCPCSCode5]
			  ,[Field45ServiceDate5]
			  ,[Field46ServiceUnits5]
			  ,[Field47TotalChargesWhole5]
			  ,[Field47TotalChargesDecimal5]
			  ,[Field48NonCoveredChargesWhole5]
			  ,[Field48NonCoveredChargesDecimal5]
			  ,[Field49Unlabelled5]
			  ,[Field42RevenueCode6]
			  ,[Field43RevenueDescription6]
			  ,[Field44HCPCSCode6]
			  ,[Field45ServiceDate6]
			  ,[Field46ServiceUnits6]
			  ,[Field47TotalChargesWhole6]
			  ,[Field47TotalChargesDecimal6]
			  ,[Field48NonCoveredChargesWhole6]
			  ,[Field48NonCoveredChargesDecimal6]
			  ,[Field49Unlabelled6]
			  ,[Field42RevenueCode7]
			  ,[Field43RevenueDescription7]
			  ,[Field44HCPCSCode7]
			  ,[Field45ServiceDate7]
			  ,[Field46ServiceUnits7]
			  ,[Field47TotalChargesWhole7]
			  ,[Field47TotalChargesDecimal7]
			  ,[Field48NonCoveredChargesWhole7]
			  ,[Field48NonCoveredChargesDecimal7]
			  ,[Field49Unlabelled7]
			  ,[Field42RevenueCode8]
			  ,[Field43RevenueDescription8]
			  ,[Field44HCPCSCode8]
			  ,[Field45ServiceDate8]
			  ,[Field46ServiceUnits8]
			  ,[Field47TotalChargesWhole8]
			  ,[Field47TotalChargesDecimal8]
			  ,[Field48NonCoveredChargesWhole8]
			  ,[Field48NonCoveredChargesDecimal8]
			  ,[Field49Unlabelled8]
			  ,[Field42RevenueCode9]
			  ,[Field43RevenueDescription9]
			  ,[Field44HCPCSCode9]
			  ,[Field45ServiceDate9]
			  ,[Field46ServiceUnits9]
			  ,[Field47TotalChargesWhole9]
			  ,[Field47TotalChargesDecimal9]
			  ,[Field48NonCoveredChargesWhole9]
			  ,[Field48NonCoveredChargesDecimal9]
			  ,[Field49Unlabelled9]
			  ,[Field42RevenueCode10]
			  ,[Field43RevenueDescription10]
			  ,[Field44HCPCSCode10]
			  ,[Field45ServiceDate10]
			  ,[Field46ServiceUnits10]
			  ,[Field47TotalChargesWhole10]
			  ,[Field47TotalChargesDecimal10]
			  ,[Field48NonCoveredChargesWhole10]
			  ,[Field48NonCoveredChargesDecimal10]
			  ,[Field49Unlabelled10]
			  ,[Field42RevenueCode11]
			  ,[Field43RevenueDescription11]
			  ,[Field44HCPCSCode11]
			  ,[Field45ServiceDate11]
			  ,[Field46ServiceUnits11]
			  ,[Field47TotalChargesWhole11]
			  ,[Field47TotalChargesDecimal11]
			  ,[Field48NonCoveredChargesWhole11]
			  ,[Field48NonCoveredChargesDecimal11]
			  ,[Field49Unlabelled11]
			  ,[Field42RevenueCode12]
			  ,[Field43RevenueDescription12]
			  ,[Field44HCPCSCode12]
			  ,[Field45ServiceDate12]
			  ,[Field46ServiceUnits12]
			  ,[Field47TotalChargesWhole12]
			  ,[Field47TotalChargesDecimal12]
			  ,[Field48NonCoveredChargesWhole12]
			  ,[Field48NonCoveredChargesDecimal12]
			  ,[Field49Unlabelled12]
			  ,[Field42RevenueCode13]
			  ,[Field43RevenueDescription13]
			  ,[Field44HCPCSCode13]
			  ,[Field45ServiceDate13]
			  ,[Field46ServiceUnits13]
			  ,[Field47TotalChargesWhole13]
			  ,[Field47TotalChargesDecimal13]
			  ,[Field48NonCoveredChargesWhole13]
			  ,[Field48NonCoveredChargesDecimal13]
			  ,[Field49Unlabelled13]
			  ,[Field42RevenueCode14]
			  ,[Field43RevenueDescription14]
			  ,[Field44HCPCSCode14]
			  ,[Field45ServiceDate14]
			  ,[Field46ServiceUnits14]
			  ,[Field47TotalChargesWhole14]
			  ,[Field47TotalChargesDecimal14]
			  ,[Field48NonCoveredChargesWhole14]
			  ,[Field48NonCoveredChargesDecimal14]
			  ,[Field49Unlabelled14]
			  ,[Field42RevenueCode15]
			  ,[Field43RevenueDescription15]
			  ,[Field44HCPCSCode15]
			  ,[Field45ServiceDate15]
			  ,[Field46ServiceUnits15]
			  ,[Field47TotalChargesWhole15]
			  ,[Field47TotalChargesDecimal15]
			  ,[Field48NonCoveredChargesWhole15]
			  ,[Field48NonCoveredChargesDecimal15]
			  ,[Field49Unlabelled15]
			  ,[Field42RevenueCode16]
			  ,[Field43RevenueDescription16]
			  ,[Field44HCPCSCode16]
			  ,[Field45ServiceDate16]
			  ,[Field46ServiceUnits16]
			  ,[Field47TotalChargesWhole16]
			  ,[Field47TotalChargesDecimal16]
			  ,[Field48NonCoveredChargesWhole16]
			  ,[Field48NonCoveredChargesDecimal16]
			  ,[Field49Unlabelled16]
			  ,[Field42RevenueCode17]
			  ,[Field43RevenueDescription17]
			  ,[Field44HCPCSCode17]
			  ,[Field45ServiceDate17]
			  ,[Field46ServiceUnits17]
			  ,[Field47TotalChargesWhole17]
			  ,[Field47TotalChargesDecimal17]
			  ,[Field48NonCoveredChargesWhole17]
			  ,[Field48NonCoveredChargesDecimal17]
			  ,[Field49Unlabelled17]
			  ,[Field42RevenueCode18]
			  ,[Field43RevenueDescription18]
			  ,[Field44HCPCSCode18]
			  ,[Field45ServiceDate18]
			  ,[Field46ServiceUnits18]
			  ,[Field47TotalChargesWhole18]
			  ,[Field47TotalChargesDecimal18]
			  ,[Field48NonCoveredChargesWhole18]
			  ,[Field48NonCoveredChargesDecimal18]
			  ,[Field49Unlabelled18]
			  ,[Field42RevenueCode19]
			  ,[Field43RevenueDescription19]
			  ,[Field44HCPCSCode19]
			  ,[Field45ServiceDate19]
			  ,[Field46ServiceUnits19]
			  ,[Field47TotalChargesWhole19]
			  ,[Field47TotalChargesDecimal19]
			  ,[Field48NonCoveredChargesWhole19]
			  ,[Field48NonCoveredChargesDecimal19]
			  ,[Field49Unlabelled19]
			  ,[Field42RevenueCode20]
			  ,[Field43RevenueDescription20]
			  ,[Field44HCPCSCode20]
			  ,[Field45ServiceDate20]
			  ,[Field46ServiceUnits20]
			  ,[Field47TotalChargesWhole20]
			  ,[Field47TotalChargesDecimal20]
			  ,[Field48NonCoveredChargesWhole20]
			  ,[Field48NonCoveredChargesDecimal20]
			  ,[Field49Unlabelled20]
			  ,[Field42RevenueCode21]
			  ,[Field43RevenueDescription21]
			  ,[Field44HCPCSCode21]
			  ,[Field45ServiceDate21]
			  ,[Field46ServiceUnits21]
			  ,[Field47TotalChargesWhole21]
			  ,[Field47TotalChargesDecimal21]
			  ,[Field48NonCoveredChargesWhole21]
			  ,[Field48NonCoveredChargesDecimal21]
			  ,[Field49Unlabelled21]
			  ,[Field42RevenueCode22]
			  ,[Field43RevenueDescription22]
			  ,[Field44HCPCSCode22]
			  ,[Field45ServiceDate22]
			  ,[Field46ServiceUnits22]
			  ,[Field47TotalChargesWhole22]
			  ,[Field47TotalChargesDecimal22]
			  ,[Field48NonCoveredChargesWhole22]
			  ,[Field48NonCoveredChargesDecimal22]
			  ,[Field49Unlabelled22]
			  ,[Field43PageNumber]
			  ,[Field43PageOf]
			  ,[Field44CreationDate]
			  ,[Field47TotalChargesWhole23]
			  ,[Field47TotalChargesDecimal23]
			  ,[Field48NonCoveredChargesWhole23]
			  ,[Field48NonCoveredChargesDecimal23]
			  ,[Field50aPayerName]
			  ,[Field50bPayerName]
			  ,[Field50cPayerName]
			  ,[Field51aHealthPlanId]
			  ,[Field51bHealthPlanId]
			  ,[Field51cHealthPlanId]
			  ,[Field52aReleaseOfInformation]
			  ,[Field52bReleaseOfInformation]
			  ,[Field52cReleaseOfInformation]
			  ,[Field53aAssignmentOfBenefits]
			  ,[Field53bAssignmentOfBenefits]
			  ,[Field53cAssignmentOfBenefits]
			  ,[Field54aPriorPaymentsWhole]
			  ,[Field54aPriorPaymentsDecimal]
			  ,[Field54bPriorPaymentsWhole]
			  ,[Field54bPriorPaymentsDecimal]
			  ,[Field54cPriorPaymentsWhole]
			  ,[Field54cPriorPaymentsDecimal]
			  ,[Field55aEstimatedAmountWhole]
			  ,[Field55aEstimatedAmountDecimal]
			  ,[Field55bEstimatedAmountWhole]
			  ,[Field55bEstimatedAmountDecimal]
			  ,[Field55cEstimatedAmountWhole]
			  ,[Field55cEstimatedAmountDecimal]
			  ,[Field56FacilityNPI]
			  ,[Field57aOtherProviderId]
			  ,[Field57bOtherProviderId]
			  ,[Field57cOtherProviderId]
			  ,[Field58aInsuredName]
			  ,[Field58bInsuredName]
			  ,[Field58cInsuredName]
			  ,[Field59aPatientRelationship]
			  ,[Field59bPatientRelationship]
			  ,[Field59cPatientRelationship]
			  ,[Field60aInsuredId]
			  ,[Field60bInsuredId]
			  ,[Field60cInsuredId]
			  ,[Field61aGroupName]
			  ,[Field61bGroupName]
			  ,[Field61cGroupName]
			  ,[Field62aGroupNumber]
			  ,[Field62bGroupNumber]
			  ,[Field62cGroupNumber]
			  ,[Field63aAuthorizationCode]
			  ,[Field63bAuthorizationCode]
			  ,[Field63cAuthorizationCode]
			  ,[Field64aDocumentControlNumber]
			  ,[Field64bDocumentControlNumber]
			  ,[Field64cDocumentControlNumber]
			  ,[Field65aEmployerName]
			  ,[Field65bEmployerName]
			  ,[Field65cEmployerName]
			  ,[Field66DiagnosisVersion]
			  ,[Field67PrincipalDiagnosis]
			  ,[Field67POA]
			  ,[Field67aOtherDiagnosis]
			  ,[Field67aPOA]
			  ,[Field67bOtherDiagnosis]
			  ,[Field67bPOA]
			  ,[Field67cOtherDiagnosis]
			  ,[Field67cPOA]
			  ,[Field67dOtherDiagnosis]
			  ,[Field67dPOA]
			  ,[Field67eOtherDiagnosis]
			  ,[Field67ePOA]
			  ,[Field67fOtherDiagnosis]
			  ,[Field67fPOA]
			  ,[Field67gOtherDiagnosis]
			  ,[Field67gPOA]
			  ,[Field67hOtherDiagnosis]
			  ,[Field67hPOA]
			  ,[Field67iOtherDiagnosis]
			  ,[Field67iPOA]
			  ,[Field67jOtherDiagnosis]
			  ,[Field67jPOA]
			  ,[Field67kOtherDiagnosis]
			  ,[Field67kPOA]
			  ,[Field67lOtherDiagnosis]
			  ,[Field67lPOA]
			  ,[Field67mOtherDiagnosis]
			  ,[Field67mPOA]
			  ,[Field67nOtherDiagnosis]
			  ,[Field67nPOA]
			  ,[Field67oOtherDiagnosis]
			  ,[Field67oPOA]
			  ,[Field67pOtherDiagnosis]
			  ,[Field67pPOA]
			  ,[Field67qOtherDiagnosis]
			  ,[Field67qPOA]
			  ,[Field68aUnlabelled]
			  ,[Field68bUnlabelled]
			  ,[Field69AdmittingDiagnosis]
			  ,[Field70aReasonForVisitCode]
			  ,[Field70bReasonForVisitCode]
			  ,[Field70cReasonForVisitCode]
			  ,[Field71PPSCode]
			  ,[Field72aECICode]
			  ,[Field72bECICode]
			  ,[Field72cECICode]
			  ,[Field73Unlabelled]
			  ,[Field74PrincipalProcedureCode]
			  ,[Field74PrincipalProcedureDate]
			  ,[Field74aOtherProcedureCode]
			  ,[Field74aOtherProcedureDate]
			  ,[Field74bOtherProcedureCode]
			  ,[Field74bOtherProcedureDate]
			  ,[Field74cOtherProcedureCode]
			  ,[Field74cOtherProcedureDate]
			  ,[Field74dOtherProcedureCode]
			  ,[Field74dOtherProcedureDate]
			  ,[Field74eOtherProcedureCode]
			  ,[Field74eOtherProcedureDate]
			  ,[Field75aUnlabelled]
			  ,[Field75bUnlabelled]
			  ,[Field75cUnlabelled]
			  ,[Field75dUnlabelled]
			  ,[Field76AttendingNPI]
			  ,[Field76AttendingQualifier]
			  ,[Field76AttendingProviderId]
			  ,[Field76AttendingLastName]
			  ,[Field76AttendingFirstName]
			  ,[Field77OperatingNPI]
			  ,[Field77OperatingQualifier]
			  ,[Field77OperatingProviderId]
			  ,[Field77OperatingLastName]
			  ,[Field77OperatingFirstName]
			  ,[Field78OtherType]
			  ,[Field78OtherNPI]
			  ,[Field78OtherQualifier]
			  ,[Field78OtherProviderId]
			  ,[Field78OtherLastName]
			  ,[Field78OtherFirstName]
			  ,[Field79OtherType]
			  ,[Field79OtherNPI]
			  ,[Field79OtherQualifier]
			  ,[Field79OtherProviderId]
			  ,[Field79OtherLastName]
			  ,[Field79OtherFirstName]
			  ,[Field80aRemarks]
			  ,[Field80bRemarks]
			  ,[Field80cRemarks]
			  ,[Field80dRemarks]
			  ,[Field81aQualifier]
			  ,[Field81aCode]
			  ,[Field81aValue]
			  ,[Field81bQualifier]
			  ,[Field81bCode]
			  ,[Field81bValue]
			  ,[Field81cQualifier]
			  ,[Field81cCode]
			  ,[Field81cValue]
			  ,[Field81dQualifier]
			  ,[Field81dCode]
			  ,[Field81dValue]		 
			FROM [ClaimUB04s_Temp111]

PRINT 'STEP 5 COMPLETED'

END			
GO
-------END STEP 5-------------
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN
	IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_MoveForeignKeyConstraints]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [dbo].[ssp_MoveForeignKeyConstraints]
END
go
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN  
Exec('create proc [dbo].[ssp_MoveForeignKeyConstraints]  
		@FromTable varchar(128), @ToTable varchar(128)  
		as  
  
		create table #temp1  
		(PKTable varchar(128) null,  
		FKTable varchar(128) null,  
		ConstraintName varchar(128) null,  
		Status int null,  
		cKeyCol1 varchar(128) null,  
		cKeyCol2 varchar(128) null,  
		cKeyCol3 varchar(128) null,  
		cKeyCol4 varchar(128) null,  
		cKeyCol5 varchar(128) null,  
		cKeyCol6 varchar(128) null,  
		cKeyCol7 varchar(128) null,  
		cKeyCol8 varchar(128) null,  
		cKeyCol9 varchar(128) null,  
		cKeyCol10 varchar(128) null,  
		cKeyCol11 varchar(128) null,  
		cKeyCol12 varchar(128) null,  
		cKeyCol13 varchar(128) null,  
		cKeyCol14 varchar(128) null,  
		cKeyCol15 varchar(128) null,  
		cKeyCol16 varchar(128) null,  
		cRefCol1 varchar(128) null,  
		cRefCol2 varchar(128) null,  
		cRefCol3 varchar(128) null,  
		cRefCol4 varchar(128) null,  
		cRefCol5 varchar(128) null,  
		cRefCol6 varchar(128) null,  
		cRefCol7 varchar(128) null,  
		cRefCol8 varchar(128) null,  
		cRefCol9 varchar(128) null,  
		cRefCol10 varchar(128) null,  
		cRefCol11 varchar(128) null,  
		cRefCol12 varchar(128) null,  
		cRefCol13 varchar(128) null,  
		cRefCol14 varchar(128) null,  
		cRefCol15 varchar(128) null,  
		cRefCol16 varchar(128) null,  
		PKTableOwner varchar(50) null,  
		FKTableOwner varchar(50) null,  
		DeleteCascade int null,  
		UpdateCascade int null,  
		)  
  
		declare @CreateSQLString varchar(8000)  
		declare @DropSQLString varchar(8000)  
  
		declare @PKTable varchar(128),  
		@FKTable varchar(128),  
		@ConstraintName varchar(128),  
		@Status int,  
		@cKeyCol1 varchar(128),  
		@cKeyCol2 varchar(128),  
		@cKeyCol3 varchar(128),  
		@cKeyCol4 varchar(128),  
		@cKeyCol5 varchar(128),  
		@cKeyCol6 varchar(128),  
		@cKeyCol7 varchar(128),  
		@cKeyCol8 varchar(128),  
		@cKeyCol9 varchar(128),  
		@cKeyCol10 varchar(128),  
		@cKeyCol11 varchar(128),  
		@cKeyCol12 varchar(128),  
		@cKeyCol13 varchar(128),  
		@cKeyCol14 varchar(128),  
		@cKeyCol15 varchar(128),  
		@cKeyCol16 varchar(128),  
		@cRefCol1 varchar(128),  
		@cRefCol2 varchar(128),  
		@cRefCol3 varchar(128),  
		@cRefCol4 varchar(128),  
		@cRefCol5 varchar(128),  
		@cRefCol6 varchar(128),  
		@cRefCol7 varchar(128),  
		@cRefCol8 varchar(128),  
		@cRefCol9 varchar(128),  
		@cRefCol10 varchar(128),  
		@cRefCol11 varchar(128),  
		@cRefCol12 varchar(128),  
		@cRefCol13 varchar(128),  
		@cRefCol14 varchar(128),  
		@cRefCol15 varchar(128),  
		@cRefCol16 varchar(128),  
		@PKTableOwner varchar(50),  
		@FKTableOwner varchar(50),  
		@DeleteCascade int,  
		@UpdateCascade int  
  
		insert into #temp1  
		exec sp_MStablerefs @FromTable, N''actualtables'', N''both'', null   
  
		declare cur_ForeignKeys cursor for  
		select PKTable,  
		FKTable,  
		ConstraintName,  
		Status,  
		cKeyCol1,  
		cKeyCol2,  
		cKeyCol3,  
		cKeyCol4,  
		cKeyCol5,  
		cKeyCol6,  
		cKeyCol7,  
		cKeyCol8,  
		cKeyCol9,  
		cKeyCol10,  
		cKeyCol11,  
		cKeyCol12,  
		cKeyCol13,  
		cKeyCol14,  
		cKeyCol15,  
		cKeyCol16,  
		cRefCol1,  
		cRefCol2,  
		cRefCol3,  
		cRefCol4,  
		cRefCol5,  
		cRefCol6,  
		cRefCol7,  
		cRefCol8,  
		cRefCol9,  
		cRefCol10,  
		cRefCol11,  
		cRefCol12,  
		cRefCol13,  
		cRefCol14,  
		cRefCol15,  
		cRefCol16,  
		PKTableOwner,  
		FKTableOwner,  
		DeleteCascade,  
		UpdateCascade  
		from #temp1  
		  
		if @@error <> 0 return  
		  
		open cur_ForeignKeys  
		  
		if @@error <> 0 return  
		  
		fetch cur_ForeignKeys into  
		@PKTable,  
		@FKTable,  
		@ConstraintName,  
		@Status,  
		@cKeyCol1,  
		@cKeyCol2,  
		@cKeyCol3,  
		@cKeyCol4,  
		@cKeyCol5,  
		@cKeyCol6,  
		@cKeyCol7,  
		@cKeyCol8,  
		@cKeyCol9,  
		@cKeyCol10,  
		@cKeyCol11,  
		@cKeyCol12,  
		@cKeyCol13,  
		@cKeyCol14,  
		@cKeyCol15,  
		@cKeyCol16,  
		@cRefCol1,  
		@cRefCol2,  
		@cRefCol3,  
		@cRefCol4,  
		@cRefCol5,  
		@cRefCol6,  
		@cRefCol7,  
		@cRefCol8,  
		@cRefCol9,  
		@cRefCol10,  
		@cRefCol11,  
		@cRefCol12,  
		@cRefCol13,  
		@cRefCol14,  
		@cRefCol15,  
		@cRefCol16,  
		@PKTableOwner,  
		@FKTableOwner,  
		@DeleteCascade,  
		@UpdateCascade  
		  
		if @@error <> 0 return  
		  
		while @@Fetch_Status = 0  
		begin  
		  
		set @DropSQLString = ''ALTER Table '' + @FKTable + '' DROP CONSTRAINT '' + @ConstraintName  
		  
		if @FKTable = @FromTable set @FKTable = @ToTable  
		else set @PKTable = @ToTable  
		  
		if @@error <> 0 return  
		  
		set @CreateSQLString = ''ALTER Table '' + @FKTable + '' ADD CONSTRAINT '' + @ConstraintName +  
		'' FOREIGN KEY ('' + @cKeyCol1 +   
		case when @cKeyCol2 is null then rtrim('''') else '', '' + @cKeyCol2 end +   
		case when @cKeyCol3 is null then rtrim('''') else '', '' + @cKeyCol3 end +   
		case when @cKeyCol4 is null then rtrim('''') else '', '' + @cKeyCol4 end +   
		case when @cKeyCol5 is null then rtrim('''') else '', '' + @cKeyCol5 end +  
		case when @cKeyCol6 is null then rtrim('''') else '', '' + @cKeyCol6 end +  
		case when @cKeyCol7 is null then rtrim('''') else '', '' + @cKeyCol7 end +  
		case when @cKeyCol8 is null then rtrim('''') else '', '' + @cKeyCol8 end +  
		case when @cKeyCol9 is null then rtrim('''') else '', '' + @cKeyCol9 end +  
		case when @cKeyCol10 is null then rtrim('''') else '', '' + @cKeyCol10 end +  
		'') REFERENCES '' + replace(@PKTable, ''_temp111'', '''') + ''('' + @cRefCol1 +  
		case when @cRefCol2 is null then rtrim('''') else '', '' + @cRefCol2 end +   
		case when @cRefCol3 is null then rtrim('''') else '', '' + @cRefCol3 end +   
		case when @cRefCol4 is null then rtrim('''') else '', '' + @cRefCol4 end +   
		case when @cRefCol5 is null then rtrim('''') else '', '' + @cRefCol5 end +   
		case when @cRefCol6 is null then rtrim('''') else '', '' + @cRefCol6 end +   
		case when @cRefCol7 is null then rtrim('''') else '', '' + @cRefCol7 end +   
		case when @cRefCol8 is null then rtrim('''') else '', '' + @cRefCol8 end +   
		case when @cRefCol9 is null then rtrim('''') else '', '' + @cRefCol9 end +   
		case when @cRefCol10 is null then rtrim('''') else '', '' + @cRefCol10 end +   
		'')'' + case  when @DeleteCascade = 1 then '' ON DELETE CASCADE'' else rtrim('''') end  
		+ case  when @UpdateCascade = 1 then '' ON UPDATE CASCADE'' else rtrim('''') end  
		  
		   
		if @@error <> 0 return  
		  
		print @DropSQLString  
		execute(@DropSQLString)  
		  
		if @@error <> 0 return  
		  
		print @CreateSQLString  
		execute(@CreateSQLString)  
		  
		  
		if @@error <> 0 return  
		  
		fetch cur_ForeignKeys into  
		@PKTable,  
		@FKTable,  
		@ConstraintName,  
		@Status,  
		@cKeyCol1,  
		@cKeyCol2,  
		@cKeyCol3,  
		@cKeyCol4,  
		@cKeyCol5,  
		@cKeyCol6,  
		@cKeyCol7,  
		@cKeyCol8,  
		@cKeyCol9,  
		@cKeyCol10,  
		@cKeyCol11,  
		@cKeyCol12,  
		@cKeyCol13,  
		@cKeyCol14,  
		@cKeyCol15,  
		@cKeyCol16,  
		@cRefCol1,  
		@cRefCol2,  
		@cRefCol3,  
		@cRefCol4,  
		@cRefCol5,  
		@cRefCol6,  
		@cRefCol7,  
		@cRefCol8,  
		@cRefCol9,  
		@cRefCol10,  
		@cRefCol11,  
		@cRefCol12,  
		@cRefCol13,  
		@cRefCol14,  
		@cRefCol15,  
		@cRefCol16,  
		@PKTableOwner,  
		@FKTableOwner,  
		@DeleteCascade,  
		@UpdateCascade  
		  
		if @@error <> 0 return  
		  
		end  
		  
		close cur_ForeignKeys  
		  
		if @@error <> 0 return  
		  
		deallocate cur_ForeignKeys  
		  
		if @@error <> 0 return ')  

END

GO


------ STEP 6  ----------

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	Begin
		exec ssp_MoveForeignKeyConstraints  'ClaimUB04s_Temp111','ClaimUB04s'
		PRINT 'STEP 6 COMPLETED'
	end
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	Begin
		Drop Table ClaimUB04s_Temp111
	End
	
IF OBJECT_ID('tempdb..#ColumnExists') IS NOT NULL
 DROP TABLE #ColumnExists
 
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.27)
BEGIN
Update SystemConfigurations set DataModelVersion=15.28
PRINT 'STEP 7 COMPLETED'
END
Go
