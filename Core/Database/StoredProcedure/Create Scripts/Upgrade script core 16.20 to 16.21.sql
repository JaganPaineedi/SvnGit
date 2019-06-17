----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.20)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.20 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------

-- Changed Column(s) DataType in ClientContactsAddressHistory Table

IF OBJECT_ID('ClientContactsAddressHistory')IS NOT NULL
BEGIN
	IF EXISTS( select 1 from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = 'ClientContactsAddressHistory' and COLUMN_NAME = 'Address'  and DOMAIN_NAME='type_Address')
	BEGIN
		ALTER TABLE ClientContactsAddressHistory ALTER COLUMN [Address] VARCHAR(200)  NULL
	END
	
	IF EXISTS( select 1 from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = 'ClientContactsAddressHistory' and COLUMN_NAME = 'Display'  and DOMAIN_NAME='type_AddressDisplay')
	BEGIN
		ALTER TABLE ClientContactsAddressHistory ALTER COLUMN Display VARCHAR(300)  NULL
	END

	PRINT 'STEP 3 COMPLETED'
END 

-----END Of STEP 3--------------------

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.20)
BEGIN
Update SystemConfigurations set DataModelVersion=16.21
PRINT 'STEP 7 COMPLETED'
END
Go


