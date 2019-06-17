----- STEP 1 ----------
IF (((SELECT value FROM SystemConfigurationKeys WHERE [key] = 'CDM_IncidentReport')  < 1.1 )or 
Not exists(SELECT 1 FROM SystemConfigurationKeys WHERE [key] = 'CDM_IncidentReport'))
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 1.1 for CDM_IncidentReport update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
--Part1 Begin
--Part1 Ends

--Part2 Begins


--Part2 Ends
-----End of Step 2 -------

------ STEP 3 ------------
-- add column to CustomIncidentReportDetails
IF OBJECT_ID('CustomIncidentReportDetails')  IS NOT NULL
BEGIN
		IF COL_LENGTH('CustomIncidentReportDetails','DetailsSupervisorFlaggedId') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportDetails ADD DetailsSupervisorFlaggedId int	NULL
		END

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Staff_CustomIncidentReportDetails_FK3]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomIncidentReportDetails]'))
	BEGIN
	ALTER TABLE CustomIncidentReportDetails   ADD  CONSTRAINT Staff_CustomIncidentReportDetails_FK3
		FOREIGN KEY(DetailsSupervisorFlaggedId)
		REFERENCES Staff (StaffId)
	END
	
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomIncidentReportDetails]') AND name = N'XIE1_CustomIncidentReportDetails')
	  BEGIN
	   CREATE NONCLUSTERED INDEX [XIE1_CustomIncidentReportDetails] ON [dbo].[CustomIncidentReportDetails] 
	   (
	   DetailsSupervisorFlaggedId  ASC
	   )
	   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomIncidentReportDetails') AND name='XIE1_CustomIncidentReportDetails')
	   PRINT '<<< CREATED INDEX CustomIncidentReportDetails.XIE1_CustomIncidentReportDetails >>>'
	   ELSE
	   RAISERROR('<<< FAILED CREATING INDEX CustomIncidentReportDetails.XIE1_CustomIncidentReportDetails >>>', 16, 1)  
	  END    
	  	
END

-- add column to CustomIncidentReportFallDetails
IF OBJECT_ID('CustomIncidentReportFallDetails')  IS NOT NULL
BEGIN
IF COL_LENGTH('CustomIncidentReportFallDetails','FallDetailsSupervisorFlaggedId') IS NULL
BEGIN
 ALTER TABLE CustomIncidentReportFallDetails ADD FallDetailsSupervisorFlaggedId int	NULL
END

  IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Staff_CustomIncidentReportFallDetails_FK2]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomIncidentReportFallDetails]'))
	BEGIN
	ALTER TABLE CustomIncidentReportFallDetails   ADD  CONSTRAINT Staff_CustomIncidentReportFallDetails_FK2
		FOREIGN KEY(FallDetailsSupervisorFlaggedId)
		REFERENCES Staff(StaffId)
	END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomIncidentReportFallDetails]') AND name = N'XIE1_CustomIncidentReportFallDetails')
	  BEGIN
	   CREATE NONCLUSTERED INDEX [XIE1_CustomIncidentReportFallDetails] ON [dbo].[CustomIncidentReportFallDetails] 
	   (
	   FallDetailsSupervisorFlaggedId  ASC
	   )
	   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomIncidentReportFallDetails') AND name='XIE1_CustomIncidentReportFallDetails')
	   PRINT '<<< CREATED INDEX CustomIncidentReportFallDetails.XIE1_CustomIncidentReportFallDetails >>>'
	   ELSE
	   RAISERROR('<<< FAILED CREATING INDEX CustomIncidentReportFallDetails.XIE1_CustomIncidentReportFallDetails >>>', 16, 1)  
	  END    
	  	
END

