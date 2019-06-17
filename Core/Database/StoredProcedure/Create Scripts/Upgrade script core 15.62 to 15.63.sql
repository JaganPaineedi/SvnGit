----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.62)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.62 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------

IF OBJECT_ID('ClaimDenialOverrides')  IS NOT NULL
BEGIN

	IF COL_LENGTH('ClaimDenialOverrides','ProviderSiteGroupName') IS NULL
	BEGIN
	ALTER TABLE ClaimDenialOverrides ADD  ProviderSiteGroupName varchar(250) NULL		
	END
	
	IF COL_LENGTH('ClaimDenialOverrides','InsurerGroupName') IS NULL
	BEGIN
	ALTER TABLE ClaimDenialOverrides ADD  InsurerGroupName varchar(250) NULL		
	END	
	
	IF COL_LENGTH('ClaimDenialOverrides','DenialReasonGroupName') IS NULL
	BEGIN
	ALTER TABLE ClaimDenialOverrides ADD  DenialReasonGroupName varchar(250) NULL		
	END
		
	IF COL_LENGTH('ClaimDenialOverrides','BillingCodeGroupName') IS NULL
	BEGIN
	ALTER TABLE ClaimDenialOverrides ADD  BillingCodeGroupName varchar(250) NULL		
	END
		
	PRINT 'STEP 3 COMPLETED'
END
GO

-----END Of STEP 3--------------------

------ STEP 4 ------------

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ClaimDenialOverrideProviderSites')
BEGIN
/*  
 * TABLE: ClaimDenialOverrideProviderSites
 */
CREATE TABLE ClaimDenialOverrideProviderSites(
			ClaimDenialOverrideProviderSiteId			int	identity(1,1)		NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,
			ClaimDenialOverrideId						int						NULL,
			ProviderId									int						NULL,
			SiteId										int						NULL,			
			CONSTRAINT CK_ClaimDenialOverrideProviderSites_ProviderId_Or_SiteId CHECK ((ProviderId IS NOT NULL AND SiteId IS NULL) OR (ProviderId IS NULL AND SiteId IS NOT NULL)), 
			CONSTRAINT ClaimDenialOverrideProviderSites_PK PRIMARY KEY CLUSTERED (ClaimDenialOverrideProviderSiteId) 
 )
 
IF OBJECT_ID('ClaimDenialOverrideProviderSites') IS NOT NULL
    PRINT '<<< CREATED TABLE ClaimDenialOverrideProviderSites >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ClaimDenialOverrideProviderSites >>>', 16, 1)
    
   	
/* 
 * TABLE: ClaimDenialOverrideProviderSites 
 */ 
 
ALTER TABLE ClaimDenialOverrideProviderSites ADD CONSTRAINT ClaimDenialOverrides_ClaimDenialOverrideProviderSites_FK 
	FOREIGN KEY (ClaimDenialOverrideId)
	REFERENCES ClaimDenialOverrides(ClaimDenialOverrideId)
	
ALTER TABLE ClaimDenialOverrideProviderSites ADD CONSTRAINT Providers_ClaimDenialOverrideProviderSites_FK 
	FOREIGN KEY (ProviderId)
	REFERENCES Providers(ProviderId)
	
ALTER TABLE ClaimDenialOverrideProviderSites ADD CONSTRAINT Sites_ClaimDenialOverrideProviderSites_FK 
	FOREIGN KEY (SiteId)
	REFERENCES Sites(SiteId)

 
	PRINT 'STEP 4(A) COMPLETED'
END
GO

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ClaimDenialOverrideInsurers')
BEGIN
/* 
 * TABLE: ClaimDenialOverrideInsurers
 */
CREATE TABLE ClaimDenialOverrideInsurers(
			ClaimDenialOverrideInsurerId				int	identity(1,1)		NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,
			ClaimDenialOverrideId						int						NOT NULL,
			InsurerId									int						NOT NULL,	
			CONSTRAINT ClaimDenialOverrideInsurers_PK PRIMARY KEY CLUSTERED (ClaimDenialOverrideInsurerId) 
 )
