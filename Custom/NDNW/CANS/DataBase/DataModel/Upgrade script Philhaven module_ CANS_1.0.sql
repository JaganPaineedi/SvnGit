----- STEP 1 ----------

------ STEP 2 ----------
--Part1 Begin

--Part1 Ends

--Part2 Begins


--Part2 Ends

-----End of Step 2 -------

------ STEP 3 ------------

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentVersions_CustomDocumentCANSGenerals_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentCANSGenerals]'))
ALTER TABLE [dbo].[CustomDocumentCANSGenerals] DROP CONSTRAINT [DocumentVersions_CustomDocumentCANSGenerals_FK]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentVersions_CustomDocumentCANSYouthStrengths_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentCANSYouthStrengths]'))
ALTER TABLE [dbo].[CustomDocumentCANSYouthStrengths] DROP CONSTRAINT [DocumentVersions_CustomDocumentCANSYouthStrengths_FK]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentVersions_CustomDocumentCANSModules_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomDocumentCANSModules]'))
ALTER TABLE [dbo].[CustomDocumentCANSModules] DROP CONSTRAINT [DocumentVersions_CustomDocumentCANSModules_FK]
GO
-------------------------------------------------------------------------
/****** Object:  Table [dbo].[CustomDocumentCANSGenerals]    Script Date: 07/01/2013 09:52:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomDocumentCANSGenerals]') AND type in (N'U'))
DROP TABLE [dbo].[CustomDocumentCANSGenerals]
GO

/****** Object:  Table [dbo].[CustomDocumentCANSYouthStrengths]    Script Date: 07/01/2013 09:52:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomDocumentCANSYouthStrengths]') AND type in (N'U'))
DROP TABLE [dbo].[CustomDocumentCANSYouthStrengths]
GO

/****** Object:  Table [dbo].[CustomDocumentCANSModules]    Script Date: 07/01/2013 09:52:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomDocumentCANSModules]') AND type in (N'U'))
DROP TABLE [dbo].[CustomDocumentCANSModules]
GO

PRINT 'STEP 3 COMPLETED'
------ END OF STEP 3 -----

------ STEP 4 ----------
IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentCANSGenerals')
 BEGIN
/* 
 * TABLE: CustomDocumentCANSGenerals 
 */

CREATE TABLE CustomDocumentCANSGenerals
(
    DocumentVersionId				int                      NOT NULL,
    CreatedBy						[type_CurrentUser]       NOT NULL,
    CreatedDate						[type_CurrentDatetime]   NOT NULL,
    ModifiedBy						[type_CurrentUser]       NOT NULL,
    ModifiedDate					[type_CurrentDatetime]   NOT NULL,
    RecordDeleted					[type_YOrN]              NULL
									CHECK (RecordDeleted in	('Y','N')),
    DeletedBy						[type_UserId]            NULL,
    DeletedDate						datetime                 NULL,
    DocumentType					type_GlobalCode			 NULL,
    Psychosis						char(1)					 NULL
									CHECK (Psychosis in	('N','U','0','1','2','3')),
	AngerManagement					char(1)					 NULL
									CHECK (AngerManagement in	('N','U','0','1','2','3')),
	SubstanceAbuse					char(1)					 NULL
									CHECK (SubstanceAbuse in	('N','U','0','1','2','3')),
	DepressionAnxiety				char(1)					 NULL
									CHECK (DepressionAnxiety in	('N','U','0','1','2','3')),
    Attachment						char(1)					 NULL
									CHECK (Attachment in	('N','U','0','1','2','3')),	
	AttentionDefictImpluse			char(1)					 NULL
									CHECK (AttentionDefictImpluse in ('N','U','0','1','2','3')),	
	AdjustmenttoTrauma				char(1)					 NULL
									CHECK (AdjustmenttoTrauma in ('N','U','0','1','2','3')),
	OppositionalBehavior			char(1)					 NULL
									CHECK (OppositionalBehavior in ('N','U','0','1','2','3')),	
	AntisocialBehavior				char(1)					 NULL
									CHECK (AntisocialBehavior in ('N','U','0','1','2','3')),	
	Safety							char(1)					 NULL
									CHECK (Safety in ('N','U','0','1','2','3')),	
	Resources						char(1)					 NULL
									CHECK (Resources in	('N','U','0','1','2','3')),
	Supervision						char(1)					 NULL
									CHECK (Supervision in ('N','U','0','1','2','3')),	
	Knowledge						char(1)					 NULL
									CHECK (Knowledge in	('N','U','0','1','2','3')),	
	Involvement						char(1)					 NULL
									CHECK (Involvement in ('N','U','0','1','2','3')),	
	Organization					char(1)					 NULL
									CHECK (Organization in ('N','U','0','1','2','3')),	
	Development						char(1)					 NULL
									CHECK (Development in ('N','U','0','1','2','3')),
	PhysicalBehavioralHealth		char(1)					 NULL
									CHECK (PhysicalBehavioralHealth in ('N','U','0','1','2','3')),
	ResidentialStability			char(1)					 NULL
									CHECK (ResidentialStability in ('N','U','0','1','2','3')),
	Abuse							char(1)					 NULL
									CHECK (Abuse in	('N','U','0','1','2','3')),
	Neglect							char(1)					 NULL
									CHECK (Neglect in ('N','U','0','1','2','3')),
	Exploitation					char(1)					 NULL
									CHECK (Exploitation in ('N','U','0','1','2','3')),
	Permanency						char(1)					 NULL
									CHECK (Permanency in('N','U','0','1','2','3')),
	ChildSafety						char(1)					 NULL
									CHECK (ChildSafety in('N','U','0','1','2','3')),
	EmotionalCloseness				char(1)					 NULL
									CHECK (EmotionalCloseness in('N','U','0','1','2','3')),																																							
																																								
	CONSTRAINT CustomDocumentCANSGenerals_PK
    PRIMARY KEY CLUSTERED (DocumentVersionId)
)

