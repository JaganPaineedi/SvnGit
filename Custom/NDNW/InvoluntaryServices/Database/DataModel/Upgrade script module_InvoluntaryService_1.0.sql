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
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentInvoluntaryServices')
BEGIN
/* 
 TABLE: CustomDocumentInvoluntaryServices 
 */ 
 CREATE TABLE CustomDocumentInvoluntaryServices( 
		DocumentVersionId							int					 NOT NULL,
		CreatedBy									type_CurrentUser     NOT NULL,
		CreatedDate									type_CurrentDatetime NOT NULL,
		ModifiedBy									type_CurrentUser     NOT NULL,
		ModifiedDate								type_CurrentDatetime NOT NULL,
		RecordDeleted								type_YOrN			 NULL
													CHECK (RecordDeleted in ('Y','N')),
		DeletedBy									type_UserId          NULL,
		DeletedDate									datetime			 NULL,
		SIDNumber									int					 NULL,
		ServiceStatus								type_GlobalCode		 NULL,
		TypeOfPetition								type_GlobalCode		 NULL,
		DateOfPetition								datetime			 NULL,
		HearingRecommended							type_GlobalCode		 NULL,
		ReasonForHearing							type_GlobalCode		 NULL,
		BasisForInvoluntaryServices					type_GlobalCode		 NULL,
		DispositionByJudge							type_GlobalCode		 NULL,
		InvoluntaryServicesCommitted				type_GlobalCode		 NULL,
		ServiceSettingAssignedTo					type_GlobalCode		 NULL,
		DateOfCommitment							datetime			 NULL,
		LengthOfCommitment							int					 NULL,		
		PeriodOfIntensiveTreatment					datetime			 NULL,
		CONSTRAINT CustomDocumentInvoluntaryServices_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
 
  IF OBJECT_ID('CustomDocumentInvoluntaryServices') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentInvoluntaryServices >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentInvoluntaryServices >>>', 16, 1)
/* 
 * TABLE: CustomDocumentInvoluntaryServices 
 */   
 
 ALTER TABLE CustomDocumentInvoluntaryServices ADD CONSTRAINT DocumentVersions_CustomDocumentInvoluntaryServices_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
 
 PRINT 'STEP 4 COMPLETED'
 END
 
 --END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

If NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_InvoluntaryService')
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
				   ,'CDM_InvoluntaryService'
				   ,'1.0'
				   )

		PRINT 'STEP 7 COMPLETED'     
	END
Go