IF OBJECT_ID('ClaimDenialOverrideInsurers') IS NOT NULL
    PRINT '<<< CREATED TABLE ClaimDenialOverrideInsurers >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ClaimDenialOverrideInsurers >>>', 16, 1)
    
   	
/* 
 * TABLE: ClaimDenialOverrideInsurers 
 */ 
 
ALTER TABLE ClaimDenialOverrideInsurers ADD CONSTRAINT ClaimDenialOverrides_ClaimDenialOverrideInsurers_FK 
	FOREIGN KEY (ClaimDenialOverrideId)
	REFERENCES ClaimDenialOverrides(ClaimDenialOverrideId)
	
ALTER TABLE ClaimDenialOverrideInsurers ADD CONSTRAINT Insurers_ClaimDenialOverrideInsurers_FK 
	FOREIGN KEY (InsurerId)
	REFERENCES Insurers(InsurerId)
	
	PRINT 'STEP 4(B) COMPLETED'
END
Go

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ClaimDenialOverrideClients')
BEGIN
/*  
 * TABLE:  ClaimDenialOverrideClients 
 */ 
CREATE TABLE ClaimDenialOverrideClients(
	ClaimDenialOverrideClientId			int	identity(1,1)			NOT NULL,
	CreatedBy							type_CurrentUser			NOT NULL,
	CreatedDate							type_CurrentDatetime		NOT NULL,
	ModifiedBy							type_CurrentUser			NOT NULL,
	ModifiedDate						type_CurrentDatetime		NOT NULL,
	RecordDeleted						type_YOrN					NULL
										CHECK (RecordDeleted in ('Y','N')),
	DeletedBy							type_UserId					NULL,
	DeletedDate							datetime					NULL,
	ClaimDenialOverrideId				int							NULL,
	ClientId							int							NULL,
	CONSTRAINT ClaimDenialOverrideClients_PK PRIMARY KEY CLUSTERED (ClaimDenialOverrideClientId) 
) 

 IF OBJECT_ID('ClaimDenialOverrideClients') IS NOT NULL
    PRINT '<<< CREATED TABLE ClaimDenialOverrideClients >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ClaimDenialOverrideClients >>>', 16, 1)
 
    
/* 
 * TABLE: ClaimDenialOverrideClients 
 */ 
  ALTER TABLE ClaimDenialOverrideClients ADD CONSTRAINT ClaimDenialOverrides_ClaimDenialOverrideClients_FK 
    FOREIGN KEY (ClaimDenialOverrideId)
    REFERENCES ClaimDenialOverrides(ClaimDenialOverrideId)     
    
  ALTER TABLE ClaimDenialOverrideClients ADD CONSTRAINT Clients_ClaimDenialOverrideClients_FK 
    FOREIGN KEY (ClientId)
    REFERENCES Clients(ClientId)     
    
