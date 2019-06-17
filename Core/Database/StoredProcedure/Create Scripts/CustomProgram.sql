

/****** Object:  Table [dbo].[CustomProgram]    Script Date: 2/5/2018 1:01:36 AM ******/


/****** Object:  Table [dbo].[CustomProgram]    Script Date: 2/5/2018 1:01:36 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CustomProgram]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CustomProgram](
	[ProgramId] [int] NOT NULL,
	[CreatedBy] [dbo].[type_CurrentUser] NOT NULL,
	[CreatedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	[ModifiedBy] [dbo].[type_CurrentUser] NOT NULL,
	[ModifiedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	[RecordDeleted] [dbo].[type_YOrN] NULL,
	[DeletedBy] [dbo].[type_UserId] NULL,
	[DeletedDate] [datetime] NULL,
	[SNOMEDCODE] [varchar](100) NULL,
 CONSTRAINT [CustomProgram_PK] PRIMARY KEY CLUSTERED 
(
	[ProgramId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]




ALTER TABLE [dbo].[CustomProgram]  WITH CHECK ADD  CONSTRAINT [Programs_CustomProgram_FK] FOREIGN KEY([ProgramId])
REFERENCES [dbo].[Programs] ([ProgramId])

ALTER TABLE [dbo].[CustomProgram] CHECK CONSTRAINT [Programs_CustomProgram_FK]
END


SET ANSI_PADDING OFF
GO