IF OBJECT_ID('CustomDocumentCANSGenerals') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentCANSGenerals >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE CustomDocumentCANSGenerals >>>'

/* 
 * TABLE: CustomDocumentCANSGenerals 
 */
END

IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentCANSYouthStrengths')
 BEGIN
/* 
 * TABLE: CustomDocumentCANSYouthStrengths 
 */

CREATE TABLE CustomDocumentCANSYouthStrengths
(
    DocumentVersionId				int                      NOT NULL,
    CreatedBy						[type_CurrentUser]       NOT NULL,
    CreatedDate						[type_CurrentDatetime]   NOT NULL,
    ModifiedBy						[type_CurrentUser]       NOT NULL,
    ModifiedDate					[type_CurrentDatetime]   NOT NULL,
    RecordDeleted					[type_YOrN]              NULL
									CHECK (RecordDeleted in	('Y','N')),
    DeletedBy						[type_UserId]            NULL,
    DeletedDate						datetime                 NULL,
    Family							char(1)					 NULL
									CHECK (Family in ('N','U','0','1','2','3')),
	Optimism						char(1)					 NULL
									CHECK (Optimism in ('N','U','0','1','2','3')),
	Vocational						char(1)					 NULL
									CHECK (Vocational in ('N','U','0','1','2','3')),
	Resiliency						char(1)					 NULL
									CHECK (Resiliency in	('N','U','0','1','2','3')),
    Educational						char(1)					 NULL
									CHECK (Educational in	('N','U','0','1','2','3')),	
	Interpersonal					char(1)					 NULL
									CHECK (Interpersonal in ('N','U','0','1','2','3')),	
	Resourcefulness					char(1)					 NULL
									CHECK (Resourcefulness in ('N','U','0','1','2','3')),
	CommunityLife					char(1)					 NULL
									CHECK (CommunityLife in ('N','U','0','1','2','3')),	
	TalentInterests					char(1)					 NULL
									CHECK (TalentInterests in ('N','U','0','1','2','3')),	
	SpiritualReligious				char(1)					 NULL
									CHECK (SpiritualReligious in ('N','U','0','1','2','3')),	
	RelationPerformance				char(1)					 NULL
									CHECK (RelationPerformance in('N','U','0','1','2','3')),
	DangertoSelf					char(1)					 NULL
									CHECK (DangertoSelf in ('N','U','0','1','2','3')),	
	ViolentThinking					char(1)					 NULL
									CHECK (ViolentThinking in('N','U','0','1','2','3')),	
	Elopement						char(1)					 NULL
									CHECK (Elopement in ('N','U','0','1','2','3')),	
	SocialBehavior					char(1)					 NULL
									CHECK (SocialBehavior in ('N','U','0','1','2','3')),	
	OtherSelfHarm					char(1)					 NULL
									CHECK (OtherSelfHarm in ('N','U','0','1','2','3')),
	DangertoOthers					char(1)					 NULL
									CHECK (DangertoOthers in ('N','U','0','1','2','3')),
	CrimeDelinquency				char(1)					 NULL
									CHECK (CrimeDelinquency in ('N','U','0','1','2','3')),
	Commitment						char(1)					 NULL
									CHECK (Commitment in('N','U','0','1','2','3')),
	SexuallyAbusive					char(1)					 NULL
									CHECK (SexuallyAbusive in ('N','U','0','1','2','3')),
	SchoolBehavior					char(1)					 NULL
									CHECK (SchoolBehavior in ('N','U','0','1','2','3')),
	SexualDevelopment				char(1)					 NULL
									CHECK (SexualDevelopment in('N','U','0','1','2','3')),																																					
																																								
	CONSTRAINT CustomDocumentCANSYouthStrengths_PK
    PRIMARY KEY CLUSTERED (DocumentVersionId)
)

