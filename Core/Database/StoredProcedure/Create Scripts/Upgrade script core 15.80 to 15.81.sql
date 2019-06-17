----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.80)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.80 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END

------ STEP 2 ----------
--Part1 Begin


--Part1 Ends

--Part2 Begins

--Part2 Ends	

-----End of Step 2 -------

------ STEP 3 ------------

-----END Of STEP 3--------------------

------ STEP 4 ------------

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='AuthorizationClaimsBillingCodeExchanges')
BEGIN
/* 
 * TABLE: AuthorizationClaimsBillingCodeExchanges
 */
CREATE TABLE AuthorizationClaimsBillingCodeExchanges(
			AuthorizationClaimsBillingCodeExchangeId	int	identity(1,1)		NOT NULL,
			CreatedBy									type_CurrentUser        NOT NULL,
			CreatedDate									type_CurrentDatetime    NOT NULL,
			ModifiedBy									type_CurrentUser        NOT NULL,
			ModifiedDate								type_CurrentDatetime    NOT NULL,
			RecordDeleted								type_YOrN               NULL
														CHECK (RecordDeleted in ('Y','N')),
			DeletedBy									type_UserId             NULL,
			DeletedDate									datetime				NULL,
			BillingCodeModifierId						int						NOT NULL,
			ApplyToAllModifiers							type_YOrN               NOT NULL 
														CHECK (ApplyToAllModifiers in ('Y','N')),			
			Interchangeable								type_YOrN  DEFAULT 'Y'  NOT NULL
														CHECK (Interchangeable in ('Y','N')),	
			StartDate									datetime				NULL,
			EndDate										datetime				NULL,
			ProviderSitesGroupName						varchar(250)			NULL,
			InsurerGroupName							varchar(250)			NULL,
			ClaimBillingCodeGroupName					varchar(250)			NULL,
			CONSTRAINT AuthorizationClaimsBillingCodeExchanges_PK PRIMARY KEY CLUSTERED (AuthorizationClaimsBillingCodeExchangeId) 
 )
 
IF OBJECT_ID('AuthorizationClaimsBillingCodeExchanges') IS NOT NULL
    PRINT '<<< CREATED TABLE AuthorizationClaimsBillingCodeExchanges >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE AuthorizationClaimsBillingCodeExchanges >>>', 16, 1)
    
   	
/* 
 * TABLE: AuthorizationClaimsBillingCodeExchanges 
 */ 
 
ALTER TABLE AuthorizationClaimsBillingCodeExchanges ADD CONSTRAINT BillingCodeModifiers_AuthorizationClaimsBillingCodeExchanges_FK 
	FOREIGN KEY (BillingCodeModifierId)
	REFERENCES BillingCodeModifiers(BillingCodeModifierId)
	
EXEC sys.sp_addextendedproperty 'AuthorizationClaimsBillingCodeExchanges_Description'
	,'Default Interchangeable to ''Y'' since 99% of the time they will be interchangeable'
	,'schema'
	,'dbo'
	,'table'
	,'AuthorizationClaimsBillingCodeExchanges'
	,'column'
	,'Interchangeable'
 
	PRINT 'STEP 4(A) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='AuthorizationClaimsBillingCodeExchangeProviderSites')
BEGIN
/* 
 * TABLE: AuthorizationClaimsBillingCodeExchangeProviderSites 
 */	