PRINT 'STEP 4(C) COMPLETED'
END
Go
--- Data Migrated from ClaimDenialOverrides to ClaimDenialOverrideProviderSites table
IF EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'ProviderId' AND Object_ID = Object_ID(N'ClaimDenialOverrides'))
BEGIN
exec ('	
IF OBJECT_ID(''ClaimDenialOverrideProviderSites'') IS NOT NULL
BEGIN
	INSERT INTO ClaimDenialOverrideProviderSites 
	(CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	ClaimDenialOverrideId,
	ProviderId,
	SiteId)
	SELECT
	''DATA MIGRATED'',
	GETDATE(),
	''DATA MIGRATED'',
	GETDATE(),
	CD.ClaimDenialOverrideId,
	CD.ProviderId,
	NULL
	FROM ClaimDenialOverrides CD
	LEFT JOIN Providers P ON P.ProviderId= CD.ProviderId AND (ISNULL(P.RecordDeleted, ''N'') = ''N'') 
	WHERE ISNULL(CD.RecordDeleted,''N'')=''N''
	AND (CD.ProviderId IS NOT NULL)
	AND (CD.SiteId IS  NULL)
	AND NOT EXISTS(SELECT 1 FROM ClaimDenialOverrideProviderSites CPS WHERE CD.ClaimDenialOverrideId=CPS.ClaimDenialOverrideId AND  CD.ProviderId=CPS.ProviderId AND ISNULL(CPS.RecordDeleted,''N'')=''N'')
END
')
END
GO

IF EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'SiteId' AND Object_ID = Object_ID(N'ClaimDenialOverrides'))
BEGIN
exec ('	
IF OBJECT_ID(''ClaimDenialOverrideProviderSites'') IS NOT NULL
BEGIN
INSERT INTO ClaimDenialOverrideProviderSites 
	(CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	ClaimDenialOverrideId,
	ProviderId,
	SiteId)
	SELECT
	''DATA MIGRATED'',
	GETDATE(),
	''DATA MIGRATED'',
	GETDATE(),
	CD.ClaimDenialOverrideId,
	Null,
	CD.SiteId
	FROM ClaimDenialOverrides CD
	LEFT JOIN Sites S ON S.SiteId=CD.SiteId 
			AND ISNULL(S.RecordDeleted,''N'')=''N''
	WHERE ISNULL(CD.RecordDeleted,''N'')=''N''
	AND (CD.SiteId  IS NOT NULL)
	AND NOT EXISTS(SELECT 1 FROM ClaimDenialOverrideProviderSites CPS WHERE CD.ClaimDenialOverrideId=CPS.ClaimDenialOverrideId AND  CD.SiteId=CPS.SiteId AND  ISNULL(CPS.RecordDeleted,''N'')=''N'')
END')
END
GO


--- Data Migrated from ClaimDenialOverrides to ClaimDenialOverrideClients table
IF EXISTS(SELECT * FROM sys.columns 
            WHERE Name = N'ClientId' AND Object_ID = Object_ID(N'ClaimDenialOverrides'))
BEGIN
exec ('	
IF OBJECT_ID(''ClaimDenialOverrideClients'') IS NOT NULL
BEGIN
INSERT INTO ClaimDenialOverrideClients 
	(CreatedBy,
	CreatedDate,
	ModifiedBy,
	ModifiedDate,
	ClaimDenialOverrideId,
	ClientId
	)
	SELECT
	''DATA MIGRATED'',
	GETDATE(),
	''DATA MIGRATED'',
	GETDATE(),
	CD.ClaimDenialOverrideId,
	CD.ClientId
	FROM ClaimDenialOverrides CD
	LEFT JOIN Clients C ON C.ClientId=CD.ClientId 
			AND ISNULL(C.RecordDeleted,''N'')=''N''
	WHERE ISNULL(CD.RecordDeleted,''N'')=''N''
	AND (CD.ClientId  IS NOT NULL)
	AND NOT EXISTS(SELECT 1 FROM ClaimDenialOverrideClients CDC WHERE CD.ClaimDenialOverrideId=CDC.ClaimDenialOverrideId AND  CD.ClientId=CDC.ClientId AND  ISNULL(CDC.RecordDeleted,''N'')=''N'')
END')
END
GO

-- updating DenialReasonGroupName,BillingCodeGroupName, ProviderSiteGroupName in ClaimDenialOverrides

IF EXISTS(SELECT * FROM sys.columns WHERE Name IN ('AllDenialReasons','AllBillingCodes','ProviderId','SiteId')
                                    AND Object_ID = Object_ID(N'ClaimDenialOverrides'))
BEGIN
exec ('	
	UPDATE D
	SET D.DenialReasonGroupName = case when ISNULL(D.AllDenialReasons,''N'')=''Y'' then NULL
									  else (select top 1 GC.CodeName  
											FROM ClaimDenialOverrideDenialReasons R
											JOIN GlobalCodes GC ON GC.GlobalCodeId = R.DenialReasonId 
											WHERE R.ClaimDenialOverrideId=D.ClaimDenialOverrideId 
											AND ISNULL(R.RecordDeleted, ''N'') = ''N'') 
									 END,
	 D.BillingCodeGroupName = case when ISNULL(D.AllBillingCodes,''N'')=''Y'' then NULL
									  else (select top 1 BC.BillingCode 
									  FROM ClaimDenialOverrideBillingCodes B 
									  JOIN BillingCodes  BC ON BC.BillingCodeId= B.BillingCodeId 
									  WHERE B.ClaimDenialOverrideId=D.ClaimDenialOverrideId 
									  AND ISNULL(B.RecordDeleted, ''N'') = ''N'') 
									  END,	
									  
	 D.ProviderSiteGroupName = case when D.ProviderId IS NULL AND D.SiteId IS NULL then ''ALL'' 
									when D.ProviderId IS NOT NULL THEN (select P.ProviderName 
																			  FROM Providers P 
																			  where P.ProviderId=D.ProviderId )
								  when D.SiteId IS NOT NULL AND D.ProviderId IS  NULL
									   THEN (select S.SiteName 
											  FROM Sites S 
											  where S.SiteId=D.SiteId )
								END ,
	 D.CreatedBy = ''DATA MIGRATED'',
	 D.CreatedDate =  GETDATE() ,
	 D.ModifiedBy = ''DATA MIGRATED'',
	 D.ModifiedDate = GETDATE() 				  
	FROM ClaimDenialOverrides D	
	WHERE ISNULL(D.RecordDeleted, ''N'') = ''N''
	')

END
Go


-- droped foreignkey relationship 

IF OBJECT_ID('ClaimDenialOverrides')  IS NOT NULL
BEGIN
IF COL_LENGTH('ClaimDenialOverrides','ProviderId') IS NOT NULL
BEGIN		
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Providers_ClaimDenialOverrides_FK]') AND parent_object_id = OBJECT_ID(N'ClaimDenialOverrides'))
	BEGIN
		ALTER TABLE [dbo].[ClaimDenialOverrides] DROP CONSTRAINT [Providers_ClaimDenialOverrides_FK]		
	END
END

IF COL_LENGTH('ClaimDenialOverrides','SiteId') IS NOT NULL
BEGIN		
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Sites_ClaimDenialOverrides_FK]') AND parent_object_id = OBJECT_ID(N'ClaimDenialOverrides'))
	BEGIN
		ALTER TABLE [dbo].[ClaimDenialOverrides] DROP CONSTRAINT [Sites_ClaimDenialOverrides_FK]		
	END
END

IF COL_LENGTH('ClaimDenialOverrides','ClientId') IS NOT NULL
BEGIN		
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Clients_ClaimDenialOverrides_FK]') AND parent_object_id = OBJECT_ID(N'ClaimDenialOverrides'))
	BEGIN
		ALTER TABLE [dbo].[ClaimDenialOverrides] DROP CONSTRAINT [Clients_ClaimDenialOverrides_FK]		
	END
