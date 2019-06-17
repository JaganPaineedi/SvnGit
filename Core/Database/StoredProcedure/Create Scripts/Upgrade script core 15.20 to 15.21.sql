----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.20)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.20 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins

--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------
-- changing datatype of column(s) in client table

IF EXISTS( select 1 from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = 'Clients' and COLUMN_NAME = 'LastName'  and DOMAIN_NAME='type_LastName_Encrypted')
BEGIN
	ALTER TABLE Clients ALTER COLUMN LastName  varchar(50) NULL
END

IF EXISTS( select 1 from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = 'Clients' and COLUMN_NAME = 'FirstName'  and DOMAIN_NAME='type_FirstName_Encrypted') 
BEGIN
	ALTER TABLE Clients ALTER COLUMN FirstName  varchar(30) NULL
END

IF EXISTS( select 1 from INFORMATION_SCHEMA.COLUMNS IC where TABLE_NAME = 'Clients' and COLUMN_NAME = 'MiddleName'  and DOMAIN_NAME='type_MiddleName_Encrypted') 
BEGIN
	ALTER TABLE Clients ALTER COLUMN MiddleName  varchar(30) NULL
END

-- add column(s) to Clients table 

IF COL_LENGTH('Clients','ClientType')IS NULL
BEGIN
	ALTER TABLE Clients  ADD  ClientType char(1) NULL
						  CHECK (ClientType in ('I','O'))
End	
Go

IF COL_LENGTH('Clients','OrganizationName')IS NULL
BEGIN
	ALTER TABLE Clients ADD  OrganizationName  varchar(100)	NULL
END

IF COL_LENGTH('Clients','EIN')IS NULL
BEGIN
	ALTER TABLE Clients ADD  EIN  varchar(25)	NULL
END

IF COL_LENGTH('Clients','ClientType')IS NOT NULL
BEGIN						  
exec('UPDATE Clients Set ClientType=''I'' where ClientType IS NULL')
END

IF EXISTS (SELECT *	FROM::fn_listextendedproperty('Clients_Description', 'schema', 'dbo', 'table', 'Clients', 'column', 'ClientType'))
BEGIN
	EXEC sys.sp_dropextendedproperty 'Clients_Description'
		,'schema'
		,'dbo'
		,'table'
		,'Clients'
		,'column'
		,'ClientType'
END

EXEC sys.sp_addextendedproperty 'Clients_Description'
	,'If ClientType cloumn data is  I   then  ClientType is Individual , If ClientType cloumn data is  O  then ClientType would be for organization'
	,'schema'
	,'dbo'
	,'table'
	,'Clients'
	,'column'
	,'ClientType'
	

IF EXISTS (SELECT *	FROM::fn_listextendedproperty('Clients_Description', 'schema', 'dbo', 'table', 'Clients', 'column', 'OrganizationName'))
BEGIN
	EXEC sys.sp_dropextendedproperty 'Clients_Description'
		,'schema'
		,'dbo'
		,'table'
		,'Clients'
		,'column'
		,'OrganizationName'
END

EXEC sys.sp_addextendedproperty 'Clients_Description'
	,'Client Organization Name'
	,'schema'
	,'dbo'
	,'table'
	,'Clients'
	,'column'
	,'OrganizationName'

IF EXISTS (SELECT *	FROM::fn_listextendedproperty('Clients_Description', 'schema', 'dbo', 'table', 'Clients', 'column', 'EIN'))
BEGIN
	EXEC sys.sp_dropextendedproperty 'Clients_Description'
		,'schema'
		,'dbo'
		,'table'
		,'Clients'
		,'column'
		,'EIN'
END

EXEC sys.sp_addextendedproperty 'Clients_Description'
	,'EIN number of Organization'
	,'schema'
	,'dbo'
	,'table'
	,'Clients'
	,'column'
	,'EIN'
	
	
PRINT 'STEP 3 COMPLETED'


------ END OF STEP 3 -----

------ STEP 4 ---------- 

--END Of STEP 4 ------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.20)
BEGIN
Update SystemConfigurations set DataModelVersion=15.21
PRINT 'STEP 7 COMPLETED'
END
Go

