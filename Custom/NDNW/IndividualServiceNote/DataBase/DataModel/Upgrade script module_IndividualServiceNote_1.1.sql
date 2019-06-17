----- STEP 1 ----------
IF ((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_IndividualServiceNote')  < 1.0 ) or
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_IndividualServiceNote')
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.0 for CDM_IndividualServiceNote update.Upgrade Script Failed.>>>', 16, 1)
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
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomServices')
BEGIN
/* 
 * TABLE: CustomServices 
 */
  CREATE TABLE CustomServices( 
		ServiceId							int					 NOT NULL,
		CreatedBy							type_CurrentUser     NOT NULL,
		CreatedDate							type_CurrentDatetime NOT NULL,
		ModifiedBy							type_CurrentUser     NOT NULL,
		ModifiedDate						type_CurrentDatetime NOT NULL,
		RecordDeleted						type_YOrN			 NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId          NULL,
		DeletedDate							datetime             NULL,
		PsychiatristReview					type_YOrN			 NULL
											CHECK (PsychiatristReview in ('Y','N')),
		CONSTRAINT CustomServices_PK PRIMARY KEY CLUSTERED (ServiceId) 
 )
 
  IF OBJECT_ID('CustomServices') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomServices >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomServices >>>', 16, 1)
/* 
 * TABLE: CustomServices 
 */   
    
ALTER TABLE CustomServices ADD CONSTRAINT Services_CustomServices_FK
    FOREIGN KEY (ServiceId)
    REFERENCES Services(ServiceId)
    
    PRINT 'STEP 4 COMPLETED'

END
  ---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ---------------- 
-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_IndividualServiceNote')  = 1.0 )
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.1' WHERE [key] = 'CDM_IndividualServiceNote'
	PRINT 'STEP 7 COMPLETED'
END
GO
 
 