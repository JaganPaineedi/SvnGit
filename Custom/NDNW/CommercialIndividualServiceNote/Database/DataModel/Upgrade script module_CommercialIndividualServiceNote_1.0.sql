----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

--PRINT 'STEP 3 COMPLETED'
------ END OF STEP 3 -----

------ STEP 4 ----------
IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentCommercialIndividualServiceNotes')
 BEGIN
/*  
 * TABLE: CustomDocumentCommercialIndividualServiceNotes 
 */

CREATE TABLE CustomDocumentCommercialIndividualServiceNotes(
    DocumentVersionId			int                      NOT NULL,
    CreatedBy					type_CurrentUser         NOT NULL,
    CreatedDate					type_CurrentDatetime	 NOT NULL,
    ModifiedBy					type_CurrentUser         NOT NULL,
    ModifiedDate				type_CurrentDatetime	 NOT NULL,
    RecordDeleted				type_YOrN                NULL
								CHECK (RecordDeleted in	('Y','N')),
    DeletedBy					type_UserId				 NULL,
    DeletedDate					datetime                 NULL,
    SituationInterventionPlan 	type_Comment2			 NULL,
	AddressProgressToGoal 		type_Comment2			 NULL,
	CONSTRAINT CustomDocumentCommercialIndividualServiceNotes_PK PRIMARY KEY CLUSTERED (DocumentVersionId) 
 )
  IF OBJECT_ID('CustomDocumentCommercialIndividualServiceNotes') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentCommercialIndividualServiceNotes >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomDocumentCommercialIndividualServiceNotes >>>', 16, 1)
/* 
 * TABLE: CustomDocumentCommercialIndividualServiceNotes 
 */
    
ALTER TABLE CustomDocumentCommercialIndividualServiceNotes ADD CONSTRAINT DocumentVersions_CustomDocumentCommercialIndividualServiceNotes_FK
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


IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_CommercialIndividualServiceNote')
	BEGIN
		INSERT INTO SystemConfigurationKeys
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_CommercialIndividualServiceNote'
				   ,'1.0'
				   )
		PRINT 'STEP 7 COMPLETED'
	END
 GO
