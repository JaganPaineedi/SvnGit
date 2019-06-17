----- STEP 1 ----------
IF ((select DataModelVersion FROM SystemConfigurations)  < 18.95)
BEGIN
	RAISERROR('<<< Data Model Version - Need data model version 18.95 for update.Upgrade Script Failed.>>>', 16, 1)
	RETURN 
END
------ STEP 2 ----------
-------------------------------------------------------------

------ STEP 3 ------------
IF OBJECT_ID('FlagTypes') IS NOT NULL
BEGIN

	IF COL_LENGTH('FlagTypes','DefaultWorkGroup') IS NULL
	BEGIN
	 ALTER TABLE FlagTypes ADD DefaultWorkGroup type_GlobalCode  NULL
	END
	
	IF COL_LENGTH('FlagTypes','FlagLinkTo') IS NULL
	 BEGIN
	  ALTER TABLE FlagTypes ADD FlagLinkTo char(1)  NULL
		   CHECK (FlagLinkTo in ('N','A','D','C'))
	 
	  EXEC sys.sp_addextendedproperty 'FlagTypes_Description'
	 ,'FlagLinkTo columns Stores N,A,D,C. N-Nothing D-Document, A-Action,C-Dynamic (this allows the user to specify the link at the time of client flag creation)'
	 ,'schema'
	 ,'dbo'
	 ,'table'
	 ,'FlagTypes'
	 ,'column'
	 ,'FlagLinkTo'
	END
	
IF COL_LENGTH('FlagTypes','DocumentCodeId') IS NULL
	BEGIN
	 ALTER TABLE FlagTypes ADD DocumentCodeId int  NULL
	END
	
	 IF COL_LENGTH('FlagTypes','DocumentCodeId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentCodes_FlagTypes_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[FlagTypes]'))
			BEGIN
				ALTER TABLE FlagTypes ADD CONSTRAINT DocumentCodes_FlagTypes_FK
				FOREIGN KEY (DocumentCodeId)
				REFERENCES DocumentCodes(DocumentCodeId) 
			END
	  END
	  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('FlagTypes') AND name='XIE1_FlagTypes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_FlagTypes] ON [dbo].[FlagTypes] 
		(
		DocumentCodeId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('FlagTypes') AND name='XIE1_FlagTypes')
		PRINT '<<< CREATED INDEX FlagTypes.XIE1_FlagTypes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX FlagTypes.XIE1_FlagTypes >>>', 16, 1)		
		END	
		
	IF COL_LENGTH('FlagTypes','ActionId') IS NULL
	BEGIN
	 ALTER TABLE FlagTypes ADD ActionId int  NULL
	END
	
	 IF COL_LENGTH('FlagTypes','ActionId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[SystemActions_FlagTypes_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[FlagTypes]'))
			BEGIN
				ALTER TABLE FlagTypes ADD CONSTRAINT SystemActions_FlagTypes_FK
				FOREIGN KEY (ActionId)
				REFERENCES SystemActions(ActionId) 
			END
	  END
	  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('FlagTypes') AND name='XIE2_FlagTypes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_FlagTypes] ON [dbo].[FlagTypes] 
		(
		ActionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('FlagTypes') AND name='XIE2_FlagTypes')
		PRINT '<<< CREATED INDEX FlagTypes.XIE2_FlagTypes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX FlagTypes.XIE2_FlagTypes >>>', 16, 1)		
		END			
		
END