CREATE TABLE AuthorizationClaimsBillingCodeExchangeProviderSites(
			AuthorizationClaimsBillingCodeExchangeProviderSiteId	int	identity(1,1)		NOT NULL,
			CreatedBy												type_CurrentUser        NOT NULL,
			CreatedDate												type_CurrentDatetime    NOT NULL,
			ModifiedBy												type_CurrentUser        NOT NULL,
			ModifiedDate											type_CurrentDatetime    NOT NULL,
			RecordDeleted											type_YOrN               NULL
																	CHECK (RecordDeleted in ('Y','N')),
			DeletedBy												type_UserId             NULL,
			DeletedDate												datetime				NULL,
			AuthorizationClaimsBillingCodeExchangeId				int						NOT NULL,
			ProviderId												int						NULL,
			SiteId													int						NULL,			-- if site is NULL then all sites for provider can be exchanged
			CONSTRAINT CK_AuthorizationClaimsBillingCodeExchangeProviderSites_ProviderId_Or_SiteId CHECK ((ProviderId IS NOT NULL AND SiteId IS NULL) OR (ProviderId IS NULL AND SiteId IS NOT NULL)), --If provider is specified and no site then all sites for the given provider can be exchanged and when  a site is specified then the provider must be what is specified on the site table 
			CONSTRAINT AuthorizationClaimsBillingCodeExchangeProviderSites_PK PRIMARY KEY CLUSTERED (AuthorizationClaimsBillingCodeExchangeProviderSiteId) 
 )
 
  IF OBJECT_ID('AuthorizationClaimsBillingCodeExchangeProviderSites') IS NOT NULL
    PRINT '<<< CREATED TABLE AuthorizationClaimsBillingCodeExchangeProviderSites >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE AuthorizationClaimsBillingCodeExchangeProviderSites >>>', 16, 1)
    
     	
/* 
 * TABLE: AuthorizationClaimsBillingCodeExchangeProviderSites 
 */ 
 
ALTER TABLE AuthorizationClaimsBillingCodeExchangeProviderSites ADD CONSTRAINT AuthorizationClaimsBillingCodeExchanges_BillingCodeExchangeProviderSites_FK 
	FOREIGN KEY (AuthorizationClaimsBillingCodeExchangeId)
	REFERENCES AuthorizationClaimsBillingCodeExchanges(AuthorizationClaimsBillingCodeExchangeId)

ALTER TABLE AuthorizationClaimsBillingCodeExchangeProviderSites ADD CONSTRAINT Providers_AuthorizationClaimsBillingCodeExchangeProviderSites_FK 
	FOREIGN KEY (ProviderId)
	REFERENCES Providers(ProviderId)

	
ALTER TABLE AuthorizationClaimsBillingCodeExchangeProviderSites ADD CONSTRAINT Sites_AuthorizationClaimsBillingCodeExchangeProviderSites_FK 
	FOREIGN KEY (SiteId)
	REFERENCES Sites(SiteId)
	
EXEC sys.sp_addextendedproperty 'AuthorizationClaimsBillingCodeExchangeProviderSites_Description'
	,'if site is NULL then all sites for provider can be exchanged'
	,'schema'
	,'dbo'
	,'table'
	,'AuthorizationClaimsBillingCodeExchangeProviderSites'
	,'column'
	,'SiteId'
	
EXEC sys.sp_addextendedproperty 'AuthorizationClaimsBillingCodeExchangeProviderSites_Description'
	,'If provider is specified and no site then all sites for the given provider can be exchanged and when a site is specified then the provider must be what is specified on the site table'
	,'schema'
	,'dbo'
	,'table'
	,'AuthorizationClaimsBillingCodeExchangeProviderSites'
	,'column'
	,'ProviderId'
  
	PRINT 'STEP 4(B) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='AuthorizationClaimsBillingCodeExchangeInsurers')
BEGIN
/* 
 * TABLE: AuthorizationClaimsBillingCodeExchangeInsurers 
 */	
CREATE TABLE AuthorizationClaimsBillingCodeExchangeInsurers (
		AuthorizationClaimsBillingCodeExchangeInsurerId				int	identity(1,1)		NOT NULL,
		CreatedBy													type_CurrentUser        NOT NULL,
		CreatedDate													type_CurrentDatetime    NOT NULL,
		ModifiedBy													type_CurrentUser        NOT NULL,
		ModifiedDate												type_CurrentDatetime    NOT NULL,
		RecordDeleted												type_YOrN               NULL 
																	CHECK (RecordDeleted in ('Y','N')),
		DeletedBy													type_UserId             NULL,
		DeletedDate													datetime				NULL,
		AuthorizationClaimsBillingCodeExchangeId					int						NOT NULL,
		InsurerId													int						NOT NULL,
		CONSTRAINT AuthorizationClaimsBillingCodeExchangeInsurers_PK PRIMARY KEY CLUSTERED (AuthorizationClaimsBillingCodeExchangeInsurerId) 
 )
 
  IF OBJECT_ID('AuthorizationClaimsBillingCodeExchangeInsurers') IS NOT NULL
    PRINT '<<< CREATED TABLE AuthorizationClaimsBillingCodeExchangeInsurers >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE AuthorizationClaimsBillingCodeExchangeInsurers >>>', 16, 1)
    
     	
