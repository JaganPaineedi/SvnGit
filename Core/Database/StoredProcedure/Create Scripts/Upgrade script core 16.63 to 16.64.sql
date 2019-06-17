----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.63 )
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.63  for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------
IF OBJECT_ID('CarePlanNeeds') IS NOT NULL
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
	ALTER TABLE CarePlanNeeds   ALTER COLUMN [Source] varchar(100) NULL
	
	IF EXISTS (SELECT *	FROM::fn_listextendedproperty('CarePlanNeeds_Description', 'schema', 'dbo', 'table', 'CarePlanNeeds', 'column', 'Source'))
	BEGIN
	EXEC sys.sp_dropextendedproperty 'CarePlanNeeds_Description'
		,'schema'
		,'dbo'
		,'table'
		,'CarePlanNeeds'
		,'column'
		,'Source'
	END

EXEC sys.sp_addextendedproperty 'CarePlanNeeds_Description'
	,'Source column stores GlobalCodes.Code field of category CarePlanSource'
	,'schema'
	,'dbo'
	,'table'
	,'CarePlanNeeds'
	,'column'
	,'Source'
	
END

PRINT 'STEP 3 COMPLETED'
END



--- Insert script for GlobalCode  CarePlanSource 

 IF NOT EXISTS (SELECT * FROM GlobalCodeCategories WHERE Category = 'CarePlanSource')
BEGIN 
	INSERT INTO GlobalCodeCategories (Category,CategoryName,Active,AllowAddDelete,AllowCodeNameEdit,AllowSortOrderEdit)
	VALUES ('CarePlanSource','Care Plan Source','Y','N','N','N') 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CarePlanSource' and Code='O')
BEGIN
INSERT INTO GlobalCodes
	(Category,
	CodeName,
	Code,
	Active,
	[Description],
	CannotModifyNameOrDelete
	)
	VALUES
	('CarePlanSource',
	'Old MHA',
	'O',
	'Y',
	'Source is from Old MHA',
	'Y'
	) 
END


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CarePlanSource' and Code='C')
BEGIN
INSERT INTO GlobalCodes
	(Category,
	CodeName,
	Code,
	Active,
	[Description],
	CannotModifyNameOrDelete
	)
	VALUES
	('CarePlanSource',
	'Care Plan',
	'C',
	'Y',
	'Source is from Care Plan',
	'Y'
	) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CarePlanSource' and Code='M')
BEGIN
INSERT INTO GlobalCodes
	(Category,
	CodeName,
	Code,
	Active,
	[Description],
	CannotModifyNameOrDelete
	)
	VALUES
	('CarePlanSource',
	'MHA',
	'M',
	'Y',
	'Source is from MHA',
	'Y'
	) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CarePlanSource' and Code='A')
BEGIN
INSERT INTO GlobalCodes
	(Category,
	CodeName,
	Code,
	Active,
	[Description],
	CannotModifyNameOrDelete
	)
	VALUES
	('CarePlanSource',
	'ASAM',
	'A',
	'Y',
	'Source is from ASAM',
	'Y'
	) 
END


IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CarePlanSource' and Code='T')
BEGIN
INSERT INTO GlobalCodes
	(Category,
	CodeName,
	Code,
	Active,
	[Description],
	CannotModifyNameOrDelete
	)
	VALUES
	('CarePlanSource',
	'TRR Assessment',
	'T',
	'Y',
	'Source is from TRR Assessment',
	'Y'
	) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CarePlanSource' and Code='S')
BEGIN
INSERT INTO GlobalCodes
	(Category,
	CodeName,
	Code,
	Active,
	[Description],
	CannotModifyNameOrDelete
	)
	VALUES
	('CarePlanSource',
	'Substance Use',
	'S',
	'Y',
	'Source is from Substance Use',
	'Y'
	) 
END

IF NOT EXISTS(SELECT GlobalCodeId FROM GlobalCodes WHERE Category='CarePlanSource' and Code='R')
BEGIN
INSERT INTO GlobalCodes
	(Category,
	CodeName,
	Code,
	Active,
	[Description],
	CannotModifyNameOrDelete
	)
	VALUES
	('CarePlanSource',
	'Suicide Risk Assessment',
	'R',
	'Y',
	'Source is from Suicide Risk Assessment',
	'Y'
	) 
END
------ END OF STEP 3 -----

------ STEP 4 ---------- 

--END Of STEP 4 ------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.63 )
BEGIN
Update SystemConfigurations set DataModelVersion=16.64 
PRINT 'STEP 7 COMPLETED'
END
Go