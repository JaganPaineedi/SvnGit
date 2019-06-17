----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.10)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.10 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------
--Part1 Begin
IF OBJECT_ID('tempdb..#ColumnExists') IS NOT NULL
 DROP TABLE #ColumnExists
 
 CREATE TABLE #ColumnExists (value INT)


 IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN
	IF COL_LENGTH('ERBatches','ERPayerName') IS NOT NULL  AND   EXISTS(SELECT 1 FROM syscolumns where id = object_id('ERBatches') AND name='CreatedBy' AND colorder=2)
	BEGIN
		INSERT INTO #ColumnExists
				(value)
			VALUES (1)
		PRINT 'ERPayerName Column already  exists in dbo.ERBatches  - Skipping operation'
	END	
	
END
-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('ERBatches')IS NOT NULL
BEGIN
	IF COL_LENGTH('ERBatches','ERPayerName') IS NULL
	BEGIN
		ALTER TABLE ERBatches ADD  ERPayerName VARCHAR(MAX)
	END
	
	IF COL_LENGTH('ERBatches','ERPayerIdentifier') IS NULL
	BEGIN
		ALTER TABLE ERBatches ADD  ERPayerIdentifier VARCHAR(MAX)
	END
END

------------------------
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	BEGIN					
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ERBatches') AND type in (N'U'))     Exec sp_rename  ERBatches,ERBatches_Temp111
		PRINT 'STEP 1 COMPLETED'
	END
	
	IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	BEGIN
		IF EXISTS (SELECT * FROM sys.objects WHERE object_id=OBJECT_ID(N'ssp_DeleteTableChecks') AND type IN (N'P',N'PC')) 	DROP PROCEDURE ssp_DeleteTableChecks
	END
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	BEGIN
		exec ('create PROCEDURE ssp_DeleteTableChecks
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
		
--End of Step 1	
------ STEP 2 ----------
--Part1 Begin
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	exec ssp_DeleteTableChecks 'ERBatches_Temp111'
--Part2 Begins
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	BEGIN
	declare @PKName nvarchar(max)
	declare @tempPK  nvarchar(max)

	IF EXISTS(SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'ERBatches_Temp111') AND is_primary_key=1)
	BEGIN
		SET @PKName=(SELECT name FROM sys.indexes WHERE object_id = OBJECT_ID(N'ERBatches_Temp111') AND is_primary_key=1)
		SET @tempPK=@PKName +'_Temp111'
		Exec sp_rename  @PKName,@tempPK
	END			
	END
-----End of Step 2 -------
------ STEP 3 ------------


IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce )
BEGIN 
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ERBatches_Temp111]') AND name = N'XIE1_ERBatches_Temp111')
	BEGIN
	DROP INDEX [XIE1_ERBatches] ON [dbo].[ERBatches_Temp111] 
	END	
END

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce )
BEGIN 
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ERBatches_Temp111]') AND name = N'XIE2_ERBatches_Temp111')
	BEGIN
	DROP INDEX [XIE2_ERBatches] ON [dbo].[ERBatches_Temp111] 
	END	
END

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce )
BEGIN 
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ERFiles_ERBatches_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ERBatches_Temp111]'))
	ALTER TABLE [dbo].[ERBatches_Temp111] DROP CONSTRAINT ERFiles_ERBatches_FK
END

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce )
BEGIN 
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Payments_ERBatches_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ERBatches_Temp111]'))
	ALTER TABLE [dbo].[ERBatches_Temp111] DROP CONSTRAINT Payments_ERBatches_FK
END



------ STEP 4 ----------


/* 
 * TABLE: ERBatches 
 */
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN
 CREATE TABLE ERBatches(
			ERBatchId							int identity(1,1)		NOT NULL,
			CreatedBy							type_CurrentUser		NOT NULL,
			CreatedDate							type_CurrentDatetime	NOT NULL,
			ModifiedBy							type_CurrentUser		NOT NULL,
			ModifiedDate						type_CurrentDatetime	NOT NULL,
			RecordDeleted						type_YOrN				NULL
												CHECK (RecordDeleted in	('Y','N')),	
			DeletedBy							type_UserId				NULL,
			DeletedDate							datetime				NULL,
			ERFileId							int						NOT NULL,
			PaymentId							int						NULL,
			SenderBatchId						varchar(25)				NULL,
			CheckAmount							type_Money				NULL,
			CheckDate							datetime				NULL,
			CheckNumber							varchar(30)				NULL,
			TotalProviderAdjustments			type_Money				NULL,
			ERPayerName							varchar(max)			NULL,
			ERPayerIdentifier					varchar(max)			NULL,
			RowIdentifier						type_GUID				NOT NULL,		
			CONSTRAINT ERBatches_PK PRIMARY KEY NONCLUSTERED (ERBatchId)
 ) 
 IF OBJECT_ID('ERBatches') IS NOT NULL
	PRINT '<<< CREATED TABLE ERBatches >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE ERBatches >>>', 16, 1)	

 
 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ERBatches]') AND name = N'XIE1_ERBatches')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ERBatches] ON [dbo].[ERBatches] 
		(
		[ERFileId] asc
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ERBatches') AND name='XIE1_ERBatches')
		PRINT '<<< CREATED INDEX ERBatches.XIE1_ERBatches >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ERBatches.XIE1_ERBatches >>>', 16, 1)		
	END
	
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[ERBatches]') AND name = N'XIE2_ERBatches')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ERBatches] ON [dbo].[ERBatches] 
		(
		[PaymentId] asc
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ERBatches') AND name='XIE2_ERBatches')
		PRINT '<<< CREATED INDEX ERBatches.XIE2_ERBatches >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ERBatches.XIE2_ERBatches >>>', 16, 1)		
	END
	
