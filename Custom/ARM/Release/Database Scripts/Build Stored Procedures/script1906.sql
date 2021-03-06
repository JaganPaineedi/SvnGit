/****** Object:  ForeignKey [DocumentCodes_CustomFields_FK]    Script Date: 06/19/2013 11:46:50 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentCodes_CustomFields_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFields]'))
ALTER TABLE [dbo].[CustomFields] DROP CONSTRAINT [DocumentCodes_CustomFields_FK]
GO
/****** Object:  ForeignKey [DocumentCodes_CustomFieldsData_FK]    Script Date: 06/19/2013 11:46:50 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentCodes_CustomFieldsData_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFieldsData]'))
ALTER TABLE [dbo].[CustomFieldsData] DROP CONSTRAINT [DocumentCodes_CustomFieldsData_FK]
GO
/****** Object:  Check [CK__CustomFie__Activ__2785B5C4]    Script Date: 06/19/2013 11:46:50 ******/
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomFie__Activ__2785B5C4]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFields]'))
BEGIN
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomFie__Activ__2785B5C4]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFields]'))
ALTER TABLE [dbo].[CustomFields] DROP CONSTRAINT [CK__CustomFie__Activ__2785B5C4]

END
GO
/****** Object:  Check [CK__CustomFie__Recor__2879D9FD]    Script Date: 06/19/2013 11:46:50 ******/
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomFie__Recor__2879D9FD]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFields]'))
BEGIN
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomFie__Recor__2879D9FD]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFields]'))
ALTER TABLE [dbo].[CustomFields] DROP CONSTRAINT [CK__CustomFie__Recor__2879D9FD]

END
GO
/****** Object:  Check [CK__CustomFie__Recor__296DFE36]    Script Date: 06/19/2013 11:46:50 ******/
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomFie__Recor__296DFE36]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFieldsData]'))
BEGIN
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomFie__Recor__296DFE36]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFieldsData]'))
ALTER TABLE [dbo].[CustomFieldsData] DROP CONSTRAINT [CK__CustomFie__Recor__296DFE36]

