----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.77)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.77 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of STEP 2 -------

------ STEP 3 ------------

-- Added Column for Clients Table

IF OBJECT_ID('Clients')IS NOT NULL
BEGIN
	IF COL_LENGTH('Clients','SexualOrientation')IS NULL
	BEGIN
		ALTER TABLE Clients ADD SexualOrientation  type_GlobalCode  NULL
	END
	
PRINT 'STEP 3 COMPLETED'
END 
-----END Of STEP 3--------------------

------ STEP 4 ------------


IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ClientEthnicities')
 BEGIN
/* 
 * TABLE: ClientEthnicities 
 */
CREATE TABLE ClientEthnicities(
    ClientEthnicityId					INT IDENTITY(1,1)		NOT NULL,
    CreatedBy							type_CurrentUser        NOT NULL,
    CreatedDate							type_CurrentDatetime    NOT NULL,
    ModifiedBy							type_CurrentUser        NOT NULL,
    ModifiedDate						type_CurrentDatetime    NOT NULL,
    RecordDeleted						type_YOrN               NULL
										CHECK (RecordDeleted in ('Y','N')),
    DeletedDate							datetime                NULL,
    DeletedBy							type_UserId             NULL,
	ClientId							int						NOT NULL,
    EthnicityId							type_GlobalCode			NOT NULL,
    CONSTRAINT ClientEthnicities_PK PRIMARY KEY CLUSTERED (ClientEthnicityId)
)

IF OBJECT_ID('ClientEthnicities') IS NOT NULL
    PRINT '<<< CREATED TABLE ClientEthnicities >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ClientEthnicities >>>', 16, 1)
/* 
 * TABLE: ClientEthnicities 
 */
ALTER TABLE ClientEthnicities ADD CONSTRAINT Clients_ClientEthnicities_FK 
	FOREIGN KEY (ClientId)
	REFERENCES Clients(ClientId) 
   
PRINT 'STEP 4(A) COMPLETED' 
END

----END Of STEP 4------------

IF EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'HispanicOrigin' AND Object_ID = Object_ID(N'Clients'))
BEGIN
IF OBJECT_ID('ClientEthnicities') IS NOT NULL
BEGIN
	INSERT INTO ClientEthnicities 
	(CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	ClientId,
	EthnicityId)
	SELECT
	'DATA MIGRATED',
	GETDATE(),
	'DATA MIGRATED',
	GETDATE(),
	C.ClientId,
	C.HispanicOrigin
	FROM Clients C 
	WHERE ISNULL(C.RecordDeleted,'N')='N'
	AND (C.HispanicOrigin IS NOT NULL)
	AND NOT EXISTS(SELECT 1 FROM ClientEthnicities CE WHERE C.ClientId=CE.ClientId  AND ISNULL(CE.RecordDeleted,'N')='N')
END
END
GO



--IF OBJECT_ID('Clients')IS NOT NULL
--BEGIN
--	IF COL_LENGTH('Clients','HispanicOrigin')IS NOT NULL
--	BEGIN
--		ALTER TABLE Clients DROP COLUMN HispanicOrigin  
--	END
	
--END 

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.77)
BEGIN
Update SystemConfigurations set DataModelVersion=15.78
PRINT 'STEP 7 COMPLETED'
END
Go