IF OBJECT_ID('ClientNotes') IS NOT NULL
BEGIN

	IF COL_LENGTH('ClientNotes','OpenDate') IS NULL
	BEGIN
	 ALTER TABLE ClientNotes ADD OpenDate datetime  NULL
	END
	
	IF COL_LENGTH('ClientNotes','DueDate') IS NULL
	BEGIN
	 ALTER TABLE ClientNotes ADD DueDate datetime  NULL
	END
	
	
	IF COL_LENGTH('ClientNotes','FlagRecurs') IS NULL
	BEGIN
	 ALTER TABLE ClientNotes ADD FlagRecurs type_YOrN	 NULL
							CHECK (FlagRecurs in ('Y','N'))
	END
	
	IF COL_LENGTH('ClientNotes','CompletedBy') IS NULL
	BEGIN
	 ALTER TABLE ClientNotes ADD CompletedBy int  NULL
	END
	
	 IF COL_LENGTH('ClientNotes','CompletedBy')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Staff_ClientNotes_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClientNotes]'))
			BEGIN
				ALTER TABLE ClientNotes ADD CONSTRAINT Staff_ClientNotes_FK
				FOREIGN KEY (CompletedBy)
				REFERENCES Staff(StaffId) 
			END
	  END
	  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNotes') AND name='XIE2_ClientNotes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ClientNotes] ON [dbo].[ClientNotes] 
		(
		CompletedBy ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNotes') AND name='XIE2_ClientNotes')
		PRINT '<<< CREATED INDEX ClientNotes.XIE2_ClientNotes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientNotes.XIE2_ClientNotes >>>', 16, 1)		
		END
		
	IF COL_LENGTH('ClientNotes','FlagLinkTo') IS NULL
	 BEGIN
	  ALTER TABLE ClientNotes ADD FlagLinkTo char(1)  NULL
							  CHECK (FlagLinkTo in ('N','A','D'))
	 
	  EXEC sys.sp_addextendedproperty 'ClientNotes_Description'
	 ,'FlagLinkTo columns Stores N,A,D,C. N-Nothing D-Document,A-Action'
	 ,'schema'
	 ,'dbo'
	 ,'table'
	 ,'ClientNotes'
	 ,'column'
	 ,'FlagLinkTo'
	END	
			
	
	IF COL_LENGTH('ClientNotes','DocumentCodeId') IS NULL
		BEGIN
		 ALTER TABLE ClientNotes ADD DocumentCodeId int  NULL
		END
	  
	  
 IF COL_LENGTH('ClientNotes','DocumentCodeId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentCodes_ClientNotes_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClientNotes]'))
			BEGIN
				ALTER TABLE ClientNotes ADD CONSTRAINT DocumentCodes_ClientNotes_FK
				FOREIGN KEY (DocumentCodeId)
				REFERENCES DocumentCodes(DocumentCodeId) 
			END
	  END
	  	  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNotes') AND name='XIE3_ClientNotes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_ClientNotes] ON [dbo].[ClientNotes] 
		(
		DocumentCodeId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNotes') AND name='XIE3_ClientNotes')
		PRINT '<<< CREATED INDEX ClientNotes.XIE3_ClientNotes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientNotes.XIE3_ClientNotes >>>', 16, 1)		
		END	
		
IF COL_LENGTH('ClientNotes','DocumentId') IS NULL
	BEGIN
	 ALTER TABLE ClientNotes ADD DocumentId int  NULL
	END
		 
