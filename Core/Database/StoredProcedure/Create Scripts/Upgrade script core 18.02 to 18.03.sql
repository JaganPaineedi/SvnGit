----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.02)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.02 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------
------ STEP 3 ------------

-----End of Step 3 -------

------ STEP 4 ---------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='SurveillanceDownloadHistory')
BEGIN
/* 
 * TABLE:  SurveillanceDownloadHistory 
 */
 
 CREATE TABLE SurveillanceDownloadHistory(
		SurveillanceDownloadHistoryId		INT IDENTITY(1,1)		NOT NULL,
		CreatedBy							type_CurrentUser		NOT NULL,
		CreatedDate							type_CurrentDatetime	NOT NULL,
		ModifiedBy							type_CurrentUser		NOT NULL,
		ModifiedDate						type_CurrentDatetime	NOT NULL,
		RecordDeleted						type_YOrN				NULL
											CHECK (RecordDeleted in	('Y','N')),	
		DeletedBy							type_UserId				NULL,
		DeletedDate							datetime				NULL,
		DocumentId							int						NULL,
		LastDownload						datetime				NULL,
		CONSTRAINT SurveillanceDownloadHistory_PK PRIMARY KEY CLUSTERED (SurveillanceDownloadHistoryId)
 ) 
 IF OBJECT_ID('SurveillanceDownloadHistory') IS NOT NULL
	PRINT '<<< CREATED TABLE SurveillanceDownloadHistory >>>'
ELSE
	RAISERROR('<<< FAILED CREATING TABLE SurveillanceDownloadHistory >>>', 16, 1)	
	
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('SurveillanceDownloadHistory') AND name='XIE1_SurveillanceDownloadHistory')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_SurveillanceDownloadHistory] ON [dbo].[SurveillanceDownloadHistory] 
		(
		DocumentId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('SurveillanceDownloadHistory') AND name='XIE1_SurveillanceDownloadHistory')
		PRINT '<<< CREATED INDEX SurveillanceDownloadHistory.XIE1_SurveillanceDownloadHistory >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX SurveillanceDownloadHistory.XIE1_SurveillanceDownloadHistory >>>', 16, 1)		
		END 
		
	
/* 
 * TABLE: SurveillanceDownloadHistory 
 */	

ALTER TABLE SurveillanceDownloadHistory ADD CONSTRAINT Documents_SurveillanceDownloadHistory_FK 
	FOREIGN KEY (DocumentId)
	REFERENCES Documents(DocumentId)
	
		
PRINT 'STEP 4(A) COMPLETED'
		
END
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 18.02)
BEGIN
Update SystemConfigurations set DataModelVersion=18.03
PRINT 'STEP 7 COMPLETED'
END
Go

