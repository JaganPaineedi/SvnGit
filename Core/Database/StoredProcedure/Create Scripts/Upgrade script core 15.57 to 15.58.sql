----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.57)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.57 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------
IF OBJECT_ID('ClientContactNotes') IS NOT NULL
BEGIN
	IF COL_LENGTH('ClientContactNotes','ReferenceType') IS  NULL
		BEGIN
		 ALTER TABLE ClientContactNotes ADD  ReferenceType  type_GlobalCode	NULL
		END
		
	IF COL_LENGTH('ClientContactNotes','ReferenceId') IS  NULL
		BEGIN
		 ALTER TABLE ClientContactNotes ADD  ReferenceId   INT	NULL
		END	
		
	IF COL_LENGTH('ClientContactNotes','AssignedTo') IS  NULL
		BEGIN
		 ALTER TABLE ClientContactNotes ADD  AssignedTo  INT	NULL
		END
			
	IF COL_LENGTH('ClientContactNotes','AssignedTo')IS  NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Staff_ClientContactNotes_FK2]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClientContactNotes]'))	
			BEGIN
				ALTER TABLE ClientContactNotes ADD CONSTRAINT Staff_ClientContactNotes_FK2
				FOREIGN KEY (AssignedTo)
				REFERENCES Staff(StaffId)	 
			END 
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

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.57)
BEGIN
Update SystemConfigurations set DataModelVersion=15.58
PRINT 'STEP 7 COMPLETED'
END
Go