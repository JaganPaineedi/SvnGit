----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------
/* Drop Constraint(s) */

declare @Cstname nvarchar(50), 
    @sql nvarchar(1000)

-- find constraint name
SELECT
     @Cstname= SCO.name 
    FROM
        sys.Objects TB
        INNER JOIN sys.Columns TC on (TB.Object_id = TC.object_id)
        INNER JOIN sys.sysconstraints SC ON (TC.Object_ID = SC.id and TC.column_id = SC.colid)
        INNER JOIN sys.objects SCO ON (SC.Constid = SCO.object_id)
    where
        TB.name='CustomDocumentCANSGenerals'
        AND TC.name='LDFLegal'

   
  if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [CustomDocumentCANSGenerals] DROP CONSTRAINT [' + @Cstname + ']'
    execute sp_executesql @sql
end

set @Cstname=null
-- find constraint name
SELECT
     @Cstname= SCO.name 
    FROM
        sys.Objects TB
        INNER JOIN sys.Columns TC on (TB.Object_id = TC.object_id)
        INNER JOIN sys.sysconstraints SC ON (TC.Object_ID = SC.id and TC.column_id = SC.colid)
        INNER JOIN sys.objects SCO ON (SC.Constid = SCO.object_id)
    where
        TB.name='CustomDocumentCANSGenerals'
        AND TC.name='LDFRecreation'

   
  if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [CustomDocumentCANSGenerals] DROP CONSTRAINT [' + @Cstname + ']'
    execute sp_executesql @sql
end

set @Cstname=null

-- find constraint name
SELECT
     @Cstname= SCO.name 
    FROM
        sys.Objects TB
        INNER JOIN sys.Columns TC on (TB.Object_id = TC.object_id)
        INNER JOIN sys.sysconstraints SC ON (TC.Object_ID = SC.id and TC.column_id = SC.colid)
        INNER JOIN sys.objects SCO ON (SC.Constid = SCO.object_id)
    where
        TB.name='CustomDocumentCANSGenerals'
        AND TC.name='LDFDevelopment'

   
  if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [CustomDocumentCANSGenerals] DROP CONSTRAINT [' + @Cstname + ']'
    execute sp_executesql @sql
end

set @Cstname=null
-- find constraint name
SELECT
     @Cstname= SCO.name 
    FROM
        sys.Objects TB
        INNER JOIN sys.Columns TC on (TB.Object_id = TC.object_id)
        INNER JOIN sys.sysconstraints SC ON (TC.Object_ID = SC.id and TC.column_id = SC.colid)
        INNER JOIN sys.objects SCO ON (SC.Constid = SCO.object_id)
    where
        TB.name='CustomDocumentCANSGenerals'
        AND TC.name='LDFMedical'

   
  if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [CustomDocumentCANSGenerals] DROP CONSTRAINT [' + @Cstname + ']'
    execute sp_executesql @sql
end

set @Cstname=null
-- find constraint name
SELECT
     @Cstname= SCO.name 
    FROM
        sys.Objects TB
        INNER JOIN sys.Columns TC on (TB.Object_id = TC.object_id)
        INNER JOIN sys.sysconstraints SC ON (TC.Object_ID = SC.id and TC.column_id = SC.colid)
        INNER JOIN sys.objects SCO ON (SC.Constid = SCO.object_id)
    where
        TB.name='CustomDocumentCANSGenerals'
        AND TC.name='LDFPhysical'

   
  if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [CustomDocumentCANSGenerals] DROP CONSTRAINT [' + @Cstname + ']'
    execute sp_executesql @sql
end

set @Cstname=null
-- find constraint name
SELECT
     @Cstname= SCO.name 
    FROM
        sys.Objects TB
        INNER JOIN sys.Columns TC on (TB.Object_id = TC.object_id)
        INNER JOIN sys.sysconstraints SC ON (TC.Object_ID = SC.id and TC.column_id = SC.colid)
        INNER JOIN sys.objects SCO ON (SC.Constid = SCO.object_id)
    where
        TB.name='CustomDocumentCANSGenerals'
        AND TC.name='LDFSexuality'

   
  if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [CustomDocumentCANSGenerals] DROP CONSTRAINT [' + @Cstname + ']'
    execute sp_executesql @sql
end

/* Drop Column(s) */
IF COL_LENGTH('CustomDocumentCANSGenerals','LDFLegal')IS NOT NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals DROP COLUMN LDFLegal 
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFRecreation')IS NOT NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals DROP COLUMN LDFRecreation 
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFDevelopment')IS NOT NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals DROP COLUMN LDFDevelopment 
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFMedical')IS NOT NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals DROP COLUMN LDFMedical 
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFPhysical')IS NOT NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals DROP COLUMN LDFPhysical 
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFSexuality')IS NOT NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals DROP COLUMN LDFSexuality 
END
GO

/* Add Column(s) */

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFPhysicalMedical')IS NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals ADD LDFPhysicalMedical char(1) NULL CHECK (LDFPhysicalMedical in('N','U','0','1','2','3'))
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFSexualDevelopment')IS NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals ADD LDFSexualDevelopment char(1) NULL CHECK (LDFSexualDevelopment in('N','U','0','1','2','3'))
END
GO

IF COL_LENGTH('CustomDocumentCANSGenerals','LDFIntellectualDevelopmental')IS NULL
BEGIN
 ALTER TABLE CustomDocumentCANSGenerals ADD LDFIntellectualDevelopmental char(1) NULL CHECK (LDFIntellectualDevelopmental in('N','U','0','1','2','3'))
END
GO

PRINT 'STEP 3 COMPLETED'
------ END OF STEP 3 -----

------ STEP 4 ----------

--PRINT 'STEP 4 COMPLETED'
---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------


If not exists (select [key] from SystemConfigurationKeys where [key] = 'CDM_CANS')
	begin
	INSERT INTO [dbo].[SystemConfigurationKeys]
			   (CreatedBy
			   ,CreateDate 
			   ,ModifiedBy
			   ,ModifiedDate
			   ,[Key]
			   ,Value
			   )
		 VALUES    
			   ('SHSDBA'
			   ,GETDATE()
			   ,'SHSDBA'
			   ,GETDATE()
			   ,'CDM_CANS'
			   ,'1.2'
			   )
        
	End
Else
	Begin
		Update SystemConfigurationKeys set value ='1.2' Where [key] = 'CDM_CANS'
	End
Go

PRINT 'STEP 7 COMPLETED'