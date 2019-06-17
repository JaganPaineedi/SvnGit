----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.83)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.83 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of STEP 2 -------

------ STEP 3 ------------

-----END Of STEP 3--------------------

------ STEP 4 ------------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='DocumentSyndromicSurveillances')
BEGIN
/* 
  TABLE: DocumentSyndromicSurveillances 
 */
 CREATE TABLE DocumentSyndromicSurveillances( 
		DocumentVersionId					int					 NOT NULL,
		CreatedBy							type_CurrentUser     NOT NULL,
		CreatedDate							type_CurrentDatetime NOT NULL,
		ModifiedBy							type_CurrentUser     NOT NULL,
		ModifiedDate						type_CurrentDatetime NOT NULL,
		RecordDeleted						type_YOrN			 NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId          NULL,
		DeletedDate							datetime             NULL,									
		GeneralType							type_GlobalCode		 NULL,
		AdmissionDateTime					datetime			 NULL,
		DischargeDateTime					datetime			 NULL,
		DeathDateTime						datetime			 NULL,
		DischargeReason						type_GlobalCode		 NULL,
		ChiefComplaint						type_Comment2		 NULL,
		FacilityVisitType					type_GlobalCode		 NULL,
		CONSTRAINT DocumentSyndromicSurveillances_PK PRIMARY KEY CLUSTERED (DocumentVersionId)	 
 )
 
  IF OBJECT_ID('DocumentSyndromicSurveillances') IS NOT NULL
    PRINT '<<< CREATED TABLE DocumentSyndromicSurveillances >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE DocumentSyndromicSurveillances >>>', 16, 1)
         
/* 
 * TABLE: DocumentSyndromicSurveillances 
 */         
   
 ALTER TABLE DocumentSyndromicSurveillances ADD CONSTRAINT DocumentVersions_DocumentSyndromicSurveillances_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
    
    
EXEC sys.sp_addextendedproperty 'DocumentSyndromicSurveillances_Description'
	,'GeneralType Field Store the GlobalCode Id of Admission, Discharge, Registration and Update values'
	,'schema'
	,'dbo'
	,'table'
	,'DocumentSyndromicSurveillances'
	,'column'
	,'GeneralType'
       
     PRINT 'STEP 4(A) COMPLETED'
 END
 
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.83)
BEGIN
Update SystemConfigurations set DataModelVersion=16.84
PRINT 'STEP 7 COMPLETED'
END
Go