END
END
Go	

-- droped column(s) from ClaimDenialOverrides
IF OBJECT_ID('ClaimDenialOverrides')  IS NOT NULL
BEGIN
	IF COL_LENGTH('ClaimDenialOverrides','ProviderId') IS NOT NULL
	BEGIN
		ALTER TABLE ClaimDenialOverrides DROP COLUMN  ProviderId 		
	END
	
	IF COL_LENGTH('ClaimDenialOverrides','SiteId') IS NOT NULL
	BEGIN
		ALTER TABLE ClaimDenialOverrides DROP COLUMN  SiteId 		
	END
	
	IF COL_LENGTH('ClaimDenialOverrides','ClientId') IS NOT NULL
	BEGIN
		ALTER TABLE ClaimDenialOverrides DROP COLUMN  ClientId 		
	END
END

IF OBJECT_ID('ClaimDenialOverrides')  IS NOT NULL
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
        TB.name='ClaimDenialOverrides'
        AND TC.name='AllDenialReasons'
       order by SCO.name 
 if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [ClaimDenialOverrides] DROP CONSTRAINT ' + @Cstname + ''   
    execute sp_executesql @sql
end
set @Cstname=null
set @sql=null
-- find constraint name
SELECT @Cstname=COALESCE(@Cstname+',','')+SCO.name 
    FROM
        sys.Objects TB
        INNER JOIN sys.Columns TC on (TB.Object_id = TC.object_id)
        INNER JOIN sys.sysconstraints SC ON (TC.Object_ID = SC.id and TC.column_id = SC.colid)
        INNER JOIN sys.objects SCO ON (SC.Constid = SCO.object_id)
    where
        TB.name='ClaimDenialOverrides'
        AND TC.name='AllBillingCodes'
       order by SCO.name 
  if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [ClaimDenialOverrides] DROP CONSTRAINT ' + @Cstname + ''   
    execute sp_executesql @sql
