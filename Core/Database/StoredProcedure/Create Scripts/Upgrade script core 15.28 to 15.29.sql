----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.28)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.28 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------

IF COL_LENGTH('Clients','ClientType')IS NOT NULL
 BEGIN 
 
	IF NOT EXISTS (SELECT 1  FROM   sys.columns WHERE  name ='ClientType' AND  object_id = object_id('dbo.Clients') AND object_definition(default_object_id) is not null)
	BEGIN
	ALTER TABLE Clients ADD CONSTRAINT  DEFAULT_Clients_ClientType  DEFAULT ('I') FOR ClientType
	
	PRINT 'STEP 3 COMPLETED'
	END
END

-----END Of STEP 3--------------------

------ STEP 4 ------------
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.28)
BEGIN
Update SystemConfigurations set DataModelVersion=15.29
PRINT 'STEP 7 COMPLETED'
END
Go