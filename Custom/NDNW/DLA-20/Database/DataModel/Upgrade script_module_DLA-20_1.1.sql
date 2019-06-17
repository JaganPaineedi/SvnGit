----- STEP 1 ----------
IF (((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_DLA-20')  < 1.0 )or 
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_DLA-20'))
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.0 for CDM_DLA-20 update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----END Of STEP 2 -------

------ STEP 3 ------------
IF OBJECT_ID('CustomDocumentDLA20s')IS NOT NULL
BEGIN
		
	IF COL_LENGTH('CustomDocumentDLA20s','NoDLA') IS NULL
	BEGIN
		 ALTER TABLE CustomDocumentDLA20s ADD NoDLA type_YOrN	 NULL
										 CHECK (NoDLA in ('Y','N'))
		 EXEC sys.sp_addextendedproperty 'CustomDocumentDLA20s_Description'
		,'NoDLA column  To store the value which decides we need to fill DLA or not'
		,'schema'
		,'dbo'
		,'table'
		,'CustomDocumentDLA20s'
		,'column'
		,'NoDLA'
		
	END
	
	 PRINT 'STEP 3 COMPLETED'
END
------ END OF STEP 3 -----
 
------ STEP 4 ------------

------END Of STEP 4-------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_DLA-20')  = 1.0)
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.1' WHERE [key] = 'CDM_DLA-20'
		PRINT 'STEP 7 COMPLETED'
END
GO

