----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.13)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.13 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------
------ STEP 3 ------------

-----End of Step 3 -------

------ STEP 4 ---------------
-------------------Claims---------------

IF OBJECT_ID('Claims') IS NOT NULL
BEGIN

	IF COL_LENGTH('Claims','SupervisingProviderId')IS  NULL
	BEGIN
		ALTER TABLE Claims   ADD  SupervisingProviderId  int NULL	
	END
	
	IF COL_LENGTH('Claims','SupervisingProviderName')IS  NULL
	BEGIN
		ALTER TABLE Claims   ADD  SupervisingProviderName  varchar(100) NULL	
	END
	
	IF COL_LENGTH('Claims','SupervisingProviderId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Providers_Claims_FK2]') AND parent_object_id = OBJECT_ID(N'[dbo].[Claims]'))
			BEGIN
				ALTER TABLE Claims ADD CONSTRAINT Providers_Claims_FK2
				FOREIGN KEY (SupervisingProviderId)
				REFERENCES Providers(ProviderId) 
			END
	  END
	  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('Claims') AND name='XIE5_Claims')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE5_Claims] ON [dbo].[Claims] 
		(
		SupervisingProviderId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Claims') AND name='XIE5_Claims')
		PRINT '<<< CREATED INDEX Claims.XIE5_Claims >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX Claims.XIE5_Claims >>>', 16, 1)		
		END	
	
END


-------------------ClaimLines-----------

IF OBJECT_ID('ClaimLines') IS NOT NULL
BEGIN

	IF COL_LENGTH('ClaimLines','SupervisingProviderId')IS  NULL
	BEGIN
		ALTER TABLE ClaimLines   ADD  SupervisingProviderId  int NULL	
	END
	
	IF COL_LENGTH('ClaimLines','SupervisingProviderName')IS  NULL
	BEGIN
		ALTER TABLE ClaimLines   ADD  SupervisingProviderName  varchar(100) NULL	
	END
	
	IF COL_LENGTH('ClaimLines','OrderingProviderId')IS  NULL
	BEGIN
		ALTER TABLE ClaimLines   ADD  OrderingProviderId  int NULL	
	END
	
	IF COL_LENGTH('ClaimLines','OrderingProviderName')IS  NULL
	BEGIN
		ALTER TABLE ClaimLines   ADD  OrderingProviderName  varchar(100) NULL	
	END
	
	IF COL_LENGTH('ClaimLines','SupervisingProviderId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Providers_ClaimLines_FK2]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimLines]'))
			BEGIN
				ALTER TABLE ClaimLines ADD CONSTRAINT Providers_ClaimLines_FK2
				FOREIGN KEY (SupervisingProviderId)
				REFERENCES Providers(ProviderId) 
			END
	  END
	  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClaimLines') AND name='XIE6_ClaimLines')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE6_ClaimLines] ON [dbo].[ClaimLines] 
		(
		SupervisingProviderId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClaimLines') AND name='XIE6_ClaimLines')
		PRINT '<<< CREATED INDEX ClaimLines.XIE6_ClaimLines >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClaimLines.XIE6_ClaimLines >>>', 16, 1)		
		END	
		
		
		IF COL_LENGTH('ClaimLines','OrderingProviderId')IS NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Providers_ClaimLines_FK3]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClaimLines]'))
			BEGIN
				ALTER TABLE ClaimLines ADD CONSTRAINT Providers_ClaimLines_FK3
				FOREIGN KEY (OrderingProviderId)
				REFERENCES Providers(ProviderId) 
			END
		END
	  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClaimLines') AND name='XIE7_ClaimLines')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE7_ClaimLines] ON [dbo].[ClaimLines] 
		(
		OrderingProviderId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClaimLines') AND name='XIE7_ClaimLines')
		PRINT '<<< CREATED INDEX ClaimLines.XIE7_ClaimLines >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClaimLines.XIE7_ClaimLines >>>', 16, 1)		
		END	
	
END



-------------------Import837BatchClaimLines-----------
-------------------------------------------------------------
IF OBJECT_ID('tempdb..#ColumnExists') IS NOT NULL
 DROP TABLE #ColumnExists
 
 CREATE TABLE #ColumnExists (value INT)