IF COL_LENGTH('ClientNotes','DocumentId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Documents_ClientNotes_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClientNotes]'))
			BEGIN
				ALTER TABLE ClientNotes ADD CONSTRAINT Documents_ClientNotes_FK
				FOREIGN KEY (DocumentId)
				REFERENCES Documents(DocumentId) 
			END
	  END		 
		  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNotes') AND name='XIE4_ClientNotes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE4_ClientNotes] ON [dbo].[ClientNotes] 
		(
		DocumentId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNotes') AND name='XIE4_ClientNotes')
		PRINT '<<< CREATED INDEX ClientNotes.XIE4_ClientNotes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientNotes.XIE4_ClientNotes >>>', 16, 1)		
		END	
		
		
		
	IF COL_LENGTH('ClientNotes','TrackingProtocolId') IS NULL
	BEGIN
	 ALTER TABLE ClientNotes ADD TrackingProtocolId int  NULL
	END
		 	 
		  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNotes') AND name='XIE5_ClientNotes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE5_ClientNotes] ON [dbo].[ClientNotes] 
		(
		TrackingProtocolId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNotes') AND name='XIE5_ClientNotes')
		PRINT '<<< CREATED INDEX ClientNotes.XIE5_ClientNotes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientNotes.XIE5_ClientNotes >>>', 16, 1)		
		END		
		
		
	IF COL_LENGTH('ClientNotes','TrackingProtocolFlagId') IS NULL
	BEGIN
	 ALTER TABLE ClientNotes ADD TrackingProtocolFlagId int  NULL
	END
		 		 
		  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNotes') AND name='XIE6_ClientNotes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE6_ClientNotes] ON [dbo].[ClientNotes] 
		(
		TrackingProtocolFlagId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNotes') AND name='XIE6_ClientNotes')
		PRINT '<<< CREATED INDEX ClientNotes.XIE6_ClientNotes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientNotes.XIE6_ClientNotes >>>', 16, 1)		
		END	
		
		
	IF COL_LENGTH('ClientNotes','ActionId') IS NULL
	BEGIN
	 ALTER TABLE ClientNotes ADD ActionId int  NULL
	END
	
	IF COL_LENGTH('ClientNotes','ActionId')IS NOT NULL
	 BEGIN
			IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[SystemActions_ClientNotes_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[ClientNotes]'))
			BEGIN
				ALTER TABLE ClientNotes ADD CONSTRAINT SystemActions_ClientNotes_FK
				FOREIGN KEY (ActionId)
				REFERENCES SystemActions(ActionId) 
			END
	  END
	  	  
	  IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNotes') AND name='XIE7_ClientNotes')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE7_ClientNotes] ON [dbo].[ClientNotes] 
		(
		ActionId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNotes') AND name='XIE7_ClientNotes')
		PRINT '<<< CREATED INDEX ClientNotes.XIE7_ClientNotes >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientNotes.XIE7_ClientNotes >>>', 16, 1)		
		END	
		
		IF COL_LENGTH('ClientNotes','Initials') IS NULL
		BEGIN
		 ALTER TABLE ClientNotes ADD Initials varchar(100)  NULL
		END	
				
	
END
 
 PRINT 'STEP 3 COMPLETED'

 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ClientNoteAssignedUsers')
BEGIN
/* 
 * TABLE: ClientNoteAssignedUsers 
 */
 CREATE TABLE ClientNoteAssignedUsers( 
		ClientNoteAssignedUserId				int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		ClientNoteId							int					 NULL,		
		StaffId									int					 NULL,
		CONSTRAINT ClientNoteAssignedUsers_PK PRIMARY KEY CLUSTERED (ClientNoteAssignedUserId) 
 )
 
  IF OBJECT_ID('ClientNoteAssignedUsers') IS NOT NULL
    PRINT '<<< CREATED TABLE ClientNoteAssignedUsers >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ClientNoteAssignedUsers >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNoteAssignedUsers') AND name='XIE1_ClientNoteAssignedUsers')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ClientNoteAssignedUsers] ON [dbo].[ClientNoteAssignedUsers] 
		(
		ClientNoteId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNoteAssignedUsers') AND name='XIE1_ClientNoteAssignedUsers')
		PRINT '<<< CREATED INDEX ClientNoteAssignedUsers.XIE1_ClientNoteAssignedUsers >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientNoteAssignedUsers.XIE1_ClientNoteAssignedUsers >>>', 16, 1)		
		END	
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNoteAssignedUsers') AND name='XIE2_ClientNoteAssignedUsers')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ClientNoteAssignedUsers] ON [dbo].[ClientNoteAssignedUsers] 
		(
		StaffId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNoteAssignedUsers') AND name='XIE2_ClientNoteAssignedUsers')
		PRINT '<<< CREATED INDEX ClientNoteAssignedUsers.XIE2_ClientNoteAssignedUsers >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientNoteAssignedUsers.XIE2_ClientNoteAssignedUsers >>>', 16, 1)		
		END	

/* 
 * TABLE: ClientNoteAssignedUsers 
 */   
 
ALTER TABLE ClientNoteAssignedUsers ADD CONSTRAINT ClientNotes_ClientNoteAssignedUsers_FK
    FOREIGN KEY (ClientNoteId)
    REFERENCES ClientNotes(ClientNoteId)
    
