----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.49)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.49 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------

-------Add Column in MedicationReconciliationCurrentMedications & MedicationReconciliationCCDMedications Table 

IF OBJECT_ID('MedicationReconciliationCurrentMedications') IS NOT NULL
BEGIN
		IF COL_LENGTH('MedicationReconciliationCurrentMedications','DiscontinuedMedication') IS NULL
		BEGIN
			ALTER TABLE MedicationReconciliationCurrentMedications ADD DiscontinuedMedication type_YOrN  NULL
																   CHECK (DiscontinuedMedication in ('Y','N'))	
			EXEC sys.sp_addextendedproperty 'MedicationReconciliationCurrentMedications_Description'
			 ,'DiscontinuedMedication Column stores Y,N,NULL. Y-medications were discontinued on signature,N/Null-medications are still active'
			 ,'schema'
			 ,'dbo'
			 ,'table'
			 ,'MedicationReconciliationCurrentMedications'
			 ,'column'
			 ,'DiscontinuedMedication' 
 										
		END
END	

IF OBJECT_ID('MedicationReconciliationCCDMedications') IS NOT NULL
BEGIN
		IF COL_LENGTH('MedicationReconciliationCCDMedications','DiscontinuedMedication') IS NULL
		BEGIN
			ALTER TABLE MedicationReconciliationCCDMedications ADD DiscontinuedMedication type_YOrN  NULL
															   CHECK (DiscontinuedMedication in ('Y','N'))
			EXEC sys.sp_addextendedproperty 'MedicationReconciliationCCDMedications_Description'
			 ,'DiscontinuedMedication Column stores Y,N,NULL. Y-medications were discontinued on signature,N/Null-medications are still active'
			 ,'schema'
			 ,'dbo'
			 ,'table'
			 ,'MedicationReconciliationCCDMedications'
			 ,'column'
			 ,'DiscontinuedMedication' 
			 											
		END
END	
PRINT 'STEP 3 COMPLETED'



--END Of STEP 3------------
------ STEP 4 ----------
 
------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.49)
BEGIN
Update SystemConfigurations set DataModelVersion=19.50
PRINT 'STEP 7 COMPLETED'
END
Go
