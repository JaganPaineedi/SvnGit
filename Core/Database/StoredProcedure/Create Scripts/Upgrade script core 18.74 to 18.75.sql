----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.74)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.74 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------

--END Of STEP 3------------
------ STEP 4 ----------
IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='OrderDiagnosis')
BEGIN
/*		  
 * TABLE: OrderDiagnosis
 */ 
CREATE TABLE OrderDiagnosis(
		 OrderDiagnosisId			 				int identity(1,1)		NOT NULL,
		 CreatedBy									type_CurrentUser		NOT NULL,
		 CreatedDate								type_CurrentDatetime	NOT NULL,
		 ModifiedBy									type_CurrentUser		NOT NULL,
		 ModifiedDate								type_CurrentDatetime	NOT NULL,
		 RecordDeleted								type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),
		 DeletedBy									type_UserId				NULL,
		 DeletedDate								datetime				NULL,
		 OrderId									int						NULL,
		 ICD10CodeId								int						NULL,
		 IsDefault									type_YOrN				NULL
													CHECK (IsDefault in ('Y','N')),
		 ICDCode									varchar(20)				NULL,
		 ICDDescription								varchar(max)			NULL,	
		 CONSTRAINT OrderDiagnosis_PK PRIMARY KEY CLUSTERED (OrderDiagnosisId) 
) 

 IF OBJECT_ID('OrderDiagnosis') IS NOT NULL
    PRINT '<<< CREATED TABLE OrderDiagnosis >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE OrderDiagnosis >>>', 16, 1)
    
    
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('OrderDiagnosis') AND name='XIE1_OrderDiagnosis')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_OrderDiagnosis] ON [dbo].[OrderDiagnosis] 
		(
		OrderId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('OrderDiagnosis') AND name='XIE1_OrderDiagnosis')
		PRINT '<<< CREATED INDEX OrderDiagnosis.XIE1_OrderDiagnosis>>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX OrderDiagnosis.XIE1_OrderDiagnosis >>>', 16, 1)		
		END	 
		
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('OrderDiagnosis') AND name='XIE2_OrderDiagnosis')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_OrderDiagnosis] ON [dbo].[OrderDiagnosis] 
		(
		ICD10CodeId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('OrderDiagnosis') AND name='XIE2_OrderDiagnosis')
		PRINT '<<< CREATED INDEX OrderDiagnosis.XIE2_OrderDiagnosis>>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX OrderDiagnosis.XIE2_OrderDiagnosis >>>', 16, 1)		
		END	 
    
/* 
 * TABLE: OrderDiagnosis 
 */ 
 
 ALTER TABLE OrderDiagnosis ADD CONSTRAINT Orders_OrderDiagnosis_FK
	FOREIGN KEY (OrderId)
	REFERENCES Orders(OrderId) 
	
 ALTER TABLE OrderDiagnosis ADD CONSTRAINT DiagnosisICD10Codes_OrderDiagnosis_FK
	FOREIGN KEY (ICD10CodeId)
	REFERENCES DiagnosisICD10Codes(ICD10CodeId) 
        
PRINT 'STEP 4(A) COMPLETED'
END

------END Of STEP 4---------------

------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.74)
BEGIN
Update SystemConfigurations set DataModelVersion=18.75
PRINT 'STEP 7 COMPLETED'
END
Go