-- add column to CustomIncidentSeizureDetails
IF OBJECT_ID('CustomIncidentSeizureDetails')  IS NOT NULL
BEGIN

	IF COL_LENGTH('CustomIncidentSeizureDetails','IncidentSeizureDetailsSupervisorFlaggedId') IS NULL
	BEGIN
	 ALTER TABLE CustomIncidentSeizureDetails ADD IncidentSeizureDetailsSupervisorFlaggedId int	NULL
	END

	IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Staff_CustomIncidentSeizureDetails_FK3]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomIncidentSeizureDetails]'))
		BEGIN
		ALTER TABLE CustomIncidentSeizureDetails   ADD  CONSTRAINT Staff_CustomIncidentSeizureDetails_FK3
			FOREIGN KEY(IncidentSeizureDetailsSupervisorFlaggedId)
			REFERENCES Staff(StaffId)
		END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomIncidentSeizureDetails]') AND name = N'XIE1_CustomIncidentSeizureDetails')
	  BEGIN
	   CREATE NONCLUSTERED INDEX [XIE1_CustomIncidentSeizureDetails] ON [dbo].[CustomIncidentSeizureDetails] 
	   (
	   IncidentSeizureDetailsSupervisorFlaggedId  ASC
	   )
	   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomIncidentSeizureDetails') AND name='XIE1_CustomIncidentSeizureDetails')
	   PRINT '<<< CREATED INDEX CustomIncidentSeizureDetails.XIE1_CustomIncidentSeizureDetails >>>'
	   ELSE
	   RAISERROR('<<< FAILED CREATING INDEX CustomIncidentSeizureDetails.XIE1_CustomIncidentSeizureDetails >>>', 16, 1)  
	  END   		
END

IF OBJECT_ID('CustomIncidentReportSeizureFollowUpOfIndividualStatuses')  IS NOT NULL
BEGIN
		IF COL_LENGTH('CustomIncidentReportSeizureFollowUpOfIndividualStatuses','SeizureDetailsO2Given') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportSeizureFollowUpOfIndividualStatuses ADD SeizureDetailsO2Given  type_YOrN  NULL
																			 CHECK (SeizureDetailsO2Given   in('Y','N'))
		END
		
		IF COL_LENGTH('CustomIncidentReportSeizureFollowUpOfIndividualStatuses','SeizureDetailsLiterMin') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportSeizureFollowUpOfIndividualStatuses ADD SeizureDetailsLiterMin  varchar(max)  NULL
		END
		
		IF COL_LENGTH('CustomIncidentReportSeizureFollowUpOfIndividualStatuses','SeizureDetailsEmergencyMedicationsGiven') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportSeizureFollowUpOfIndividualStatuses ADD SeizureDetailsEmergencyMedicationsGiven   type_YOrN  NULL
																			 CHECK (SeizureDetailsEmergencyMedicationsGiven   in('Y','N'))
		END

END

-- added new column(s) in CustomIncidentReportSeizureFollowUpOfIndividualStatuses
IF OBJECT_ID('CustomIncidentReportSeizureFollowUpOfIndividualStatuses')  IS NOT NULL
BEGIN
		IF COL_LENGTH('CustomIncidentReportSeizureFollowUpOfIndividualStatuses','NoteType') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportSeizureFollowUpOfIndividualStatuses ADD NoteType  type_GlobalCode null
		END
		
		IF COL_LENGTH('CustomIncidentReportSeizureFollowUpOfIndividualStatuses','NoteStart') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportSeizureFollowUpOfIndividualStatuses ADD NoteStart    datetime null
		END
		
		IF COL_LENGTH('CustomIncidentReportSeizureFollowUpOfIndividualStatuses','NoteEnd') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportSeizureFollowUpOfIndividualStatuses ADD NoteEnd    datetime null
		END

		IF COL_LENGTH('CustomIncidentReportSeizureFollowUpOfIndividualStatuses','NoteComment') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportSeizureFollowUpOfIndividualStatuses ADD NoteComment     type_Comment2 null
		END
END	
---- added new column(s) in CustomIncidentReportFollowUpOfIndividualStatuses	

