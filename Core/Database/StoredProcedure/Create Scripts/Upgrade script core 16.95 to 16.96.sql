----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.95)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.95 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------
/* Add ERProcessingTemplateId to CoveragePlans table */
IF OBJECT_ID('ERProcessingTemplates') IS NOT NULL
BEGIN
	IF COL_LENGTH('CoveragePlans','ERProcessingTemplateId')IS NULL
	BEGIN
	  ALTER TABLE CoveragePlans ADD ERProcessingTemplateId int NULL
	END
	
		IF COL_LENGTH('CoveragePlans','ERProcessingTemplateId')IS NOT NULL
		BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[ERProcessingTemplates_CoveragePlans_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CoveragePlans]'))
			BEGIN
			ALTER TABLE CoveragePlans ADD CONSTRAINT ERProcessingTemplates_CoveragePlans_FK 
				FOREIGN KEY (ERProcessingTemplateId)
				REFERENCES ERProcessingTemplates(ERProcessingTemplateId) 
			END
		END
END
------ END OF STEP 3 -----

------ STEP 4 ----------
  
 --END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.95)
BEGIN
Update SystemConfigurations set DataModelVersion=16.96
PRINT 'STEP 7 COMPLETED'
END
Go
