
/****** Object:  Table [dbo].[CustomASAMLevelOfCares]    Script Date: 05/02/2013 12:49:09 ******/
/*
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomASAMLevelOfCares]') AND type in (N'U'))
DROP TABLE [dbo].[CustomASAMLevelOfCares]
GO
*/
IF Not EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomASAMLevelOfCares]') AND type in (N'U'))
Begin
	SET ANSI_NULLS ON
	--GO
	SET QUOTED_IDENTIFIER ON
	--GO
	SET ANSI_PADDING ON
	--GO
CREATE TABLE [dbo].[CustomASAMLevelOfCares](
	[ASAMLevelOfCareId] [int] IDENTITY(1,1) NOT NULL,
	[LevelOfCareName] [varchar](100) NULL,
	[LevelNumber] [int] NULL,
	[Dimension1Description] [varchar](1000) NULL,
	[Dimension2Description] [varchar](1000) NULL,
	[Dimension3Description] [varchar](1000) NULL,
	[Dimension4Description] [varchar](1000) NULL,
	[Dimension5Description] [varchar](1000) NULL,
	[Dimension6Description] [varchar](1000) NULL,
	[RowIdentifier] [dbo].[type_GUID] NOT NULL,
	[CreatedBy] [dbo].[type_CurrentUser] NOT NULL,
	[CreatedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	[ModifiedBy] [dbo].[type_CurrentUser] NOT NULL,
	[ModifiedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	[RecordDeleted] [dbo].[type_YOrN] NULL,
	[DeletedDate] [datetime] NULL,
	[DeletedBy] [dbo].[type_UserId] NULL,
 CONSTRAINT [CustomASAMLevelOfCares_PK] PRIMARY KEY CLUSTERED 
(
	[ASAMLevelOfCareId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
--GO
SET ANSI_PADDING OFF
--GO
/****** Object:  Check [CK__CustomASA__Recor__3DEDBF18]    Script Date: 05/02/2013 12:49:09 ******/
ALTER TABLE [dbo].[CustomASAMLevelOfCares]  WITH NOCHECK ADD CHECK  (([RecordDeleted]='N' OR [RecordDeleted]='Y'))
--GO

End
GO

-------------------------------------------1-------------------------------------


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomDocumentEventInformations]') AND type in (N'U'))
DROP TABLE [dbo].[CustomDocumentEventInformations]
GO

/****** Object:  Table [dbo].[CustomDocumentEventInformations]    Script Date: 04/30/2013 15:53:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomDocumentEventInformations](
	[DocumentVersionId] [int] NOT NULL,
	[CreatedBy] [dbo].[type_CurrentUser] NOT NULL,
	[CreatedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	[ModifiedBy] [dbo].[type_CurrentUser] NOT NULL,
	[ModifiedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	[RecordDeleted] [dbo].[type_YOrN] NULL,
	[DeletedDate] [datetime] NULL,
	[DeletedBy] [dbo].[type_UserId] NULL,
	[EventDateTime] [datetime] NULL,
	[InsurerId] [dbo].[type_GlobalCode] NULL,
 CONSTRAINT [CustomDocumentEventsInformations_PK] PRIMARY KEY CLUSTERED 
(
	[DocumentVersionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'Interact_Description_1.19', @value=N'Itis used to store globalcode of Category "XEVENTINSURER"' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CustomDocumentEventInformations', @level2type=N'COLUMN',@level2name=N'InsurerId'
GO
/****** Object:  Check [CK__CustomDoc__Recor__4342DED2]    Script Date: 04/30/2013 15:53:06 ******/
ALTER TABLE [dbo].[CustomDocumentEventInformations]  WITH CHECK ADD CHECK  (([RecordDeleted]='N' OR [RecordDeleted]='Y'))
GO
/****** Object:  ForeignKey [DocumentVersions_CustomDocumentEventInformations_FK]    Script Date: 04/30/2013 15:53:06 ******/
ALTER TABLE [dbo].[CustomDocumentEventInformations]  WITH CHECK ADD  CONSTRAINT [DocumentVersions_CustomDocumentEventInformations_FK] FOREIGN KEY([DocumentVersionId])
REFERENCES [dbo].[DocumentVersions] ([DocumentVersionId])
GO
ALTER TABLE [dbo].[CustomDocumentEventInformations] CHECK CONSTRAINT [DocumentVersions_CustomDocumentEventInformations_FK]
GO


-------------------------------------------2-------------------------------------

/*
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[CustomASAMLevelOfCares_CustomASAMPlacements_FK8]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomASAMPlacements]'))
ALTER TABLE [dbo].[CustomASAMPlacements] DROP CONSTRAINT [CustomASAMLevelOfCares_CustomASAMPlacements_FK8]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomASAMPlacements]') AND type in (N'U'))
ALTER TABLE [dbo].[CustomASAMPlacements] ALTER COLUMN FinalPlacement  [dbo].[type_GlobalCode]
GO
*/

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomASAMPlacements]') AND type in (N'U'))
DROP TABLE [dbo].[CustomASAMPlacements]
GO

/****** Object:  Table [dbo].[CustomASAMPlacements]    Script Date: 05/07/2013 17:37:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CustomASAMPlacements](
	[DocumentVersionId] [int] NOT NULL,
	[Dimension1LevelOfCare] [int] NULL,
	[Dimension1Need] [dbo].[type_Comment] NULL,
	[Dimension2LevelOfCare] [int] NULL,
	[Dimension2Need] [dbo].[type_Comment] NULL,
	[Dimension3LevelOfCare] [int] NULL,
	[Dimension3Need] [dbo].[type_Comment] NULL,
	[Dimension4LevelOfCare] [int] NULL,
	[Dimension4Need] [dbo].[type_Comment] NULL,
	[Dimension5LevelOfCare] [int] NULL,
	[Dimension5Need] [dbo].[type_Comment] NULL,
	[Dimension6LevelOfCare] [int] NULL,
	[Dimension6Need] [dbo].[type_Comment] NULL,
	[SuggestedPlacement] [int] NULL,
	[FinalPlacement] [dbo].[type_GlobalCode] NULL,
	[FinalPlacementComment] [dbo].[type_Comment] NULL,
	[RowIdentifier] [dbo].[type_GUID] NOT NULL,
	[CreatedBy] [dbo].[type_CurrentUser] NOT NULL,
	[CreatedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	[ModifiedBy] [dbo].[type_CurrentUser] NOT NULL,
	[ModifiedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	[RecordDeleted] [dbo].[type_YOrN] NULL,
	[DeletedDate] [datetime] NULL,
	[DeletedBy] [dbo].[type_UserId] NULL,
 CONSTRAINT [CustomASAMPlacements_PK] PRIMARY KEY CLUSTERED 
(
	[DocumentVersionId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Check [CK__CustomASA__Recor__27CE37D9]    Script Date: 05/07/2013 17:37:48 ******/
ALTER TABLE [dbo].[CustomASAMPlacements]  WITH CHECK ADD  CONSTRAINT [CK__CustomASA__Recor__27CE37D9] CHECK  (([RecordDeleted]='N' OR [RecordDeleted]='Y'))
GO
ALTER TABLE [dbo].[CustomASAMPlacements] CHECK CONSTRAINT [CK__CustomASA__Recor__27CE37D9]
GO
/****** Object:  ForeignKey [CustomASAMLevelOfCares_CustomASAMPlacements_FK]    Script Date: 05/07/2013 17:37:48 ******/
ALTER TABLE [dbo].[CustomASAMPlacements]  WITH CHECK ADD  CONSTRAINT [CustomASAMLevelOfCares_CustomASAMPlacements_FK] FOREIGN KEY([Dimension1LevelOfCare])
REFERENCES [dbo].[CustomASAMLevelOfCares] ([ASAMLevelOfCareId])
GO
ALTER TABLE [dbo].[CustomASAMPlacements] CHECK CONSTRAINT [CustomASAMLevelOfCares_CustomASAMPlacements_FK]
GO
/****** Object:  ForeignKey [CustomASAMLevelOfCares_CustomASAMPlacements_FK2]    Script Date: 05/07/2013 17:37:48 ******/
ALTER TABLE [dbo].[CustomASAMPlacements]  WITH CHECK ADD  CONSTRAINT [CustomASAMLevelOfCares_CustomASAMPlacements_FK2] FOREIGN KEY([Dimension2LevelOfCare])
REFERENCES [dbo].[CustomASAMLevelOfCares] ([ASAMLevelOfCareId])
GO
ALTER TABLE [dbo].[CustomASAMPlacements] CHECK CONSTRAINT [CustomASAMLevelOfCares_CustomASAMPlacements_FK2]
GO
/****** Object:  ForeignKey [CustomASAMLevelOfCares_CustomASAMPlacements_FK3]    Script Date: 05/07/2013 17:37:48 ******/
ALTER TABLE [dbo].[CustomASAMPlacements]  WITH CHECK ADD  CONSTRAINT [CustomASAMLevelOfCares_CustomASAMPlacements_FK3] FOREIGN KEY([Dimension3LevelOfCare])
REFERENCES [dbo].[CustomASAMLevelOfCares] ([ASAMLevelOfCareId])
GO
ALTER TABLE [dbo].[CustomASAMPlacements] CHECK CONSTRAINT [CustomASAMLevelOfCares_CustomASAMPlacements_FK3]
GO
/****** Object:  ForeignKey [CustomASAMLevelOfCares_CustomASAMPlacements_FK4]    Script Date: 05/07/2013 17:37:48 ******/
ALTER TABLE [dbo].[CustomASAMPlacements]  WITH CHECK ADD  CONSTRAINT [CustomASAMLevelOfCares_CustomASAMPlacements_FK4] FOREIGN KEY([Dimension4LevelOfCare])
REFERENCES [dbo].[CustomASAMLevelOfCares] ([ASAMLevelOfCareId])
GO
ALTER TABLE [dbo].[CustomASAMPlacements] CHECK CONSTRAINT [CustomASAMLevelOfCares_CustomASAMPlacements_FK4]
GO
/****** Object:  ForeignKey [CustomASAMLevelOfCares_CustomASAMPlacements_FK5]    Script Date: 05/07/2013 17:37:48 ******/
ALTER TABLE [dbo].[CustomASAMPlacements]  WITH CHECK ADD  CONSTRAINT [CustomASAMLevelOfCares_CustomASAMPlacements_FK5] FOREIGN KEY([Dimension5LevelOfCare])
REFERENCES [dbo].[CustomASAMLevelOfCares] ([ASAMLevelOfCareId])
GO
ALTER TABLE [dbo].[CustomASAMPlacements] CHECK CONSTRAINT [CustomASAMLevelOfCares_CustomASAMPlacements_FK5]
GO
/****** Object:  ForeignKey [CustomASAMLevelOfCares_CustomASAMPlacements_FK6]    Script Date: 05/07/2013 17:37:48 ******/
ALTER TABLE [dbo].[CustomASAMPlacements]  WITH CHECK ADD  CONSTRAINT [CustomASAMLevelOfCares_CustomASAMPlacements_FK6] FOREIGN KEY([Dimension6LevelOfCare])
REFERENCES [dbo].[CustomASAMLevelOfCares] ([ASAMLevelOfCareId])
GO
ALTER TABLE [dbo].[CustomASAMPlacements] CHECK CONSTRAINT [CustomASAMLevelOfCares_CustomASAMPlacements_FK6]
GO
/****** Object:  ForeignKey [CustomASAMLevelOfCares_CustomASAMPlacements_FK7]    Script Date: 05/07/2013 17:37:48 ******/
ALTER TABLE [dbo].[CustomASAMPlacements]  WITH CHECK ADD  CONSTRAINT [CustomASAMLevelOfCares_CustomASAMPlacements_FK7] FOREIGN KEY([SuggestedPlacement])
REFERENCES [dbo].[CustomASAMLevelOfCares] ([ASAMLevelOfCareId])
GO
ALTER TABLE [dbo].[CustomASAMPlacements] CHECK CONSTRAINT [CustomASAMLevelOfCares_CustomASAMPlacements_FK7]
GO
/****** Object:  ForeignKey [DocumentVersions_CustomASAMPlacements_FK]    Script Date: 05/07/2013 17:37:48 ******/
ALTER TABLE [dbo].[CustomASAMPlacements]  WITH CHECK ADD  CONSTRAINT [DocumentVersions_CustomASAMPlacements_FK] FOREIGN KEY([DocumentVersionId])
REFERENCES [dbo].[DocumentVersions] ([DocumentVersionId])
GO
ALTER TABLE [dbo].[CustomASAMPlacements] CHECK CONSTRAINT [DocumentVersions_CustomASAMPlacements_FK]
GO

-------------------------------------------3-------------------------------------



/*
	Created By: Swapan Mohan
	Created On: 29 January 2013
	Purpose	  : Task #128 3.5x Issues (Ace Project). To Make entries in "CustomASAMLevelOfCares" table.
*/
if not exists(Select 1 from [CustomASAMLevelOfCares] where ASAMLevelOfCareId=1 and [LevelOfCareName]='Level 0.5 Early Intervention')
BEGIN
	SET IDENTITY_INSERT [CustomASAMLevelOfCares] ON
		INSERT [CustomASAMLevelOfCares] ([ASAMLevelOfCareId],[LevelOfCareName], [LevelNumber], [Dimension1Description], [Dimension2Description], [Dimension3Description], [Dimension4Description], [Dimension5Description], [Dimension6Description]) 
		VALUES (1,N'Level 0.5 Early Intervention', NULL, N'The patient is not at risk of withdrawal', N'None or very stable', N'None or very stable', N'The patient is willing to explore how current alcohol or drug use  may affect personal goals.', N'The patient needs an understanding of, or skills to change,  His or her current alcohol and drug use pattern.', N'The patient’s social support system or significant others increase the risk Of personal conflict about alcohol or srug use.')
	SET IDENTITY_INSERT [CustomASAMLevelOfCares] OFF
END

if not exists(Select 1 from [CustomASAMLevelOfCares] where ASAMLevelOfCareId=2 and [LevelOfCareName]='Opioid Maintenance Therapy')
BEGIN
	SET IDENTITY_INSERT [CustomASAMLevelOfCares] ON
		INSERT [CustomASAMLevelOfCares] ([ASAMLevelOfCareId],[LevelOfCareName], [LevelNumber], [Dimension1Description], [Dimension2Description], [Dimension3Description], [Dimension4Description], [Dimension5Description], [Dimension6Description]) 
		VALUES (2,N'Opioid Maintenance Therapy', NULL, N'The patient is physiologically dependent on opiates and requires OMT to prevent withdrawal', N'None or manageable with outpatient medical monitoring', N'None or manageable in an outpatient structured enviornment', N'The patient is ready to change the negative effects of opiate use, but is not ready for total abstinence.', N'The patient is at high risk of relapse or continued use without  OMT and structured therapy to promote treatment progress.', N'The patient’s recovery environment is supportive and/or the Patient has skills to cope.')
	SET IDENTITY_INSERT [CustomASAMLevelOfCares] OFF
END

if not exists(Select 1 from [CustomASAMLevelOfCares] where ASAMLevelOfCareId=3 and [LevelOfCareName]='Level I OP Tx')
BEGIN
	SET IDENTITY_INSERT [CustomASAMLevelOfCares] ON
		INSERT [CustomASAMLevelOfCares] ([ASAMLevelOfCareId],[LevelOfCareName], [LevelNumber], [Dimension1Description], [Dimension2Description], [Dimension3Description], [Dimension4Description], [Dimension5Description], [Dimension6Description]) 
		VALUES (3,N'Level I OP Tx', NULL, N'The patient is not experiencing significant withdrawal or is at   minimal risk of severe withdrawal', N'None or very stable, or the patient is receiving concurrent medical Monitoring', N'None or very stable, or the patient is receiving concurrent  Mental health monitoring.', N'The patient is ready for recovery, but needs motivating and monitoring Strategies to strengthen readiness. Or there is high severity in this Dimension but not in other dimensions. The patient therefore needs a   Level I motivational enhancement program.', N'The patient is able to maintain abstinence or control use and   Pursue recovery or motivational goals with minimal support.', N'The patient’s recovery environment is supportive and/or the patient has skills to cope.')
	SET IDENTITY_INSERT [CustomASAMLevelOfCares] OFF
END

if not exists(Select 1 from [CustomASAMLevelOfCares] where ASAMLevelOfCareId=4 and [LevelOfCareName]='Level II.1 IOP')
BEGIN
	SET IDENTITY_INSERT [CustomASAMLevelOfCares] ON
		INSERT [CustomASAMLevelOfCares] ([ASAMLevelOfCareId],[LevelOfCareName], [LevelNumber], [Dimension1Description], [Dimension2Description], [Dimension3Description], [Dimension4Description], [Dimension5Description], [Dimension6Description]) 
		VALUES (4,N'Level II.1 IOP', NULL, N'The patient is at minimal risk of severe withdrawal', N'None or not a distraction from treatment. Such problems are manageable at Level II.1', N'Mild severity, with the potential to distract from recovery;  The patient needs monitoring.', N'The patient has variable engagement in treatment, ambivalence or   lack of awareness of the substance use or mental health problem,  and requires a structured program several times a week to promote  progress through the stages of change.', N'Intensification of the patient’s addiction or mental health symptoms indicate a high likelihood of relapse or continued use or continued  problems without close monitoring and support several times a week.', N'The patient’s recovery environment is not supportive but, with structure and support, the patient can cope.')
	SET IDENTITY_INSERT [CustomASAMLevelOfCares] OFF
END

if not exists(Select 1 from [CustomASAMLevelOfCares] where ASAMLevelOfCareId=5 and [LevelOfCareName]='Level II. 5 Partial')
BEGIN
	SET IDENTITY_INSERT [CustomASAMLevelOfCares] ON
		INSERT [CustomASAMLevelOfCares] ([ASAMLevelOfCareId],[LevelOfCareName], [LevelNumber], [Dimension1Description], [Dimension2Description], [Dimension3Description], [Dimension4Description], [Dimension5Description], [Dimension6Description]) 
		VALUES (5,N'Level II. 5 Partial', NULL, N'The patient is at moderate risk of severe withdrawal', N'None or not sufficient to distract from treatment. Such problems are manageable at Level II.5', N'Mild to moderate severity, with the potential to distract from  Recovery; the patient needs stabilization.', N'The patient has poor engagement in treatment, significant ambivalence, or lack of awareness of the substance use or mental health problem,requiring a near-daily structured program or intensive engagement   services to promote progress through the stages of change.', N'Intensification of the patient’s addiction or mental health symptoms, Despite active participation in a Level I ro II.1 program, indicates a High likelihood of relapse or continued use or continued use or  Continued problems without near-daily monitoring and support.', N'The patient’s recovery environment is not supportive but, with structure and support and relief from the home environment, the patient can cope.')
	SET IDENTITY_INSERT [CustomASAMLevelOfCares] OFF
END

if not exists(Select 1 from [CustomASAMLevelOfCares] where ASAMLevelOfCareId=6 and [LevelOfCareName]='Level III.1 Res (low)')
BEGIN
	SET IDENTITY_INSERT [CustomASAMLevelOfCares] ON
		INSERT [CustomASAMLevelOfCares] ([ASAMLevelOfCareId],[LevelOfCareName], [LevelNumber], [Dimension1Description], [Dimension2Description], [Dimension3Description], [Dimension4Description], [Dimension5Description], [Dimension6Description]) 
		VALUES (6,N'Level III.1 Res (low)', NULL, N'The patient is not at risk of withdrawal, or is experiencing minimal or stable withdrawal.  The patient is concurrently receiving   Level I-D (minimal) or Level II-D (moderate) services', N'None or stable, or the patient is receiving concurrent medical monitoring', N'None or minimal; not distracting to recovery.  If stable, a Dual  Diagnosis Capable program. If not a Dual Diagnosis Enhanced  Program is required.', N'The patient is open to recovery, but needs a structured environment To maintain therapeutic gains.', N'The patient understands relapse but needs structure to maintain  therapeutic gains.', N'The patient’s environment is dangerous, but recovery is achievable if Level III.1 24-hour structure is available.')
	SET IDENTITY_INSERT [CustomASAMLevelOfCares] OFF
END

GO

-------------------------------------------4-------------------------------------