------------------We are Adding Column in  Import837BatchClaimLines  table 

 IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN
	IF COL_LENGTH('Import837BatchClaimLines','SupervisingProviderName') IS NOT NULL or  OBJECT_ID('Import837BatchClaimLines') IS  NULL
	BEGIN
		INSERT INTO #ColumnExists
				(value)
			VALUES (1)
		PRINT 'SupervisingProviderName Column is  exists in dbo.Import837BatchClaimLines  - Skipping operation'
	END
	
END



IF OBJECT_ID('Import837BatchClaimLines') IS NOT NULL
BEGIN
	
	IF COL_LENGTH('Import837BatchClaimLines','SupervisingProviderName')IS  NULL
	BEGIN
		ALTER TABLE Import837BatchClaimLines   ADD  SupervisingProviderName  varchar(100) NULL	
	END
	
	IF COL_LENGTH('Import837BatchClaimLines','SupervisingProviderNPI')IS  NULL
	BEGIN
		ALTER TABLE Import837BatchClaimLines   ADD  SupervisingProviderNPI  varchar(20) NULL	
	END

	IF COL_LENGTH('Import837BatchClaimLines','SupervisingProviderId')IS  NULL
	BEGIN
		ALTER TABLE Import837BatchClaimLines   ADD  SupervisingProviderId  int NULL	
	END
	
	IF COL_LENGTH('Import837BatchClaimLines','OrderingProviderName')IS  NULL
	BEGIN
		ALTER TABLE Import837BatchClaimLines   ADD  OrderingProviderName  varchar(100) NULL	
	END
	
	IF COL_LENGTH('Import837BatchClaimLines','OrderingProviderNPI')IS  NULL
	BEGIN
		ALTER TABLE Import837BatchClaimLines   ADD  OrderingProviderNPI   varchar(20) NULL	
	END
	
	
	IF COL_LENGTH('Import837BatchClaimLines','OrderingProviderId')IS  NULL
	BEGIN
		ALTER TABLE Import837BatchClaimLines   ADD  OrderingProviderId  int NULL	
	END
		
	IF COL_LENGTH('Import837BatchClaimLines','SupervisingProviderId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Providers_Import837BatchClaimLines_FK2]') AND parent_object_id = OBJECT_ID(N'[dbo].[Import837BatchClaimLines]'))
			BEGIN
				ALTER TABLE Import837BatchClaimLines ADD CONSTRAINT Providers_Import837BatchClaimLines_FK2
				FOREIGN KEY (SupervisingProviderId)
				REFERENCES Providers(ProviderId) 
			END
	  END
	  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('Import837BatchClaimLines') AND name='XIE3_Import837BatchClaimLines')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_Import837BatchClaimLines] ON [dbo].[Import837BatchClaimLines] 
		(
		SupervisingProviderId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Import837BatchClaimLines') AND name='XIE3_Import837BatchClaimLines')
		PRINT '<<< CREATED INDEX Import837BatchClaimLines.XIE3_Import837BatchClaimLines >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX Import837BatchClaimLines.XIE3_Import837BatchClaimLines >>>', 16, 1)		
		END	
		
		
		IF COL_LENGTH('Import837BatchClaimLines','OrderingProviderId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Providers_Import837BatchClaimLines_FK3]') AND parent_object_id = OBJECT_ID(N'[dbo].[Import837BatchClaimLines]'))
			BEGIN
				ALTER TABLE Import837BatchClaimLines ADD CONSTRAINT Providers_Import837BatchClaimLines_FK3
				FOREIGN KEY (OrderingProviderId)
				REFERENCES Providers(ProviderId) 
			END
	  END
	  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('Import837BatchClaimLines') AND name='XIE4_Import837BatchClaimLines')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE4_Import837BatchClaimLines] ON [dbo].[Import837BatchClaimLines] 
		(
		OrderingProviderId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Import837BatchClaimLines') AND name='XIE4_Import837BatchClaimLines')
		PRINT '<<< CREATED INDEX Import837BatchClaimLines.XIE4_Import837BatchClaimLines >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX Import837BatchClaimLines.XIE4_Import837BatchClaimLines >>>', 16, 1)		
		END	
	
