----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.85)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.85 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------

-----END Of STEP 3--------------------

------ STEP 4 ------------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='DocumentASAMs')
BEGIN
/* 
 * TABLE: DocumentASAMs 
 */
 CREATE TABLE DocumentASAMs( 
			DocumentVersionId						int						NOT NULL,
			CreatedBy								type_CurrentUser		NOT NULL,
			CreatedDate								type_CurrentDatetime	NOT NULL,
			ModifiedBy								type_CurrentUser		NOT NULL,
			ModifiedDate							type_CurrentDatetime	NOT NULL,
			RecordDeleted							type_YOrN				NULL
													CHECK (RecordDeleted in ('Y','N')),			
			DeletedDate								datetime				NULL,
			DeletedBy								type_UserId				NULL,
			Dimension1LevelOfCare					int						NULL,	
			Dimension1Level							type_GlobalCode			NULL,	
			Dimension1DocumentedRisk				type_GlobalCode			NULL,	
			Dimension1Comments						type_Comment2			NULL,
			Dimension1Summary						type_Comment2			NULL,
			Dimension2LevelOfCare					int						NULL,
			Dimension2Level							type_GlobalCode			NULL,	
			Dimension2DocumentedRisk				type_GlobalCode			NULL,	
			Dimension2Comments						type_Comment2			NULL,
			Dimension2Summary						type_Comment2			NULL,
			Dimension3LevelOfCare					int						NULL,
			Dimension3Level							type_GlobalCode			NULL,	
			Dimension3DocumentedRisk				type_GlobalCode			NULL,	
			Dimension3Comments						type_Comment2			NULL,
			Dimension3Summary						type_Comment2			NULL,
			Dimension4LevelOfCare					int						NULL,
			Dimension4Level							type_GlobalCode			NULL,	
			Dimension4DocumentedRisk				type_GlobalCode			NULL,	
			Dimension4Comments						type_Comment2			NULL,
			Dimension4Summary						type_Comment2			NULL,
			Dimension5LevelOfCare					int						NULL,
			Dimension5Level							type_GlobalCode			NULL,	
			Dimension5DocumentedRisk				type_GlobalCode			NULL,	
			Dimension5Comments						type_Comment2			NULL,
			Dimension5Summary						type_Comment2			NULL,
			Dimension6LevelOfCare					int						NULL,
			Dimension6Level							type_GlobalCode			NULL,	
			Dimension6DocumentedRisk				type_GlobalCode			NULL,	
			Dimension6Comments						type_Comment2			NULL,
			Dimension6Summary						type_Comment2			NULL,						
			IndicatedReferredLevel					type_GlobalCode			NULL,	
			ProvidedLevel							type_GlobalCode			NULL,	
			FinalDeterminationComments				type_Comment2			NULL,	
			FinalDeterminationSummary				type_Comment2			NULL,
			CONSTRAINT DocumentASAMs_PK PRIMARY KEY CLUSTERED (DocumentVersionId)

 )
  IF OBJECT_ID('DocumentASAMs') IS NOT NULL
    PRINT '<<< CREATED TABLE DocumentASAMs >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE DocumentASAMs >>>', 16, 1)
/* 
 * TABLE: DocumentASAMs 
 */ 
	ALTER TABLE DocumentASAMs ADD CONSTRAINT DocumentVersions_DocumentASAMs_FK
	FOREIGN KEY (DocumentVersionId)
	REFERENCES DocumentVersions (DocumentVersionId)
            
    PRINT 'STEP 4 COMPLETED'
END


-- Script for key SHOWASAMSUMMARY   in System Configuration Keys table


IF NOT EXISTS (
  SELECT [key]
  FROM SystemConfigurationKeys
  WHERE [key] = 'SHOWASAMSUMMARY'
  )
BEGIN
 INSERT INTO [dbo].[SystemConfigurationKeys] (
  CreatedBy
  ,CreateDate
  ,ModifiedBy
  ,ModifiedDate
  ,[Key]
  ,Value
  ,[Description]
  )
 VALUES (
  'SHSDBA'
  ,GETDATE()
  ,'SHSDBA'
  ,GETDATE()
  ,'SHOWASAMSUMMARY'
  ,'N'  --Default this setting to ‘N’
  ,'To display the ASAM Document summary tab on each screen.Y = show all summary fields , N = do not show summary field  - default N'
  )
END


----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.85)
BEGIN
Update SystemConfigurations set DataModelVersion=15.86
PRINT 'STEP 7 COMPLETED'
END
Go