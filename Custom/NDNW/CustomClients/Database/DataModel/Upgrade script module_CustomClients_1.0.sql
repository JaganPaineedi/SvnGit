------- STEP 1 ----------
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins 

--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------

-----End of Step 3 -------

------ STEP 4 ----------

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomClients')
BEGIN
/*  
 * TABLE: CustomClients 
 */
 CREATE TABLE CustomClients( 
		ClientId						int						 NOT NULL,
		CreatedBy						type_CurrentUser		 NOT NULL,
		CreatedDate						type_Currentdatetime	 NOT NULL,
		ModifiedBy						type_CurrentUser		 NOT NULL,
		ModifiedDate					type_Currentdatetime	 NOT NULL,
		RecordDeleted					type_YOrN				 NULL
										CHECK (RecordDeleted in ('Y','N')),
		DeletedBy						type_UserId				 NULL,
		DeletedDate						datetime				 NULL,
		AccompaniedByChild				type_YOrN				 NULL
										CHECK (AccompaniedByChild in ('Y','N')),
		ChildName1						varchar(250)			 NULL,
		ChildDOB1						datetime				 NULL,
		MoveInDate1						datetime				 NULL,
		MoveOutDate1					datetime				 NULL,
		ReasonForLeaving1				varchar(250)			 NULL,
		ChildName2						varchar(250)			 NULL,
		ChildDOB2						datetime				 NULL,
		MoveInDate2						datetime				 NULL,
		MoveOutDate2					datetime				 NULL,
		ReasonForLeaving2				varchar(250)			 NULL,
		ChildName3						varchar(250)			 NULL,
		ChildDOB3						varchar(250)			 NULL,
		MoveInDate3						datetime				 NULL,
		MoveOutDate3					datetime				 NULL,
		ReasonForLeaving3				varchar(250)			 NULL,
		CurrentlyEnrolledInEducation	type_YOrN				 NULL
										CHECK (CurrentlyEnrolledInEducation in ('Y','N')),
		NameOfSchool					varchar(250)			 NULL,
		TCUEntryDate					datetime				 NULL,
		TCUScore						varchar(250)			 NULL,
		NinetyDayScoreDate				datetime				 NULL,
		NinetyDayScore					varchar(250)			 NULL,
		DischargeScoreDate				datetime				 NULL,
		DischargeScore					varchar(250)			 NULL,
		AIPDateOfIncarceration			datetime				 NULL,
		AIPPotentialReleaseDate			datetime				 NULL,
		AIPActualReleaseDate			datetime				 NULL,
		AIPTransLeaveDate				datetime				 NULL,
		AIPPostPrisonSupervisionEndDate datetime				 NULL,
		CONSTRAINT CustomClients_PK PRIMARY KEY CLUSTERED (ClientId) 
 )
 
  IF OBJECT_ID('CustomClients') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomClients >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomClients >>>', 16, 1)
/* 
 * TABLE: CustomClients 
 */   
 
ALTER TABLE CustomClients ADD CONSTRAINT Clients_CustomClients_FK
    FOREIGN KEY (ClientId)
    REFERENCES Clients(ClientId)
 
    PRINT 'STEP 4 COMPLETED'
 END
 
  --END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------


------ STEP 7 -----------
IF NOT EXISTS (SELECT [key] FROM SystemConfigurationKeys WHERE [key] = 'CDM_CustomClients')
	BEGIN
		INSERT INTO SystemConfigurationKeys
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_CustomClients'
				   ,'1.0'
				   )
		PRINT 'STEP 7 COMPLETED'
	END
 GO