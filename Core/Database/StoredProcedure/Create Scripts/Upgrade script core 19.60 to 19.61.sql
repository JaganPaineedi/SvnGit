----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.60)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.60 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------

----Added columns in HL7CPQueueMessages  Table

IF OBJECT_ID('HL7CPQueueMessages') IS NOT NULL
BEGIN

		IF COL_LENGTH('HL7CPQueueMessages','PotentialClientId')IS NULL
		BEGIN
		 ALTER TABLE HL7CPQueueMessages  ADD  PotentialClientId int   NULL									  
		END
		
	IF COL_LENGTH('HL7CPQueueMessages','PotentialClientId')IS NOT NULL
	BEGIN
		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Clients_HL7CPQueueMessages_FK2]') AND parent_object_id = OBJECT_ID(N'[dbo].[HL7CPQueueMessages]'))
			BEGIN
				ALTER TABLE HL7CPQueueMessages ADD CONSTRAINT Clients_HL7CPQueueMessages_FK2
				FOREIGN KEY (PotentialClientId)
				REFERENCES Clients(ClientId) 
			END
		
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[HL7CPQueueMessages]') AND name = N'XIE3_HL7CPQueueMessages')
	  BEGIN
	   CREATE NONCLUSTERED INDEX [XIE3_HL7CPQueueMessages] ON [dbo].[HL7CPQueueMessages] 
	   (
	   [PotentialClientId]  ASC
	   )
	   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('HL7CPQueueMessages') AND name='XIE3_HL7CPQueueMessages')
	   PRINT '<<< CREATED INDEX HL7CPQueueMessages.XIE3_HL7CPQueueMessages >>>'
	   ELSE
	   RAISERROR('<<< FAILED CREATING INDEX HL7CPQueueMessages.XIE3_HL7CPQueueMessages >>>', 16, 1)  
	  END     
	END
	
	
	IF COL_LENGTH('HL7CPQueueMessages','FivePointMatch')IS NULL
		BEGIN
		 ALTER TABLE HL7CPQueueMessages  ADD  FivePointMatch type_YOrN	NULL
										 CHECK (FivePointMatch in	('Y','N'))							  
		END
	
END
	
--END Of STEP 3------------
------ STEP 4 ----------

------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 19.60)
BEGIN
Update SystemConfigurations set DataModelVersion=19.61
PRINT 'STEP 7 COMPLETED'
END
Go
