----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.06)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.06 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------

-----END Of STEP 3--------

------ STEP 4 ------------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='AdjudicationProcessBatches')
 BEGIN
/* 
 * TABLE: AdjudicationProcessBatches 
 */
CREATE TABLE AdjudicationProcessBatches(
	BatchId								int						NOT NULL,
	StaffId								int				        NOT NULL,
	ScrollId							type_GUID				NOT NULL,
    CONSTRAINT AdjudicationProcessBatches_PK PRIMARY KEY CLUSTERED (BatchId,StaffId,ScrollId)
)
IF OBJECT_ID('AdjudicationProcessBatches') IS NOT NULL
    PRINT '<<< CREATED TABLE AdjudicationProcessBatches >>>'
ELSE
   RAISERROR('<<< FAILED CREATING TABLE AdjudicationProcessBatches >>>', 16, 1)
   
   
/* 
 * TABLE: AdjudicationProcessBatches 
 */

 ALTER TABLE AdjudicationProcessBatches ADD CONSTRAINT AdjudicationBatches_AdjudicationProcessBatches_FK
    FOREIGN KEY (BatchId)
    REFERENCES AdjudicationBatches(BatchId)
    
     PRINT 'STEP 4(A) COMPLETED'
END
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.06)
BEGIN
Update SystemConfigurations set DataModelVersion=16.07
PRINT 'STEP 7 COMPLETED'
END
Go



