----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.35)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.35 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

IF EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='WhiteBoardAdmissionFlags')
 BEGIN
	 DROP TABLE WhiteBoardAdmissionFlags
	 PRINT 'STEP 3 COMPLETED'

 END
------ STEP 3 ------------

------ END Of STEP 3 ------------

------ STEP 4 ---------------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='WhiteBoardPrecautions')
 BEGIN
/* 
 * TABLE: WhiteBoardPrecautions  
 */

CREATE TABLE WhiteBoardPrecautions(
    WhiteBoardPrecautionId 				int identity(1,1)			NOT NULL,
    CreatedBy							type_CurrentUser			NOT NULL,
    CreatedDate							type_CurrentDatetime		NOT NULL,
    ModifiedBy							type_CurrentUser			NOT NULL,
    ModifiedDate						type_CurrentDatetime		NOT NULL,
    RecordDeleted						type_YOrN					NULL
										CHECK (RecordDeleted in	('Y','N')),
    DeletedBy							type_UserId					NULL,
    DeletedDate							datetime					NULL,
	WhiteBoardInfoId					int							NULL,
	PrecautionId						type_GlobalCode				NOT NULL, --Foreign Key to GlobalCodes.GlobalCodeId
	PrecautionComment					VARCHAR(500)				NULL,											
    CONSTRAINT WhiteBoardPrecautions_PK PRIMARY KEY CLUSTERED (WhiteBoardPrecautionId)		 	
)
 IF OBJECT_ID('WhiteBoardPrecautions') IS NOT NULL
    PRINT '<<< CREATED TABLE WhiteBoardPrecautions >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE WhiteBoardPrecautions >>>', 16, 1)

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('WhiteBoardPrecautions') AND name='XIE1_WhiteBoardPrecautions')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_WhiteBoardPrecautions] ON [dbo].[WhiteBoardPrecautions] 
		(
		WhiteBoardInfoId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('WhiteBoardPrecautions') AND name='XIE1_WhiteBoardPrecautions')
		PRINT '<<< CREATED INDEX WhiteBoardPrecautions.XIE1_WhiteBoardPrecautions >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX WhiteBoardPrecautions.XIE1_WhiteBoardPrecautions >>>', 16, 1)		
		END  
   	
/*  
 * TABLE: WhiteBoardPrecautions 
 */ 
 
 ALTER TABLE WhiteBoardPrecautions ADD CONSTRAINT WhiteBoard_WhiteBoardPrecautions_FK 
	FOREIGN KEY (WhiteBoardInfoId)
	REFERENCES WhiteBoard(WhiteBoardInfoId)
    
PRINT 'STEP 4(A) COMPLETED'
END	
 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.35)
BEGIN
Update SystemConfigurations set DataModelVersion=18.36
PRINT 'STEP 7 COMPLETED'
END
Go