ALTER TABLE ClientNoteAssignedUsers ADD CONSTRAINT Staff_ClientNoteAssignedUsers_FK
    FOREIGN KEY (StaffId)
    REFERENCES Staff(StaffId)
    
   
 PRINT 'STEP 4(A) COMPLETED'
 END
 
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ClientNoteAssignedRoles')
BEGIN
/* 
 * TABLE: ClientNoteAssignedRoles 
 */
 CREATE TABLE ClientNoteAssignedRoles( 
		ClientNoteAssignedRoleId				int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		ClientNoteId							int					 NULL,		
		RoleId									type_GlobalCode		 NULL,
		CONSTRAINT ClientNoteAssignedRoles_PK PRIMARY KEY CLUSTERED (ClientNoteAssignedRoleId) 
 )
 
  IF OBJECT_ID('ClientNoteAssignedRoles') IS NOT NULL
    PRINT '<<< CREATED TABLE ClientNoteAssignedRoles >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ClientNoteAssignedRoles >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNoteAssignedRoles') AND name='XIE1_ClientNoteAssignedRoles')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ClientNoteAssignedRoles] ON [dbo].[ClientNoteAssignedRoles] 
		(
		ClientNoteId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNoteAssignedRoles') AND name='XIE1_ClientNoteAssignedRoles')
		PRINT '<<< CREATED INDEX ClientNoteAssignedRoles.XIE1_ClientNoteAssignedRoles >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientNoteAssignedRoles.XIE1_ClientNoteAssignedRoles >>>', 16, 1)		
		END	
		
/* 
 * TABLE: ClientNoteAssignedRoles 
 */   
 
ALTER TABLE ClientNoteAssignedRoles ADD CONSTRAINT ClientNotes_ClientNoteAssignedRoles_FK
    FOREIGN KEY (ClientNoteId)
    REFERENCES ClientNotes(ClientNoteId)
   
 PRINT 'STEP 4(B) COMPLETED'
 END
 
 
 

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='TrackingProtocols')
BEGIN
/* 
 * TABLE: TrackingProtocols 
 */
 CREATE TABLE TrackingProtocols( 
		TrackingProtocolId						int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,		
		ProtocolName							varchar(250)		 NULL,
		ProtocolDescription						type_Comment2		 NULL,
		StartDate								datetime             NULL,	
		EndDate									datetime             NULL,	
		Active									type_YOrN			 NULL
												CHECK (Active in ('Y','N')),
		CreateProtocol							type_GlobalCode		 NULL,
		CONSTRAINT TrackingProtocols_PK PRIMARY KEY CLUSTERED (TrackingProtocolId) 
 )
 
  IF OBJECT_ID('TrackingProtocols') IS NOT NULL
    PRINT '<<< CREATED TABLE TrackingProtocols >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE TrackingProtocols >>>', 16, 1)
/* 
 * TABLE: TrackingProtocols 
 */   
 
 
 ALTER TABLE ClientNotes ADD CONSTRAINT TrackingProtocols_ClientNotes_FK
	FOREIGN KEY (TrackingProtocolId)
	REFERENCES TrackingProtocols(TrackingProtocolId) 

    
 PRINT 'STEP 4(C) COMPLETED'
 END
 
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='TrackingProtocolPrograms')
BEGIN
/* 
 * TABLE: TrackingProtocolPrograms 
 */
 CREATE TABLE TrackingProtocolPrograms( 
		TrackingProtocolProgramId				int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		TrackingProtocolId						int					 NULL,		
		ProgramId								int					 NULL,	
		CONSTRAINT TrackingProtocolPrograms_PK PRIMARY KEY CLUSTERED (TrackingProtocolProgramId) 
 )
 
  IF OBJECT_ID('TrackingProtocolPrograms') IS NOT NULL
    PRINT '<<< CREATED TABLE TrackingProtocolPrograms >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE TrackingProtocolPrograms >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('TrackingProtocolPrograms') AND name='XIE1_TrackingProtocolPrograms')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_TrackingProtocolPrograms] ON [dbo].[TrackingProtocolPrograms] 
		(
		TrackingProtocolId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('TrackingProtocolPrograms') AND name='XIE1_TrackingProtocolPrograms')
		PRINT '<<< CREATED INDEX TrackingProtocolPrograms.XIE1_TrackingProtocolPrograms >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX TrackingProtocolPrograms.XIE1_TrackingProtocolPrograms >>>', 16, 1)		
		END	
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('TrackingProtocolPrograms') AND name='XIE2_TrackingProtocolPrograms')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_TrackingProtocolPrograms] ON [dbo].[TrackingProtocolPrograms] 
		(
		ProgramId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('TrackingProtocolPrograms') AND name='XIE2_TrackingProtocolPrograms')
		PRINT '<<< CREATED INDEX TrackingProtocolPrograms.XIE2_TrackingProtocolPrograms >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX TrackingProtocolPrograms.XIE2_TrackingProtocolPrograms >>>', 16, 1)		
		END	