IF OBJECT_ID('CustomIncidentReportFollowUpOfIndividualStatuses')  IS NOT NULL
BEGIN
		IF COL_LENGTH('CustomIncidentReportFollowUpOfIndividualStatuses','NoteType') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportFollowUpOfIndividualStatuses ADD NoteType  type_GlobalCode null
		END
		
		IF COL_LENGTH('CustomIncidentReportFollowUpOfIndividualStatuses','NoteStart') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportFollowUpOfIndividualStatuses ADD NoteStart    datetime null
		END
		
		IF COL_LENGTH('CustomIncidentReportFollowUpOfIndividualStatuses','NoteEnd') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportFollowUpOfIndividualStatuses ADD NoteEnd    datetime null
		END

		IF COL_LENGTH('CustomIncidentReportFollowUpOfIndividualStatuses','NoteComment') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportFollowUpOfIndividualStatuses ADD NoteComment     type_Comment2 null
		END		
END	

---- added new column(s) in CustomIncidentReportFallFollowUpOfIndividualStatuses	
	
IF OBJECT_ID('CustomIncidentReportFallFollowUpOfIndividualStatuses')  IS NOT NULL
BEGIN
		IF COL_LENGTH('CustomIncidentReportFallFollowUpOfIndividualStatuses','NoteType') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportFallFollowUpOfIndividualStatuses ADD NoteType  type_GlobalCode null
		END
		
		IF COL_LENGTH('CustomIncidentReportFallFollowUpOfIndividualStatuses','NoteStart') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportFallFollowUpOfIndividualStatuses ADD NoteStart    datetime null
		END
		
		IF COL_LENGTH('CustomIncidentReportFallFollowUpOfIndividualStatuses','NoteEnd') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportFallFollowUpOfIndividualStatuses ADD NoteEnd    datetime null
		END

		IF COL_LENGTH('CustomIncidentReportFallFollowUpOfIndividualStatuses','NoteComment') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportFallFollowUpOfIndividualStatuses ADD NoteComment     type_Comment2 null
		END		
END	

---- added new column(s) in CustomIncidentReports	

IF OBJECT_ID('CustomIncidentReports')  IS NOT NULL
BEGIN
		IF COL_LENGTH('CustomIncidentReports','IncidentReportManagerFollowUpId') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReports ADD IncidentReportManagerFollowUpId   int  null
		END
		
		IF COL_LENGTH('CustomIncidentReports','IncidentReportSeizureManagerFollowUpId') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReports ADD IncidentReportSeizureManagerFollowUpId    int  null
		END
		
		IF COL_LENGTH('CustomIncidentReports','IncidentReportFallManagerFollowUpId') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReports ADD IncidentReportFallManagerFollowUpId    int  null
		END
		
		IF COL_LENGTH('CustomIncidentReports','ManagerFollowUpStatus') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReports ADD ManagerFollowUpStatus    type_GlobalCode  null
		END
		
		IF COL_LENGTH('CustomIncidentReports','SeizureManagerFollowUpStatus') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReports ADD SeizureManagerFollowUpStatus    type_GlobalCode  null
		END
		
		IF COL_LENGTH('CustomIncidentReports','FallManagerFollowUpStatus') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReports ADD FallManagerFollowUpStatus    type_GlobalCode  null
		END
		
END		

