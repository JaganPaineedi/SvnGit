----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.66)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.66 or update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------
---Add new Column in CourseTypes Table

IF OBJECT_ID('CourseTypes') IS NOT NULL
BEGIN
		IF COL_LENGTH('CourseTypes','NoOfCredits')IS NOT NULL
		BEGIN
		 ALTER TABLE CourseTypes ALTER COLUMN  NoOfCredits  decimal(18,2)	NULL										
		END
END

--Add new Column in Courses Table

IF OBJECT_ID('Courses') IS NOT NULL
BEGIN
		IF COL_LENGTH('Courses','NoOfCredits')IS NOT NULL
		BEGIN
		 ALTER TABLE Courses ALTER COLUMN  NoOfCredits  decimal(18,2)	NULL										
		END
END


 PRINT 'STEP 3 COMPLETED'



------ END OF STEP 3 -----

------ STEP 4 ----------

---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.66)
BEGIN
Update SystemConfigurations set DataModelVersion=19.67
PRINT 'STEP 7 COMPLETED'
END
Go