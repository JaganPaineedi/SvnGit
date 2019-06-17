IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CQM].[MeasureValueSet]') AND type in (N'P', N'PC'))
DROP PROCEDURE [CQM].[MeasureValueSet]
GO

/****** Object:  Table [CQM].[MeasureValueSet]    Script Date: 2/5/2018 1:01:14 AM ******/


/****** Object:  Table [CQM].[MeasureValueSet]    Script Date: 2/5/2018 1:01:14 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [CQM].[MeasureValueSet](
	[MeasureId] [int] NOT NULL,
	[MeasureName] [varchar](max) NOT NULL,
	[NQFId] [varchar](50) NOT NULL,
	[Version] [varchar](50) NOT NULL,
	[Eligibility] [varchar](50) NOT NULL,
	[Category] [varchar](50) NULL,
	[CategoryAction] [varchar](50) NULL,
	[CategoryCode] [varchar](200) NULL,
	[QualityDataElement] [varchar](max) NOT NULL,
	[ValueSetOID] [varchar](50) NOT NULL,
	[ValueSetName] [varchar](max) NOT NULL,
	[ValueSetVersion] [varchar](50) NOT NULL,
	[CodeSystem] [varchar](50) NOT NULL,
	[CodeSystemOID] [varchar](50) NOT NULL,
	[CodeSystemVersion] [varchar](50) NOT NULL,
	[Concept] [varchar](50) NOT NULL,
	[ConceptDescription] [varchar](max) NOT NULL,
	[TemplateID] [varchar](255) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