END

------------------------
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	BEGIN					
		IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Import837BatchClaimLines') AND type in (N'U'))     Exec sp_rename  Import837BatchClaimLines,Import837BatchClaimLines_Temp111
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
	exec ssp_DeleteTableChecks 'Import837BatchClaimLines_Temp111'
--Part2 Begins
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	BEGIN
	declare @PKName nvarchar(max)
	declare @tempPK  nvarchar(max)

	IF EXISTS(SELECT 1 FROM sys.indexes WHERE object_id = OBJECT_ID(N'Import837BatchClaimLines_Temp111') AND is_primary_key=1)
	BEGIN
		SET @PKName=(SELECT name FROM sys.indexes WHERE object_id = OBJECT_ID(N'Import837BatchClaimLines_Temp111') AND is_primary_key=1)
		SET @tempPK=@PKName +'_Temp111'
		Exec sp_rename  @PKName,@tempPK
	END			
	END
-----End of Step 2 -------
------ STEP 3 ------------
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce )
BEGIN 
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Import837BatchClaimLines_Temp111]') AND name = N'XIE1_Import837BatchClaimLines')
	BEGIN
	DROP INDEX [XIE1_Import837BatchClaimLines] ON [dbo].[Import837BatchClaimLines_Temp111] 
	END	
END

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce )
BEGIN 
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Import837BatchClaimLines_Temp111]') AND name = N'XIE2_Import837BatchClaimLines')
	BEGIN
	DROP INDEX [XIE2_Import837BatchClaimLines] ON [dbo].[Import837BatchClaimLines_Temp111] 
	END	
END


IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce )
BEGIN 
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Import837BatchClaimLines_Temp111]') AND name = N'XIE3_Import837BatchClaimLines')
	BEGIN
	DROP INDEX [XIE3_Import837BatchClaimLines] ON [dbo].[Import837BatchClaimLines_Temp111] 
	END	
END

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce )
BEGIN 
IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Import837BatchClaimLines_Temp111]') AND name = N'XIE4_Import837BatchClaimLines')
	BEGIN
	DROP INDEX [XIE4_Import837BatchClaimLines] ON [dbo].[Import837BatchClaimLines_Temp111] 
	END	
END


IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce )
BEGIN 
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ClaimLines_Import837BatchClaimLines_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Import837BatchClaimLines_Temp111]'))
	ALTER TABLE [dbo].[Import837BatchClaimLines_Temp111] DROP CONSTRAINT ClaimLines_Import837BatchClaimLines_FK	
END

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce )
BEGIN 
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Import837BatchClaims_Import837BatchClaimLines_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Import837BatchClaimLines_Temp111]'))
	ALTER TABLE [dbo].[Import837BatchClaimLines_Temp111] DROP CONSTRAINT Import837BatchClaims_Import837BatchClaimLines_FK	
END

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce )
BEGIN 
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Providers_Import837BatchClaimLines_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Import837BatchClaimLines_Temp111]'))
	ALTER TABLE [dbo].[Import837BatchClaimLines_Temp111] DROP CONSTRAINT Providers_Import837BatchClaimLines_FK	
END

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce )
BEGIN 
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Providers_Import837BatchClaimLines_FK2]') AND parent_object_id = OBJECT_ID(N'[dbo].[Import837BatchClaimLines_Temp111]'))
	ALTER TABLE [dbo].[Import837BatchClaimLines_Temp111] DROP CONSTRAINT Providers_Import837BatchClaimLines_FK2	
END

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce )
BEGIN 
	IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Providers_Import837BatchClaimLines_FK3]') AND parent_object_id = OBJECT_ID(N'[dbo].[Import837BatchClaimLines_Temp111]'))
	ALTER TABLE [dbo].[Import837BatchClaimLines_Temp111] DROP CONSTRAINT Providers_Import837BatchClaimLines_FK3	
END

------ STEP 4 ----------

