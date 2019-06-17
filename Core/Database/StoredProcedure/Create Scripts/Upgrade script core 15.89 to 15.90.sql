----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.89)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.89 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of Step 2 -------

------ STEP 3 --------------

/* Added Column(s) in HL7CPVendorConfigurations table */

IF OBJECT_ID('HL7CPVendorConfigurations')  IS NOT NULL
BEGIN
	IF COL_LENGTH('HL7CPVendorConfigurations','AcceptAckType') IS NULL
	BEGIN
		 ALTER TABLE HL7CPVendorConfigurations ADD AcceptAckType varchar(10) NULL
	END

	IF COL_LENGTH('HL7CPVendorConfigurations','AppAckType') IS NULL
	BEGIN
		 ALTER TABLE HL7CPVendorConfigurations ADD AppAckType varchar(10) NULL
	END

	IF COL_LENGTH('HL7CPVendorConfigurations','MessageProfileIdentifier') IS NULL
	BEGIN
		 ALTER TABLE HL7CPVendorConfigurations ADD MessageProfileIdentifier varchar(250) NULL
	END
		
	PRINT 'STEP 3 COMPLETED'
END
		
------ END OF STEP 3 -------

------ STEP 4 ---------------
  
 ------END Of STEP 4----------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.89)
BEGIN
Update SystemConfigurations set DataModelVersion=15.90
PRINT 'STEP 7 COMPLETED'
END
Go