/* 
 * TABLE: AuthorizationClaimsBillingCodeExchangeInsurers 
 */ 
 
ALTER TABLE AuthorizationClaimsBillingCodeExchangeInsurers ADD CONSTRAINT AuthorizationClaimsBillingCodeExchanges_AuthorizationClaimsBillingCodeExchangeInsurers_FK 
	FOREIGN KEY (AuthorizationClaimsBillingCodeExchangeId)
	REFERENCES AuthorizationClaimsBillingCodeExchanges(AuthorizationClaimsBillingCodeExchangeId)
	
ALTER TABLE AuthorizationClaimsBillingCodeExchangeInsurers ADD CONSTRAINT Insurers_AuthorizationClaimsBillingCodeExchangeInsurers_FK 
	FOREIGN KEY (InsurerId)
	REFERENCES Insurers(InsurerId)
  
	PRINT 'STEP 4(C) COMPLETED'
END


IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='AuthorizationClaimsBillingCodeExchangeBillingCodes')
BEGIN
/* 
 * TABLE: AuthorizationClaimsBillingCodeExchangeBillingCodes 
 */	
CREATE TABLE AuthorizationClaimsBillingCodeExchangeBillingCodes(
			AuthorizationClaimsBillingCodeExchangeBillingCodeId				int	identity(1,1)		NOT NULL,
			CreatedBy														type_CurrentUser        NOT NULL,
			CreatedDate														type_CurrentDatetime    NOT NULL,
			ModifiedBy														type_CurrentUser        NOT NULL,
			ModifiedDate													type_CurrentDatetime    NOT NULL,
			RecordDeleted													type_YOrN               NULL 
																			CHECK (RecordDeleted in ('Y','N')),
			DeletedBy														type_UserId             NULL,
			DeletedDate														datetime				NULL,
			AuthorizationClaimsBillingCodeExchangeId						int						NOT NULL,
			BillingCodeModifierId											int						NOT NULL,
			ApplyToAllModifiers												type_YOrN               NOT NULL 
																			CHECK (ApplyToAllModifiers in ('Y','N')),
			CONSTRAINT AuthorizationClaimsBillingCodeExchangeBillingCodes_PK PRIMARY KEY CLUSTERED (AuthorizationClaimsBillingCodeExchangeBillingCodeId) 
 )
 
  IF OBJECT_ID('AuthorizationClaimsBillingCodeExchangeBillingCodes') IS NOT NULL
    PRINT '<<< CREATED TABLE AuthorizationClaimsBillingCodeExchangeBillingCodes >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE AuthorizationClaimsBillingCodeExchangeBillingCodes >>>', 16, 1)
    
     	
/* 
 * TABLE: AuthorizationClaimsBillingCodeExchangeBillingCodes 
 */ 
 
ALTER TABLE AuthorizationClaimsBillingCodeExchangeBillingCodes ADD CONSTRAINT AuthorizationClaimsBillingCodeExchanges_AuthorizationClaimsBillingCodeExchangeBillingCodes_FK 
	FOREIGN KEY (AuthorizationClaimsBillingCodeExchangeId)
	REFERENCES AuthorizationClaimsBillingCodeExchanges(AuthorizationClaimsBillingCodeExchangeId)
	
ALTER TABLE AuthorizationClaimsBillingCodeExchangeBillingCodes ADD CONSTRAINT BillingCodeModifiers_AuthorizationClaimsBillingCodeExchangeBillingCodes_FK 
	FOREIGN KEY (BillingCodeModifierId)
	REFERENCES BillingCodeModifiers(BillingCodeModifierId)
  
	PRINT 'STEP 4(D) COMPLETED'
END

/*
drop table #BillingCodeExchange
drop table #NewRecords
*/


IF EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='BillingCodeExchange')
BEGIN