-- added new column(s) in CustomIncidentReportSupervisOrFollowUps
IF OBJECT_ID('CustomIncidentReportSupervisOrFollowUps')  IS NOT NULL
BEGIN
		IF COL_LENGTH('CustomIncidentReportSupervisOrFollowUps','SupervisorFollowUpManagerNotified') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportSupervisOrFollowUps ADD SupervisorFollowUpManagerNotified   type_YOrN  null
															 CHECK (SupervisorFollowUpManagerNotified in ('Y','N'))
		END
		
		IF COL_LENGTH('CustomIncidentReportSupervisOrFollowUps','SupervisorFollowUpManager') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportSupervisOrFollowUps ADD SupervisorFollowUpManager int null
		END
		
		IF COL_LENGTH('CustomIncidentReportSupervisOrFollowUps','SupervisorFollowUpManagerDateOfNotification') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportSupervisOrFollowUps ADD SupervisorFollowUpManagerDateOfNotification  datetime null
		END

		IF COL_LENGTH('CustomIncidentReportSupervisOrFollowUps','SupervisorFollowUpManagerTimeOfNotification') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportSupervisOrFollowUps ADD SupervisorFollowUpManagerTimeOfNotification  datetime  null
		END
		
		IF COL_LENGTH('CustomIncidentReportSupervisOrFollowUps','SupervisorFollowUpManager')IS  NOT NULL
		BEGIN
		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Staff_CustomIncidentReportSupervisOrFollowUps_FK5]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomIncidentReportSupervisOrFollowUps]'))	
		BEGIN
			ALTER TABLE CustomIncidentReportSupervisOrFollowUps ADD CONSTRAINT Staff_CustomIncidentReportSupervisOrFollowUps_FK5
			FOREIGN KEY (SupervisorFollowUpManager)
			REFERENCES Staff(StaffId)	 
		END 

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomIncidentReportSupervisOrFollowUps]') AND name = N'XIE1_CustomIncidentReportSupervisOrFollowUps')
	  BEGIN
	   CREATE NONCLUSTERED INDEX [XIE1_CustomIncidentReportSupervisOrFollowUps] ON [dbo].[CustomIncidentReportSupervisOrFollowUps] 
	   (
	   SupervisorFollowUpManager  ASC
	   )
	   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomIncidentReportSupervisOrFollowUps') AND name='XIE1_CustomIncidentReportSupervisOrFollowUps')
	   PRINT '<<< CREATED INDEX CustomIncidentReportSupervisOrFollowUps.XIE1_CustomIncidentReportSupervisOrFollowUps >>>'
	   ELSE
	   RAISERROR('<<< FAILED CREATING INDEX CustomIncidentReportSupervisOrFollowUps.XIE1_CustomIncidentReportSupervisOrFollowUps >>>', 16, 1)  
	  END     
	  		
		END
END		

-- added new column(s) in CustomIncidentReportFallSupervisOrFollowUps
IF OBJECT_ID('CustomIncidentReportFallSupervisOrFollowUps')  IS NOT NULL
BEGIN
		IF COL_LENGTH('CustomIncidentReportFallSupervisOrFollowUps','SupervisorFollowUpManagerNotified ') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportFallSupervisOrFollowUps ADD SupervisorFollowUpManagerNotified    type_YOrN  null
															 CHECK (SupervisorFollowUpManagerNotified  in ('Y','N'))
		END
		
		IF COL_LENGTH('CustomIncidentReportFallSupervisOrFollowUps','SupervisorFollowUpManager') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportFallSupervisOrFollowUps ADD SupervisorFollowUpManager int null
		END
		
		IF COL_LENGTH('CustomIncidentReportFallSupervisOrFollowUps','SupervisorFollowUpManagerDateOfNotification') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportFallSupervisOrFollowUps ADD SupervisorFollowUpManagerDateOfNotification  datetime null
		END

		IF COL_LENGTH('CustomIncidentReportFallSupervisOrFollowUps','SupervisorFollowUpManagerTimeOfNotification') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportFallSupervisOrFollowUps ADD SupervisorFollowUpManagerTimeOfNotification  datetime  null
		END	
		
		IF COL_LENGTH('CustomIncidentReportFallSupervisOrFollowUps','SupervisorFollowUpManager')IS  NOT NULL
		BEGIN
		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Staff_CustomIncidentReportFallSupervisOrFollowUps_FK5]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomIncidentReportFallSupervisOrFollowUps]'))	
		BEGIN
			ALTER TABLE CustomIncidentReportFallSupervisOrFollowUps ADD CONSTRAINT Staff_CustomIncidentReportFallSupervisOrFollowUps_FK5
			FOREIGN KEY (SupervisorFollowUpManager)
			REFERENCES Staff(StaffId)	 
		END
		
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomIncidentReportFallSupervisOrFollowUps]') AND name = N'XIE1_CustomIncidentReportFallSupervisOrFollowUps')
	  BEGIN
	   CREATE NONCLUSTERED INDEX [XIE1_CustomIncidentReportFallSupervisOrFollowUps] ON [dbo].[CustomIncidentReportFallSupervisOrFollowUps] 
	   (
	   SupervisorFollowUpManager  ASC
	   )
	   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomIncidentReportFallSupervisOrFollowUps') AND name='XIE1_CustomIncidentReportFallSupervisOrFollowUps')
	   PRINT '<<< CREATED INDEX CustomIncidentReportFallSupervisOrFollowUps.XIE1_CustomIncidentReportFallSupervisOrFollowUps >>>'
	   ELSE
	   RAISERROR('<<< FAILED CREATING INDEX CustomIncidentReportFallSupervisOrFollowUps.XIE1_CustomIncidentReportFallSupervisOrFollowUps >>>', 16, 1)  
	  END 
	  		 
		END
