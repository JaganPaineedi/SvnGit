----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 20.07)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 20.07 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 -----------

------ END Of STEP 3 ------------

------ STEP 4 ---------------

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='SUDrugs')
BEGIN
/*  
 * TABLE: SUDrugs 
 */
CREATE TABLE SUDrugs(
			SUDrugId									int	IDENTITY(1,1)		NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,		
			DrugName									varchar(100)			NOT NULL,
			DrugDescription								varchar(500)			NULL,
			CanBePrescribed								type_YOrN               NULL
														CHECK (CanBePrescribed in ('Y','N')),
			Active										type_Active             NULL
														CHECK (Active in ('Y','N')),
			CommonStreetNames							varchar(max)			NULL,
			SortOrder									int						NULL,
			CONSTRAINT SUDrugs_PK PRIMARY KEY CLUSTERED (SUDrugId) 
 )
 
  IF OBJECT_ID('SUDrugs') IS NOT NULL
    PRINT '<<< CREATED TABLE SUDrugs >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE SUDrugs >>>', 16, 1)
    
/* 
 * TABLE: SUDrugs 
 */ 
         
	PRINT 'STEP 4(A) COMPLETED'
END

 ----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 20.07)
BEGIN
Update SystemConfigurations set DataModelVersion=20.08
PRINT 'STEP 7 COMPLETED'
END

Go
