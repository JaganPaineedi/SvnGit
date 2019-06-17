----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.78)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.78 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

-------Add Column in SchoolDistricts Table 

IF OBJECT_ID('SchoolDistricts') IS NOT NULL
BEGIN
		IF COL_LENGTH('SchoolDistricts','ClientSchoolDistrict') IS NULL
		BEGIN
			ALTER TABLE SchoolDistricts ADD ClientSchoolDistrict   type_YOrN	NULL
										CHECK (ClientSchoolDistrict in ('Y','N'))							
		END
		
END

-------CourseTypes   Table 

IF OBJECT_ID('CourseTypes') IS NOT NULL
BEGIN
		IF COL_LENGTH('CourseTypes','ClientCourses') IS NULL
		BEGIN
			ALTER TABLE CourseTypes ADD ClientCourses   type_YOrN	NULL
									CHECK (ClientCourses in ('Y','N'))							
		END
		
		IF EXISTS( select 1 from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = 'CourseTypes' and COLUMN_NAME = 'NoOfCredits'  and DATA_TYPE='decimal')
		BEGIN
		UPDATE CourseTypes SET NoOfCredits=NULL 
		 ALTER TABLE CourseTypes ALTER COLUMN  NoOfCredits  type_GlobalCode	NULL
		 
		 EXEC sys.sp_addextendedproperty 'CourseTypes_Description'
		 ,'NoOfCredits Column stores GlobalCodeIds of Category ''NumberOfCredits''.'
		 ,'schema'
		 ,'dbo'
		 ,'table'
		 ,'CourseTypes'
		 ,'column'
		 ,'NoOfCredits' 
 										
		END

END


IF OBJECT_ID('Courses') IS NOT NULL
BEGIN
		
		IF EXISTS( select 1 from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = 'Courses' and COLUMN_NAME = 'NoOfCredits'  and DATA_TYPE='decimal')
		BEGIN
		UPDATE Courses SET NoOfCredits=NULL 
		 ALTER TABLE Courses ALTER COLUMN  NoOfCredits  type_GlobalCode	NULL
		 
		 EXEC sys.sp_addextendedproperty 'Courses_Description'
		 ,'NoOfCredits Column stores GlobalCodeIds of Category ''NumberOfCredits''.'
		 ,'schema'
		 ,'dbo'
		 ,'table'
		 ,'Courses'
		 ,'column'
		 ,'NoOfCredits' 
 										
		END

END

-------Add Column in CourseClientAssignments   Table 

IF OBJECT_ID('CourseClientAssignments') IS NOT NULL
BEGIN
		IF COL_LENGTH('CourseClientAssignments','Grade') IS NULL
		BEGIN
			ALTER TABLE CourseClientAssignments ADD Grade   type_GlobalCode	NULL
														
		END
		
		IF COL_LENGTH('CourseClientAssignments','QuarterOrSemester') IS NULL
		BEGIN
			ALTER TABLE CourseClientAssignments ADD QuarterOrSemester  type_GlobalCode    NULL														
		END
		
		IF COL_LENGTH('CourseClientAssignments','AttemptedCredit') IS NULL
		BEGIN
			ALTER TABLE CourseClientAssignments ADD AttemptedCredit   type_GlobalCode	NULL
														
		END
		
		IF COL_LENGTH('CourseClientAssignments','AwardedCredit') IS NULL
		BEGIN
			ALTER TABLE CourseClientAssignments ADD AwardedCredit   type_GlobalCode	NULL												
		END
		
	IF EXISTS( select 1 from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = 'CourseClientAssignments' and COLUMN_NAME = 'ClientsFromClassroom'  and DATA_TYPE='char')
	BEGIN
	
	---/ Drop Constraint /
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
        TB.name='CourseClientAssignments'
        AND TC.name='ClientsFromClassroom '
       order by SCO.name 
 if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [CourseClientAssignments] DROP CONSTRAINT ' + @Cstname + ''   
    execute sp_executesql @sql
end

 PRINT 'STEP 3 COMPLETED'
	
		ALTER TABLE CourseClientAssignments  ALTER COLUMN  ClientsFromClassroom  varchar(max) NULL
	END
END

PRINT 'STEP 3 COMPLETED'

------ END OF STEP 3 -----

------ STEP 4 ----------

--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.78)
BEGIN
Update SystemConfigurations set DataModelVersion=19.79
PRINT 'STEP 7 COMPLETED'
END
Go