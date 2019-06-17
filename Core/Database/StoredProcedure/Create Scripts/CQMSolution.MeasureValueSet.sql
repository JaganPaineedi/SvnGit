

/****** Object:  Table [CQMSolution].[MeasureValueSet]    Script Date: 6/22/2018 10:33:23 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CQMSolution].[MeasureValueSet]') AND type in (N'U'))
BEGIN
    CREATE TABLE [CQMSolution].[MeasureValueSet](
	    [MeasureValueSetId] [int] IDENTITY(1,1) NOT NULL,
	    [CreatedBy] [dbo].[type_CurrentUser] NOT NULL,
	    [CreatedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	    [ModifiedBy] [dbo].[type_CurrentUser] NOT NULL,
	    [ModifiedDate] [dbo].[type_CurrentDatetime] NOT NULL,
	    [RecordDeleted] [dbo].[type_YOrN] NULL,
	    [DeletedBy] [dbo].[type_UserId] NULL,
	    [DeletedDate] [datetime] NULL,
	    [MeasureId] [int] NULL,
	    [MeasureName] [varchar](max) NOT NULL,
	    [NQFId] [varchar](50) NOT NULL,
	    [Version] [varchar](50) NOT NULL,
	    [Eligibility] [varchar](50) NOT NULL,
	    [Category] [varchar](50) NULL,
	    [QualityDataElement] [varchar](max) NOT NULL,
	    [ValueSetOID] [varchar](50) NOT NULL,
	    [ValueSetName] [varchar](max) NOT NULL,
	    [ValueSetVersion] [varchar](50) NOT NULL,
	    [CodeSystem] [varchar](50) NOT NULL,
	    [CodeSystemOID] [varchar](50) NOT NULL,
	    [CodeSystemVersion] [varchar](50) NOT NULL,
	    [Concept] [varchar](50) NOT NULL,
	    [ConceptDescription] [varchar](max) NOT NULL,
	    [TemplateID] [varchar](255) NULL,
	CONSTRAINT [PK__MeasureV__745FACDF9DAFEAB5] PRIMARY KEY CLUSTERED 
    (
	    [MeasureValueSetId] ASC
    )WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
    ) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
end
GO


