----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 16.08)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 16.08 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ------------

-----End of Step 2 -------
------ STEP 3 ------------

-- Added column AssignedPopulation to Authorizations table 

IF OBJECT_ID('Authorizations')IS NOT NULL
BEGIN
	IF COL_LENGTH('Authorizations','AssignedPopulation')IS  NULL
	BEGIN
		ALTER TABLE Authorizations ADD  AssignedPopulation type_GlobalCode  NULL
	END
END 
Go
-- Added column AssignedPopulation to ProviderAuthorizations table 

IF OBJECT_ID('ProviderAuthorizations')IS NOT NULL
BEGIN
	IF COL_LENGTH('ProviderAuthorizations','AssignedPopulation')IS  NULL
	BEGIN
		ALTER TABLE ProviderAuthorizations ADD  AssignedPopulation type_GlobalCode  NULL
	END
END 
Go


-- AssignedPopulation column Data Migrated from AuthorizationDocuments

UPDATE A
SET A.AssignedPopulation= AD.Assigned
FROM Authorizations A 
	 JOIN AuthorizationDocuments AD ON A.AuthorizationDocumentId=AD.AuthorizationDocumentId
	 WHERE ISNULL(AD.RecordDeleted,'N')='N'
	 AND A.AssignedPopulation IS NOT NULL


-- AssignedPopulation column Data Migrated from AuthorizationDocuments

UPDATE P
SET P.AssignedPopulation= PAD.AssignedPopulation
FROM ProviderAuthorizations P 
	 JOIN ProviderAuthorizationDocuments PAD ON P.ProviderAuthorizationDocumentId=PAD.ProviderAuthorizationDocumentId
	 WHERE ISNULL(PAD.RecordDeleted,'N')='N'
	 AND PAD.AssignedPopulation IS NOT NULL

PRINT 'STEP 3 COMPLETED'

-----END Of STEP 3--------------------

------ STEP 4 ------------

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 16.08)
BEGIN
Update SystemConfigurations set DataModelVersion=16.09
PRINT 'STEP 7 COMPLETED'
END
Go


       