/* 
 * TABLE: Import837BatchClaimLines 
 */
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN
 CREATE TABLE Import837BatchClaimLines(
		Import837BatchClaimLineId		INT IDENTITY(1,1)		NOT NULL,
		CreatedBy						type_CurrentUser		NOT NULL,
		CreatedDate						type_CurrentDatetime	NOT NULL,
		ModifiedBy						type_CurrentUser		NOT NULL,
		ModifiedDate					type_CurrentDatetime	NOT NULL,
		RecordDeleted					type_YOrN				NULL
										CHECK (RecordDeleted in	('Y','N')),	
		DeletedBy						type_UserId				NULL,
		DeletedDate						datetime				NULL,			
		Import837BatchClaimId			int						NOT NULL,
		ClaimLineId						int						NULL,
		RenderingProviderId				int						NULL,
		SupervisingProviderId			int						NULL,  
		OrderingProviderId				int						NULL,  
		FileLineStart					int						NULL,
		FileLineEnd						int						NULL,
		ServiceLineNumber				varchar(6)				NULL,
		LineItemControlNumber			varchar(30)				NULL,
		ServiceDate						datetime				NULL,
		RevenueCode						varchar(30)				NULL,
		ProcedureCode					varchar(30)				NULL,
		AuthorizationNumber				varchar(30)				NULL,
		ChargeAmount					money					NULL,
		RenderingProviderNumber			varchar(30)				NULL,
		RenderingProviderName			varchar(60)				NULL,
		RenderingProviderTaxId			varchar(11)				NULL,
		RenderingProviderNPI			varchar(80)				NULL,
		Processed						type_YOrN				NULL
										CHECK (Processed in	('Y','N')),	
		SupervisingProviderName			varchar(100)			NULL,
		SupervisingProviderNPI			varchar(20)				NULL,
		OrderingProviderName			varchar(100)			NULL,
		OrderingProviderNPI				varchar(20)				NULL,
		RowIdentifier					type_GUID				NOT NULL,	
		CONSTRAINT Import837BatchClaimLines_PK PRIMARY KEY CLUSTERED (Import837BatchClaimLineId)
 ) 
 IF OBJECT_ID('Import837BatchClaimLines') IS NOT NULL
	PRINT '<<< CREATED TABLE Import837BatchClaimLines >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE Import837BatchClaimLines >>>', 16, 1)	

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Import837BatchClaimLines]') AND name = N'XIE1_Import837BatchClaimLines')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_Import837BatchClaimLines] ON [dbo].[Import837BatchClaimLines] 
		(
		Import837BatchClaimId ASC		
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Import837BatchClaimLines') AND name='XIE1_Import837BatchClaimLines')
		PRINT '<<< CREATED INDEX Import837BatchClaimLines.XIE1_Import837BatchClaimLines >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX Import837BatchClaimLines.XIE1_Import837BatchClaimLines >>>', 16, 1)		
	END
	
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Import837BatchClaimLines]') AND name = N'XIE2_Import837BatchClaimLines')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_Import837BatchClaimLines] ON [dbo].[Import837BatchClaimLines] 
		(
		ClaimLineId ASC		
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Import837BatchClaimLines') AND name='XIE2_Import837BatchClaimLines')
		PRINT '<<< CREATED INDEX Import837BatchClaimLines.XIE2_Import837BatchClaimLines >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX Import837BatchClaimLines.XIE2_Import837BatchClaimLines >>>', 16, 1)		
	END
	
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Import837BatchClaimLines]') AND name = N'XIE3_Import837BatchClaimLines')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_Import837BatchClaimLines] ON [dbo].[Import837BatchClaimLines] 
		(
		SupervisingProviderId ASC		
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Import837BatchClaimLines') AND name='XIE3_Import837BatchClaimLines')
		PRINT '<<< CREATED INDEX Import837BatchClaimLines.XIE3_Import837BatchClaimLines >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX Import837BatchClaimLines.XIE3_Import837BatchClaimLines >>>', 16, 1)		
	END
	
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Import837BatchClaimLines]') AND name = N'XIE4_Import837BatchClaimLines')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE4_Import837BatchClaimLines] ON [dbo].[Import837BatchClaimLines] 
		(
		OrderingProviderId ASC		
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Import837BatchClaimLines') AND name='XIE4_Import837BatchClaimLines')
		PRINT '<<< CREATED INDEX Import837BatchClaimLines.XIE4_Import837BatchClaimLines >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX Import837BatchClaimLines.XIE4_Import837BatchClaimLines >>>', 16, 1)		
	END
	
	