END
GO
/****** Object:  Table [dbo].[CustomFields]    Script Date: 06/19/2013 11:46:50 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentCodes_CustomFields_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFields]'))
ALTER TABLE [dbo].[CustomFields] DROP CONSTRAINT [DocumentCodes_CustomFields_FK]
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomFie__Activ__2785B5C4]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFields]'))
ALTER TABLE [dbo].[CustomFields] DROP CONSTRAINT [CK__CustomFie__Activ__2785B5C4]
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomFie__Recor__2879D9FD]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFields]'))
ALTER TABLE [dbo].[CustomFields] DROP CONSTRAINT [CK__CustomFie__Recor__2879D9FD]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomFields]') AND type in (N'U'))
DROP TABLE [dbo].[CustomFields]
GO
/****** Object:  Table [dbo].[CustomFieldsData]    Script Date: 06/19/2013 11:46:50 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentCodes_CustomFieldsData_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFieldsData]'))
ALTER TABLE [dbo].[CustomFieldsData] DROP CONSTRAINT [DocumentCodes_CustomFieldsData_FK]
GO
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomFie__Recor__296DFE36]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFieldsData]'))
ALTER TABLE [dbo].[CustomFieldsData] DROP CONSTRAINT [CK__CustomFie__Recor__296DFE36]
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomFieldsData]') AND type in (N'U'))
DROP TABLE [dbo].[CustomFieldsData]
GO
/****** Object:  Table [dbo].[CustomFieldsData]    Script Date: 06/19/2013 11:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomFieldsData]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CustomFieldsData](
	[CustomFieldsDataId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentType] [dbo].[type_GlobalCode] NULL,
	[DocumentCodeId] [int] NULL,
	[PrimaryKey1] [int] NULL,
	[PrimaryKey2] [int] NOT NULL,
	[ColumnVarchar1] [varchar](250) NULL,
	[ColumnVarchar2] [varchar](250) NULL,
	[ColumnVarchar3] [varchar](250) NULL,
	[ColumnVarchar4] [varchar](250) NULL,
	[ColumnVarchar5] [varchar](250) NULL,
	[ColumnVarchar6] [varchar](250) NULL,
	[ColumnVarchar7] [varchar](250) NULL,
	[ColumnVarchar8] [varchar](250) NULL,
	[ColumnVarchar9] [varchar](250) NULL,
	[ColumnVarchar10] [varchar](250) NULL,
	[ColumnVarchar11] [varchar](250) NULL,
	[ColumnVarchar12] [varchar](250) NULL,
	[ColumnVarchar13] [varchar](250) NULL,
	[ColumnVarchar14] [varchar](250) NULL,
	[ColumnVarchar15] [varchar](250) NULL,
	[ColumnVarchar16] [varchar](250) NULL,
	[ColumnVarchar17] [varchar](250) NULL,
	[ColumnVarchar18] [varchar](250) NULL,
	[ColumnVarchar19] [varchar](250) NULL,
	[ColumnVarchar20] [varchar](250) NULL,
	[ColumnText1] [dbo].[type_Comment] NULL,
	[ColumnText2] [dbo].[type_Comment] NULL,
	[ColumnText3] [dbo].[type_Comment] NULL,
	[ColumnText4] [dbo].[type_Comment] NULL,
	[ColumnText5] [dbo].[type_Comment] NULL,
	[ColumnText6] [dbo].[type_Comment] NULL,
	[ColumnText7] [dbo].[type_Comment] NULL,
	[ColumnText8] [dbo].[type_Comment] NULL,
	[ColumnText9] [dbo].[type_Comment] NULL,
	[ColumnText10] [dbo].[type_Comment] NULL,
	[ColumnInt1] [int] NULL,
	[ColumnInt2] [int] NULL,
	[ColumnInt3] [int] NULL,
	[ColumnInt4] [int] NULL,
	[ColumnInt5] [int] NULL,
	[ColumnInt6] [int] NULL,
	[ColumnInt7] [int] NULL,
	[ColumnInt8] [int] NULL,
	[ColumnInt9] [int] NULL,
	[ColumnInt10] [int] NULL,
	[ColumnDatetime1] [datetime] NULL,
	[ColumnDatetime2] [datetime] NULL,
	[ColumnDatetime3] [datetime] NULL,
	[ColumnDatetime4] [datetime] NULL,
	[ColumnDatetime5] [datetime] NULL,
	[ColumnDatetime6] [datetime] NULL,
	[ColumnDatetime7] [datetime] NULL,
	[ColumnDatetime8] [datetime] NULL,
	[ColumnDatetime9] [datetime] NULL,
	[ColumnDatetime10] [datetime] NULL,
	[ColumnDatetime11] [datetime] NULL,
	[ColumnDatetime12] [datetime] NULL,
	[ColumnDatetime13] [datetime] NULL,
	[ColumnDatetime14] [datetime] NULL,
	[ColumnDatetime15] [datetime] NULL,
	[ColumnDatetime16] [datetime] NULL,
	[ColumnDatetime17] [datetime] NULL,
	[ColumnDatetime18] [datetime] NULL,
	[ColumnDatetime19] [datetime] NULL,
	[ColumnDatetime20] [datetime] NULL,
	[ColumnGlobalCode1] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode2] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode3] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode4] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode5] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode6] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode7] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode8] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode9] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode10] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode11] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode12] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode13] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode14] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode15] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode16] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode17] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode18] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode19] [dbo].[type_GlobalCode] NULL,
	[ColumnGlobalCode20] [dbo].[type_GlobalCode] NULL,
	[ColumnMoney1] [dbo].[type_Money] NULL,
	[ColumnMoney2] [dbo].[type_Money] NULL,
	[ColumnMoney3] [dbo].[type_Money] NULL,
	[ColumnMoney4] [dbo].[type_Money] NULL,
	[ColumnMoney5] [dbo].[type_Money] NULL,
	[ColumnMoney6] [dbo].[type_Money] NULL,
	[ColumnMoney7] [dbo].[type_Money] NULL,
	[ColumnMoney8] [dbo].[type_Money] NULL,
	[ColumnMoney9] [dbo].[type_Money] NULL,
	[ColumnMoney10] [dbo].[type_Money] NULL,
	[RowIdentifier] [dbo].[type_GUID] NOT NULL,
	[CreatedBy] [dbo].[type_CurrentUser] NOT NULL,
	[CreatedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	[ModifiedBy] [dbo].[type_CurrentUser] NOT NULL,
	[ModifiedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	[RecordDeleted] [dbo].[type_YOrN] NULL,
	[DeletedDate] [datetime] NULL,
	[DeletedBy] [dbo].[type_UserId] NULL,
 CONSTRAINT [CustomFieldsData_PK] PRIMARY KEY NONCLUSTERED 
(
	[CustomFieldsDataId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CustomFields]    Script Date: 06/19/2013 11:46:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CustomFields]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CustomFields](
	[CustomFieldId] [int] IDENTITY(1,1) NOT NULL,
	[DocumentTypeId] [dbo].[type_GlobalCode] NULL,
	[DocumentCodeId] [int] NULL,
	[ColumnName] [varchar](100) NOT NULL,
	[Datatype] [dbo].[type_GlobalCode] NULL,
	[ColumnLabel] [varchar](250) NOT NULL,
	[OrderNumber] [int] NOT NULL,
	[GlobalCodeCategory] [varchar](100) NULL,
	[Active] [dbo].[type_Active] NULL,
	[RowIdentifier] [dbo].[type_GUID] NOT NULL,
	[CreatedBy] [dbo].[type_CurrentUser] NOT NULL,
	[CreatedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	[ModifiedBy] [dbo].[type_CurrentUser] NOT NULL,
	[ModifiedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	[RecordDeleted] [dbo].[type_YOrN] NULL,
 CONSTRAINT [CustomFields_PK] PRIMARY KEY NONCLUSTERED 
(
	[CustomFieldId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Check [CK__CustomFie__Activ__2785B5C4]    Script Date: 06/19/2013 11:46:50 ******/
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomFie__Activ__2785B5C4]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFields]'))
ALTER TABLE [dbo].[CustomFields]  WITH NOCHECK ADD CHECK  (([Active]='N' OR [Active]='Y'))
GO
/****** Object:  Check [CK__CustomFie__Recor__2879D9FD]    Script Date: 06/19/2013 11:46:50 ******/
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomFie__Recor__2879D9FD]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFields]'))
ALTER TABLE [dbo].[CustomFields]  WITH NOCHECK ADD CHECK  (([RecordDeleted]='N' OR [RecordDeleted]='Y'))
GO
/****** Object:  Check [CK__CustomFie__Recor__296DFE36]    Script Date: 06/19/2013 11:46:50 ******/
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK__CustomFie__Recor__296DFE36]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFieldsData]'))
ALTER TABLE [dbo].[CustomFieldsData]  WITH NOCHECK ADD CHECK  (([RecordDeleted]='N' OR [RecordDeleted]='Y'))
GO
/****** Object:  ForeignKey [DocumentCodes_CustomFields_FK]    Script Date: 06/19/2013 11:46:50 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentCodes_CustomFields_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFields]'))
ALTER TABLE [dbo].[CustomFields]  WITH NOCHECK ADD  CONSTRAINT [DocumentCodes_CustomFields_FK] FOREIGN KEY([DocumentCodeId])
REFERENCES [dbo].[DocumentCodes] ([DocumentCodeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentCodes_CustomFields_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFields]'))
ALTER TABLE [dbo].[CustomFields] CHECK CONSTRAINT [DocumentCodes_CustomFields_FK]
GO
/****** Object:  ForeignKey [DocumentCodes_CustomFieldsData_FK]    Script Date: 06/19/2013 11:46:50 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentCodes_CustomFieldsData_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFieldsData]'))
ALTER TABLE [dbo].[CustomFieldsData]  WITH NOCHECK ADD  CONSTRAINT [DocumentCodes_CustomFieldsData_FK] FOREIGN KEY([DocumentCodeId])
REFERENCES [dbo].[DocumentCodes] ([DocumentCodeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[DocumentCodes_CustomFieldsData_FK]') AND parent_object_id = OBJECT_ID(N'[dbo].[CustomFieldsData]'))
ALTER TABLE [dbo].[CustomFieldsData] CHECK CONSTRAINT [DocumentCodes_CustomFieldsData_FK]
GO
