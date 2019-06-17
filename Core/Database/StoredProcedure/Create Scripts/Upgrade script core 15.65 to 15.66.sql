----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.65)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.65 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('HL7DocumentInboundMessageMappings') IS NOT NULL
BEGIN

-- dropped the columns from HL7DocumentInboundMessageMappings

	IF COL_LENGTH('HL7DocumentInboundMessageMappings','Schedule') IS NOT NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings DROP COLUMN Schedule 					  
	END
	
	IF COL_LENGTH('HL7DocumentInboundMessageMappings','ScheduleId') IS NOT NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings DROP COLUMN ScheduleId 					  
	END
	
	IF COL_LENGTH('HL7DocumentInboundMessageMappings','MedicationStartDate') IS NOT NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings DROP COLUMN MedicationStartDate 					  
	END
	
	IF COL_LENGTH('HL7DocumentInboundMessageMappings','MedicationEndDate') IS NOT NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings DROP COLUMN MedicationEndDate 					  
	END
	
	IF COL_LENGTH('HL7DocumentInboundMessageMappings','TextInstruction') IS NOT NULL
	BEGIN
	 ALTER TABLE HL7DocumentInboundMessageMappings DROP COLUMN TextInstruction 					  
	END
	
PRINT 'STEP 3 COMPLETED'
END

-----END Of STEP 3--------------------

------ STEP 4 ------------

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='HL7DocumentInboundMessageMappingsDeatils')
BEGIN
/* 
 * TABLE: HL7DocumentInboundMessageMappingsDeatils 
 */
CREATE TABLE HL7DocumentInboundMessageMappingsDeatils(
			HL7DocumentInboundMessageMappingsDeatilId	int	identity(1,1)		NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,
			DocumentVersionId							int						NULL,
		    Schedule									varchar(100)			NULL,
		    ScheduleId									int						NULL,
		    MedicationStartDate							datetime				NULL,
		    MedicationEndDate							datetime				NULL,
		    TextInstruction								varchar(max)			NULL,
			CONSTRAINT HL7DocumentInboundMessageMappingsDeatils_PK PRIMARY KEY CLUSTERED (HL7DocumentInboundMessageMappingsDeatilId) 
 )
 
  IF OBJECT_ID('HL7DocumentInboundMessageMappingsDeatils') IS NOT NULL
    PRINT '<<< CREATED TABLE HL7DocumentInboundMessageMappingsDeatils >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE HL7DocumentInboundMessageMappingsDeatils >>>', 16, 1)
    
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[HL7DocumentInboundMessageMappingsDeatils]') AND name = N'XIE1_HL7DocumentInboundMessageMappingsDeatils')
	BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_HL7DocumentInboundMessageMappingsDeatils] ON [dbo].[HL7DocumentInboundMessageMappingsDeatils] 
		(
		[DocumentVersionId] ASC 
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('HL7DocumentInboundMessageMappingsDeatils') AND name='XIE1_HL7DocumentInboundMessageMappingsDeatils')
		PRINT '<<< CREATED INDEX HL7DocumentInboundMessageMappingsDeatils.XIE1_HL7DocumentInboundMessageMappingsDeatils >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX HL7DocumentInboundMessageMappingsDeatils.XIE1_HL7DocumentInboundMessageMappingsDeatils >>>', 16, 1)		
	END
    
	
/* 
 * TABLE: HL7DocumentInboundMessageMappingsDeatils 
 */ 
 
ALTER TABLE HL7DocumentInboundMessageMappingsDeatils ADD CONSTRAINT DocumentVersions_HL7DocumentInboundMessageMappingsDeatils_FK
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions(DocumentVersionId)	 
		
 
	PRINT 'STEP 4(A) COMPLETED'
END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.65)
BEGIN
Update SystemConfigurations set DataModelVersion=15.66
PRINT 'STEP 7 COMPLETED'
END
Go