/* 
 * TABLE: Import837BatchClaimLines 
 */	
 
ALTER TABLE Import837BatchClaimLines ADD CONSTRAINT Import837BatchClaims_Import837BatchClaimLines_FK 
	FOREIGN KEY (Import837BatchClaimId)
	REFERENCES Import837BatchClaims(Import837BatchClaimId)
	
ALTER TABLE Import837BatchClaimLines ADD CONSTRAINT ClaimLines_Import837BatchClaimLines_FK 
	FOREIGN KEY (ClaimLineId)
	REFERENCES ClaimLines(ClaimLineId)		
	
ALTER TABLE Import837BatchClaimLines ADD CONSTRAINT Providers_Import837BatchClaimLines_FK 
	FOREIGN KEY (RenderingProviderId)
	REFERENCES Providers(ProviderId)
	
ALTER TABLE Import837BatchClaimLines ADD CONSTRAINT Providers_Import837BatchClaimLines_FK2 
	FOREIGN KEY (SupervisingProviderId)
	REFERENCES Providers(ProviderId)	
	
ALTER TABLE Import837BatchClaimLines ADD CONSTRAINT Providers_Import837BatchClaimLines_FK3 
	FOREIGN KEY (OrderingProviderId)
	REFERENCES Providers(ProviderId)	
			
PRINT 'STEP 4 COMPLETED'
		
END

--END Of STEP 4

------ STEP 5 ----------------

IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
BEGIN
SET IDENTITY_INSERT Import837BatchClaimLines ON	
 INSERT INTO [Import837BatchClaimLines]
	 (
	Import837BatchClaimLineId
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedBy
	,DeletedDate
	,Import837BatchClaimId
	,ClaimLineId
	,RenderingProviderId
	,SupervisingProviderId
	,OrderingProviderId
	,FileLineStart
	,FileLineEnd
	,ServiceLineNumber
	,LineItemControlNumber
	,ServiceDate
	,RevenueCode
	,ProcedureCode
	,AuthorizationNumber
	,ChargeAmount
	,RenderingProviderNumber
	,RenderingProviderName
	,RenderingProviderTaxId
	,RenderingProviderNPI
	,Processed
	,SupervisingProviderName
	,SupervisingProviderNPI
	,OrderingProviderName
	,OrderingProviderNPI
	,RowIdentifier

	)
SELECT
	Import837BatchClaimLineId
	,CreatedBy
	,CreatedDate
	,ModifiedBy
	,ModifiedDate
	,RecordDeleted
	,DeletedBy
	,DeletedDate
	,Import837BatchClaimId
	,ClaimLineId
	,RenderingProviderId
	,SupervisingProviderId
	,OrderingProviderId
	,FileLineStart
	,FileLineEnd
	,ServiceLineNumber
	,LineItemControlNumber
	,ServiceDate
	,RevenueCode
	,ProcedureCode
	,AuthorizationNumber
	,ChargeAmount
	,RenderingProviderNumber
	,RenderingProviderName
	,RenderingProviderTaxId
	,RenderingProviderNPI
	,Processed
	,SupervisingProviderName
	,SupervisingProviderNPI
	,OrderingProviderName
	,OrderingProviderNPI
	,RowIdentifier
	FROM [Import837BatchClaimLines_Temp111]
	SET IDENTITY_INSERT Import837BatchClaimLines OFF	
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
		exec ssp_MoveForeignKeyConstraints  'Import837BatchClaimLines_Temp111','Import837BatchClaimLines'
		PRINT 'STEP 6 COMPLETED'
	end
IF NOT EXISTS ( SELECT 1 FROM #ColumnExists ce ) 
	BEGIN
		DROP TABLE Import837BatchClaimLines_Temp111
	END
				
IF OBJECT_ID('tempdb..#ColumnExists') IS NOT NULL
 DROP TABLE #ColumnExists

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.13)
BEGIN
Update SystemConfigurations set DataModelVersion=18.14
PRINT 'STEP 7 COMPLETED'
END
Go

