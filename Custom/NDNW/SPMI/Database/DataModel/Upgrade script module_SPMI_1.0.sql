----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

------ STEP 4 ----------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentSPMIs')
BEGIN
/* 
 * TABLE: CustomDocumentSPMIs 
 */
 CREATE TABLE CustomDocumentSPMIs( 
		DocumentVersionId					int					 NOT NULL,
		CreatedBy							type_CurrentUser     NOT NULL,
		CreatedDate							type_CurrentDatetime NOT NULL,
		ModifiedBy							type_CurrentUser     NOT NULL,
		ModifiedDate						type_CurrentDatetime NOT NULL,
		RecordDeleted						type_YOrN			 NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId          NULL,
		DeletedDate							datetime			 NULL,
		Schizophrenia						type_YOrN			 NULL
											CHECK (Schizophrenia in ('Y','N')),
		MajorDepression						type_YOrN			 NULL
											CHECK (MajorDepression in ('Y','N')),						
		Anxiety								type_YOrN			 NULL
											CHECK (Anxiety in ('Y','N')),
		Personality							type_YOrN			 NULL
											CHECK (Personality in ('Y','N')),
		Individual							type_YOrN			 NULL
											CHECK (Individual in ('Y','N')),
		CONSTRAINT CustomDocumentSPMIs_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentSPMIs') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentSPMIs >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentSPMIs >>>', 16, 1)
/* 
 * TABLE: CustomDocumentSPMIs 
 */   
 
 ALTER TABLE CustomDocumentSPMIs ADD CONSTRAINT DocumentVersions_CustomDocumentSPMIs_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
    
 PRINT 'STEP 4 COMPLETED'
 END
 
 ---------------------------------------------------------------------------------------------
--END Of STEP 4 ------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

If NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_SPMI')
	BEGIN
		INSERT INTO [dbo].[SystemConfigurationKeys]
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[Key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_SPMI'
				   ,'1.0'
				   )

		PRINT 'STEP 7 COMPLETED'     
	END
Go
 
		