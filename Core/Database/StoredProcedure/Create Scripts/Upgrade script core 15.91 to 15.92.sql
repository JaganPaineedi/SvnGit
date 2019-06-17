----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 15.91)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 15.91 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------

-----End of STEP 2 -------

------ STEP 3 ----------------
 
-----END Of STEP 3------------

------ STEP 4 ------------

IF NOT EXISTS(SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='TwoFactorAuthenticationHistory')
BEGIN
/*  
 * TABLE: TwoFactorAuthenticationHistory
 */ 
CREATE TABLE TwoFactorAuthenticationHistory(
	TwoFactorAuthenticationHistoryId  int identity(1,1) 		NOT NULL,
	CreatedBy                         type_CurrentUser			NOT NULL,
	CreatedDate                       type_CurrentDatetime		NOT NULL,
	ModifiedBy                        type_CurrentUser			NOT NULL,
	ModifiedDate                      type_CurrentDatetime		NOT NULL,
	RecordDeleted                     type_YOrN					NULL
									  CHECK (RecordDeleted in ('Y','N')),
	DeletedBy                         type_UserId				NULL,
	DeletedDate                       datetime					NULL,
	LoggedInStaffId					  int						NOT NULL,
    RequestTime						  datetime					NOT NULL,
    Username						  varchar(100)				NOT NULL,
    Passed							  type_YOrN					NULL
									  CHECK (Passed in ('Y','N')),
	CONSTRAINT TwoFactorAuthenticationHistory_PK PRIMARY KEY CLUSTERED (TwoFactorAuthenticationHistoryId) 
) 

 IF OBJECT_ID('TwoFactorAuthenticationHistory') IS NOT NULL
    PRINT '<<< CREATED TABLE TwoFactorAuthenticationHistory >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE TwoFactorAuthenticationHistory >>>', 16, 1)
 
    
/* 
 * TABLE: TwoFactorAuthenticationHistory 
 */ 
     
    
PRINT 'STEP 4 COMPLETED'
END

----END Of STEP 4------------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------

IF ((select DataModelVersion FROM SystemConfigurations)  = 15.91)
BEGIN
Update SystemConfigurations set DataModelVersion=15.92
PRINT 'STEP 7 COMPLETED'
END
Go



