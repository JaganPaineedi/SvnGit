----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.19)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.19 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ---------- 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ClientMedicationScriptDispenseDays')
BEGIN
/*  
 * TABLE: ClientMedicationScriptDispenseDays 
 */
 CREATE TABLE ClientMedicationScriptDispenseDays( 
		ClientMedicationScriptDispenseDayId			int	identity(1,1)	 NOT NULL,
		CreatedBy									type_CurrentUser     NOT NULL,
		CreatedDate									type_CurrentDatetime NOT NULL,
		ModifiedBy									type_CurrentUser     NOT NULL,
		ModifiedDate								type_CurrentDatetime NOT NULL,
		RecordDeleted								type_YOrN			 NULL
													CHECK (RecordDeleted in ('Y','N')),
		DeletedBy									type_UserId          NULL,
		DeletedDate									datetime             NULL,
		ClientMedicationScriptId					int					 NULL,
		ClientMedicationInstructionId				int					 NULL,
		ClientMedicationId							int					 NULL,
		DaysOfWeek									varchar(20)			 NULL,		
		CONSTRAINT ClientMedicationScriptDispenseDays_PK PRIMARY KEY CLUSTERED (ClientMedicationScriptDispenseDayId)
)
IF OBJECT_ID('ClientMedicationScriptDispenseDays') IS NOT NULL
    PRINT '<<< CREATED TABLE ClientMedicationScriptDispenseDays >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ClientMedicationScriptDispenseDays >>>', 16, 1)
    
/* 
 * TABLE: ClientMedicationScriptDispenseDays 
 */ 
 
 ALTER TABLE ClientMedicationScriptDispenseDays ADD CONSTRAINT ClientMedicationScripts_ClientMedicationScriptDispenseDays_FK
    FOREIGN KEY (ClientMedicationScriptId)
    REFERENCES ClientMedicationScripts(ClientMedicationScriptId)  

 ALTER TABLE ClientMedicationScriptDispenseDays ADD CONSTRAINT ClientMedicationInstructions_ClientMedicationScriptDispenseDays_FK
    FOREIGN KEY (ClientMedicationInstructionId)
    REFERENCES ClientMedicationInstructions(ClientMedicationInstructionId)  
        
   ALTER TABLE ClientMedicationScriptDispenseDays ADD CONSTRAINT ClientMedications_ClientMedicationScriptDispenseDays_FK
    FOREIGN KEY (ClientMedicationId)
    REFERENCES ClientMedications(ClientMedicationId)          

 PRINT 'STEP 4(A) COMPLETED' 
END

--END Of STEP 4 ------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.19)
BEGIN
Update SystemConfigurations set DataModelVersion=15.20
PRINT 'STEP 7 COMPLETED'
END
Go
