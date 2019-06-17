----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.28)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.28 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('ClientMedicationInstructions') IS NOT NULL
BEGIN

 IF EXISTS(SELECT so.name , OBJECT_NAME(sc.object_id),sc.name
     FROM sys.objects so
     JOIN sys.columns sc
     ON so.object_id = sc.rule_object_id
     WHERE 
     OBJECT_NAME(sc.object_id) =('ClientMedicationInstructions')
   )
  BEGIN 
    EXEC sp_unbindrule 'ClientMedicationInstructions.Active'   
      
  END
 PRINT 'STEP 3 COMPLETED'
END
------ END Of STEP 3 ------------

------ STEP 4 ---------------

 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.28)
BEGIN
Update SystemConfigurations set DataModelVersion=18.29
PRINT 'STEP 7 COMPLETED'
END
Go

