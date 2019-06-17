----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.82)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.82 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of STEP 2 -------

------ STEP 3 ----------------

-- Added column(s) in Sites Table

IF OBJECT_ID('Sites')  IS NOT NULL
BEGIN
		IF COL_LENGTH('Sites','MondayOpen') IS NULL
		BEGIN
		 ALTER TABLE Sites ADD MondayOpen  varchar(250)  NULL
		END
		
		IF COL_LENGTH('Sites','MondayClose') IS NULL
		BEGIN
		 ALTER TABLE Sites ADD MondayClose  varchar(250)  NULL
		END
		
		IF COL_LENGTH('Sites','TuesdayOpen') IS NULL
		BEGIN
		 ALTER TABLE Sites ADD TuesdayOpen  varchar(250)  NULL
		END
		
		IF COL_LENGTH('Sites','TuesdayClose') IS NULL
		BEGIN
		 ALTER TABLE Sites ADD TuesdayClose  varchar(250)  NULL
		END
		
		IF COL_LENGTH('Sites','WednesdayOpen') IS NULL
		BEGIN
		 ALTER TABLE Sites ADD WednesdayOpen  varchar(250)  NULL
		END
		
		IF COL_LENGTH('Sites','WednesdayClose') IS NULL
		BEGIN
		 ALTER TABLE Sites ADD WednesdayClose  varchar(250)  NULL
		END
		
		IF COL_LENGTH('Sites','ThursdayOpen') IS NULL
		BEGIN
		 ALTER TABLE Sites ADD ThursdayOpen  varchar(250)  NULL
		END
		
		IF COL_LENGTH('Sites','ThursdayClose') IS NULL
		BEGIN
		 ALTER TABLE Sites ADD ThursdayClose  varchar(250)  NULL
		END
		
		IF COL_LENGTH('Sites','FridayOpen') IS NULL
		BEGIN
		 ALTER TABLE Sites ADD FridayOpen  varchar(250)  NULL
		END
		
		IF COL_LENGTH('Sites','FridayClose') IS NULL
		BEGIN
		 ALTER TABLE Sites ADD FridayClose  varchar(250)  NULL
		END
		
		IF COL_LENGTH('Sites','SaturdayOpen') IS NULL
		BEGIN
		 ALTER TABLE Sites ADD SaturdayOpen  varchar(250)  NULL
		END
		
		IF COL_LENGTH('Sites','SaturdayClose') IS NULL
		BEGIN
		 ALTER TABLE Sites ADD SaturdayClose  varchar(250)  NULL
		END
		
		IF COL_LENGTH('Sites','SundayOpen') IS NULL
		BEGIN
		 ALTER TABLE Sites ADD SundayOpen  varchar(250)  NULL
		END
		
		IF COL_LENGTH('Sites','SundayClose') IS NULL
		BEGIN
		 ALTER TABLE Sites ADD SundayClose  varchar(250)  NULL
		END
		
		PRINT 'STEP 3 COMPLETED'
	
END	
 
-----END Of STEP 3------------

------ STEP 4 ------------

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CredentialingSites')
BEGIN
/*  
 * TABLE: CredentialingSites
 */ 
CREATE TABLE CredentialingSites(
	CredentialingSiteId				  int identity(1,1) 		NOT NULL,
	CreatedBy                         type_CurrentUser			NOT NULL,
	CreatedDate                       type_CurrentDatetime		NOT NULL,
	ModifiedBy                        type_CurrentUser			NOT NULL,
	ModifiedDate                      type_CurrentDatetime		NOT NULL,
	RecordDeleted                     type_YOrN					NULL
									  CHECK (RecordDeleted in ('Y','N')),
	DeletedBy                         type_UserId				NULL,
	DeletedDate                       datetime					NULL,
	CredentialingId					  int						NULL,
    SiteInformation					  type_GlobalCode			NULL,
	CONSTRAINT CredentialingSites_PK PRIMARY KEY CLUSTERED (CredentialingSiteId) 
) 

 IF OBJECT_ID('CredentialingSites') IS NOT NULL
    PRINT '<<< CREATED TABLE CredentialingSites >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CredentialingSites >>>', 16, 1)
 
    
/* 
 * TABLE: CredentialingSites 
 */ 
   
ALTER TABLE CredentialingSites ADD CONSTRAint Credentialing_CredentialingSites_FK
    FOREIGN KEY (CredentialingId)
    REFERENCES Credentialing(CredentialingId)     
    
PRINT 'STEP 4(A) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CredentialingCulturalConsiderations')
BEGIN
/*  
 * TABLE: CredentialingCulturalConsiderations
 */ 