/* 
 * TABLE: ERBatches 
 */	

	ALTER TABLE ERBatches ADD CONSTRAINT ERFiles_ERBatches_FK 
		FOREIGN KEY (ERFileId)
		REFERENCES ERFiles(ERFileId)
	 
	ALTER TABLE ERBatches ADD CONSTRAINT Payments_ERBatches_FK
		FOREIGN KEY (PaymentId)
		REFERENCES Payments(PaymentId)	

PRINT 'STEP 4 COMPLETED'
		
END

--END Of STEP 4

------ STEP 5 ----------------

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN
SET IDENTITY_INSERT ERBatches ON	
 INSERT INTO [ERBatches]
	 (
	ERBatchId	
	,CreatedBy								
	,CreatedDate								
	,ModifiedBy								
	,ModifiedDate							
	,RecordDeleted																		
	,DeletedBy								
	,DeletedDate								
	,ERFileId							
	,PaymentId								
	,SenderBatchId
	,CheckAmount
	,CheckDate
	,CheckNumber
	,TotalProviderAdjustments
	,ERPayerName 
	,ERPayerIdentifier 						
	,RowIdentifier														
	)
SELECT
	 ERBatchId	
	,CreatedBy								
	,CreatedDate								
	,ModifiedBy								
	,ModifiedDate							
	,RecordDeleted																		
	,DeletedBy								
	,DeletedDate								
	,ERFileId							
	,PaymentId								
	,SenderBatchId
	,CheckAmount
	,CheckDate
	,CheckNumber
	,TotalProviderAdjustments
	,ERPayerName 
	,ERPayerIdentifier 						
	,RowIdentifier		
	FROM [ERBatches_Temp111]
	SET IDENTITY_INSERT ERBatches OFF	
END

-------END STEP 5-------------

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	Begin
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ssp_MoveForeignKeyConstraints]') AND type in (N'P', N'PC'))
			DROP PROCEDURE [dbo].[ssp_MoveForeignKeyConstraints]
	End

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	Begin
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
	End


------ STEP 6  ----------

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	Begin
		exec ssp_MoveForeignKeyConstraints  'ERBatches_Temp111','ERBatches'
		PRINT 'STEP 6 COMPLETED'
	end
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	BEGIN
		DROP TABLE ERBatches_Temp111
	END
				

IF OBJECT_ID('tempdb..#ColumnExists') IS NOT NULL
 DROP TABLE #ColumnExists




-----END Of STEP 3---------

------ STEP 4 ------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ERFileToPayerMapping')
 BEGIN
/* 
 * TABLE: ERFileToPayerMapping 
 */

CREATE TABLE ERFileToPayerMapping(
    ERFileToPayerMappingId			int	identity(1,1)		NOT NULL,
    CreatedBy						type_CurrentUser		NOT NULL,
    CreatedDate						type_CurrentDatetime    NOT NULL,
    ModifiedBy						type_CurrentUser        NOT NULL,
    ModifiedDate					type_CurrentDatetime    NOT NULL,
    RecordDeleted					type_YOrN               NULL
									CHECK (RecordDeleted in ('Y','N')),
    DeletedBy						type_UserId             NULL,
	DeletedDate						datetime                NULL,
	PayerId 						int						NULL,
	ERPayerName						varchar(max)            NULL,
	ERPayerIdentifier				varchar(max)            NULL,
	CONSTRAINT ERFileToPayerMapping_PK PRIMARY KEY CLUSTERED (ERFileToPayerMappingId)
)

IF OBJECT_ID('ERFileToPayerMapping') IS NOT NULL
    PRINT '<<< CREATED TABLE ERFileToPayerMapping >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ERFileToPayerMapping >>>', 16, 1)
    
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ERFileToPayerMapping') AND name='XIE1_ERFileToPayerMapping')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ERFileToPayerMapping] ON [dbo].[ERFileToPayerMapping] 
		(
			PayerId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ERFileToPayerMapping') AND name='XIE1_ERFileToPayerMapping')
		PRINT '<<< CREATED INDEX ERFileToPayerMapping.XIE1_ERFileToPayerMapping >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ERFileToPayerMapping.XIE1_ERFileToPayerMapping >>>', 16, 1)		
		END	    

/* 
 * TABLE: ERFileToPayerMapping 
 */

ALTER TABLE ERFileToPayerMapping ADD CONSTRAINT Payers_ERFileToPayerMapping_FK 
    FOREIGN KEY (PayerId)
    REFERENCES Payers(PayerId)
    
    PRINT 'STEP 4(A) COMPLETED'
END


--added SystemConfigurationKey CREATE835PAYMENTSBYPAYER

IF NOT EXISTS (
		SELECT 1
		FROM SystemConfigurationKeys
		WHERE [Key] = 'CREATE835PAYMENTSBYPAYER'
		)
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[Key]
		,Value
		,AcceptedValues
		,[Description]
		)
	VALUES (
		SYSTEM_USER
		,CURRENT_TIMESTAMP
		,SYSTEM_USER
		,CURRENT_TIMESTAMP
		,'CREATE835PAYMENTSBYPAYER'
		,'N'
		,'Y,N'
		,'When this key is Y, 835 process will create one payment record by Payer for a given check, if the payer is set up in ERFileToPayerMapping. When this key is N, 835 process will follow existing logic of creating payments by Coverage Plan'
		)
END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.10)
BEGIN
Update SystemConfigurations set DataModelVersion=16.11
PRINT 'STEP 7 COMPLETED'
END
Go