END		

-- added new column(s) in CustomIncidentReportSeizureSupervisOrFollowUps
IF OBJECT_ID('CustomIncidentReportSeizureSupervisOrFollowUps')  IS NOT NULL
BEGIN
		IF COL_LENGTH('CustomIncidentReportSeizureSupervisOrFollowUps','SupervisorFollowUpManagerNotified') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportSeizureSupervisOrFollowUps ADD SupervisorFollowUpManagerNotified    type_YOrN  null
															 CHECK (SupervisorFollowUpManagerNotified  in ('Y','N'))
		END
		
		IF COL_LENGTH('CustomIncidentReportSeizureSupervisOrFollowUps','SupervisorFollowUpManager') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportSeizureSupervisOrFollowUps ADD SupervisorFollowUpManager int null
		END
		
		IF COL_LENGTH('CustomIncidentReportSeizureSupervisOrFollowUps','SupervisorFollowUpManagerDateOfNotification') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportSeizureSupervisOrFollowUps ADD SupervisorFollowUpManagerDateOfNotification  datetime null
		END

		IF COL_LENGTH('CustomIncidentReportSeizureSupervisOrFollowUps','SupervisorFollowUpManagerTimeOfNotification') IS NULL
		BEGIN
		 ALTER TABLE CustomIncidentReportSeizureSupervisOrFollowUps ADD SupervisorFollowUpManagerTimeOfNotification  datetime  null
		END	
		
		IF COL_LENGTH('CustomIncidentReportSeizureSupervisOrFollowUps','SupervisorFollowUpManager')IS  NOT NULL
		BEGIN
		IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[Staff_CustomIncidentReportSeizureSupervisOrFollowUps_FK5]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomIncidentReportSeizureSupervisOrFollowUps]'))	
		BEGIN
			ALTER TABLE CustomIncidentReportSeizureSupervisOrFollowUps ADD CONSTRAINT Staff_CustomIncidentReportSeizureSupervisOrFollowUps_FK5
			FOREIGN KEY (SupervisorFollowUpManager)
			REFERENCES Staff(StaffId)	 
		END 

	IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[CustomIncidentReportSeizureSupervisOrFollowUps]') AND name = N'XIE1_CustomIncidentReportSeizureSupervisOrFollowUps')
		  BEGIN
		   CREATE NONCLUSTERED INDEX [XIE1_CustomIncidentReportSeizureSupervisOrFollowUps] ON [dbo].[CustomIncidentReportSeizureSupervisOrFollowUps] 
		   (
		   SupervisorFollowUpManager  ASC
		   )
		   WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		   IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomIncidentReportSeizureSupervisOrFollowUps') AND name='XIE1_CustomIncidentReportSeizureSupervisOrFollowUps')
		   PRINT '<<< CREATED INDEX CustomIncidentReportSeizureSupervisOrFollowUps.XIE1_CustomIncidentReportSeizureSupervisOrFollowUps >>>'
		   ELSE
		   RAISERROR('<<< FAILED CREATING INDEX CustomIncidentReportSeizureSupervisOrFollowUps.XIE1_CustomIncidentReportSeizureSupervisOrFollowUps >>>', 16, 1)  
		  END     		
			END			
	END	

	PRINT 'STEP 3 COMPLETED'