CREATE TABLE CredentialingCulturalConsiderations(
	CredentialingCulturalConsiderationId	int identity(1,1) 		NOT NULL,
	CreatedBy								type_CurrentUser		NOT NULL,
	CreatedDate								type_CurrentDatetime	NOT NULL,
	ModifiedBy								type_CurrentUser		NOT NULL,
	ModifiedDate							type_CurrentDatetime	NOT NULL,
	RecordDeleted							type_YOrN				NULL
											CHECK (RecordDeleted in ('Y','N')),
	DeletedBy								type_UserId				NULL,
	DeletedDate								datetime				NULL,
	CredentialingId							int						NULL,
    CulturalConsiderations					type_GlobalCode			NULL,
	CONSTRAINT CredentialingCulturalConsiderations_PK PRIMARY KEY CLUSTERED (CredentialingCulturalConsiderationId) 
) 

 IF OBJECT_ID('CredentialingCulturalConsiderations') IS NOT NULL
    PRINT '<<< CREATED TABLE CredentialingCulturalConsiderations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CredentialingCulturalConsiderations >>>', 16, 1)
 
    
/* 
 * TABLE: CredentialingCulturalConsiderations 
 */ 
 
ALTER TABLE CredentialingCulturalConsiderations ADD CONSTRAint Credentialing_CredentialingCulturalConsiderations_FK
    FOREIGN KEY (CredentialingId)
    REFERENCES Credentialing(CredentialingId)     
    
PRINT 'STEP 4(B) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CredentialingAgeGroupServed')
BEGIN
/*  
 * TABLE: CredentialingAgeGroupServed
 */ 
CREATE TABLE CredentialingAgeGroupServed(
	CredentialingAgeGroupServedId	  int identity(1,1) 		NOT NULL,
	CreatedBy                         type_CurrentUser			NOT NULL,
	CreatedDate                       type_CurrentDatetime		NOT NULL,
	ModifiedBy                        type_CurrentUser			NOT NULL,
	ModifiedDate                      type_CurrentDatetime		NOT NULL,
	RecordDeleted                     type_YOrN					NULL
									  CHECK (RecordDeleted in ('Y','N')),
	DeletedBy                         type_UserId				NULL,
	DeletedDate                       datetime					NULL,
	CredentialingId					  int						NULL,
    AgeGroupServed					  type_GlobalCode			NULL,
	CONSTRAINT CredentialingAgeGroupServed_PK PRIMARY KEY CLUSTERED (CredentialingAgeGroupServedId) 
) 

 IF OBJECT_ID('CredentialingAgeGroupServed') IS NOT NULL
    PRINT '<<< CREATED TABLE CredentialingAgeGroupServed >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CredentialingAgeGroupServed >>>', 16, 1)
 
    
/* 
 * TABLE: CredentialingAgeGroupServed 
 */ 
 
ALTER TABLE CredentialingAgeGroupServed ADD CONSTRAint Credentialing_CredentialingAgeGroupServed_FK
    FOREIGN KEY (CredentialingId)
    REFERENCES Credentialing(CredentialingId)      
    
PRINT 'STEP 4(C) COMPLETED'
END

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CredentialingLanguages')
BEGIN
/*  
 * TABLE: CredentialingLanguages
 */ 
CREATE TABLE CredentialingLanguages(
	CredentialingLanguageId			  int identity(1,1) 		NOT NULL,
	CreatedBy                         type_CurrentUser			NOT NULL,
	CreatedDate                       type_CurrentDatetime		NOT NULL,
	ModifiedBy                        type_CurrentUser			NOT NULL,
	ModifiedDate                      type_CurrentDatetime		NOT NULL,
	RecordDeleted                     type_YOrN					NULL
									  CHECK (RecordDeleted in ('Y','N')),
	DeletedBy                         type_UserId				NULL,
	DeletedDate                       datetime					NULL,
	CredentialingId					  int						NULL,
    CredentialLanguage				  type_GlobalCode			NULL,
	CONSTRAINT CredentialingLanguages_PK PRIMARY KEY CLUSTERED (CredentialingLanguageId) 
) 

 IF OBJECT_ID('CredentialingLanguages') IS NOT NULL
    PRINT '<<< CREATED TABLE CredentialingLanguages >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CredentialingLanguages >>>', 16, 1)
 
    
/* 
 * TABLE: CredentialingLanguages 
 */ 

ALTER TABLE CredentialingLanguages ADD CONSTRAint Credentialing_CredentialingLanguages_FK
    FOREIGN KEY (CredentialingId)
    REFERENCES Credentialing(CredentialingId)       
    
PRINT 'STEP 4(D) COMPLETED'
END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.82)
BEGIN
Update SystemConfigurations set DataModelVersion=15.83
PRINT 'STEP 7 COMPLETED'
END
Go