IF OBJECT_ID('CustomDocumentCANSYouthStrengths') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentCANSYouthStrengths >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE CustomDocumentCANSYouthStrengths >>>'

/* 
 * TABLE: CustomDocumentCANSYouthStrengths 
 */
END

IF Not EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE  TABLE_NAME='CustomDocumentCANSModules')
 BEGIN
/* 
 * TABLE: CustomDocumentCANSModules 
 */

CREATE TABLE CustomDocumentCANSModules
(
    DocumentVersionId				int                      NOT NULL,
    CreatedBy						[type_CurrentUser]       NOT NULL,
    CreatedDate						[type_CurrentDatetime]   NOT NULL,
    ModifiedBy						[type_CurrentUser]       NOT NULL,
    ModifiedDate					[type_CurrentDatetime]   NOT NULL,
    RecordDeleted					[type_YOrN]              NULL
									CHECK (RecordDeleted in	('Y','N')),
    DeletedBy						[type_UserId]            NULL,
    DeletedDate						datetime                 NULL,
    SeverityofUse					char(1)					 NULL
									CHECK (SeverityofUse in ('N','U','0','1','2','3')),
	DurationofUse					char(1)					 NULL
									CHECK (DurationofUse in ('N','U','0','1','2','3')),
	PeerInfluences					char(1)					 NULL
									CHECK (PeerInfluences in ('N','U','0','1','2','3')),
	StageofRecovery					char(1)					 NULL
									CHECK (StageofRecovery in	('N','U','0','1','2','3')),
    ParentalInfluences				char(1)					 NULL
									CHECK (ParentalInfluences in ('N','U','0','1','2','3')),	
	PhysicalAbuse					char(1)					 NULL
									CHECK (PhysicalAbuse in ('N','U','0','1','2','3')),	
	EmotionalAbuse					char(1)					 NULL
									CHECK (EmotionalAbuse in ('N','U','0','1','2','3')),
	WitnessofViolence				char(1)					 NULL
									CHECK (WitnessofViolence in ('N','U','0','1','2','3')),	
	SexualAbuse						char(1)					 NULL
									CHECK (SexualAbuse in ('N','U','0','1','2','3')),
	MedicalTrauma					char(1)					 NULL
									CHECK (MedicalTrauma in ('N','U','0','1','2','3')),																																				
																																								
	CONSTRAINT CustomDocumentCANSModules_PK
    PRIMARY KEY CLUSTERED (DocumentVersionId)
)

IF OBJECT_ID('CustomDocumentCANSModules') IS NOT NULL
    PRINT '<<< CREATED TABLE CustomDocumentCANSModules >>>'
ELSE
    PRINT '<<< FAILED CREATING TABLE CustomDocumentCANSModules >>>'

/* 
 * TABLE: CustomDocumentCANSModules 
 */
END



ALTER TABLE CustomDocumentCANSGenerals ADD CONSTRAINT DocumentVersions_CustomDocumentCANSGenerals_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
go

ALTER TABLE CustomDocumentCANSYouthStrengths ADD CONSTRAINT DocumentVersions_CustomDocumentCANSYouthStrengths_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
go

ALTER TABLE CustomDocumentCANSModules ADD CONSTRAINT DocumentVersions_CustomDocumentCANSModules_FK 
    FOREIGN KEY (DocumentVersionId)
    REFERENCES DocumentVersions(DocumentVersionId)
go

PRINT 'STEP 4 COMPLETED'
---------------------------------------------------------------
--END Of STEP 4

------ STEP 5 ----------------

-------END STEP 5-------------

------ STEP 6  ----------

------ STEP 7 -----------


If not exists (select [key] from SystemConfigurationKeys where [key] = 'CDM_CANS')
	begin
		INSERT INTO [dbo].[SystemConfigurationKeys]
				   (CreatedBy
				   ,CreateDate 
				   ,ModifiedBy
				   ,ModifiedDate
				   ,[Key]
				   ,Value
				   )
			 VALUES    
				   ('SHSDBA'
				   ,GETDATE()
				   ,'SHSDBA'
				   ,GETDATE()
				   ,'CDM_CANS'
				   ,'1.0'
				   )
            
	End
Else
	Begin
		Update SystemConfigurationKeys set value ='1.0' Where [key] = 'CDM_CANS'
	End
Go

PRINT 'STEP 7 COMPLETED'
