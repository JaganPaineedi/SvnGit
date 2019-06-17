----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.03)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.03 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 -----------

-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('Programs') IS NOT NULL
BEGIN
	 IF COL_LENGTH('Programs ','Mobile') IS NULL
	 BEGIN
		ALTER TABLE  Programs  ADD Mobile type_YOrNOrNA	 NULL
		                       CHECK (Mobile in ('Y','N','A'))
	 END
END


IF OBJECT_ID('ProcedureCodes') IS NOT NULL
BEGIN
	 IF COL_LENGTH('ProcedureCodes ','Mobile') IS NULL
	 BEGIN
		ALTER TABLE  ProcedureCodes  ADD Mobile type_YOrNOrNA	 NULL
		                             CHECK (Mobile in ('Y','N','A'))
	 END
END

IF OBJECT_ID('Locations') IS NOT NULL
BEGIN
	 IF COL_LENGTH('Locations ','Mobile') IS NULL
	 BEGIN
		ALTER TABLE  Locations  ADD Mobile type_YOrNOrNA	 NULL
		                        CHECK (Mobile in ('Y','N','A'))
	 END
END

IF OBJECT_ID('DocumentCodes') IS NOT NULL
BEGIN
	 IF COL_LENGTH('DocumentCodes ','Mobile') IS NULL
	 BEGIN
		ALTER TABLE  DocumentCodes  ADD Mobile type_YOrNOrNA	 NULL
		                            CHECK (Mobile in ('Y','N','A'))
	 END
END


IF OBJECT_ID('Forms') IS NOT NULL
BEGIN
	 IF COL_LENGTH('Forms ','Mobile') IS NULL
	 BEGIN
		ALTER TABLE  Forms  ADD Mobile type_YOrNOrNA	 NULL
		                    CHECK (Mobile in ('Y','N','A'))
	 END
END

PRINT 'STEP 3 COMPLETED'

-----END Of STEP 3---------

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.03)
BEGIN
Update SystemConfigurations set DataModelVersion=16.04
PRINT 'STEP 7 COMPLETED'
END
Go