create table #BillingCodeExchange (
BillingCodeExchangeId int identity
                          not null,
AuthorizationBillingCodeId int,
AuthorizationBillingCodeModifierId int,
AuthorizationApplyToAllModifiers char(1),
ClaimBillingCodeId int,
ClaimBillingCodeModifierId int,
ClaimApplyToAllModifiers char(1),
Interchangeable char(1),
ClaimBillingCodeGroupId int,
ClaimBillingCodeGroupRowId int,
ClaimBillingCodeGroupName varchar(250))

create table #NewRecords (RecordId int)


insert  into #BillingCodeExchange
        (AuthorizationBillingCodeId,
         AuthorizationBillingCodeModifierId,
		 AuthorizationApplyToAllModifiers,
         ClaimBillingCodeId,
         ClaimBillingCodeModifierId,
		 ClaimApplyToAllModifiers,
         Interchangeable)
        select  e.AuthorizationBillingCodeId,
                ma.BillingCodeModifierId,
				'N',
                e.ClaimBillingCodeId,
                mc.BillingCodeModifierId,
				'N',
                'N'
        from    BillingCodeExchange e
                join BillingCodeModifiers ma on ma.BillingCodeId = e.AuthorizationBillingCodeId
                join BillingCodeModifiers mc on mc.BillingCodeId = e.ClaimBillingCodeId
        where   isnull(ma.RecordDeleted, 'N') = 'N'
                and isnull(mc.RecordDeleted, 'N') = 'N'
                and isnull(e.RecordDeleted, 'N') = 'N'
                and isnull(ma.Modifier1, '') = ''
                and isnull(ma.Modifier2, '') = ''
                and isnull(ma.Modifier3, '') = ''
                and isnull(ma.Modifier4, '') = ''
                and isnull(mc.Modifier1, '') = ''
                and isnull(mc.Modifier2, '') = ''
                and isnull(mc.Modifier3, '') = ''
                and isnull(mc.Modifier4, '') = ''
                and not exists ( select *
                                 from   BillingCodeExchange e2
                                 where  e2.AuthorizationBillingCodeId = e.ClaimBillingCodeId
                                        and e2.ClaimBillingCodeId = e.AuthorizationBillingCodeId
                                        and e2.ExchangeId < e.ExchangeId
                                        and isnull(e2.RecordDeleted, 'N') = 'N' )     

update  e
set     Interchangeable = 'Y'
from    #BillingCodeExchange e
where   exists ( select *
                 from   BillingCodeExchange e2
                 where  e2.AuthorizationBillingCodeId = e.ClaimBillingCodeId
                        and e2.ClaimBillingCodeId = e.AuthorizationBillingCodeId
                        and isnull(e2.RecordDeleted, 'N') = 'N' )   

if object_id('dbo.CustomBillingCodeExchangeModifiers') is not null 
  begin
    insert  into #BillingCodeExchange
            (AuthorizationBillingCodeId,
             AuthorizationBillingCodeModifierId,
			 AuthorizationApplyToAllModifiers,
             ClaimBillingCodeId,
             ClaimBillingCodeModifierId,
			 ClaimApplyToAllModifiers,
             Interchangeable)
            select  e.AuthorizationBillingCodeId,
                    ma.BillingCodeModifierId,
                    'N',
                    e.ClaimBillingCodeId,
                    mc.BillingCodeModifierId,
                    'N',
                    'N'
            from    BillingCodeExchange e
                    join BillingCodeModifiers ma on ma.BillingCodeId = e.AuthorizationBillingCodeId
                    join BillingCodeModifiers mc on mc.BillingCodeId = e.ClaimBillingCodeId
                    join CustomBillingCodeExchangeModifiers m on m.ExchangeId = e.ExchangeId
            where   isnull(ma.RecordDeleted, 'N') = 'N'
                    and isnull(mc.RecordDeleted, 'N') = 'N'
                    and isnull(e.RecordDeleted, 'N') = 'N'
                    and isnull(ma.Modifier1, '') = isnull(m.AuthorizationModifier1, '')
                    and isnull(ma.Modifier2, '') = isnull(m.AuthorizationModifier2, '')
                    and isnull(ma.Modifier3, '') = isnull(m.AuthorizationModifier3, '')
                    and isnull(ma.Modifier4, '') = isnull(m.AuthorizationModifier4, '')
                    and isnull(mc.Modifier1, '') = isnull(m.ClaimModifier1, '')
                    and isnull(mc.Modifier2, '') = isnull(m.ClaimModifier2, '')
                    and isnull(mc.Modifier3, '') = isnull(m.ClaimModifier3, '')
                    and isnull(mc.Modifier4, '') = isnull(m.ClaimModifier4, '')


  end;
  
