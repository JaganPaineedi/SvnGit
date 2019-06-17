----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 19.46)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 19.46 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------

IF OBJECT_ID('HL7CPVendorCommOverrides') IS NOT NULL
BEGIN
		IF COL_LENGTH('HL7CPVendorCommOverrides','EmbeddedPDF') IS NULL
		BEGIN
			ALTER TABLE HL7CPVendorCommOverrides ADD EmbeddedPDF type_YOrN	 NULL
												CHECK (EmbeddedPDF in ('Y','N'))					
		END
	
		IF COL_LENGTH('HL7CPVendorCommOverrides','EmbeddedPDFSegmentIdentifier') IS NULL
		BEGIN
			ALTER TABLE HL7CPVendorCommOverrides ADD EmbeddedPDFSegmentIdentifier VARCHAR(50) NULL				
		END
	
		IF COL_LENGTH('HL7CPVendorCommOverrides','SFTPHost') IS NULL
		BEGIN
		 ALTER TABLE HL7CPVendorCommOverrides  ADD SFTPHost  VARCHAR(250)	NULL
		END
		
		IF COL_LENGTH('HL7CPVendorCommOverrides','SFTPPort') IS NULL
		BEGIN
		 ALTER TABLE HL7CPVendorCommOverrides  ADD SFTPPort  INT	NULL
		END
		
		IF COL_LENGTH('HL7CPVendorCommOverrides','SFTPUsername') IS NULL
		BEGIN
		 ALTER TABLE HL7CPVendorCommOverrides  ADD SFTPUsername  VARCHAR(100)	NULL
		END
		
		IF COL_LENGTH('HL7CPVendorCommOverrides','SFTPPassword') IS NULL
		BEGIN
		 ALTER TABLE HL7CPVendorCommOverrides  ADD SFTPPassword  VARCHAR(100)	NULL
		END
		
		IF COL_LENGTH('HL7CPVendorCommOverrides','SourceFolder') IS NULL
		BEGIN
		 ALTER TABLE HL7CPVendorCommOverrides  ADD SourceFolder  VARCHAR(250)	NULL
		END
		
		IF COL_LENGTH('HL7CPVendorCommOverrides','DeleteFileAfterDownload') IS NULL
		BEGIN
		 ALTER TABLE HL7CPVendorCommOverrides  ADD DeleteFileAfterDownload  type_YOrN	NULL
											   CHECK (DeleteFileAfterDownload in ('Y','N'))
		END
		
		
		---Drop column if exists
		IF COL_LENGTH('HL7CPVendorCommOverrides','DestinationFolder') IS NOT NULL
		BEGIN
		 ALTER TABLE HL7CPVendorCommOverrides  DROP COLUMN DestinationFolder  
		END
		
END

IF OBJECT_ID('Laboratories') IS NOT NULL
BEGIN
IF COL_LENGTH('Laboratories','VendorId') IS NULL
		BEGIN
		 ALTER TABLE Laboratories  ADD VendorId  int	NULL
		END
		
		IF COL_LENGTH('Laboratories','VendorId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[HL7CPVendorConfigurations_Laboratories_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[Laboratories]'))
			BEGIN
				ALTER TABLE Laboratories ADD CONSTRAINT HL7CPVendorConfigurations_Laboratories_FK
				FOREIGN KEY (VendorId)
				REFERENCES HL7CPVendorConfigurations(VendorId) 
			END
	  END
	  
	 IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Laboratories]') AND name = N'XIE1_Laboratories')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE1_Laboratories] ON [dbo].[Laboratories] 
			(
			[VendorId]  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Laboratories') AND name='XIE1_Laboratories')
			PRINT '<<< CREATED INDEX Laboratories.XIE1_Laboratories >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX Laboratories.XIE1_Laboratories >>>', 16, 1)		
		END	
		
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Laboratories]') AND name = N'XIE2_Laboratories')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE2_Laboratories] ON [dbo].[Laboratories] 
			(
			[HL7InterfaceId]  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('Laboratories') AND name='XIE2_Laboratories')
			PRINT '<<< CREATED INDEX Laboratories.XIE2_Laboratories >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX Laboratories.XIE2_Laboratories >>>', 16, 1)		
		END	
		
END


IF OBJECT_ID('HL7CPInboundMessageConfigurations') IS NOT NULL
BEGIN
		IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[HL7CPInboundMessageConfigurations]') AND name = N'XIE1_HL7CPInboundMessageConfigurations')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE1_HL7CPInboundMessageConfigurations] ON [dbo].[HL7CPInboundMessageConfigurations] 
			(
			[VendorId]  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('HL7CPInboundMessageConfigurations') AND name='XIE1_HL7CPInboundMessageConfigurations')
			PRINT '<<< CREATED INDEX HL7CPInboundMessageConfigurations.XIE1_HL7CPInboundMessageConfigurations >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX HL7CPInboundMessageConfigurations.XIE1_HL7CPInboundMessageConfigurations >>>', 16, 1)		
		END	
