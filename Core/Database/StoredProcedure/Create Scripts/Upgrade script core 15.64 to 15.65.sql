----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.64)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.64 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

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
        TB.name='CarePlanNeeds'
        AND TC.name='Source'
       order by SCO.name 
 if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [CarePlanNeeds] DROP CONSTRAINT ' + @Cstname + ''   
    execute sp_executesql @sql
end


IF COL_LENGTH('CarePlanNeeds','Source')IS NOT NULL
BEGIN
	ALTER TABLE CarePlanNeeds  WITH CHECK  ADD CHECK([Source] in ('O','C','M','A','S','T')) 
END

PRINT 'STEP 3 COMPLETED'

------ END OF STEP 3 -----

------ STEP 4 ---------- 

--END Of STEP 4 ------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.64)
BEGIN
Update SystemConfigurations set DataModelVersion=15.65
PRINT 'STEP 7 COMPLETED'
END
Go