with  CTE_Group
        as (select  BillingCodeExchangeId,
                    dense_rank() over (order by AuthorizationBillingCodeModifierId, Interchangeable) as GroupId,
                    row_number() over (partition by AuthorizationBillingCodeModifierId, Interchangeable order by AuthorizationBillingCodeModifierId) as GroupRowId
            from    #BillingCodeExchange)
  update  e
  set     ClaimBillingCodeGroupId = GroupId,
          ClaimBillingCodeGroupRowId = GroupRowId
  from    #BillingCodeExchange e
          join CTE_Group g on g.BillingCodeExchangeId = e.BillingCodeExchangeId;

with  CTE_GroupName
        as (select  BillingCodeExchangeId,
                    GroupName = (select stuff((select ';' + d.Description
                                               from   (select distinct
                                                              coalesce(nullif(m.Description, ''), 
															           bc.BillingCode + 
																	   coalesce(':' + nullif(m.Modifier1, ''), '') + 
																	   coalesce(':' + nullif(m.Modifier2, ''), '') + 
																	   coalesce(':' + nullif(m.Modifier3, ''), '') + 
																	   coalesce(':' + nullif(m.Modifier4, ''), '')) as Description
                                                       from   #BillingCodeExchange e
                                                              join BillingCodeModifiers m on m.BillingCodeModifierId = e.ClaimBillingCodeModifierId
                                                              join BillingCodes bc on bc.BillingCodeId = e.ClaimBillingCodeId
                                                       where  e2.ClaimBillingCodeGroupId = e.ClaimBillingCodeGroupId) d
                                              for
                                               xml path('')), 1, 1, '') as d)
            from    #BillingCodeExchange e2)
  update  e
  set     ClaimBillingCodeGroupName = g.GroupName
  from    #BillingCodeExchange e
          join CTE_GroupName g on g.BillingCodeExchangeId = e.BillingCodeExchangeId

insert  into AuthorizationClaimsBillingCodeExchanges
        (BillingCodeModifierId,
         ApplyToAllModifiers,
         Interchangeable,
         ClaimBillingCodeGroupName,
         DeletedBy)
output  inserted.AuthorizationClaimsBillingCodeExchangeId
        into #NewRecords (RecordId)
        select  max(e.AuthorizationBillingCodeModifierId),
                max(e.AuthorizationApplyToAllModifiers),
                max(e.Interchangeable),
                max(e.ClaimBillingCodeGroupName),
                ClaimBillingCodeGroupId
        from    #BillingCodeExchange e
        group by ClaimBillingCodeGroupId


insert  into AuthorizationClaimsBillingCodeExchangeBillingCodes
        (AuthorizationClaimsBillingCodeExchangeId,
         BillingCodeModifierId,
         ApplyToAllModifiers)
        select  a.AuthorizationClaimsBillingCodeExchangeId,
                e.ClaimBillingCodeModifierId,
                e.ClaimApplyToAllModifiers
        from    AuthorizationClaimsBillingCodeExchanges a
                join #NewRecords nr on nr.RecordId = AuthorizationClaimsBillingCodeExchangeId
                join #BillingCodeExchange e on e.ClaimBillingCodeGroupId = a.DeletedBy

update  a
set     DeletedBy = null
from    AuthorizationClaimsBillingCodeExchanges a
        join #NewRecords nr on nr.RecordId = AuthorizationClaimsBillingCodeExchangeId


--DROP table BillingCodeExchange
END
----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------
------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.80)
BEGIN
Update SystemConfigurations set DataModelVersion=15.81
PRINT 'STEP 7 COMPLETED'
END
Go
