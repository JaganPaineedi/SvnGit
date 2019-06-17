----- STEP 1 ----------

IF ((select DataModelVersion FROM SystemConfigurations)  < 15.53)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.53 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

------ END OF STEP 3 -----

IF OBJECT_ID('ClientDisclosures') IS NOT NULL
BEGIN

/* Drop Constraint */
declare @Cstname nvarchar(max), 
    @sql nvarchar(1000)

-- find constraint name
SELECT @Cstname=COALESCE(@Cstname+',','')+SCO.name 
    FROM
        sys.Objects TB
        INNER JOIN sys.Columns TC on (TB.Object_id = TC.object_id)
        INNER JOIN sys.sysconstraints SC ON (TC.Object_ID = SC.id and TC.column_id = SC.colid)
        INNER JOIN sys.objects SCO ON (SC.Constid = SCO.object_id)
    where
        TB.name='ClientDisclosures'
        AND TC.name='DisclosedToIdSource'
       order by SCO.name 
 if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [ClientDisclosures] DROP CONSTRAINT ' + @Cstname + ''   
    execute sp_executesql @sql
end

IF COL_LENGTH('ClientDisclosures','DisclosedToIdSource')IS NOT NULL
	BEGIN 
	ALTER TABLE ClientDisclosures	WITH CHECK ADD CHECK (DisclosedToIdSource in ('C','E','R','D'))  
END
	
IF EXISTS (SELECT *	FROM::fn_listextendedproperty('ClientDisclosures_Description', 'schema', 'dbo', 'table', 'ClientDisclosures', 'column', 'DisclosedToIdSource'))
BEGIN
	EXEC sys.sp_dropextendedproperty 'ClientDisclosures_Description'
		,'schema'
		,'dbo'
		,'table'
		,'ClientDisclosures'
		,'column'
		,'DisclosedToIdSource'
END

EXEC sys.sp_addextendedproperty 'ClientDisclosures_Description'
	,'If DisclosedToIdSource cloumn value is  C  then  DisclosedToId data is from ClientContacts, If E then ExternalReferralProviders, If R then  ClientInformationReleases,If D then DisclosedToDetails'
	,'schema'
	,'dbo'
	,'table'
	,'ClientDisclosures'
	,'column'
	,'DisclosedToIdSource'
	 
	 	 
 PRINT 'STEP 3 COMPLETED'
 
END
------ STEP 4 ----------
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='DisclosedToDetails')
BEGIN
/* 
 * TABLE: DisclsoureDetails 
 */
  CREATE TABLE DisclosedToDetails( 
		DisclosedToDetailId					int	identity(1,1)	 NOT NULL,
		CreatedBy							type_CurrentUser     NOT NULL,
		CreatedDate							type_CurrentDatetime NOT NULL,
		ModifiedBy							type_CurrentUser     NOT NULL,
		ModifiedDate						type_CurrentDatetime NOT NULL,
		RecordDeleted						type_YOrN			 NULL
											CHECK (RecordDeleted in ('Y','N')),
		DeletedBy							type_UserId          NULL,
		DeletedDate							datetime             NULL,
		ClientId							int					 NULL,
		DisclsoureType						type_GlobalCode		 NULL,
		Name								varchar(250)		 NULL,
		FirstName							varchar(100)		 NULL,
		LastName							varchar(100)		 NULL,
		Suffix								type_GlobalCode		 NULL,
		OrganizationName					varchar(250)		 NULL,
		DisclsoureAddress					type_Address		 NULL,
		DisclsoureAddress2					type_Address		 NULL,
		City								type_City			 NULL,
		DisclsoureState						type_State			 NULL,
		ZipCode								type_ZipCode		 NULL,
		PhoneNumber							type_PhoneNumber	 NULL,
		Fax									type_PhoneNumber	 NULL,
		Email								varchar(100)		 NULL,
		Website								type_Website		 NULL,
		Active								type_YOrN			 NULL
											CHECK (Active in ('Y','N')),
		DataEntryComplete					type_YOrN			 NULL
											CHECK (DataEntryComplete in ('Y','N')),
		CONSTRAINT DisclosedToDetails_PK PRIMARY KEY CLUSTERED (DisclosedToDetailId) 
 )
 
  IF OBJECT_ID('DisclosedToDetails') IS NOT NULL
    PRINT '<<< CREATED TABLE DisclosedToDetails >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE DisclosedToDetails >>>', 16, 1)
    
    IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[DisclosedToDetails]') AND name = N'XIE1_DisclosedToDetails')
		BEGIN
			CREATE NONCLUSTERED INDEX [XIE1_DisclosedToDetails] ON [dbo].[DisclosedToDetails] 
			(
			[ClientId] ASC
			)
			WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
			IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('DisclosedToDetails') AND name='XIE1_DisclosedToDetails')
			PRINT '<<< CREATED INDEX DisclosedToDetails.XIE1_DisclosedToDetails >>>'
			ELSE
			RAISERROR('<<< FAILED CREATING INDEX DisclosedToDetails.XIE1_DisclosedToDetails >>>', 16, 1)		
		END		
    
/* 
 * TABLE: DisclsoureDetails 
 */   
 
		ALTER TABLE DisclosedToDetails ADD CONSTRAINT Clients_DisclosedToDetails_FK
		FOREIGN KEY (ClientId)
		REFERENCES Clients(ClientId)
    
  PRINT 'STEP 4 COMPLETED'

END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.53)
BEGIN
Update SystemConfigurations set DataModelVersion=15.54
PRINT 'STEP 7 COMPLETED'
END
