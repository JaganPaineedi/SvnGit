----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.55)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.55 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------

IF OBJECT_ID('HealthMaintenanceTriggeringFactors') IS NOT NULL
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
        TB.name='HealthMaintenanceTriggeringFactors'
        AND TC.name='Gender'
       order by SCO.name 
 if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [HealthMaintenanceTriggeringFactors] DROP CONSTRAINT ' + @Cstname + ''   
    execute sp_executesql @sql
end

IF COL_LENGTH('HealthMaintenanceTriggeringFactors','Gender')IS NOT NULL
BEGIN
	UPDATE HealthMaintenanceTriggeringFactors SET Gender='A' where Gender='B'
	ALTER TABLE HealthMaintenanceTriggeringFactors	WITH CHECK ADD CHECK(Gender in ('M','F','U','A'))
END


IF EXISTS (SELECT *	FROM::fn_listextendedproperty('HealthMaintenanceTriggeringFactors_Description', 'schema', 'dbo', 'table', 'HealthMaintenanceTriggeringFactors', 'column', 'Gender'))
BEGIN
	EXEC sys.sp_dropextendedproperty 'HealthMaintenanceTriggeringFactors_Description'
		,'schema'
		,'dbo'
		,'table'
		,'HealthMaintenanceTriggeringFactors'
		,'column'
		,'Gender'
END

EXEC sys.sp_addextendedproperty 'HealthMaintenanceTriggeringFactors_Description'
	,'Gender column store the values M,F,U,A M-Male,F-Female,U-Unknown,A-All'
	,'schema'
	,'dbo'
	,'table'
	,'HealthMaintenanceTriggeringFactors'
	,'column'
	,'Gender'
	

PRINT 'STEP 3 COMPLETED'

END
--END Of STEP 3------------
------ STEP 4 ----------


------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.55)
BEGIN
Update SystemConfigurations set DataModelVersion=18.56
PRINT 'STEP 7 COMPLETED'
END
Go