END


--HL7CPInboundSegmentConfigurations
IF OBJECT_ID('HL7CPInboundSegmentConfigurations') IS NOT NULL
BEGIN
		IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[HL7CPInboundSegmentConfigurations]') AND name = N'XIE1_HL7CPInboundSegmentConfigurations')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE1_HL7CPInboundSegmentConfigurations] ON [dbo].[HL7CPInboundSegmentConfigurations] 
			(
			[VendorId]  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('HL7CPInboundSegmentConfigurations') AND name='XIE1_HL7CPInboundSegmentConfigurations')
			PRINT '<<< CREATED INDEX HL7CPInboundSegmentConfigurations.XIE1_HL7CPInboundSegmentConfigurations >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX HL7CPInboundSegmentConfigurations.XIE1_HL7CPInboundSegmentConfigurations >>>', 16, 1)		
		END	
END


--HL7CPSegmentConfigurations
IF OBJECT_ID('HL7CPSegmentConfigurations') IS NOT NULL
BEGIN
		IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[HL7CPSegmentConfigurations]') AND name = N'XIE1_HL7CPSegmentConfigurations')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE1_HL7CPSegmentConfigurations] ON [dbo].[HL7CPSegmentConfigurations] 
			(
			[VendorId]  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('HL7CPSegmentConfigurations') AND name='XIE1_HL7CPSegmentConfigurations')
			PRINT '<<< CREATED INDEX HL7CPSegmentConfigurations.XIE1_HL7CPSegmentConfigurations >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX HL7CPSegmentConfigurations.XIE1_HL7CPSegmentConfigurations >>>', 16, 1)		
		END	
END


--HL7CPMessageConfigurations
IF OBJECT_ID('HL7CPMessageConfigurations') IS NOT NULL
BEGIN
		IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[HL7CPMessageConfigurations]') AND name = N'XIE1_HL7CPMessageConfigurations')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE1_HL7CPMessageConfigurations] ON [dbo].[HL7CPMessageConfigurations] 
			(
			[VendorId]  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('HL7CPMessageConfigurations') AND name='XIE1_HL7CPMessageConfigurations')
			PRINT '<<< CREATED INDEX HL7CPMessageConfigurations.XIE1_HL7CPMessageConfigurations >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX HL7CPMessageConfigurations.XIE1_HL7CPMessageConfigurations >>>', 16, 1)		
		END	
END


--HL7CPVendorCommOverrides
IF OBJECT_ID('HL7CPVendorCommOverrides') IS NOT NULL
BEGIN
		IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[HL7CPVendorCommOverrides]') AND name = N'XIE1_HL7CPVendorCommOverrides')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE1_HL7CPVendorCommOverrides] ON [dbo].[HL7CPVendorCommOverrides] 
			(
			[VendorId]  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('HL7CPVendorCommOverrides') AND name='XIE1_HL7CPVendorCommOverrides')
			PRINT '<<< CREATED INDEX HL7CPVendorCommOverrides.XIE1_HL7CPVendorCommOverrides >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX HL7CPVendorCommOverrides.XIE1_HL7CPVendorCommOverrides >>>', 16, 1)		
		END	
END


--OrderLabs

IF OBJECT_ID('OrderLabs') IS NOT NULL
BEGIN
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[OrderLabs]') AND name = N'XIE1_OrderLabs')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE1_OrderLabs] ON [dbo].[OrderLabs] 
			(
			[OrderId]  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('OrderLabs') AND name='XIE1_OrderLabs')
			PRINT '<<< CREATED INDEX OrderLabs.XIE1_OrderLabs >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX OrderLabs.XIE1_OrderLabs >>>', 16, 1)		
		END	
		
	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[OrderLabs]') AND name = N'XIE2_OrderLabs')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE2_OrderLabs] ON [dbo].[OrderLabs] 
			(
			[LaboratoryId]  ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('OrderLabs') AND name='XIE2_OrderLabs')
			PRINT '<<< CREATED INDEX OrderLabs.XIE2_OrderLabs >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX OrderLabs.XIE2_OrderLabs >>>', 16, 1)		
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
IF ((select DataModelVersion FROM SystemConfigurations)  = 19.46)
BEGIN
Update SystemConfigurations set DataModelVersion=19.47
PRINT 'STEP 7 COMPLETED'
END
Go