/* 
 * TABLE: TrackingProtocolPrograms 
 */   
 
ALTER TABLE TrackingProtocolPrograms ADD CONSTRAINT TrackingProtocols_TrackingProtocolPrograms_FK
    FOREIGN KEY (TrackingProtocolId)
    REFERENCES TrackingProtocols(TrackingProtocolId)
    
ALTER TABLE TrackingProtocolPrograms ADD CONSTRAINT Programs_TrackingProtocolPrograms_FK
    FOREIGN KEY (ProgramId)
    REFERENCES Programs(ProgramId)
    
   
 PRINT 'STEP 4(D) COMPLETED'
 END
 
 
 IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='TrackingProtocolFlags')
BEGIN
/* 
 * TABLE: TrackingProtocolFlags 
 */
 CREATE TABLE TrackingProtocolFlags( 
		TrackingProtocolFlagId					int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		TrackingProtocolId						int					 NULL,	
		FlagTypeId								int				     NULL,	
		Active									type_YOrN			 NULL
												CHECK (Active in ('Y','N')),
		Recurring								char(1)				 NULL
												CHECK (Recurring in ('R','N')),
		DueDateType								char(1)				 NULL
												CHECK (DueDateType in ('U','M')),
		DueDateUnits							int					NULL,
		DueDateUnitType							type_GlobalCode		NULL,
		FirstDueDate							type_GlobalCode		NULL,
		FirstDueDateDays						int					NULL,
		DueDateStartDate						type_GlobalCode		NULL,
		DueDateStartDays						int					NULL,
		DueDateBasedOn							type_GlobalCode		NULL,
		CanBeCompletedNoSoonerThan				int					NULL,
		FlagAssignment							char(1)				NULL
												CHECK (FlagAssignment in ('M','R')),
		Initials								varchar(100)		NULL,
		CONSTRAINT TrackingProtocolFlags_PK PRIMARY KEY CLUSTERED (TrackingProtocolFlagId) 
 )
 
  IF OBJECT_ID('TrackingProtocolFlags') IS NOT NULL
    PRINT '<<< CREATED TABLE TrackingProtocolFlags >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE TrackingProtocolFlags >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('TrackingProtocolFlags') AND name='XIE1_TrackingProtocolFlags')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_TrackingProtocolFlags] ON [dbo].[TrackingProtocolFlags] 
		(
		TrackingProtocolId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('TrackingProtocolFlags') AND name='XIE1_TrackingProtocolFlags')
		PRINT '<<< CREATED INDEX TrackingProtocolFlags.XIE1_TrackingProtocolFlags >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX TrackingProtocolFlags.XIE1_TrackingProtocolFlags >>>', 16, 1)		
		END	
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('TrackingProtocolFlags') AND name='XIE2_TrackingProtocolFlags')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_TrackingProtocolFlags] ON [dbo].[TrackingProtocolFlags] 
		(
		FlagTypeId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('TrackingProtocolFlags') AND name='XIE2_TrackingProtocolFlags')
		PRINT '<<< CREATED INDEX TrackingProtocolFlags.XIE2_TrackingProtocolFlags >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX TrackingProtocolFlags.XIE2_TrackingProtocolFlags >>>', 16, 1)		
		END	
		

/* 
 * TABLE: TrackingProtocolFlags 
 */   
 
ALTER TABLE TrackingProtocolFlags ADD CONSTRAINT TrackingProtocols_TrackingProtocolFlags_FK
    FOREIGN KEY (TrackingProtocolId)
    REFERENCES TrackingProtocols(TrackingProtocolId)

 ALTER TABLE TrackingProtocolFlags ADD CONSTRAINT FlagTypes_TrackingProtocolFlags_FK
    FOREIGN KEY (FlagTypeId)
    REFERENCES FlagTypes(FlagTypeId)       
    