end

set @Cstname=null
set @sql=null
-- find constraint name
SELECT @Cstname=COALESCE(@Cstname+',','')+SCO.name 
    FROM
        sys.Objects TB
        INNER JOIN sys.Columns TC on (TB.Object_id = TC.object_id)
        INNER JOIN sys.sysconstraints SC ON (TC.Object_ID = SC.id and TC.column_id = SC.colid)
        INNER JOIN sys.objects SCO ON (SC.Constid = SCO.object_id)
    where
        TB.name='ClaimDenialOverrides'
        AND TC.name='AllAuthorizationNumbers'
       order by SCO.name 
  if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [ClaimDenialOverrides] DROP CONSTRAINT ' + @Cstname + ''   
    execute sp_executesql @sql
end

set @Cstname=null
set @sql=null
-- find constraint name
SELECT @Cstname=COALESCE(@Cstname+',','')+SCO.name 
    FROM
        sys.Objects TB
        INNER JOIN sys.Columns TC on (TB.Object_id = TC.object_id)
        INNER JOIN sys.sysconstraints SC ON (TC.Object_ID = SC.id and TC.column_id = SC.colid)
        INNER JOIN sys.objects SCO ON (SC.Constid = SCO.object_id)
    where
        TB.name='ClaimDenialOverrides'
        AND TC.name='AllReasons'
       order by SCO.name 
  if not @Cstname is null
begin
    select @sql = 'ALTER TABLE [ClaimDenialOverrides] DROP CONSTRAINT ' + @Cstname + ''   
    execute sp_executesql @sql
end

IF COL_LENGTH('ClaimDenialOverrides','AllDenialReasons')IS NOT NULL
BEGIN
	ALTER TABLE ClaimDenialOverrides DROP COLUMN  AllDenialReasons 
END

IF COL_LENGTH('ClaimDenialOverrides','AllBillingCodes')IS NOT NULL
BEGIN
	ALTER TABLE ClaimDenialOverrides DROP COLUMN  AllBillingCodes 
END

IF COL_LENGTH('ClaimDenialOverrides','AllAuthorizationNumbers')IS NOT NULL
BEGIN
	ALTER TABLE ClaimDenialOverrides DROP COLUMN  AllAuthorizationNumbers 
END

IF COL_LENGTH('ClaimDenialOverrides','AllReasons')IS NOT NULL
BEGIN
	ALTER TABLE ClaimDenialOverrides DROP COLUMN  AllReasons 
END

END
-- renamed column 

IF COL_LENGTH('ClaimDenialOverrides','OtherReasonComment')IS NOT NULL and COL_LENGTH('ClaimDenialOverrides','ReasonComment')IS NULL
BEGIN
 Exec sp_rename  'ClaimDenialOverrides.OtherReasonComment', 'ReasonComment', 'COLUMN'                                					  																											                    
END



--END Of STEP 4------------
---- STEP 5 ----------------
-----END STEP 5-------------
---- STEP 6  ----------
---- STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.62)
BEGIN
Update SystemConfigurations set DataModelVersion=15.63
PRINT 'STEP 7 COMPLETED'
END
Go


	