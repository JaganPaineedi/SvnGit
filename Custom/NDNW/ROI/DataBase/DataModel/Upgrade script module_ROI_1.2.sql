----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------
----Add New Columns in CustomDocumentRevokeReleaseOfInformations Table 	
IF OBJECT_ID('CustomDocumentRevokeReleaseOfInformations') IS NOT NULL
BEGIN
	IF COL_LENGTH('CustomDocumentRevokeReleaseOfInformations','ClientUnableToGiveWrittenConsent')IS NULL
	BEGIN
	 ALTER TABLE CustomDocumentRevokeReleaseOfInformations ADD  ClientUnableToGiveWrittenConsent  type_YOrN	NULL
														   CHECK (ClientUnableToGiveWrittenConsent in ('Y','N'))	
	
	END
	
	IF COL_LENGTH('CustomDocumentRevokeReleaseOfInformations','RevokeROSComments')IS NULL
	BEGIN
	 ALTER TABLE CustomDocumentRevokeReleaseOfInformations ADD  RevokeROSComments type_Comment2	NULL									 
	END
		
PRINT 'STEP 3 COMPLETED'
END

------ END OF STEP 3 -----

------ STEP 4 ----------

--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF NOT EXISTS (	SELECT [key] FROM SystemConfigurationKeys	WHERE [key] = 'CDM_ROI')
BEGIN
	INSERT INTO SystemConfigurationKeys (
		CreatedBy
		,CreateDate
		,ModifiedBy
		,ModifiedDate
		,[key]
		,Value
		)
	VALUES (
		'SHSDBA'
		,GETDATE()
		,'SHSDBA'
		,GETDATE()
		,'CDM_ROI'
		,'1.2'
		)
END
ELSE 
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.2' WHERE [key] = 'CDM_ROI'
END
PRINT 'STEP 7 COMPLETED'
GO