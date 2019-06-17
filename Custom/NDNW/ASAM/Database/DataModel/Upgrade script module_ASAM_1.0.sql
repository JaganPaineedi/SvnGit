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
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentASAMs')
BEGIN
/* 
 * TABLE: CustomDocumentASAMs 
 */
 CREATE TABLE CustomDocumentASAMs( 
		DocumentVersionId				int						NOT NULL,
		CreatedBy						type_CurrentUser		NOT NULL,
		CreatedDate						type_CurrentDatetime	NOT NULL,
		ModifiedBy						type_CurrentUser		NOT NULL,
		ModifiedDate					type_CurrentDatetime	NOT NULL,
		RecordDeleted					type_YOrN				NULL
										CHECK (RecordDeleted in ('Y','N')),
		DeletedBy						type_UserId				NULL,
		DeletedDate						datetime				NULL,
		Dimension1						char(1)					NULL
										CHECK (Dimension1 in ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H')),
		D1Level							type_GlobalCode			NULL,
		D1Risk							type_GlobalCode			NULL,
		D1Comments						type_Comment2			NULL,
		Dimension2						char(1)					NULL
										CHECK (Dimension2 in ('A', 'B', 'C', 'D', 'E', 'F', 'G')),
		D2Level							type_GlobalCode			NULL,
		D2Risk							type_GlobalCode			NULL,
		D2Comments						type_Comment2			NULL,
		Dimension3						char(1)					NULL
										CHECK (Dimension3 in ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H')),
		D3Level							type_GlobalCode			NULL,
		D3Risk							type_GlobalCode			NULL,
		D3Comments						type_Comment2			NULL,
		Dimension4						char(1)					NULL
										CHECK (Dimension4 in ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H')),
		D4Level							type_GlobalCode			NULL,
		D4Risk							type_GlobalCode			NULL,
		D4Comments						type_Comment2			NULL,
		Dimension5						char(1)					NULL
										CHECK (Dimension5 in ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H')),
		D5Level							type_GlobalCode			NULL,
		D5Risk							type_GlobalCode			NULL,
		D5Comments						type_Comment2			NULL,
		Dimension6						char(1)					NULL
										CHECK (Dimension6 in ('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H')),
		D6Level							type_GlobalCode			NULL,
		D6Risk							type_GlobalCode			NULL,
		D6Comments						type_Comment2			NULL,		
		IndicatedReferredLevel			type_GlobalCode			NULL,
		ProvidedLevel					type_GlobalCode			NULL,
		FinalDeterminationComments		type_Comment2			NULL,
		D1CarePlan						type_YOrN				NULL
										CHECK (D1CarePlan in ('Y','N')),
		D2CarePlan						type_YOrN				NULL
										CHECK (D2CarePlan in ('Y','N')),
		D3CarePlan						type_YOrN				NULL
										CHECK (D3CarePlan in ('Y','N')),
		D4CarePlan						type_YOrN				NULL
										CHECK (D4CarePlan in ('Y','N')),
        D5CarePlan						type_YOrN				NULL
										CHECK (D5CarePlan in ('Y','N')),
	    D6CarePlan						type_YOrN				NULL
										CHECK (D6CarePlan in ('Y','N')),																																											
	CONSTRAINT CustomDocumentASAMs_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentASAMs') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentASAMs >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentASAMs >>>', 16, 1)
/* 
 * TABLE: CustomDocumentASAMs 
 */   

    
ALTER TABLE CustomDocumentASAMs ADD CONSTRAINT DocumentVersions_CustomDocumentASAMs_FK
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
        
     PRINT 'STEP 4 COMPLETED'
 END

 
  ---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------


IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_ASAM')
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
				   ,'CDM_ASAM'
				   ,'1.0'
				   )
		PRINT 'STEP 7 COMPLETED'
	END
 GO