ALTER TABLE ClientNotes ADD CONSTRAINT TrackingProtocolFlags_ClientNotes_FK
		FOREIGN KEY (TrackingProtocolFlagId)
		REFERENCES TrackingProtocolFlags(TrackingProtocolFlagId) 
	  
    
 EXEC sys.sp_addextendedproperty 'TrackingProtocolFlags_Description'
	,'Recurring columns Stores R,N. R-Recurring Flag, N-Non Recurring Flag'
	,'schema'
	,'dbo'
	,'table'
	,'TrackingProtocolFlags'
	,'column'
	,'Recurring'
	
	
EXEC sys.sp_addextendedproperty 'TrackingProtocolFlags_Description'
	,'DueDateType columns Stores U,M. U-Units, M-  Manually'
	,'schema'
	,'dbo'
	,'table'
	,'TrackingProtocolFlags'
	,'column'
	,'DueDateType'
	
EXEC sys.sp_addextendedproperty 'TrackingProtocolFlags_Description'
	,'FlagAssignment columns Stores R,M. R-By Role, M-  Manually'
	,'schema'
	,'dbo'
	,'table'
	,'TrackingProtocolFlags'
	,'column'
	,'FlagAssignment'
    
 PRINT 'STEP 4(E) COMPLETED'
 END
 
 

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='TrackingProtocolFlagRoles')
BEGIN
/* 
 * TABLE: TrackingProtocolFlagRoles 
 */
 CREATE TABLE TrackingProtocolFlagRoles( 
		TrackingProtocolFlagRoleId				int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		TrackingProtocolFlagId					int					 NULL,		
		RoleId									type_GlobalCode		 NULL,
		CONSTRAINT TrackingProtocolFlagRoles_PK PRIMARY KEY CLUSTERED (TrackingProtocolFlagRoleId) 
 )
 
  IF OBJECT_ID('TrackingProtocolFlagRoles') IS NOT NULL
    PRINT '<<< CREATED TABLE TrackingProtocolFlagRoles >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE TrackingProtocolFlagRoles >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('TrackingProtocolFlagRoles') AND name='XIE1_TrackingProtocolFlagRoles')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_TrackingProtocolFlagRoles] ON [dbo].[TrackingProtocolFlagRoles] 
		(
		TrackingProtocolFlagId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('TrackingProtocolFlagRoles') AND name='XIE1_TrackingProtocolFlagRoles')
		PRINT '<<< CREATED INDEX TrackingProtocolFlagRoles.XIE1_TrackingProtocolFlagRoles >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX TrackingProtocolFlagRoles.XIE1_TrackingProtocolFlagRoles >>>', 16, 1)		
		END	
		

/* 
 * TABLE: TrackingProtocolFlagRoles 
 */   
 
