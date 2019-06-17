----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.25)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.25 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ------------

-----End of Step 2 -------

------ STEP 3 ------------

-- Altered column(s) Nullability  in Sites Table 

IF OBJECT_ID('Sites')IS NOT NULL
BEGIN

/* Drop Constraint */
declare @Cstname nvarchar(max), 
    @sql nvarchar(1000)

-- find constraint name
SELECT @Cstname=COALESCE(@Cstname+',','')+SCO.name 
    FROM
        sys.Objects TB
        INNER JOIN sys.Columns TC on (TB.Object_id = TC.object_id)
        INNER JOIN sys.sysconstraints SC ON (TC.Object_ID = SC.id and TC.column_id = SC.colid)
        INNER JOIN sys.objects SCO ON (SC.Constid = SCO.object_id)
    where
        TB.name='Sites'
        AND TC.name='TaxIDType'
       order by SCO.name 
 if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [Sites] DROP CONSTRAINT ' + @Cstname + ''   
    execute sp_executesql @sql
end

	
	IF COL_LENGTH('Sites','TaxIDType')IS NOT NULL
	BEGIN
		ALTER TABLE Sites ALTER COLUMN TaxIDType char(1)  NULL
		ALTER TABLE Sites WITH CHECK ADD CHECK (TaxIDType in ('E','S'))
	END
	
	IF COL_LENGTH('Sites','TaxID')IS NOT NULL
	BEGIN
		ALTER TABLE Sites ALTER COLUMN TaxID char(9)  NULL
	END
	
	PRINT 'STEP 3 COMPLETED'
END 

-----END Of STEP 3--------------------

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.25)
BEGIN
Update SystemConfigurations set DataModelVersion=16.26
PRINT 'STEP 7 COMPLETED'
END
Go