------ END OF STEP 3 -----

------ STEP 4 ----------
--1.4
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportManagerFollowUps')
BEGIN
/* 
 TABLE: CustomIncidentReportManagerFollowUps 
 */ 
 CREATE TABLE CustomIncidentReportManagerFollowUps( 
		IncidentReportManagerFollowUpId						int identity(1,1)	 NOT NULL,
		CreatedBy											type_CurrentUser     NOT NULL,
		CreatedDate											type_CurrentDatetime NOT NULL,
		ModifiedBy											type_CurrentUser     NOT NULL,
		ModifiedDate										type_CurrentDatetime NOT NULL,
		RecordDeleted										type_YOrN			 NULL
															CHECK (RecordDeleted in ('Y','N')),
		DeletedBy											type_UserId         NULL,
		DeletedDate											datetime			NULL,
		IncidentReportId									int					NULL,
		ManagerFollowUpManagerId							int					NULL,
		ManagerFollowUpAdministratorNotified				type_YOrN			NULL
															CHECK (ManagerFollowUpAdministratorNotified in ('Y','N')),
		ManagerFollowUpAdministrator						int					NULL,
		ManagerFollowUpAdminDateOfNotification				datetime			NULL,
		ManagerFollowUpAdminTimeOfNotification				datetime			NULL,
		ManagerReviewFollowUp								type_Comment2		NULL,
		SignedBy											int					NULL,
		SignedDate											datetime			NULL,
		PhysicalSignature									image				NULL,
		CurrentStatus										type_GlobalCode		NULL,
		InProgressStatus									type_GlobalCode		NULL,
		CONSTRAINT CustomIncidentReportManagerFollowUps_PK PRIMARY KEY CLUSTERED (IncidentReportManagerFollowUpId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportManagerFollowUps') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportManagerFollowUps >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportManagerFollowUps >>>', 16, 1)
    
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CustomIncidentReportManagerFollowUps') AND name='XIE1_CustomIncidentReportManagerFollowUps')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CustomIncidentReportManagerFollowUps] ON [dbo].[CustomIncidentReportManagerFollowUps] 
		(
		ManagerFollowUpManagerId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomIncidentReportManagerFollowUps') AND name='XIE1_CustomIncidentReportManagerFollowUps')
		PRINT '<<< CREATED INDEX CustomIncidentReportManagerFollowUps.XIE1_CustomIncidentReportManagerFollowUps >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CustomIncidentReportManagerFollowUps.XIE1_CustomIncidentReportManagerFollowUps >>>', 16, 1)		
		END
		
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CustomIncidentReportManagerFollowUps') AND name='XIE2_CustomIncidentReportManagerFollowUps')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_CustomIncidentReportManagerFollowUps] ON [dbo].[CustomIncidentReportManagerFollowUps] 
		(
		ManagerFollowUpAdministratorNotified ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomIncidentReportManagerFollowUps') AND name='XIE2_CustomIncidentReportManagerFollowUps')
		PRINT '<<< CREATED INDEX CustomIncidentReportManagerFollowUps.XIE2_CustomIncidentReportManagerFollowUps >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CustomIncidentReportManagerFollowUps.XIE2_CustomIncidentReportManagerFollowUps >>>', 16, 1)		
		END
				
/* 
 * TABLE: CustomIncidentReportManagerFollowUps 
 */   
   ALTER TABLE CustomIncidentReportManagerFollowUps ADD CONSTRAINT CustomIncidentReports_CustomIncidentReportManagerFollowUps_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES CustomIncidentReports(IncidentReportId)
    
  ALTER TABLE CustomIncidentReports ADD CONSTRAINT CustomIncidentReportManagerFollowUps_CustomIncidentReports_FK 
    FOREIGN KEY (IncidentReportManagerFollowUpId)
    REFERENCES CustomIncidentReportManagerFollowUps(IncidentReportManagerFollowUpId)
    
 PRINT 'STEP 4(A) COMPLETED'
 END
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportSeizureManagerFollowUps')
BEGIN
/* 
 TABLE: CustomIncidentReportSeizureManagerFollowUps 
 */ 
 CREATE TABLE CustomIncidentReportSeizureManagerFollowUps( 
		IncidentReportSeizureManagerFollowUpId				int identity(1,1)	 NOT NULL,
		CreatedBy											type_CurrentUser     NOT NULL,
		CreatedDate											type_CurrentDatetime NOT NULL,
		ModifiedBy											type_CurrentUser     NOT NULL,
		ModifiedDate										type_CurrentDatetime NOT NULL,
		RecordDeleted										type_YOrN			 NULL
															CHECK (RecordDeleted in ('Y','N')),
		DeletedBy											type_UserId         NULL,
		DeletedDate											datetime			NULL,
		IncidentReportId									int					NULL,
		ManagerFollowUpManagerId							int					NULL,
		ManagerFollowUpAdministratorNotified				type_YOrN			NULL
															CHECK (ManagerFollowUpAdministratorNotified in ('Y','N')),
		ManagerFollowUpAdministrator						int					NULL,
		ManagerFollowUpAdminDateOfNotification				datetime			NULL,
		ManagerFollowUpAdminTimeOfNotification				datetime			NULL,
		ManagerReviewFollowUp								type_Comment2		NULL,
		SignedBy											int					NULL,
		SignedDate											datetime			NULL,
		PhysicalSignature									image				NULL,
		CurrentStatus										type_GlobalCode		NULL,
		InProgressStatus									type_GlobalCode		NULL,
		CONSTRAINT CustomIncidentReportSeizureManagerFollowUps_PK PRIMARY KEY CLUSTERED (IncidentReportSeizureManagerFollowUpId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportSeizureManagerFollowUps') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportSeizureManagerFollowUps >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportSeizureManagerFollowUps >>>', 16, 1)
 
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CustomIncidentReportSeizureManagerFollowUps') AND name='XIE1_CustomIncidentReportSeizureManagerFollowUps')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CustomIncidentReportSeizureManagerFollowUps] ON [dbo].[CustomIncidentReportSeizureManagerFollowUps] 
		(
		IncidentReportId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomIncidentReportSeizureManagerFollowUps') AND name='XIE1_CustomIncidentReportSeizureManagerFollowUps')
		PRINT '<<< CREATED INDEX CustomIncidentReportSeizureManagerFollowUps.XIE1_CustomIncidentReportSeizureManagerFollowUps >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CustomIncidentReportSeizureManagerFollowUps.XIE1_CustomIncidentReportSeizureManagerFollowUps >>>', 16, 1)		
		END

 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CustomIncidentReportSeizureManagerFollowUps') AND name='XIE2_CustomIncidentReportSeizureManagerFollowUps')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_CustomIncidentReportSeizureManagerFollowUps] ON [dbo].[CustomIncidentReportSeizureManagerFollowUps] 
		(
		ManagerFollowUpAdministratorNotified ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomIncidentReportSeizureManagerFollowUps') AND name='XIE2_CustomIncidentReportSeizureManagerFollowUps')
		PRINT '<<< CREATED INDEX CustomIncidentReportSeizureManagerFollowUps.XIE2_CustomIncidentReportSeizureManagerFollowUps >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CustomIncidentReportSeizureManagerFollowUps.XIE2_CustomIncidentReportSeizureManagerFollowUps >>>', 16, 1)		
		END
		 
/* 
 * TABLE: CustomIncidentReportSeizureManagerFollowUps 
 */   
   ALTER TABLE CustomIncidentReportSeizureManagerFollowUps ADD CONSTRAINT CustomIncidentReports_CustomIncidentReportSeizureManagerFollowUps_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES CustomIncidentReports(IncidentReportId)
    
  ALTER TABLE CustomIncidentReports ADD CONSTRAINT CustomIncidentReportSeizureManagerFollowUps_CustomIncidentReports_FK 
    FOREIGN KEY (IncidentReportSeizureManagerFollowUpId)
    REFERENCES CustomIncidentReportSeizureManagerFollowUps(IncidentReportSeizureManagerFollowUpId)
    
 PRINT 'STEP 4(B) COMPLETED'
 END
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomIncidentReportFallManagerFollowUps')
BEGIN
/* 
 TABLE: CustomIncidentReportFallManagerFollowUps 
 */ 
 CREATE TABLE CustomIncidentReportFallManagerFollowUps( 
		IncidentReportFallManagerFollowUpId					int identity(1,1)	 NOT NULL,
		CreatedBy											type_CurrentUser     NOT NULL,
		CreatedDate											type_CurrentDatetime NOT NULL,
		ModifiedBy											type_CurrentUser     NOT NULL,
		ModifiedDate										type_CurrentDatetime NOT NULL,
		RecordDeleted										type_YOrN			 NULL
															CHECK (RecordDeleted in ('Y','N')),
		DeletedBy											type_UserId         NULL,
		DeletedDate											datetime			NULL,
		IncidentReportId									int					NULL,
		ManagerFollowUpManagerId							int					NULL,
		ManagerFollowUpAdministratorNotified				type_YOrN			NULL
															CHECK (ManagerFollowUpAdministratorNotified in ('Y','N')),
		ManagerFollowUpAdministrator						int					NULL,
		ManagerFollowUpAdminDateOfNotification				datetime			NULL,
		ManagerFollowUpAdminTimeOfNotification				datetime			NULL,
		ManagerReviewFollowUp								type_Comment2		NULL,
		SignedBy											int					NULL,
		SignedDate											datetime			NULL,
		PhysicalSignature									image				NULL,
		CurrentStatus										type_GlobalCode		NULL,
		InProgressStatus									type_GlobalCode		NULL,
		CONSTRAINT CustomIncidentReportFallManagerFollowUps_PK PRIMARY KEY CLUSTERED (IncidentReportFallManagerFollowUpId) 
 )
 
  IF OBJECT_ID('CustomIncidentReportFallManagerFollowUps') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomIncidentReportFallManagerFollowUps >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE CustomIncidentReportFallManagerFollowUps >>>', 16, 1)
    
 IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('CustomIncidentReportFallManagerFollowUps') AND name='XIE1_CustomIncidentReportFallManagerFollowUps')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_CustomIncidentReportFallManagerFollowUps] ON [dbo].[CustomIncidentReportFallManagerFollowUps] 
		(
		IncidentReportId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('CustomIncidentReportFallManagerFollowUps') AND name='XIE1_CustomIncidentReportFallManagerFollowUps')
		PRINT '<<< CREATED INDEX CustomIncidentReportFallManagerFollowUps.XIE1_CustomIncidentReportFallManagerFollowUps >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX CustomIncidentReportFallManagerFollowUps.XIE1_CustomIncidentReportFallManagerFollowUps >>>', 16, 1)		
		END
		
 /* 
 * TABLE: CustomIncidentReportFallManagerFollowUps 
 */   
   ALTER TABLE CustomIncidentReportFallManagerFollowUps ADD CONSTRAINT CustomIncidentReports_CustomIncidentReportFallManagerFollowUps_FK 
    FOREIGN KEY (IncidentReportId)
    REFERENCES CustomIncidentReports(IncidentReportId)
    
    ALTER TABLE CustomIncidentReports ADD CONSTRAINT CustomIncidentReportFallManagerFollowUps_CustomIncidentReports_FK 
    FOREIGN KEY (IncidentReportFallManagerFollowUpId)
    REFERENCES CustomIncidentReportFallManagerFollowUps(IncidentReportFallManagerFollowUpId)
    
 PRINT 'STEP 4(C) COMPLETED'
 END

--END Of STEP 4-----------

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------


------ STEP 7 -----------

IF ((SELECT cast(value as decimal(10,2)) FROM SystemConfigurationKeys WHERE [key] = 'CDM_IncidentReport')  = 1.1 )
BEGIN
	UPDATE SystemConfigurationKeys SET value ='1.2' WHERE [key] = 'CDM_IncidentReport'
	PRINT 'STEP 7 COMPLETED'
END