ALTER TABLE TrackingProtocolFlagRoles ADD CONSTRAINT TrackingProtocolFlags_TrackingProtocolFlagRoles_FK
    FOREIGN KEY (TrackingProtocolFlagId)
    REFERENCES TrackingProtocolFlags(TrackingProtocolFlagId)
   
 PRINT 'STEP 4(F) COMPLETED'
 END
 
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='ClientNoteTrackingProtocolHistory')
BEGIN
/* 
 * TABLE: ClientNoteTrackingProtocolHistory 
 */
 CREATE TABLE ClientNoteTrackingProtocolHistory( 
		ClientNoteTrackingProtocolHistoryId		int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		ClientNoteId							int					 NULL,		
		TrackingProtocolId						int					 NULL,
		TrackingProtocolFlagId					int					 NULL,
		StartDate								datetime             NULL,
		EndDate									datetime             NULL,
		CONSTRAINT ClientNoteTrackingProtocolHistory_PK PRIMARY KEY CLUSTERED (ClientNoteTrackingProtocolHistoryId) 
 )
 
  IF OBJECT_ID('ClientNoteTrackingProtocolHistory') IS NOT NULL
    PRINT '<<< CREATED TABLE ClientNoteTrackingProtocolHistory >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE ClientNoteTrackingProtocolHistory >>>', 16, 1)
    
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNoteTrackingProtocolHistory') AND name='XIE1_ClientNoteTrackingProtocolHistory')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE1_ClientNoteTrackingProtocolHistory] ON [dbo].[ClientNoteTrackingProtocolHistory] 
		(
		ClientNoteId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNoteTrackingProtocolHistory') AND name='XIE1_ClientNoteTrackingProtocolHistory')
		PRINT '<<< CREATED INDEX ClientNoteTrackingProtocolHistory.XIE1_ClientNoteTrackingProtocolHistory >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientNoteTrackingProtocolHistory.XIE1_ClientNoteTrackingProtocolHistory >>>', 16, 1)		
		END	
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNoteTrackingProtocolHistory') AND name='XIE2_ClientNoteTrackingProtocolHistory')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE2_ClientNoteTrackingProtocolHistory] ON [dbo].[ClientNoteTrackingProtocolHistory] 
		(
		TrackingProtocolId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNoteTrackingProtocolHistory') AND name='XIE2_ClientNoteTrackingProtocolHistory')
		PRINT '<<< CREATED INDEX ClientNoteTrackingProtocolHistory.XIE2_ClientNoteTrackingProtocolHistory >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientNoteTrackingProtocolHistory.XIE2_ClientNoteTrackingProtocolHistory >>>', 16, 1)		
		END	
		
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNoteTrackingProtocolHistory') AND name='XIE3_ClientNoteTrackingProtocolHistory')
		BEGIN
		CREATE NONCLUSTERED INDEX [XIE3_ClientNoteTrackingProtocolHistory] ON [dbo].[ClientNoteTrackingProtocolHistory] 
		(
		TrackingProtocolFlagId ASC
		)
		WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
		IF EXISTS (SELECT * FROM sys.indexes WHERE object_id=OBJECT_ID('ClientNoteTrackingProtocolHistory') AND name='XIE3_ClientNoteTrackingProtocolHistory')
		PRINT '<<< CREATED INDEX ClientNoteTrackingProtocolHistory.XIE3_ClientNoteTrackingProtocolHistory >>>'
		ELSE
		RAISERROR('<<< FAILED CREATING INDEX ClientNoteTrackingProtocolHistory.XIE3_ClientNoteTrackingProtocolHistory >>>', 16, 1)		
		END	

/* 
 * TABLE: ClientNoteTrackingProtocolHistory 
 */   
 
ALTER TABLE ClientNoteTrackingProtocolHistory ADD CONSTRAINT ClientNotes_ClientNoteTrackingProtocolHistory_FK
    FOREIGN KEY (ClientNoteId)
    REFERENCES ClientNotes(ClientNoteId)
    
ALTER TABLE ClientNoteTrackingProtocolHistory ADD CONSTRAINT TrackingProtocols_ClientNoteTrackingProtocolHistory_FK
    FOREIGN KEY (TrackingProtocolId)
    REFERENCES TrackingProtocols(TrackingProtocolId)
    
ALTER TABLE ClientNoteTrackingProtocolHistory ADD CONSTRAINT TrackingProtocolFlags_ClientNoteTrackingProtocolHistory_FK
    FOREIGN KEY (TrackingProtocolFlagId)
    REFERENCES TrackingProtocolFlags(TrackingProtocolFlagId)
    
   
 PRINT 'STEP 4(G) COMPLETED'
 END
 
 
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='SystemEventConfigurations')
BEGIN
/* 
 * TABLE: SystemEventConfigurations 
 */
 CREATE TABLE SystemEventConfigurations( 
		SystemEventConfigurationId				int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		EventName								varchar(250)		 NULL,		
		EventType								varchar(250)		 NULL,
		EventTypeCode							varchar(250)		 NULL,
		EventQueueAgent							varchar(250)		 NULL,
		EventHandlerAgent						varchar(250)		 NULL,
		RealTime								type_YOrN			 NULL
												CHECK (RealTime in ('Y','N')),		
		CONSTRAINT SystemEventConfigurations_PK PRIMARY KEY CLUSTERED (SystemEventConfigurationId) 
 )
 
  IF OBJECT_ID('SystemEventConfigurations') IS NOT NULL
    PRINT '<<< CREATED TABLE SystemEventConfigurations >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE SystemEventConfigurations >>>', 16, 1)
    

