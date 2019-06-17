----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.21)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.21 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------
-- add column to OrderQuestions
IF OBJECT_ID('OrderQuestions') IS NOT NULL
BEGIN
 IF COL_LENGTH('OrderQuestions','LaboratoryId')IS NULL
 BEGIN 
  ALTER TABLE OrderQuestions ADD LaboratoryId  int NULL  														 
 END
 
  IF COL_LENGTH('OrderQuestions','QuestionCode')IS NULL
 BEGIN 
  ALTER TABLE OrderQuestions ADD QuestionCode  varchar(100) NULL  														 
 END
 
END

 IF OBJECT_ID('Laboratories') IS NOT NULL
BEGIN
 ---- add column to Laboratories
 IF COL_LENGTH('Laboratories','ReferenceLabId')IS NULL
 BEGIN 
  ALTER TABLE Laboratories ADD ReferenceLabId  varchar(50) NULL  													 
 END
 END
 
 PRINT 'STEP  3 COMPLETED'
------ END OF STEP 3 -----

------ STEP 4 ---------- 

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='OrderLabs')
BEGIN
/* 
 * TABLE: OrderLabs 
 */ 
CREATE TABLE OrderLabs(
		OrderLabId					int identity(1,1)			NOT NULL,
		CreatedBy					type_CurrentUser			NOT NULL,
		CreatedDate					type_CurrentDatetime		NOT NULL,
		ModifiedBy					type_CurrentUser			NOT NULL,
		ModifiedDate				type_CurrentDatetime		NOT NULL,
		RecordDeleted				type_YOrN					NULL
									CHECK (RecordDeleted in ('Y','N')),
		DeletedBy					type_UserId					NULL,
		DeletedDate					datetime					NULL,
		OrderId						int							NULL,
		LaboratoryId				int							NULL,
		ExternalOrderId				varchar(100)				NULL,
		IsDefault					type_YOrN					NULL  
									CHECK (IsDefault in ('Y','N')),
		CPT							varchar(500)				NULL,
		OrderCode					varchar(200)				NULL,
		CONSTRAINT OrderLabs_PK PRIMARY KEY CLUSTERED (OrderLabId)		 	
)
 IF OBJECT_ID('OrderLabs') IS NOT NULL
    PRINT '<<< CREATED TABLE OrderLabs >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE OrderLabs >>>', 16, 1)
	
/*  
 * TABLE: OrderLabs 
 */ 
 
 ALTER TABLE OrderLabs ADD CONSTRAINT Orders_OrderLabs_FK
    FOREIGN KEY (OrderId)
    REFERENCES Orders(OrderId)
    
 ALTER TABLE OrderLabs ADD CONSTRAINT Laboratories_OrderLabs_FK
    FOREIGN KEY (LaboratoryId)
    REFERENCES  Laboratories(LaboratoryId)
    
PRINT 'STEP 4 COMPLETED'
END

--END Of STEP 4 ------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.21)
BEGIN
Update SystemConfigurations set DataModelVersion=15.22
PRINT 'STEP 7 COMPLETED'
END
Go