/* 
 * TABLE: SystemEventConfigurations 
 */ 
 
 INSERT INTO SystemEventConfigurations
 (CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,EventName
,EventType
,EventTypeCode
,EventQueueAgent
,EventHandlerAgent
) 
VALUES (
	SYSTEM_USER
	,GETDATE()
	,SYSTEM_USER
	,GETDATE()
	,'Program Enrollment'
	,'GloablaCode'
	,'ProgramEnrollment'
	,'ssp_QueProgramEnrollmentEvent'
	,'ssp_ProcessClientNoteProgramEnrollment'
	)
	
, (
	SYSTEM_USER
	,GETDATE()
	,SYSTEM_USER
	,GETDATE()
	,'Program Requested'
	,'GloablaCode'
	,'ProgramRequested'
	,'ssp_QueOnProgramRequestedEvent'
	,'ssp_ProcessClientNoteProgramRequested'
	)
	
, (
	SYSTEM_USER
	,GETDATE()
	,SYSTEM_USER
	,GETDATE()
	,'Program Discharge'
	,'GloablaCode'
	,'ProgramDischarge'
	,'ssp_QueOnProgramDischargeEvent'
	,'ssp_ProcessClientNoteProgramDischarged'
	)
	
, (
	SYSTEM_USER
	,GETDATE()
	,SYSTEM_USER
	,GETDATE()
	,'Episode Start'
	,'ClientId'
	,'EpisodeStart'
	,'ssp_QueOnEpisodeStartEvent'
	,'ssp_ProcessClientNoteEpisodeStart'
	)
 
 


 PRINT 'STEP 4(H) COMPLETED'
 END
 
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='SystemEvents')
BEGIN
/* 
 * TABLE: SystemEvents 
 */
 CREATE TABLE SystemEvents( 
		SystemEventId							int identity(1,1)	 NOT NULL,
		CreatedBy								type_CurrentUser     NOT NULL,
		CreatedDate								type_CurrentDatetime NOT NULL,
		ModifiedBy								type_CurrentUser     NOT NULL,
		ModifiedDate							type_CurrentDatetime NOT NULL,
		RecordDeleted							type_YOrN			 NULL
												CHECK (RecordDeleted in ('Y','N')),
		DeletedBy								type_UserId          NULL,
		DeletedDate								datetime             NULL,
		SystemEventConfigurationId				int					 NULL,
		EventKeyId								int					 NULL,
		EventStatus								varchar(100)		 NULL,	
		CONSTRAINT SystemEvents_PK PRIMARY KEY CLUSTERED (SystemEventId) 
 )
 
  IF OBJECT_ID('SystemEvents') IS NOT NULL
    PRINT '<<< CREATED TABLE SystemEvents >>>'
ELSE
    RAISERROR('<<< FAILED CREATING TABLE SystemEvents >>>', 16, 1)
    

/* 
 * TABLE: SystemEvents 
 */ 
 
ALTER TABLE SystemEvents ADD CONSTRAINT SystemEventConfigurations_SystemEvents_FK
    FOREIGN KEY (SystemEventConfigurationId)
    REFERENCES SystemEventConfigurations(SystemEventConfigurationId)  
 

 PRINT 'STEP 4(I) COMPLETED'
 END
 
 
 
------END Of STEP 4---------------
IF OBJECT_ID('ClientNoteAssignedUsers') IS NOT NULL
BEGIN

INSERT INTO ClientNoteAssignedUsers
 (CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,ClientNoteId
,StaffId
)
SELECT 
CreatedBy
,CreatedDate
,ModifiedBy
,ModifiedDate
,ClientNoteId
,AssignedTo
FROM ClientNotes C
WHERE NOT EXISTS (SELECT 1 FROM ClientNoteAssignedUsers CN WHERE CN.ClientNoteId=C.ClientNoteId AND C.AssignedTo=CN.StaffId)
AND ISNULL(C.RecordDeleted,'N')='N'
AND C.AssignedTo IS NOT NULL
END



------ STEP 5 ----------------

-------END STEP 5-------------
------ STEP 6  ----------

----END Of STEP 6 ------------

------ STEP 7 -----------
IF ((select DataModelVersion FROM SystemConfigurations)  = 18.95)
BEGIN
Update SystemConfigurations set DataModelVersion=18.96
PRINT 'STEP 7 COMPLETED'
END
Go